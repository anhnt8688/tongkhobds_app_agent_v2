import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Force-update gate (ported from v1 `ForceUpdateService`). Compares the
/// installed version against the live store version (iOS: iTunes lookup;
/// Android: Play Store page scrape) and, when the store is newer, shows a
/// non-dismissible dialog that only offers to open the store.
///
/// Store endpoints are public — fetched with a bare [HttpClient] so they skip
/// the app's auth/dio pipeline. Any failure is swallowed (never blocks usage).
class ForceUpdateService {
  /// Guards against re-prompting on every shell rebuild within a session.
  static bool _shown = false;

  Future<void> checkAndForceUpdate(BuildContext context) async {
    if (_shown) return;
    try {
      final info = await PackageInfo.fromPlatform();
      final current = info.version;

      final ({String version, String? url})? store = Platform.isIOS
          ? await _iosStore(info.packageName)
          : await _androidStore(info.packageName);
      if (store == null) return;

      if (!_isStoreNewer(store.version, current)) return;
      if (!context.mounted) return;
      _shown = true;

      final fallbackUrl = Platform.isIOS
          ? 'https://apps.apple.com/app/${info.packageName}'
          : 'https://play.google.com/store/apps/details?id=${info.packageName}';

      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => PopScope(
          canPop: false,
          child: AlertDialog(
            title: const Text('Cập nhật bắt buộc'),
            content: Text(
              'Phiên bản mới (${store.version}) đã có trên cửa hàng. '
              'Vui lòng cập nhật để tiếp tục sử dụng.',
              style: AppTypography.body,
            ),
            actions: [
              TextButton(
                onPressed: () => launchUrl(
                  Uri.parse(store.url ?? fallbackUrl),
                  mode: LaunchMode.externalApplication,
                ),
                child: Text('Cập nhật',
                    style: AppTypography.body.copyWith(
                        color: AppColors.primary, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      );
    } catch (_) {
      // Never let a version check block the app.
    }
  }

  /// True when [store] semver is strictly greater than [current] (3 segments).
  bool _isStoreNewer(String store, String current) {
    List<int> parts(String v) =>
        v.split('.').map((e) => int.tryParse(e.trim()) ?? 0).toList();
    final a = parts(store);
    final b = parts(current);
    for (var i = 0; i < 3; i++) {
      final ai = i < a.length ? a[i] : 0;
      final bi = i < b.length ? b[i] : 0;
      if (ai != bi) return ai > bi;
    }
    return false;
  }

  Future<({String version, String? url})?> _iosStore(String bundleId) async {
    try {
      final body = await _get(
          Uri.parse('https://itunes.apple.com/lookup?bundleId=$bundleId'));
      if (body == null) return null;
      final map = json.decode(body) as Map<String, dynamic>;
      final results = (map['results'] as List?) ?? const [];
      if (results.isEmpty) return null;
      final first = results.first as Map<String, dynamic>;
      final version = first['version']?.toString();
      if (version == null) return null;
      return (version: version, url: first['trackViewUrl']?.toString());
    } catch (_) {
      return null;
    }
  }

  Future<({String version, String? url})?> _androidStore(String pkg) async {
    try {
      final body = await _get(
        Uri.parse('https://play.google.com/store/apps/details?id=$pkg&hl=en'),
        userAgent: 'Mozilla/5.0',
      );
      if (body == null) return null;
      final m = RegExp(r'\[\[\"([0-9]+\.[0-9]+\.[0-9]+)\"').firstMatch(body) ??
          RegExp(r'softwareVersion\">\s*([0-9]+\.[0-9]+\.[0-9]+)')
              .firstMatch(body);
      final version = m?.group(1);
      if (version == null) return null;
      return (
        version: version,
        url: 'https://play.google.com/store/apps/details?id=$pkg',
      );
    } catch (_) {
      return null;
    }
  }

  Future<String?> _get(Uri uri, {String? userAgent}) async {
    final client = HttpClient();
    try {
      final req = await client.getUrl(uri);
      if (userAgent != null) {
        req.headers.set(HttpHeaders.userAgentHeader, userAgent);
      }
      final res = await req.close();
      if (res.statusCode != 200) return null;
      return await res.transform(utf8.decoder).join();
    } finally {
      client.close();
    }
  }
}
