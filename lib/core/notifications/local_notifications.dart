import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Thin wrapper over flutter_local_notifications: shows a heads-up notification
/// when a push arrives in the foreground (v1 `LocalNotificationUtil`), and
/// routes a tap back to [_onTap] with the decoded data payload.
class LocalNotifications {
  LocalNotifications._();
  static final LocalNotifications instance = LocalNotifications._();

  final _plugin = FlutterLocalNotificationsPlugin();
  void Function(Map<String, dynamic> data)? _onTap;
  bool _ready = false;

  static const _channel = AndroidNotificationChannel(
    'default_channel',
    'Thông báo',
    description: 'Thông báo từ ứng dụng',
    importance: Importance.max,
  );

  Future<void> init(void Function(Map<String, dynamic>) onTap) async {
    _onTap = onTap;
    if (_ready) return;
    const android = AndroidInitializationSettings('ic_stat_notification');
    const ios = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (r) => _dispatch(r.payload),
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
    _ready = true;
  }

  /// Show a notification; [data] is JSON-encoded into the payload so the tap
  /// handler can deep-link.
  Future<void> show({
    required int id,
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) async {
    await _plugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          icon: 'ic_stat_notification',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: jsonEncode(data),
    );
  }

  void _dispatch(String? payload) {
    if (payload == null || payload.isEmpty) return;
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map) {
        _onTap?.call(Map<String, dynamic>.from(decoded));
      }
    } catch (e) {
      debugPrint('Bad notification payload: $e');
    }
  }
}
