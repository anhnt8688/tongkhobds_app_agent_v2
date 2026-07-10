import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/json_parse.dart';
import 'models/filter_config.dart';
import 'models/property.dart';
import 'models/property_detail.dart';
import 'models/search_filter.dart';
import 'models/sell_news_post.dart';

/// A single filter option from `get_list_type_search.json` (v1 `ValueModel`).
/// [id] is used by most filters (source/sort/property_types/bedrooms/
/// directions); status tabs key on [code]; [name] is the label.
class FilterValue {
  const FilterValue({this.id, this.code, required this.name});
  final dynamic id; // int or String, backend is loosely typed
  final String? code;
  final String name;

  @override
  bool operator ==(Object other) =>
      other is FilterValue &&
      other.id == id &&
      other.code == code &&
      other.name == name;

  @override
  int get hashCode => Object.hash(id, code, name);
}

/// All filter groups for "BĐS của tôi", parsed from `get_list_type_search.json`.
/// Mirrors v1's per-`code` grouping in `MyProductController.fetchListTypeStatus`.
class ListingFilters {
  const ListingFilters({
    this.statuses = const [],
    this.sources = const [],
    this.sorts = const [],
    this.propertyTypes = const [],
    this.priceRanges = const [],
    this.areaRanges = const [],
    this.bedrooms = const [],
    this.houseDirections = const [],
    this.balconyDirections = const [],
  });

  final List<FilterValue> statuses;
  final List<FilterValue> sources;
  final List<FilterValue> sorts;
  final List<FilterValue> propertyTypes;
  final List<FilterValue> priceRanges;
  final List<FilterValue> areaRanges;
  final List<FilterValue> bedrooms;
  final List<FilterValue> houseDirections;
  final List<FilterValue> balconyDirections;
}

/// A page of property results.
class PagedProperties {
  const PagedProperties({
    required this.items,
    required this.total,
    required this.page,
  });

  final List<Property> items;
  final int total;
  final int page;
}

class RealEstateApi {
  RealEstateApi(this._dio);

  final Dio _dio;

  Future<PagedProperties> search(
    SearchFilter filter, {
    required int page,
    int limit = AppConfig.pageSize,
  }) async {
    // v1 app uses the customer namespace for the main search list.
    final res = await _dio.get(
      '${AppConfig.customer}/real_estate_v2.json',
      queryParameters: filter.toQuery(page: page, limit: limit),
    );
    return _parsePaged(res.data, page);
  }

  /// My posted listings — `get_list_real_estate.json` (v1 `fetchMyProduct`).
  /// All filter args are optional; only non-empty values are sent. Param names
  /// match v1 exactly: source/sort/bedrooms/*_direction send the option `id`,
  /// `property_types` is a comma-joined id list, `status_id` is the status
  /// `code`, and `price_range`/`area_range` are "min-max" (or "min" / "0-max").
  Future<PagedProperties> myListings({
    String? search,
    String? statusId,
    String? source,
    String? sort,
    List<String> propertyTypeIds = const [],
    String? priceRange,
    String? areaRange,
    String? bedrooms,
    String? houseDirection,
    String? balconyDirection,
    int page = 1,
    int limit = AppConfig.pageSize,
  }) async {
    final raw = <String, dynamic>{
      'page': page,
      'limit': limit,
      'search': search,
      'source': source,
      'sort': sort,
      'property_types':
          propertyTypeIds.isNotEmpty ? propertyTypeIds.join(',') : null,
      'price_range': priceRange,
      'area_range': areaRange,
      'bedrooms': bedrooms,
      'house_direction': houseDirection,
      'balcony_direction': balconyDirection,
      'status_id': statusId,
    };
    final query = <String, dynamic>{
      for (final e in raw.entries)
        if (e.value != null && e.value.toString().trim().isNotEmpty)
          e.key: e.value,
    };
    final res = await _dio.get(
      '${AppConfig.agent}/get_list_real_estate.json',
      queryParameters: query,
    );
    return _parsePaged(res.data, page);
  }

  /// All filter groups for "BĐS của tôi" — `get_list_type_search.json`
  /// (v1 `fetchListTypeStatus`). Each group is `{code, value:[{id,code,name}]}`.
  /// Returns empty groups on any failure so the UI can still list all listings.
  Future<ListingFilters> myListingFilters() async {
    try {
      final res =
          await _dio.get('${AppConfig.agent}/get_list_type_search.json');
      // After the envelope unwrap, `res.data` is the inner payload: a list of
      // `{code, value:[...]}` groups, or a map wrapping that list under `data`.
      final data = res.data;
      final groups = data is List
          ? data
          : (data is Map ? (data['data'] ?? data['type_search']) : null);
      if (groups is! List) return const ListingFilters();

      List<FilterValue> valuesFor(String code) {
        final group = groups.whereType<Map>().firstWhere(
              (g) => g['code'] == code,
              orElse: () => const {},
            );
        final values = group['value'];
        if (values is! List) return const [];
        return values
            .whereType<Map>()
            .map((e) => FilterValue(
                  id: e['id'],
                  code: e['code']?.toString(),
                  name: (e['name'] ?? '').toString(),
                ))
            .where((v) => v.name.isNotEmpty)
            .toList();
      }

      return ListingFilters(
        statuses: valuesFor('status'),
        sources: valuesFor('source'),
        sorts: valuesFor('sort'),
        propertyTypes: valuesFor('property_types'),
        priceRanges: valuesFor('price_range'),
        areaRanges: valuesFor('area_range'),
        bedrooms: valuesFor('bedrooms'),
        houseDirections: valuesFor('house_direction'),
        balconyDirections: valuesFor('balcony_direction'),
      );
    } catch (_) {
      return const ListingFilters();
    }
  }

