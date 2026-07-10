import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/json_parse.dart';

/// A map marker from `real_estate_map.json` (`data.properties[]`).
class RealEstateMapItem {
  const RealEstateMapItem({
    required this.id,
    required this.lat,
    required this.lng,
    this.slug,
    this.priceDescription = '',
    this.realEstateCount = 0,
    this.projectCode = '',
    this.expired = false,
  });

  final int id;
  final double lat;
  final double lng;
  final String? slug;
  final String priceDescription;
  final int realEstateCount;
  final String projectCode;
  final bool expired;

  bool get hasLatLng => lat != 0 && lng != 0;

  factory RealEstateMapItem.fromJson(Map d) => RealEstateMapItem(
        id: asInt(d['id'] ?? d['real_estate_id']),
        lat: asDoubleOrNull(d['lat'] ?? d['latitude']) ?? 0,
        lng: asDoubleOrNull(d['lng'] ?? d['long'] ?? d['longitude']) ?? 0,
        slug: d['slug']?.toString(),
        priceDescription:
            (d['price_description'] ?? d['price_display'] ?? '').toString(),
        realEstateCount: asInt(d['real_estate_count']),
        projectCode: (d['project_code'] ?? '').toString(),
        expired: d['expired'] == true,
      );
}

/// Quick-preview detail from `property_map.json?id=` (`data`).
class PropertyMapDetail {
  const PropertyMapDetail({
    required this.id,
    required this.title,
    this.image,
    this.priceDescription = '',
    this.area = '',
    this.bedrooms,
    this.bathrooms,
    this.slug,
  });

  final int id;
  final String title;
  final String? image;
  final String priceDescription;
  final String area;
  final int? bedrooms;
  final int? bathrooms;
  final String? slug;

  factory PropertyMapDetail.fromJson(Map d, {int? fallbackId}) =>
      PropertyMapDetail(
        id: asInt(d['id'] ?? d['real_estate_id'] ?? fallbackId),
        title: (d['title'] ?? d['name'] ?? 'BĐS').toString(),
        image: AppConfig.imageUrl(
            (d['main_image'] ?? d['image'] ?? d['thumbnail'])?.toString()),
        priceDescription:
            (d['price_description'] ?? d['price_display'] ?? '').toString(),
        area: (d['area'] ?? '').toString(),
        bedrooms: asIntOrNull(d['bedrooms'] ?? d['bedroom']),
        bathrooms: asIntOrNull(d['bathrooms'] ?? d['bathroom']),
        slug: d['slug']?.toString(),
      );
}

/// A BĐS row inside a project's map bottom sheet (`real_estate_map.json`
/// filtered by `project_code`, `data.properties[]`).
class ProjectMapItem {
  const ProjectMapItem({
    required this.id,
    this.title = '',
    this.image,
    this.priceDescription = '',
    this.area = '',
    this.bedrooms,
    this.bathrooms,
  });

  final int id;
  final String title;
  final String? image;
  final String priceDescription;
  final String area;
  final int? bedrooms;
  final int? bathrooms;

  factory ProjectMapItem.fromJson(Map d) => ProjectMapItem(
        id: asInt(d['id'] ?? d['real_estate_id']),
        title: (d['title'] ?? d['name'] ?? 'BĐS').toString(),
        image: AppConfig.imageUrl(
            (d['main_image'] ?? d['image'] ?? d['thumbnail'])?.toString()),
        priceDescription:
            (d['price_description'] ?? d['price_display'] ?? '').toString(),
        area: (d['area'] ?? '').toString(),
        bedrooms: asIntOrNull(d['bedrooms'] ?? d['bedroom']),
        bathrooms: asIntOrNull(d['bathrooms'] ?? d['bathroom']),
      );
}

/// One page of a project's listings (for the bottom-sheet pagination).
class ProjectMapPage {
  const ProjectMapPage({
    this.items = const [],
    this.page = 1,
    this.totalPages = 1,
  });
  final List<ProjectMapItem> items;
  final int page;
  final int totalPages;
}

