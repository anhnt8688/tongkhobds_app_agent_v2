import 'dart:async';
import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../network/dio_client.dart';
import '../storage/token_storage.dart';

/// Pushes a periodic "user active" heartbeat to the backend
/// (`api_activity_log`) while the agent is logged in and the app is in the
/// foreground — ports v1's `SessionPinger`.
///
/// Fires once on login/resume, then every 2 minutes; stops when the app is
/// backgrounded or the session ends. Errors are swallowed (best-effort telemetry).
class ActivityPinger with WidgetsBindingObserver {
  ActivityPinger(this._ref);

  final Ref _ref;
  Timer? _timer;
  bool _attached = false;
  int _uid = 0; // pushed by AuthController; avoids a pinger→auth provider cycle.

  static const _interval = Duration(minutes: 2);

  /// Attaches the lifecycle observer and evaluates the current session.
  void boot() {
    if (!_attached) {
      WidgetsBinding.instance.addObserver(this);
      _attached = true;
    }
    _evaluate();
  }

  /// AuthController pushes the signed-in user id here (0 = logged out), then we
  /// (re)start or stop the heartbeat. Keeps this service free of any dependency
  /// on the auth providers — reading it back from AuthController stays acyclic.
  void onSession(int uid) {
    _uid = uid;
    _evaluate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _evaluate();
    } else {
      _stop();
    }
  }

  bool get _loggedIn =>
      _ref.read(tokenStorageProvider).hasToken && _uid > 0;

  void _evaluate() {
    if (_loggedIn) {
      if (_timer == null) _log(); // immediate ping on (re)activation
      _startTimer();
    } else {
      _stop();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(_interval, (_) => _log());
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  /// Sends a final heartbeat before the session is cleared (call on logout).
  Future<void> logFinal() async {
    await _log();
    _uid = 0;
    _stop();
  }

  Future<void> _log() async {
    final uid = _uid;
    if (uid <= 0) return;
    final sys = Platform.isIOS ? '1' : (Platform.isAndroid ? '2' : '0');
    try {
      await _ref.read(dioProvider).post(
            '${AppConfig.agent}/api_activity_log',
            data: {'authUserId': uid, 'systemName': sys, 'app': 'agent'},
            options: Options(
              headers: {'Content-Type': 'application/json'},
              sendTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          );
      if (kDebugMode) debugPrint('[ActivityPinger] logged uid=$uid sys=$sys');
    } catch (e) {
      // Best-effort; ignore network/parse errors.
      if (kDebugMode) debugPrint('[ActivityPinger] failed: $e');
    }
  }

  void dispose() {
    _stop();
    if (_attached) {
      WidgetsBinding.instance.removeObserver(this);
      _attached = false;
    }
  }
}

final activityPingerProvider = Provider<ActivityPinger>((ref) {
  final pinger = ActivityPinger(ref);
  // Session changes are pushed in via [ActivityPinger.onSession] from
  // AuthController — deliberately NOT `ref.listen(authControllerProvider)`,
  // which would make this provider depend on auth and cause a circular
  // dependency when AuthController reads it back on logout.
  ref.onDispose(pinger.dispose);
  return pinger;
});
