import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/json_parse.dart';
import 'models/listing_manager_models.dart';
import 'models/verification_models.dart';

/// Result of a mutating action (mirrors v1's `{status, message}` reads).
class VerificationActionResult {
  const VerificationActionResult({required this.success, required this.message});
  final bool success;
  final String message;
}

class VerificationApi {
  VerificationApi(this._dio);
  final Dio _dio;

  String get _a => AppConfig.agent; // /api_agent
  String get _public => AppConfig.public; // /api
  String get _customer => AppConfig.customer; // /api_customer
  static const String _realEstateHandle = '/real_estate_handle';

  /// Keep the full `{status, data, message}` map (don't unwrap to `data`).
  Options get _rawOpts =>
      Options(extra: const {'rawEnvelope': true}, headers: const {
        'Content-Type': 'application/json',
      });

  // ── filters / list ──

  Future<List<VerificationStatusFilter>> fetchStatusFilters() async {
    final res = await _dio.get('$_a/get_list_type_search.json',
        queryParameters: {'type': 'verify'});
    // After envelope unwrap res.data is the `data` payload (a list of groups).
    final data = res.data;
    final groups = data is List
        ? data
        : (data is Map && data['data'] is List ? data['data'] as List : const []);
    final firstGroup = groups.isNotEmpty && groups.first is Map
        ? groups.first as Map
        : const {};
    final values = firstGroup['value'] is List ? firstGroup['value'] as List : const [];
    return values
        .whereType<Map>()
        .map(VerificationStatusFilter.fromJson)
        .toList();
  }

  Future<VerificationSalesmanListResponse> fetchVerificationList({
    required int limit,
    required int offset,
    List<int>? statusIds,
    String? search,
    String? dateFrom,
    String? dateTo,
    String? timeField,
    int? office,
    int? salesOff,
    List<int>? verifyingAgentIds,
    String? createdType,
    List<int>? tags,
    String? tagOperator,
  }) async {
    final params = <String, dynamic>{
      'limit': limit,
      'offset': offset,
      if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      if (dateFrom != null && dateFrom.isNotEmpty) 'date_from': dateFrom,
      if (dateTo != null && dateTo.isNotEmpty) 'date_to': dateTo,
      if (timeField != null && timeField.isNotEmpty) 'time_field': timeField,
      if (office != null) 'office': office,
      if (salesOff != null) 'sales_off': salesOff,
      if (verifyingAgentIds != null && verifyingAgentIds.isNotEmpty)
        'verifying_agent_ids': verifyingAgentIds.join(','),
      if (createdType != null && createdType.isNotEmpty) 'created_type': createdType,
      if (tags != null && tags.isNotEmpty) 'tags': tags.join(','),
      if (tagOperator != null && tagOperator.isNotEmpty) 'tag_operator': tagOperator,
      if (statusIds != null && statusIds.isNotEmpty) 'status': statusIds.join(','),
    };
    final res = await _dio.get('$_a/get_list_verification_salesman.json',
        queryParameters: params);
    return VerificationSalesmanListResponse.fromJson(res.data);
  }

  // ── filter meta ──

  Future<List<VerificationOfficeOption>> fetchOfficeOptions() async {
    final res = await _dio.get('$_a/get_list_offices');
    return _listOf(res.data)
        .whereType<Map>()
        .map(VerificationOfficeOption.fromJson)
        .toList();
  }

  Future<List<VerificationSalesUserOption>> fetchSalesUserOptions() async {
    final res = await _dio.get('$_a/get_sales_off_users');
    return _listOf(res.data)
        .whereType<Map>()
        .map(VerificationSalesUserOption.fromJson)
        .toList();
  }

  Future<List<VerificationTagOption>> fetchVerificationTags() async {
    final res = await _dio.get('$_a/api_my_tags_for_filter');
    return _listOf(res.data)
        .whereType<Map>()
        .map(VerificationTagOption.fromJson)
        .where((t) => t.id != 0)
        .toList();
  }

  // ── detail ──

  Future<VerificationSalesmanDetailResponse> fetchVerificationDetail(int id) async {
    final res = await _dio
        .get('$_a/get_detail_verification_salesman.json', queryParameters: {'id': id});
    return VerificationSalesmanDetailResponse.fromJson(
        res.data is Map ? res.data as Map : const {});
  }

  /// Public article (property) detail for the article page's public tab.
  Future<VerificationRealEstateDetail> fetchPublicProductDetail(int id) async {
    final res = await _dio
        .get('$_customer/property.json', queryParameters: {'id': id});
    final data = res.data;
    final root = data is Map
        ? (data['data'] is Map ? data['data'] as Map : data)
        : const {};
    return VerificationRealEstateDetail.fromRaw(root);
  }

  // ── actions ──

