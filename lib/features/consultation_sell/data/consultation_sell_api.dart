import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/json_parse.dart';
import 'models/sell_activity.dart';
import 'models/sell_lead.dart';

/// API client for "Nhu cầu BÁN" (consultation_sell). Endpoints verified against
/// the web repo's src/lib/api/consultation-sell.ts.
class ConsultationSellApi {
  ConsultationSellApi(this._dio);
  final Dio _dio;
  String get _a => AppConfig.agent;

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

  // ---- List + status counts ----
  Future<PagedSellLeads> list({
    String? status,
    String? search,
    int page = 1,
    int limit = 20,
    int? officeId,
    int? listingManagerId,
    String? source,
    String? startDate,
    String? endDate,
  }) async {
    final res = await _dio.get(
      '$_a/list_consultation_sell',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (status != null && status != 'all') 'demand_status': status,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        if (officeId != null) 'office_id': officeId,
        if (listingManagerId != null) 'listing_manager_id': listingManagerId,
        if (source != null) 'source': source,
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
      },
    );
    final node = _inner(res.data);
    final items = _listOf(res.data, [
      'items',
    ]).whereType<Map>().map(SellLead.fromJson).toList();
    final total = asInt(node['total'], fallback: items.length);
    final hasMore = node['has_more'] == true || (page * limit) < total;
    return PagedSellLeads(
      items: items,
      total: total,
      page: page,
      hasMore: hasMore,
    );
  }

  Future<List<StatusCount>> statusCounts() async {
    final res = await _dio.get('$_a/get_consultation_sell_status_counts');
    return _listOf(res.data, [
      'counts',
      'items',
    ]).whereType<Map>().map(StatusCount.fromJson).toList();
  }

  // ---- Detail ----
  Future<SellLeadDetail> detail(int id) async {
    final res = await _dio.get(
      '$_a/get_consultation_sell',
      queryParameters: {'id': id},
    );
    return SellLeadDetail.fromJson(_inner(res.data));
  }

  // ---- Create / Update / Delete ----
  Future<int> create(Map<String, dynamic> payload) async {
    final res = await _dio.post('$_a/create_consultation_sell', data: payload);
    return asInt(_inner(res.data)['id']);
  }

  Future<void> update(int id, Map<String, dynamic> payload) async {
    await _dio.post(
      '$_a/update_consultation_sell',
      queryParameters: {'id': id},
      data: {'id': id, ...payload},
    );
  }

  Future<void> close(int id) => update(id, {'demand_status': 'closed'});

  Future<void> delete(int id) async {
    await _dio.post('$_a/delete_consultation_sell', data: {'id': id});
  }

  // ---- Assignments / link ----
  Future<void> assignListingManager(int id, int managerId) async {
    await _dio.post(
      '$_a/consultation_sell_assign_listing_manager',
      data: {'id': id, 'listing_manager_id': managerId},
    );
  }

  Future<void> assignSalesmanSupport(int id, int supportId) async {
    await _dio.post(
      '$_a/consultation_sell_assign_salesman_support',
      data: {'id': id, 'salesman_support_id': supportId},
    );
  }

  Future<void> linkRealEstate(
    int id,
    int realEstateId, {
    int? realEstateSalesmanId,
  }) async {
    await _dio.post(
      '$_a/consultation_sell_link_real_estate',
      data: {
        'id': id,
        'real_estate_id': realEstateId,
        if (realEstateSalesmanId != null)
          'real_estate_salesman_id': realEstateSalesmanId,
      },
    );
  }

  // ---- Activities + works + comments ----
  Future<List<SellWork>> activities(
    int id, {
    String activityType = 'all',
  }) async {
    final res = await _dio.get(
      '$_a/get_activities_consultation_sell',
      queryParameters: {'id': id, 'activity_type': activityType},
    );
    return _listOf(res.data, [
      'works',
    ]).whereType<Map>().map(SellWork.fromJson).toList();
  }

  /// Work-action dispatcher for sell leads. Unlike nhu-cầu-mua's unified
  /// `work_consultation` (whose tablename whitelist excludes `consultation_sell`),
  /// sell works go through this endpoint keyed by `consultation_sell_id` +
  /// `template_id` (4=lịch hẹn, 29=đặt cọc, 42=gọi/ghi chú/xác thực).
  Future<void> createWork({
    required int sellId,
    required int templateId,
    String? name,
    String? description,
    String? startedAt,
    String? location,
    String? depositType,
    double? depositAmount,
  }) async {
    await _dio.post(
      '$_a/create_work_consultation_sell',
      data: {
        'consultation_sell_id': sellId,
        'template_id': templateId,
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (startedAt != null) 'started_at': startedAt,
        if (location != null) 'location': location,
        if (depositType != null) 'deposit_type': depositType,
        if (depositAmount != null) 'deposit_amount': depositAmount,
      },
    );
  }

  Future<List<SellComment>> comments(int id) async {
    final res = await _dio.get(
      '$_a/consultation_sell_get_comments',
      queryParameters: {'id': id},
    );
    return _listOf(res.data, [
      'items',
      'comments',
    ]).whereType<Map>().map(SellComment.fromJson).toList();
  }

  Future<void> createComment(int id, String content) async {
    await _dio.post(
      '$_a/consultation_sell_create_comment',
      data: {'id': id, 'consultation_sell_id': id, 'content_comment': content},
    );
  }

  // ---- Tag assignment history ----
  Future<List<SellTagLog>> tagHistory(int id, {int limit = 50}) async {
    final res = await _dio.get(
      '$_a/get_entity_tag_history.json',
      queryParameters: {
        'entity_type': 'consultation_sell',
        'entity_id': id,
        'limit': limit,
      },
    );
    // Envelope `{success, data:[...]}` unwraps to the list via the interceptor.
    final data = res.data;
    final list = data is List ? data : _listOf(data, ['data', 'items']);
    return list.whereType<Map>().map(SellTagLog.fromJson).toList();
  }

  // ---- Lookups ----
  Future<List<SellPropertyType>> propertyTypes() async {
    final res = await _dio.get('$_a/get_property_types');
    return _listOf(res.data, [
      'items',
    ]).whereType<Map>().map(SellPropertyType.fromJson).toList();
  }

  /// `get_listing_managers_by_post_office` → `data.flat_list[]` (each node
  /// already flattened with `post_office_name`; `data.tree_data[]` is the
  /// nested org-chart form, not needed here). Filter out org-header nodes
  /// (`is_listing_manager: false`) that appear alongside real managers.
  Future<List<ListingManager>> listingManagers({
    int? officeId,
    String? search,
  }) async {
    final res = await _dio.get(
      '$_a/get_listing_managers_by_post_office',
      queryParameters: {
        if (officeId != null) 'office_id': officeId,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    final node = _inner(res.data);
    return _listOf(node, ['flat_list'])
        .whereType<Map>()
        .where(ListingManager.isListingManager)
        .map(ListingManager.fromJson)
        .toList();
  }

  /// `SELL_DEMAND_*` action gates — returned on every `list_consultation_sell`
  /// response, not a dedicated endpoint. Fetch the cheapest possible page
  /// (limit=1) just to read that map.
  ///
  /// `permissions` sits alongside `data` in the raw envelope (same shape as
  /// `get_listing_managers_by_post_office`'s sibling `count` field) — the
  /// normal EnvelopeInterceptor unwrap would discard it, so this opts out via
  /// `rawEnvelope` and checks both the sibling and nested-in-`data` spot
  /// defensively.
  Future<SellPermissions> permissions() async {
    final res = await _dio.get(
      '$_a/list_consultation_sell',
      queryParameters: {'page': 1, 'limit': 1},
      options: Options(extra: {'rawEnvelope': true}),
    );
    final root = res.data;
    if (root is! Map) return const SellPermissions();
    final data = root['data'];
    final permNode =
        root['permissions'] ?? (data is Map ? data['permissions'] : null);
    return SellPermissions.fromJson(permNode is Map ? permNode : const {});
  }

  Future<List<SellOffice>> offices() async {
    final res = await _dio.get('$_a/get_offices');
    return _listOf(res.data, [
      'items',
    ]).whereType<Map>().map(SellOffice.fromJson).toList();
  }

  Future<List<SellDuplicate>> checkDuplicate(
    String phone, {
    int? excludeId,
  }) async {
    final res = await _dio.get(
      '$_a/check_duplicate_consultation_sell',
      queryParameters: {
        'customer_phone': phone,
        if (excludeId != null) 'exclude_id': excludeId,
      },
    );
    return _listOf(res.data, [
      'duplicates',
    ]).whereType<Map>().map(SellDuplicate.fromJson).toList();
  }
}

final consultationSellApiProvider = Provider<ConsultationSellApi>(
  (ref) => ConsultationSellApi(ref.watch(dioProvider)),
);

final sellStatusCountsProvider = FutureProvider.autoDispose<List<StatusCount>>((
  ref,
) {
  return ref.watch(consultationSellApiProvider).statusCounts();
});

/// `SELL_DEMAND_*` action gates for the current user.
final sellPermissionsProvider = FutureProvider.autoDispose<SellPermissions>((
  ref,
) {
  return ref.watch(consultationSellApiProvider).permissions();
});

final sellDetailProvider = FutureProvider.autoDispose
    .family<SellLeadDetail, int>((ref, id) {
      return ref.watch(consultationSellApiProvider).detail(id);
    });

final sellActivitiesProvider = FutureProvider.autoDispose
    .family<List<SellWork>, int>((ref, id) {
      return ref.watch(consultationSellApiProvider).activities(id);
    });

final sellCommentsProvider = FutureProvider.autoDispose
    .family<List<SellComment>, int>((ref, id) {
      return ref.watch(consultationSellApiProvider).comments(id);
    });

final sellPropertyTypesProvider =
    FutureProvider.autoDispose<List<SellPropertyType>>((ref) {
      return ref.watch(consultationSellApiProvider).propertyTypes();
    });

final sellTagHistoryProvider = FutureProvider.autoDispose
    .family<List<SellTagLog>, int>((ref, id) {
      return ref.watch(consultationSellApiProvider).tagHistory(id);
    });
