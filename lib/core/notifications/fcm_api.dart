import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../network/dio_client.dart';

/// Registers/unregisters the FCM device token with the backend (v1
/// `saveFireBaseToken` → `/api_common/create_token.json`).
class FcmApi {
  FcmApi(this._dio);
  final Dio _dio;

  /// v1 systemName: iOS = "1", Android = "2".
  String get _systemName => Platform.isIOS ? '1' : '2';

  Future<void> registerToken({required String token, int? authUserId}) async {
    await _dio.post('${AppConfig.common}/create_token.json', data: {
      'token': token,
      'systemName': _systemName,
      'app': 'agent',
      'auth_user_id': authUserId,
    });
  }
}

final fcmApiProvider = Provider<FcmApi>((ref) => FcmApi(ref.watch(dioProvider)));
