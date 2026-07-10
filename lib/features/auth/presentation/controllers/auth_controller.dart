import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/location/location_service.dart';
import '../../../../core/network/session_signal.dart';
import '../../../../core/notifications/fcm_api.dart';
import '../../../../core/notifications/push_messaging.dart';
import '../../../../core/services/activity_pinger.dart';
import '../../../../core/storage/token_storage.dart';
import '../../data/auth_api.dart';
import '../../data/models/user.dart';
import 'auth_state.dart';

/// Owns the global [AuthState], token persistence, and login/logout actions.
class AuthController extends Notifier<AuthState> {
  late final AuthApi _api = ref.read(authApiProvider);
  late final TokenStorage _tokens = ref.read(tokenStorageProvider);

  @override
  AuthState build() {
    // Force logout whenever the network layer signals an expired session.
    ref.listen(sessionExpiredProvider, (_, __) => _forceLogout());
    return const AuthState.unknown();
  }

  /// Called once at startup: restore session from a persisted token.
  Future<void> bootstrap() async {
    // Apply a previously chosen backend domain BEFORE any API client is used
    // (done here, not in main(), so secure-storage plugins are registered).
    final savedDomain = await _tokens.loadDomain();
    if (savedDomain != null && savedDomain.isNotEmpty) {
      AppConfig.setBaseUrl(savedDomain);
      ref.read(domainProvider.notifier).state = savedDomain;
    }
    // Load the onboarding flag so the router can gate first-launch intro.
    ref.read(onboardingSeenProvider.notifier).state =
        await _tokens.onboardingSeen();
    // Detect current location in the background (permission + GPS + resolve),
    // cached for 24h. Non-blocking — never delays session restore.
    unawaited(ref.read(locationServiceProvider).detectAndCache());
    final token = await _tokens.load();
    if (token == null || token.isEmpty) {
      state = const AuthState.unauthenticated();
      return;
    }
    try {
      final user = await _api.getUserProfile();
      state = AuthState.authenticated(user);
      ref.read(activityPingerProvider).onSession(user.id);
      _registerPushToken(user);
    } catch (_) {
      await _tokens.clear();
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> loginWithPassword(String userName, String password) async {
    final res = await _api.login(userName: userName, password: password);
    await _completeLogin(res.token, res.user);
  }

  Future<void> sendOtp(String phone, String deviceId) {
    return _api.sendOtp(phone: phone, deviceId: deviceId);
  }

  Future<void> verifyOtp(String phone, String otp) async {
    final res = await _api.verifyOtp(phone: phone, otp: otp);
    await _completeLogin(res.token, res.user);
  }

  /// Re-fetches the current user profile (after an edit/KYC update).
  Future<void> refreshProfile() async {
    try {
      final user = await _api.getUserProfile();
      state = AuthState.authenticated(user);
    } catch (_) {
      // keep existing state on failure
    }
  }

  /// Restore a session from a biometric-stashed bearer token.
  Future<void> loginWithToken(String token) async {
    await _completeLogin(token, null);
  }

  /// The active bearer token (for stashing behind biometric).
  String? get currentToken => _tokens.current;

  Future<void> logout() async {
    // Send a final activity heartbeat while the session is still valid.
    await ref.read(activityPingerProvider).logFinal();
    // Drop the FCM token first so this device stops receiving pushes.
    await PushMessaging.instance.deleteToken();
    try {
      await _api.logout();
    } catch (_) {
      // Best effort; clear locally regardless.
    }
    await _tokens.clear();
    state = const AuthState.unauthenticated();
  }

  Future<void> _completeLogin(String token, User? user) async {
    if (token.isEmpty) {
      throw StateError('Phản hồi đăng nhập không có token');
    }
    await _tokens.save(token);
    // Prefer the fresh profile to ensure all fields are present.
    final profile = user ?? await _api.getUserProfile();
    state = AuthState.authenticated(profile);
    ref.read(activityPingerProvider).onSession(profile.id);
    _registerPushToken(profile);
  }

  /// Register this device's FCM token with the backend (v1 `getFcmToken`).
  /// Fire-and-forget: never block or fail the login/session on push errors.
  Future<void> _registerPushToken(User? user) async {
    try {
      final token = await PushMessaging.instance.token();
      if (token == null || token.isEmpty) return;
      await ref
          .read(fcmApiProvider)
          .registerToken(token: token, authUserId: user?.id);
    } catch (_) {
      // Push registration is best-effort.
    }
  }

  Future<void> _forceLogout() async {
    if (state.status == AuthStatus.unauthenticated) return;
    await ref.read(activityPingerProvider).logFinal();
    await _tokens.clear();
    state = const AuthState.unauthenticated();
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);

/// Convenience accessor for the current user.
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authControllerProvider).user;
});