  /// Parses the paginated envelope. The list lives under `properties` (search),
  /// `items`, or `data`; total under `total`.
  PagedProperties _parsePaged(Object? data, int page) {
    final List rawItems;
    int total;
    if (data is Map) {
      rawItems = (data['properties'] ??
          data['real_estates'] ??
          data['items'] ??
          data['data'] ??
          []) as List;
      total = asInt(data['total'] ?? data['count'], fallback: rawItems.length);
    } else if (data is List) {
      rawItems = data;
      total = data.length;
    } else {
      rawItems = const [];
      total = 0;
    }
    final items = rawItems
        .whereType<Map>()
        .map((e) => Property.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return PagedProperties(items: items, total: total, page: page);
  }

  /// Dynamic search — sends an arbitrary params map (city/transaction/sort +
  /// dynamic filter values) to `real_estate_v2.json`. Mirrors v1
  /// `fetchAllProductDynamic`.
  Future<PagedProperties> searchDynamic(
    Map<String, dynamic> params, {
    required int page,
  }) async {
    final query = <String, dynamic>{};
    params.forEach((k, v) {
      if (v == null) return;
      if (v is String && v.trim().isEmpty) return;
      if (v is List && v.isEmpty) return;
      query[k] = v is List ? v.join(',') : v;
    });
    query['page'] = page;
    final res = await _dio.get(
      '${AppConfig.customer}/real_estate_v2.json',
      queryParameters: query,
    );
    return _parsePaged(res.data, page);
  }

  /// Dynamic filter config for the search bar — `get_filter_config.json`.
  /// Reads the nested `data.filters.filters` map.
  Future<List<FilterOption>> getFilterConfig({
    required int transactionType,
    String? cityId,
  }) async {
    final res = await _dio.get(
      '${AppConfig.agent}/get_filter_config.json',
      queryParameters: {
        'transaction_type': transactionType,
        if (cityId != null && cityId.isNotEmpty) 'city_id': cityId,
      },
    );
    final data = res.data;
    if (data is! Map) return const [];
    // Path is data.filters.filters; tolerate a flatter shape too.
    Object? filters = data['filters'];
    if (filters is Map && filters['filters'] is Map) {
      filters = filters['filters'];
    }
    return parseFilterConfig(filters);
  }

  /// Property detail. When [owned] (viewing the agent's own listing), hits the
  /// agent endpoint `get_detail_real_estate.json` so the response carries
  /// status/commission/source_get; otherwise the public `property.json`.
  Future<PropertyDetail> detail({int? id, String? slug, bool owned = false}) async {
    assert(id != null || slug != null, 'id or slug required');
    final Response res;
    if (owned && id != null) {
      res = await _dio.get(
        '${AppConfig.customer}/get_detail_real_estate.json',
        queryParameters: {'real_estate_id': id, 'my_properties': 'true'},
      );
    } else {
      res = await _dio.get(
        '${AppConfig.customer}/property.json',
        queryParameters: {
          if (id != null) 'id': id,
          if (slug != null) 'slug': slug,
        },
      );
    }
    final data = res.data is Map ? res.data as Map : <String, dynamic>{};
    return PropertyDetail.fromResponse(data);
  }

  /// Unpublish (gỡ tin) an agent's listing — `unpublish_property.json?id=`.
  Future<void> unpublish(int id) async {
    await _dio.post('${AppConfig.customer}/unpublish_property.json',
        queryParameters: {'id': id});
  }

  /// "Đăng bán" post templates for a listing — `get_news_by_real_estate.json`.
  /// After the envelope unwrap, `res.data` is the inner `{posts: [...]}`.
  Future<List<SellNewsPost>> newsByRealEstate(int realEstateId) async {
    final res = await _dio.get(
      '${AppConfig.agent}/get_news_by_real_estate.json',
      queryParameters: {'real_estate_id': realEstateId},
    );
    final data = res.data;
    final raw = data is Map ? (data['posts'] as List? ?? const []) : const [];
    return raw.whereType<Map>().map(SellNewsPost.fromJson).toList();
  }
}

final realEstateApiProvider = Provider<RealEstateApi>((ref) {
  return RealEstateApi(ref.watch(dioProvider));
});
