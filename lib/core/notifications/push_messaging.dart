import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'local_notifications.dart';

/// Background isolate handler — must be a top-level function. We only need FCM
/// to wake the app; the OS renders the tray notification itself here.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('BG push: ${message.data}');
}

/// Owns the FCM lifecycle (v1 `FcmUtil`): permission, foreground display via
/// [LocalNotifications], and delivering an opened notification's data to
/// [_onOpen] (set by the app so it can deep-link through the router).
class PushMessaging {
  PushMessaging._();
  static final PushMessaging instance = PushMessaging._();

  void Function(Map<String, dynamic> data)? _onOpen;
  bool _started = false;

  // Lazy + guarded so touching this singleton never throws when Firebase
  // failed to initialise (e.g. missing GoogleService-Info.plist, simulator).
  FirebaseMessaging get _fm => FirebaseMessaging.instance;
  bool get _ready => Firebase.apps.isNotEmpty;

  /// Call once after the router exists. [onOpen] navigates for a tapped
  /// notification (foreground-local tap, background tap, or cold start).
  Future<void> init(void Function(Map<String, dynamic>) onOpen) async {
    _onOpen = onOpen;
    if (_started || !_ready) return;
    _started = true;

    await _fm.requestPermission(alert: true, badge: true, sound: true);
    await _fm.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    await LocalNotifications.instance.init(_open);

    // Foreground: FCM does not show a tray notification, so render one.
    FirebaseMessaging.onMessage.listen((m) {
      final n = m.notification;
      if (n == null) return;
      LocalNotifications.instance.show(
        id: n.hashCode,
        title: n.title ?? '',
        body: n.body ?? '',
        data: m.data,
      );
    });

    // Background → tapped tray notification.
    FirebaseMessaging.onMessageOpenedApp.listen((m) => _open(m.data));

    // Cold start from a tapped notification.
    final initial = await _fm.getInitialMessage();
    if (initial != null) _open(initial.data);
  }

  void _open(Map<String, dynamic> data) => _onOpen?.call(data);

  /// Current device token (null if unavailable / no APNs token yet on iOS).
  Future<String?> token() async {
    if (!_ready) return null;
    try {
      return await _fm.getToken();
    } catch (e) {
      debugPrint('FCM getToken failed: $e');
      return null;
    }
  }

  Future<void> deleteToken() async {
    if (!_ready) return;
    try {
      await _fm.deleteToken();
    } catch (_) {}
  }
}
