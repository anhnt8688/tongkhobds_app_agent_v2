import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../../../core/config/app_config.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';

/// KYC / identity-verification API (v1 `verify_agent.json`).
class KycApi {
  KycApi(this._dio);
  final Dio _dio;

  /// Submit CCCD verification — multipart `verify_agent.json`.
  ///
  /// [sex] is 1 for Nam, 0 for Nữ. [birthday] / [idDay] are ISO `yyyy-MM-dd`.
  /// [blockEdit] is true when the data came from a trusted QR scan. On success
  /// the envelope interceptor unwraps to the inner `data` map (may contain the
  /// new avatar `image`); a backend `status == 0` surfaces as an `ApiException`
  /// whose message the caller inspects (e.g. "đang được xử lý" → chờ duyệt).
  Future<Map?> verifyAgent({
    required String idCard,
    required String name,
    required String birthday,
    required int sex,
    required String address,
    required String idDay,
    required File front,
    required File back,
    bool blockEdit = true,
  }) async {
    final form = FormData.fromMap({
      'id_card': idCard,
      'name': name,
      'birthday': birthday,
      'sex': sex,
      'address': address,
      'id_day': idDay,
      'citizen_id_front':
          await MultipartFile.fromFile(front.path, filename: p.basename(front.path)),
      'citizen_id_back':
          await MultipartFile.fromFile(back.path, filename: p.basename(back.path)),
      'block_edit': blockEdit,
    });
    try {
      final res =
          await _dio.post('${AppConfig.agent}/verify_agent.json', data: form);
      return res.data is Map ? res.data as Map : null;
    } on DioException catch (e) {
      // The envelope interceptor wraps a backend `status == 0` (incl. the
      // "đang được xử lý" / chờ duyệt case) and HTTP errors as an ApiException
      // nested in the DioException — surface it directly so the caller's
      // `on ApiException` branch can inspect the message.
      final err = e.error;
      if (err is ApiException) throw err;
      rethrow;
    }
  }
}

final kycApiProvider = Provider<KycApi>((ref) => KycApi(ref.watch(dioProvider)));
