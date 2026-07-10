import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../features/chat/presentation/controllers/chat_room_controller.dart';

/// Maps a push-notification payload to a v2 route and navigates (v1
/// `FcmUtil.handleDeepLink` / `_handleLocalFallback`, re-expressed for
/// go_router). Payloads carry either a `url` deep link (`app.agent://bds?id=1`)
/// or a `type` + id for the local fallback.
class NotificationDeepLink {
  const NotificationDeepLink._();

  /// Entry point: resolve [data] to a route and push it onto [router], or run
  /// a side effect (open store). No-op when nothing matches.
  static Future<void> handle(GoRouter router, Map<String, dynamic> data) async {
    if (data.isEmpty) return;
    final url = data['url']?.toString();
    if (url != null && url.isNotEmpty) {
      await _handleUrl(router, url);
      return;
    }
    _handleFallback(router, data);
  }

  static Future<void> _handleUrl(GoRouter router, String urlString) async {
    final uri = Uri.tryParse(urlString);
    if (uri == null) return;

    var host = uri.host;
    var segments = uri.pathSegments;
    if (host.isEmpty && segments.isNotEmpty) {
      host = segments.first;
      segments = segments.sublist(1);
    }
    final q = uri.queryParameters;

    switch (host) {
      case 'bds':
        final id = _id(uri);
        if (id != null) router.push('/property/$id');
        break;
      case 'post':
        // Agent's own listing → property detail (owned enables edit there).
        final id = _id(uri);
        if (id != null) {
          final owned = uri.scheme == 'app.agent' ||
              segments.contains('edit') ||
              q.containsKey('edit');
          router.push('/property/$id${owned ? '?owned=true' : ''}');
        }
        break;
      case 'suggested-bds':
        final requestId = q['request_id'] ?? q['requestId'];
        router.push((requestId != null && requestId.isNotEmpty)
            ? '/demand/$requestId'
            : '/demands');
        break;
      case 'deal':
      case 'commission':
        final id = _id(uri);
        if (id != null) router.push('/transaction/$id');
        break;
      case 'appointment':
        final id = _id(uri);
        router.push(id != null ? '/appointments/$id' : '/appointments/create');
        break;
      case 'loan':
        // v1 left this a stub; v2 routes to the profile detail (or the hub).
        final id = _id(uri);
        router.push(id != null ? '/loan/profile/$id' : '/loan');
        break;
      case 'chat':
      case 'support':
      case 'message':
        _openChat(router, q['room_id'] ?? q['roomId'] ?? _id(uri), q['name']);
        break;
      case 'version':
        await _openStore();
        break;
      default:
        debugPrint('Unhandled notification deep link: $urlString');
    }
  }

  /// Local-notification fallback keyed on `type` (v1 `_handleLocalFallback`).
  static void _handleFallback(GoRouter router, Map<String, dynamic> data) {
    final type = data['type']?.toString();
    if (type == null || type.isEmpty) return;
    final kind = type.toLowerCase().split('/').first;
    final id = (data['id'] ??
            data['news_id'] ??
            data['appointment_id'] ??
            data['project_id'])
        ?.toString();

    switch (kind) {
      case 'appointment':
      case 'lich_hen':
        router.push(id != null ? '/appointments/$id' : '/appointments/create');
        break;
      case 'update_version':
      case 'version_update':
        _openStore();
        break;
      case 'chat':
      case 'support':
      case 'message':
        _openChat(router, data['room_id']?.toString() ?? id, null);
        break;
      default:
        debugPrint('Unhandled notification type: $type');
    }
  }

  /// Opens a specific room when a roomId is known, else the inbox.
  static void _openChat(GoRouter router, String? roomId, String? name) {
    if (roomId != null && roomId.isNotEmpty) {
      router.push('/chat', extra: ChatRoomArgs(roomId: roomId, name: name));
    } else {
      router.push('/messages');
    }
  }

  /// Extract an id from `?id=`, an `id/<n>` segment, an `id=<n>` segment, or a
  /// trailing numeric segment (v1 `_extractIdFromUri`).
  static String? _id(Uri uri) {
    final q = uri.queryParameters['id'];
    if (q != null && q.isNotEmpty) return q;
    final s = uri.pathSegments;
    for (var i = 0; i < s.length; i++) {
      if (s[i] == 'id' && i + 1 < s.length) return s[i + 1];
      if (s[i].startsWith('id=')) return s[i].split('=').last;
    }
    if (s.isNotEmpty && RegExp(r'^\d+$').hasMatch(s.last)) return s.last;
    return null;
  }

  static Future<void> _openStore() async {
    final info = await PackageInfo.fromPlatform();
    final url = Platform.isIOS
        ? Uri.parse('https://apps.apple.com/app/id6747106732')
        : Uri.parse(
            'https://play.google.com/store/apps/details?id=${info.packageName}');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}
