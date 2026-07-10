import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import 'models/transaction.dart';

class TransactionsApi {
  TransactionsApi(this._dio);

  final Dio _dio;

  Future<List<TransactionItem>> list({
    String? search,
    String? status,
    int page = 1,
    int limit = 30,
  }) async {
    final res = await _dio.get(
      '${AppConfig.agent}/real_estate_transaction.json',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null && status.isNotEmpty) 'status': status,
      },
    );
    return _parseList(res.data);
  }

  Future<Map> detail(int id) async {
    final res = await _dio.get(
      '${AppConfig.agent}/real_estate_transaction.json',
      queryParameters: {'id': id},
    );
    final data = res.data;
    if (data is Map) {
      final d = data['transaction_detail'] ?? data['detail'] ?? data;
      if (d is Map) return d;
    }
    return {};
  }

  Future<void> createDeposit({
    required String tableName,
    required int tableId,
    required double amount,
    int? customerId,
    int depositType = 1,
  }) async {
    await _dio.post('${AppConfig.agent}/deposit_create.json', data: {
      'table_name': tableName,
      'table_id': tableId,
      'deposit_type': depositType,
      'deposit_amount': amount.toInt(),
      if (customerId != null) 'customer_id': customerId,
    });
  }

  List<TransactionItem> _parseList(Object? data) {
    final List raw;
    if (data is Map) {
      raw = (data['items'] ?? data['data'] ?? []) as List;
    } else if (data is List) {
      raw = data;
    } else {
      raw = const [];
    }
    return raw.whereType<Map>().map(TransactionItem.fromJson).toList();
  }
}

final transactionsApiProvider =
    Provider<TransactionsApi>((ref) => TransactionsApi(ref.watch(dioProvider)));

final transactionsProvider =
    FutureProvider.autoDispose<List<TransactionItem>>((ref) {
  return ref.watch(transactionsApiProvider).list();
});

final transactionDetailProvider =
    FutureProvider.autoDispose.family<Map, int>((ref, id) {
  return ref.watch(transactionsApiProvider).detail(id);
});
