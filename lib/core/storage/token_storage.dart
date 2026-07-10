import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/app_config.dart';

/// Persists the bearer token in platform secure storage and keeps an in-memory
/// copy so synchronous code (e.g. the Dio auth interceptor) can read it.
class TokenStorage {
  TokenStorage(this._storage);

  static const _key = 'auth_token';
  static const _onboardingKey = 'onboarding_seen';
  static const _domainKey = 'api_domain';
  final FlutterSecureStorage _storage;

  String? _cached;

  /// In-memory token; valid after [load] / [save].
  String? get current => _cached;

  bool get hasToken => _cached != null && _cached!.isNotEmpty;

  /// Loads the token from secure storage into memory (call at startup).
  Future<String?> load() async {
    _cached = await _storage.read(key: _key);
    return _cached;
  }

  Future<void> save(String token) async {
    _cached = token;
    await _storage.write(key: _key, value: token);
  }

  Future<void> clear() async {
    _cached = null;
    await _storage.delete(key: _key);
  }

  /// First-launch onboarding flag (survives logout — only cleared on reinstall).
  Future<bool> onboardingSeen() async =>
      (await _storage.read(key: _onboardingKey)) == '1';

  Future<void> setOnboardingSeen() async =>
      _storage.write(key: _onboardingKey, value: '1');

  /// Overridden backend domain (in-app domain switcher). Empty = default.
  Future<String?> loadDomain() => _storage.read(key: _domainKey);
  Future<void> saveDomain(String domain) =>
      _storage.write(key: _domainKey, value: domain);
}

/// Active backend domain; drives [dioProvider]'s baseUrl so switching it
/// rebuilds the HTTP client + all API clients.
final domainProvider = StateProvider<String>((ref) => AppConfig.baseUrl);

/// Whether the intro/onboarding has been shown. Loaded at startup; `null` = unknown.
final onboardingSeenProvider = StateProvider<bool?>((ref) => null);

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage(const FlutterSecureStorage());
});
