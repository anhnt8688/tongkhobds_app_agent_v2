import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import 'deposit_models.dart';

class DepositApi {
  DepositApi(this._dio);
  final Dio _dio;
  String get _a => AppConfig.agent;

  List _list(dynamic data) {
    if (data is List) return data;
    if (data is Map && data['data'] is List) return data['data'] as List;
    return const [];
  }

  Future<List<DepositStatusGroup>> statusGroups() async {
    final res = await _dio.get('$_a/get_group_status_deposit.json');
    return _list(res.data).whereType<Map>().map(DepositStatusGroup.fromJson).toList();
  }

  Future<List<DepositWork>> list({List<String>? options}) async {
    final res = await _dio.get('$_a/get_deposit_works.json', queryParameters: {
      if (options != null && options.isNotEmpty) 'status': options.join(','),
    });
    // After envelope unwrap, res.data is `{deposits:[...], pagination:{...}}`.
    final data = res.data;
    final raw = data is Map
        ? (data['deposits'] is List
            ? data['deposits'] as List
            : (data['data'] is List ? data['data'] as List : const []))
        : (data is List ? data : const []);
    return raw.whereType<Map>().map(DepositWork.fromJson).toList();
  }

  Future<DepositDetail> detail(int depositWorkId) async {
    final res = await _dio.get('$_a/deposit_detail.json',
        queryParameters: {'deposit_work_id': depositWorkId});
    final data = res.data;
    final root = data is Map
        ? (data['data'] is Map ? data['data'] as Map : data)
        : const {};
    return DepositDetail.fromJson(root);
  }

  Future<void> cancel(int depositWorkId) async {
    await _dio.put('$_a/deposit_update.json',
        data: {'status': 'cancelled', 'deposit_work_id': depositWorkId});
  }
}

final depositApiProvider =
    Provider<DepositApi>((ref) => DepositApi(ref.watch(dioProvider)));

final depositStatusGroupsProvider =
    FutureProvider.autoDispose<List<DepositStatusGroup>>((ref) {
  return ref.watch(depositApiProvider).statusGroups();
});

/// `options` joined by comma is the family key.
final depositListProvider = FutureProvider.autoDispose
    .family<List<DepositWork>, String>((ref, optionsCsv) {
  final options = optionsCsv.isEmpty ? null : optionsCsv.split(',');
  return ref.watch(depositApiProvider).list(options: options);
});

final depositDetailProvider =
    FutureProvider.autoDispose.family<DepositDetail, int>((ref, id) {
  return ref.watch(depositApiProvider).detail(id);
});
