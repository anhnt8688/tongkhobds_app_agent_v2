import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/json_parse.dart';
import 'models/customer.dart';

class CustomersApi {
  CustomersApi(this._dio);

  final Dio _dio;

  /// "Khách hàng của tôi" — matches v1 `fetchMyCustomer`
  /// (`get_list_customer.json?page=&limit=&search=`, NO `xtype`). The earlier
  /// `xtype=0` variant is a different ("all") list that returns nothing here.
  Future<List<Customer>> list({String? search, int page = 1, int limit = 20}) async {
    final res = await _dio.get(
      '${AppConfig.agent}/get_list_customer.json',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    final data = res.data;
    final List raw;
    if (data is Map) {
      raw = (data['data'] ?? data['items'] ?? []) as List;
    } else if (data is List) {
      raw = data;
    } else {
      raw = const [];
    }
    return raw.whereType<Map>().map(Customer.fromJson).toList();
  }

  Future<int> add({
    required String name,
    required String phone,
    String? email,
    String? address,
  }) async {
    final res = await _dio.post(
      '${AppConfig.agent}/add_customer.json',
      data: {
        'name': name,
        'phone': phone,
        if (email != null && email.isNotEmpty) 'email': email,
        if (address != null && address.isNotEmpty) 'address': address,
      },
    );
    final data = res.data;
    return data is Map ? asInt(data['customer_id'] ?? data['id']) : 0;
  }

  /// Edit an existing customer — matches v1 `updateCustomer` (PUT `customer.json`
  /// with `customer_id` + fields).
  Future<void> update({
    required int id,
    required String name,
    required String phone,
    String? email,
    String? address,
  }) async {
    await _dio.put(
      '${AppConfig.agent}/customer.json',
      data: {
        'customer_id': id,
        'name': name,
        'phone': phone,
        'email': email ?? '',
        'address': address ?? '',
      },
    );
  }

  /// Delete a customer — matches v1 `deleteCustomer`
  /// (DELETE `customer.json?customer_id=`).
  Future<void> delete(int id) async {
    await _dio.delete(
      '${AppConfig.agent}/customer.json',
      queryParameters: {'customer_id': id},
    );
  }
}

final customersApiProvider = Provider<CustomersApi>((ref) {
  return CustomersApi(ref.watch(dioProvider));
});

/// Search keyword state for the customer list.
final customerSearchProvider = StateProvider.autoDispose<String>((ref) => '');

final customersProvider = FutureProvider.autoDispose<List<Customer>>((ref) {
  final search = ref.watch(customerSearchProvider);
  return ref.watch(customersApiProvider).list(search: search);
});
