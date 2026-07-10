import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'chat_api.dart';
import 'models/rocket_auth.dart';

/// Holds the RocketChat credentials (token + userId) used for REST headers and
/// DDP login. Lazily fetched from the app backend (`refresh_token_rocket`) and
/// cached in secure storage + memory. `ensure(force: true)` re-fetches on 401.
class RocketAuthStore {
  RocketAuthStore(this._ref);

  final Ref _ref;
  final _storage = const FlutterSecureStorage();
  static const _key = 'rocket_auth';

  RocketAuth? _cached;
  RocketAuth? get current => _cached;

  /// Returns valid credentials, fetching from the backend when missing/expired.
  /// [force] bypasses the cache (used after a 401 to rotate the token).
  Future<RocketAuth?> ensure({bool force = false}) async {
    if (!force) {
      _cached ??= await _read();
      if (_cached?.isValid == true) return _cached;
    }
    final fresh = await _ref.read(chatApiProvider).fetchRocketToken();
    if (fresh?.isValid == true) {
      _cached = fresh;
      await _storage.write(key: _key, value: jsonEncode(fresh!.toJson()));
    }
    return _cached;
  }

  Future<void> clear() async {
    _cached = null;
    await _storage.delete(key: _key);
  }

  Future<RocketAuth?> _read() async {
    final raw = await _storage.read(key: _key);
    if (raw == null || raw.isEmpty) return null;
    try {
      return RocketAuth.fromJson(jsonDecode(raw) as Map);
    } catch (_) {
      return null;
    }
  }
}

final rocketAuthStoreProvider =
    Provider<RocketAuthStore>((ref) => RocketAuthStore(ref));