/// Project header for the map bottom sheet (`project_details_map.json`,
/// `data.project`).
class ProjectMapDetails {
  const ProjectMapDetails({
    this.name = '',
    this.image,
    this.price = '',
    this.area = '',
  });
  final String name;
  final String? image;
  final String price;
  final String area;

  factory ProjectMapDetails.fromJson(Map d) => ProjectMapDetails(
        name: (d['project_name'] ?? d['name'] ?? '').toString(),
        image: AppConfig.imageUrl((d['main_image'] ?? d['image'])?.toString()),
        price: (d['price'] ?? d['price_description'] ?? '').toString(),
        area: (d['area'] ?? '').toString(),
      );
}

class MapApi {
  MapApi(this._dio);
  final Dio _dio;

  /// BĐS within [radiusKm] of (lat,lng). transactionType 3 → projects.
  Future<List<RealEstateMapItem>> fetchMap({
    required double lat,
    required double lng,
    required double radiusKm,
    int limit = 50,
    int? transactionType,
  }) async {
    final res = await _dio.get(
      '${AppConfig.customer}/real_estate_map.json',
      queryParameters: {
        'latlng': '${lat.toStringAsFixed(6)},${lng.toStringAsFixed(6)}',
        'radius': radiusKm.toStringAsFixed(2),
        'limit': limit,
        if (transactionType != null) 'transaction_type': transactionType,
      },
    );
    final data = res.data;
    final List raw = data is Map
        ? (data['properties'] ?? data['items'] ?? data['data'] ?? []) as List
        : (data is List ? data : const []);
    return raw.whereType<Map>().map(RealEstateMapItem.fromJson).toList();
  }

  /// Quick-preview detail for a marker tap.
  Future<PropertyMapDetail?> propertyDetail(int id) async {
    final res = await _dio.get(
      '${AppConfig.customer}/property_map.json',
      queryParameters: {'id': id},
    );
    final data = res.data;
    final Map? d = data is Map
        ? (data['data'] is Map ? data['data'] as Map : data)
        : null;
    if (d == null || d.isEmpty) return null;
    return PropertyMapDetail.fromJson(d, fallbackId: id);
  }

  /// BĐS within a project (for the project bottom sheet). v1 reuses
  /// `real_estate_map.json` with `project_code` + paging; the envelope unwrap
  /// leaves `res.data` = `{properties:[...], page, total_pages}`.
  Future<ProjectMapPage> projectProperties(
    String projectCode, {
    int page = 1,
    int limit = 20,
  }) async {
    final res = await _dio.get(
      '${AppConfig.customer}/real_estate_map.json',
      queryParameters: {
        'project_code': projectCode,
        'page': page,
        'limit': limit,
      },
    );
    final data = res.data;
    if (data is! Map) return const ProjectMapPage();
    final raw = data['properties'];
    final items = raw is List
        ? raw.whereType<Map>().map(ProjectMapItem.fromJson).toList()
        : <ProjectMapItem>[];
    return ProjectMapPage(
      items: items,
      page: asInt(data['page'], fallback: page),
      totalPages: asInt(data['total_pages'], fallback: page),
    );
  }

  /// Project header detail for the bottom sheet — `project_details_map.json?id=`
  /// → (after unwrap) `{project:{...}}`.
  Future<ProjectMapDetails?> projectDetails(int id) async {
    final res = await _dio.get(
      '${AppConfig.customer}/project_details_map.json',
      queryParameters: {'id': id},
    );
    final data = res.data;
    final p = data is Map ? data['project'] : null;
    if (p is! Map) return null;
    return ProjectMapDetails.fromJson(p);
  }
}

final mapApiProvider = Provider<MapApi>((ref) => MapApi(ref.watch(dioProvider)));
