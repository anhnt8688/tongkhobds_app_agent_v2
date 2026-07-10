import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/json_parse.dart';
import '../../realestate/data/models/property.dart';
import 'models/consultation_activity.dart';
import 'models/demand.dart';

/// API client for "Nhu cầu MUA" (consultation). Endpoints verified against the
/// web repo's src/lib/api/consultation.ts.
class DemandsApi {
  DemandsApi(this._dio);
  final Dio _dio;

  String get _a => AppConfig.agent;

  /// Unwraps `{data:{...}}` / `{result:{...}}` / flat.
  Map _inner(Object? data) {
    if (data is! Map) return const {};
    if (data['data'] is Map) return data['data'] as Map;
    if (data['result'] is Map) return data['result'] as Map;
    return data;
  }

  List _listOf(Object? data, List<String> keys) {
    final node = _inner(data);
    for (final k in keys) {
      if (node[k] is List) return node[k] as List;
    }
    if (data is List) return data;
    return const [];
  }

  // ---- List ----
  Future<PagedDemands> list({
    String? status,
    String? search,
    int page = 1,
    int limit = 20,
    int? officeId,
    String? salesOff,
    String? createdBy,
    String? startDate,
    String? endDate,
    String? cityId,
    String? districtId,
    String? wardId,
    List<int> tagIds = const [],
    String? orAnd,
  }) async {
    final q = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (status != null && status != 'all') 'status': status,
      if (search != null && search.trim().isNotEmpty) 'q': search.trim(),
      if (officeId != null) 'office': officeId,
      if (salesOff != null) 'sales_off': salesOff,
      if (createdBy != null) 'created_by': createdBy,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (cityId != null) 'city_id': cityId,
      if (districtId != null) 'district_id': districtId,
      if (wardId != null) 'ward_id': wardId,
      if (tagIds.isNotEmpty) 'tag_id': tagIds,
      if (tagIds.isNotEmpty && orAnd != null) 'or_and': orAnd,
    };
    final res = await _dio.get('$_a/get_list_consultation', queryParameters: q);
    final node = _inner(res.data);
    final items = _listOf(res.data, ['items'])
        .whereType<Map>()
        .map(Demand.fromJson)
        .toList();
    final tabs = (node['list_status'] is List ? node['list_status'] as List : [])
        .whereType<Map>()
        .map(StatusTab.fromJson)
        .toList();
    final total = asInt(node['total'], fallback: items.length);
    final tp = asInt(node['total_pages'], fallback: page);
    return PagedDemands(
      items: items,
      total: total,
      page: asInt(node['page'], fallback: page),
      totalPages: tp < 1 ? 1 : tp,
      statusTabs: tabs,
    );
  }

  // ---- Detail ----
  Future<DemandDetail> detail(int id) async {
    final res = await _dio.get('$_a/get_detail_consultation',
        queryParameters: {'demand_id': id});
    return DemandDetail.fromJson(_inner(res.data));
  }

  // ---- Create / Update / Close ----
  Future<int> create(Map<String, dynamic> payload) async {
    final res = await _dio.post('$_a/create_customer_demand', data: payload);
    final inner = _inner(res.data);
    return asInt(inner['id'] ?? inner['consultation_id']);
  }

  Future<void> update(Map<String, dynamic> payload) async {
    await _dio.put('$_a/update_demand', data: payload);
  }

  Future<void> close(int id, {String? reason}) async {
    await _dio.put('$_a/update_demand', data: {
      'demand_id': id,
      'status_info': {'demand_status': 'completed'},
      if (reason != null && reason.isNotEmpty) 'reason': reason,
    });
  }

  // ---- Suggested properties ----
  Future<List<Property>> suggest(int consultationId,
      {int page = 1, int limit = 20}) async {
    final res = await _dio.get('$_a/demand_suggest.json', queryParameters: {
      'consultation_id': consultationId,
      'page': page,
      'limit': limit,
    });
    return _listOf(res.data, ['properties', 'items'])
        .whereType<Map>()
        .map((e) => Property.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  // ---- Interests (BĐS đang làm việc) ----
  Future<InterestsResult> interests(int consultationId) async {
    final res = await _dio.get('$_a/get_consultation_interests_all',
        queryParameters: {'consultation_id': consultationId});
    final node = _inner(res.data);
    final items = _listOf(res.data, ['items'])
        .whereType<Map>()
        .map(ConsultationInterest.fromJson)
        .toList();
    final stats = node['stats'] is Map
        ? InterestStats.fromJson(node['stats'] as Map)
        : const InterestStats();
    return InterestsResult(items: items, stats: stats);
  }

  // ---- Activities timeline ----
  Future<List<ActivityWork>> activities(
    int tableId, {
    String tablename = 'consultation',
  }) async {
    final res = await _dio.get('$_a/activities_consultation', queryParameters: {
      'tablename': tablename,
      'table_id': tableId,
    });
    return _listOf(res.data, ['works'])
        .whereType<Map>()
        .map(ActivityWork.fromJson)
        .toList();
  }

  // ---- Comments (ghi chú nội bộ) ----
  Future<List<DemandComment>> comments(int tableId) async {
    final res = await _dio.get('$_a/salesman_comments', queryParameters: {
      'table_id': tableId,
      'tablename': 'consultation',
    });
    return _listOf(res.data, ['items', 'comments'])
        .whereType<Map>()
        .map(DemandComment.fromJson)
        .toList();
  }

  Future<void> addComment(int tableId, String content,
      {String type = 'note'}) async {
    await _dio.post('$_a/salesman_comments', data: {
      'table_id': tableId,
      'tablename': 'consultation',
      'comment_type': type,
      'content': content,
    });
  }

  // ---- Work actions (work_consultation) ----
  //
  // Unified action dispatcher: 7 action codes (call_owner, send_customer, note,
  // request_verification, appointment, deposit, not_suitable) on a
  // consultation_interest. The endpoint follows the module envelope
  // `{success, data}` / `{success:false, message, error_code}`, which carries no
  // `status` key — so we opt out of envelope unwrapping and surface a business
  // failure (`success == false`) as a typed ApiException ourselves.
  Future<void> work(Map<String, dynamic> payload) async {
    final res = await _dio.post(
      '$_a/work_consultation',
      data: payload,
      options: Options(extra: {'rawEnvelope': true}),
    );
    final data = res.data;
    if (data is Map && data['success'] == false) {
      throw ApiException((data['message'] ?? 'Thao tác thất bại').toString());
    }
  }

  Future<List<NotSuitableReason>> notSuitableReasons() async {
    final res = await _dio.get('$_a/get_not_suitable_reasons');
    return _listOf(res.data, ['items'])
        .whereType<Map>()
        .map(NotSuitableReason.fromJson)
        .toList();
  }

  // ---- Tag assignment history ----
  Future<List<DemandTagLog>> tagHistory(int id, {int limit = 50}) async {
    final res = await _dio.get('$_a/get_entity_tag_history.json',
        queryParameters: {
          'entity_type': 'consultation',
          'entity_id': id,
          'limit': limit,
        });
    final data = res.data;
    final list = data is List ? data : _listOf(data, ['data', 'items']);
    return list.whereType<Map>().map(DemandTagLog.fromJson).toList();
  }
}

final demandsApiProvider =
    Provider<DemandsApi>((ref) => DemandsApi(ref.watch(dioProvider)));

final demandDetailProvider =
    FutureProvider.autoDispose.family<DemandDetail, int>((ref, id) {
  return ref.watch(demandsApiProvider).detail(id);
});

final demandSuggestProvider =
    FutureProvider.autoDispose.family<List<Property>, int>((ref, id) {
  return ref.watch(demandsApiProvider).suggest(id);
});

final demandInterestsProvider =
    FutureProvider.autoDispose.family<InterestsResult, int>((ref, id) {
  return ref.watch(demandsApiProvider).interests(id);
});

final demandActivitiesProvider =
    FutureProvider.autoDispose.family<List<ActivityWork>, int>((ref, id) {
  return ref.watch(demandsApiProvider).activities(id);
});

/// Per-BĐS work log (`tablename = consultation_interest`, `table_id` = the
/// interest id) — the "công việc" of a single BĐS quan tâm.
final demandInterestActivitiesProvider =
    FutureProvider.autoDispose.family<List<ActivityWork>, int>((ref, interestId) {
  return ref
      .watch(demandsApiProvider)
      .activities(interestId, tablename: 'consultation_interest');
});

final demandTagHistoryProvider =
    FutureProvider.autoDispose.family<List<DemandTagLog>, int>((ref, id) {
  return ref.watch(demandsApiProvider).tagHistory(id);
});

final demandCommentsProvider =
    FutureProvider.autoDispose.family<List<DemandComment>, int>((ref, id) {
  return ref.watch(demandsApiProvider).comments(id);
});
