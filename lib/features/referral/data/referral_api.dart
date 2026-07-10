import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/json_parse.dart';

/// A person in the referral graph (invited / referrer / looked-up by code).
class RefPerson {
  const RefPerson({
    required this.id,
    this.name,
    this.phone,
    this.avatar,
    this.nameCode,
    this.createdOn,
    this.roles,
  });
  final int id;
  final String? name;
  final String? phone;
  final String? avatar;
  final String? nameCode;
  final String? createdOn;
  final String? roles;

  factory RefPerson.fromJson(Map d) => RefPerson(
        id: asInt(d['id'] ?? d['salesman_id']),
        name: (d['name'] ?? d['full_name'])?.toString(),
        phone: d['phone']?.toString(),
        avatar: AppConfig.imageUrl((d['avatar'] ?? d['image'])?.toString()),
        nameCode: d['name_code']?.toString(),
        createdOn: d['created_on']?.toString(),
        roles: d['roles']?.toString(),
      );
}

/// Outcome of processing a referral code (mirrors v1 ReferralProcessResult).
class ReferralResult {
  const ReferralResult({required this.success, required this.message});
  final bool success;
  final String message;
}

/// My referral info (`salesman_get_info.json`).
class MyReferral {
  const MyReferral({
    this.name,
    this.phone,
    this.avatar,
    this.nameCode,
    this.linkInvited,
    this.qrCode,
    this.qrCodeIcon,
    this.countInvited = 0,
  });
  final String? name;
  final String? phone;
  final String? avatar;
  final String? nameCode;
  final String? linkInvited;

  /// Server-rendered QR as a base64 PNG (the source of truth for the QR image).
  final String? qrCode;
  final String? qrCodeIcon;
  final int countInvited;

  /// Fallback text to generate a QR client-side if the server didn't return one.
  String get qrData => (linkInvited != null && linkInvited!.isNotEmpty)
      ? linkInvited!
      : (nameCode ?? '');

  factory MyReferral.fromJson(Map d) => MyReferral(
        name: (d['name'] ?? d['full_name'])?.toString(),
        phone: d['phone']?.toString(),
        avatar: AppConfig.imageUrl((d['avatar'] ?? d['image'])?.toString()),
        nameCode: d['name_code']?.toString(),
        linkInvited: d['link_invited']?.toString(),
        qrCode: d['qr_code']?.toString(),
        qrCodeIcon: d['qr_code_icon']?.toString(),
        countInvited: asInt(d['count_invited']),
      );
}

class ReferralApi {
  ReferralApi(this._dio);
  final Dio _dio;
  String get _a => AppConfig.agent;

  /// Referral endpoints carry the real payload in `message` while `data` is
  /// just a flag (e.g. `data: 1`). Tell the EnvelopeInterceptor not to unwrap to
  /// `data`, so we keep the full `{status, data, message}` map (like v1 which
  /// reads `res.data['message']` directly from the raw response).
  Options get _opts => Options(extra: const {'rawEnvelope': true});

  /// Pull the `message` payload out of the (un-unwrapped) envelope.
  Map _msg(Object? data) {
    if (data is! Map) return const {};
    if (data['message'] is Map) return data['message'] as Map;
    if (data['data'] is Map) return data['data'] as Map;
    return data;
  }

  Future<MyReferral> myReferral() async {
    final res = await _dio.get('$_a/salesman_get_info.json', options: _opts);
    return MyReferral.fromJson(_msg(res.data));
  }

  /// type 1 = người mình đã mời; type 2 = người giới thiệu mình.
  Future<List<RefPerson>> _list(int type, String key) async {
    final res = await _dio.get('$_a/salesman_get_list_invited.json',
        queryParameters: {'type': type}, options: _opts);
    final msg = _msg(res.data);
    final raw = msg[key];
    if (raw is List) {
      return raw.whereType<Map>().map(RefPerson.fromJson).toList();
    }
    if (raw is Map) return [RefPerson.fromJson(raw)];
    return const [];
  }

  Future<List<RefPerson>> invited() => _list(1, 'salesman_invited');
  Future<List<RefPerson>> referrers() => _list(2, 'salesman_referrer');

  Future<RefPerson?> lookupByNameCode(String nameCode) async {
    final res = await _dio.get('$_a/salesman_get_info_by_name_code.json',
        queryParameters: {'name_code': nameCode}, options: _opts);
    final msg = _msg(res.data);
    return msg.isEmpty ? null : RefPerson.fromJson(msg);
  }

  /// POST `salesman_process_referral_code.json`. Mirrors v1: send only the
  /// `name_code`; success requires the request `status==1` AND the business
  /// `data==1`. The EnvelopeInterceptor still throws on `status==0`; with
  /// `rawEnvelope` we keep the full map and read the `data` flag ourselves.
  Future<ReferralResult> processReferral(String nameCode,
      {int? idSalesmanRefered}) async {
    try {
      final res = await _dio.post(
        '$_a/salesman_process_referral_code.json',
        queryParameters: {
          'name_code': nameCode,
          if (idSalesmanRefered != null)
            'id_salesman_refered': idSalesmanRefered,
        },
        options: _opts,
      );
      final body = res.data;
      bool truthy(Object? v) => v == 1 || v == true || (v is String && v == '1');
      // `data == 1` is the business-success flag (read from the full map, or the
      // bare value if some path unwrapped it).
      final ok = (body is Map && truthy(body['data'])) || truthy(body);
      final msg = body is Map ? body['message'] : null;
      return ReferralResult(
          success: ok,
          message: (msg is String && msg.isNotEmpty)
              ? msg
              : (ok ? 'Thành công' : 'Thất bại'));
    } on DioException catch (e) {
      final err = e.error;
      return ReferralResult(
        success: false,
        message:
            err is ApiException ? err.message : 'Không thể thêm người giới thiệu',
      );
    }
  }
}

final referralApiProvider =
    Provider<ReferralApi>((ref) => ReferralApi(ref.watch(dioProvider)));

final myReferralProvider = FutureProvider.autoDispose<MyReferral>((ref) {
  return ref.watch(referralApiProvider).myReferral();
});

final invitedListProvider = FutureProvider.autoDispose<List<RefPerson>>((ref) {
  return ref.watch(referralApiProvider).invited();
});

final referrersProvider = FutureProvider.autoDispose<List<RefPerson>>((ref) {
  return ref.watch(referralApiProvider).referrers();
});
