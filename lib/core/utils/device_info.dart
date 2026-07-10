import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

/// Fallback id when the platform value is unavailable.
const _fallbackDeviceId = 'flutter_agent_app';

String? _cached;

/// Stable per-device identifier sent as `id_device` to `send_otp`.
///
/// Mirrors v1 [AppUtil.getDeviceId]: Android device codename
/// (`AndroidDeviceInfo.device`), iOS `identifierForVendor`. Cached after the
/// first lookup; never throws — degrades to [_fallbackDeviceId].
Future<String> getDeviceId() async {
  if (_cached != null) return _cached!;
  final info = DeviceInfoPlugin();
  String id;
  try {
    if (Platform.isAndroid) {
      id = (await info.androidInfo).device;
    } else if (Platform.isIOS) {
      id = (await info.iosInfo).identifierForVendor ?? '';
    } else {
      id = _fallbackDeviceId;
    }
  } catch (_) {
    id = _fallbackDeviceId;
  }
  _cached = id.isEmpty ? _fallbackDeviceId : id;
  return _cached!;
}