  Future<VerificationActionResult> updateVerificationSalesman({
    required int realEstateSalesmanId,
    required int verificationStatus,
    String? reason,
    bool? resetAgentConfirm,
  }) async {
    final body = <String, dynamic>{
      'real_estate_salesman_id': realEstateSalesmanId,
      'verification_status': verificationStatus,
      if (reason != null && reason.trim().isNotEmpty) 'reason': reason.trim(),
      if (resetAgentConfirm != null) 'reset_agent_confirm': resetAgentConfirm,
    };
    return _action('$_a/update_verification_salesman.json', body);
  }

  Future<VerificationActionResult> reverifyVerificationSalesman({
    required int realEstateSalesmanId,
    required String reason,
  }) =>
      updateVerificationSalesman(
        realEstateSalesmanId: realEstateSalesmanId,
        verificationStatus: 5,
        reason: reason,
        resetAgentConfirm: true,
      );

  Future<ListingManagerResponse> fetchListingManagers() async {
    final res = await _dio.get('$_a/get_listing_manager.json');
    return ListingManagerResponse.fromData(res.data);
  }

  Future<VerificationActionResult> assignListingManager({
    required int realEstateSalesmanId,
    required int listingManagerId,
  }) {
    return _action('$_a/assign_listing_manager.json', {
      'real_estate_salesman_id': realEstateSalesmanId,
      'listing_manager_id': listingManagerId,
    });
  }

  Future<VerificationActionResult> assignSaleOffMember({
    required int realEstateSalesmanId,
    required int saleOffMemberId,
  }) =>
      _batchUpdate(realEstateSalesmanId, {'sale_off_member_id': saleOffMemberId});

  Future<VerificationActionResult> assignRealEstateSalesmanOffice({
    required int realEstateSalesmanId,
    required int postOfficeId,
  }) =>
      _batchUpdate(realEstateSalesmanId, {'post_office_id': postOfficeId});

  Future<VerificationActionResult> _batchUpdate(
      int realEstateSalesmanId, Map<String, dynamic> updateData) {
    return _action('$_a/batch_update_entities', {
      'entity_type': 'real_estate_salesman',
      'entity_ids': [realEstateSalesmanId],
      'update_data': updateData,
      'save_mode': 'all',
    });
  }

  /// Submit the verification info form.
  Future<VerificationActionResult> verifyRealEstate(Map<String, dynamic> body) {
    return _action('$_a/real_estate_verification.json', body);
  }

  /// Upload a media file → returns the media id, or null.
  Future<int?> uploadFile(FormData formData) async {
    final res = await _dio.post('$_realEstateHandle/upload_file.json', data: formData);
    final data = res.data;
    int? pick(dynamic v) {
      if (v is int) return v;
      if (v is String) return int.tryParse(v);
      if (v is List && v.isNotEmpty) return pick(v.first);
      return null;
    }

    if (data is Map) {
      return pick(data['media_upload_ids']) ??
          pick(data['media_upload_id']) ??
          pick(data['id']) ??
          (data['data'] is Map
              ? (pick((data['data'] as Map)['media_upload_ids']) ??
                  pick((data['data'] as Map)['media_upload_id']) ??
                  pick((data['data'] as Map)['id']))
              : pick(data['data']));
    }
    return pick(data);
  }

  // ── locations (for the form picker) ──

  Future<List<Map>> fetchCities({int limit = 63}) async {
    final res = await _dio.get('$_public/cities', queryParameters: {'limit': limit});
    return _listOf(res.data).whereType<Map>().toList();
  }

  Future<List<Map>> fetchLocations({
    required String id,
    required int layer,
    int grant = 1,
    String? nSlug,
  }) async {
    final res = await _dio.get('$_a/locations.json', queryParameters: {
      'id': id,
      'layer': layer,
      'grant': grant,
      if (nSlug != null && nSlug.isNotEmpty) 'n_slug': nSlug,
    });
    return _listOf(res.data).whereType<Map>().toList();
  }

  // ── helpers ──

  /// Run a mutating endpoint and read v1-style `{status, message}` (rawEnvelope
  /// keeps the full map; status==0 already throws ApiException via the envelope).
  Future<VerificationActionResult> _action(String path, Map<String, dynamic> body) async {
    try {
      final res = await _dio.post(path, data: body, options: _rawOpts);
      final data = res.data;
      final status = data is Map ? asInt(data['status'], fallback: 1) : 1;
      final message = data is Map ? asString(data['message']) : '';
      return VerificationActionResult(success: status == 1, message: message);
    } on DioException catch (e) {
      final err = e.error;
      return VerificationActionResult(
        success: false,
        message: err is ApiException ? err.message : 'Đã có lỗi xảy ra',
      );
    }
  }

  /// Pull a list out of an (already-unwrapped) envelope payload.
  List _listOf(dynamic data) {
    if (data is List) return data;
    if (data is Map) {
      if (data['data'] is List) return data['data'] as List;
      if (data['data'] is Map && (data['data'] as Map)['data'] is List) {
        return (data['data'] as Map)['data'] as List;
      }
    }
    return const [];
  }
}

final verificationApiProvider =
    Provider<VerificationApi>((ref) => VerificationApi(ref.watch(dioProvider)));
