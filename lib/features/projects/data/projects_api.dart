import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/json_parse.dart';
import 'models/project_detail.dart';

export 'models/project_detail.dart';

/// One row of `real_estate_sale_project.json`. A flat list where `parent_id`
/// == null marks a project, and a non-null `parent_id` marks a subdivision
/// (phân khu) belonging to that project. Mirrors v1 `SaleProjectItem`.
class SaleProjectItem {
  const SaleProjectItem({
    required this.id,
    required this.parentId,
    required this.code,
    required this.name,
    this.image,
    this.realEstateSale,
    required this.visibilityLevel,
    required this.requiredInforVerify,
    required this.userInforVerify,
    required this.registeredVerify,
  });

  final int id;
  final int? parentId;
  final String code;
  final String name;
  final String? image;
  final int? realEstateSale;

  /// 1 = open, 2/3 = requires sale registration before viewing the board.
  final int visibilityLevel;
  final bool requiredInforVerify;
  final bool userInforVerify;
  final bool registeredVerify;

  /// Project image lives on the giaodich host (relative paths).
  String? get imageUrl {
    if (image == null || image!.isEmpty) return null;
    if (image!.startsWith('http')) return image;
    return 'https://giaodich.tongkhobds.com/${image!.replaceFirst(RegExp(r'^/'), '')}';
  }

  factory SaleProjectItem.fromJson(Map d) => SaleProjectItem(
        id: asInt(d['id']),
        parentId: d['parent_id'] == null ? null : asInt(d['parent_id']),
        code: (d['project_code'] ?? '').toString(),
        name: (d['project_name'] ?? '').toString(),
        image: d['project_image']?.toString(),
        realEstateSale:
            d['real_estate_sale'] == null ? null : asInt(d['real_estate_sale']),
        visibilityLevel: asInt(d['visibility_level']),
        requiredInforVerify: _bool(d['required_infor_verify']),
        userInforVerify: _bool(d['user_infor_verify']),
        registeredVerify: _bool(d['registered_verify']),
      );

  static bool _bool(dynamic v) {
    if (v is bool) return v;
    if (v is num) return v != 0;
    if (v is String) return v == 'true' || v == '1';
    return false;
  }
}

/// A project (parent) with its subdivisions (children).
class ProjectGroup {
  ProjectGroup({required this.parent, required this.children});
  final SaleProjectItem parent;
  final List<SaleProjectItem> children;
}

/// Groups a flat [items] list into [ProjectGroup]s by `parent_id`
/// (matches v1 `buildGroups`): parents on top, children nested + sorted.
List<ProjectGroup> buildGroups(List<SaleProjectItem> items) {
  final byId = {for (final e in items) e.id: e};
  final parents = items.where((e) => e.parentId == null).toList();
  final childrenByParent = <int, List<SaleProjectItem>>{};
  for (final c in items.where((e) => e.parentId != null)) {
    (childrenByParent[c.parentId!] ??= <SaleProjectItem>[]).add(c);
  }

  final groups = <ProjectGroup>[
    for (final p in parents)
      ProjectGroup(
        parent: p,
        children: List.of(childrenByParent[p.id] ?? const []),
      ),
  ];

  // Children whose parent is missing → synthesize a placeholder parent.
  for (final pid in childrenByParent.keys.where((k) => !byId.containsKey(k))) {
    groups.add(ProjectGroup(
      parent: SaleProjectItem(
        id: pid,
        parentId: null,
        code: 'UNKNOWN-$pid',
        name: 'Dự án (không xác định)',
        visibilityLevel: 1,
        requiredInforVerify: false,
        userInforVerify: false,
        registeredVerify: false,
      ),
      children: List.of(childrenByParent[pid]!),
    ));
  }

  groups.sort((a, b) => a.parent.name.compareTo(b.parent.name));
  for (final g in groups) {
    g.children.sort((a, b) => a.name.compareTo(b.name));
  }
  return groups;
}

/// A status summary chip on the subdivision board (e.g. "Còn hàng" · 24).
class ApartmentSummary {
  const ApartmentSummary({required this.title, this.count = 0, this.color});
  final String title;
  final int count;
  final String? color;

  factory ApartmentSummary.fromJson(Map d) => ApartmentSummary(
        title: (d['title'] ?? '').toString(),
        count: asInt(d['count']),
        color: d['color']?.toString(),
      );
}

/// One apartment row from `apartment_status.json` (`data.apartments[]`).
class Apartment {
  const Apartment({
    required this.code,
    this.title,
    this.area,
    this.price,
    this.priceDescription,
    this.direction,
    this.bedrooms,
    this.bathrooms,
    this.zone,
    this.floor,
    this.statusCode,
    this.statusColor,
    this.image,
  });

  final String code;
  final String? title;
  final int? area;
  final double? price;
  final String? priceDescription;
  final String? direction;
  final int? bedrooms;
  final int? bathrooms;
  final String? zone;
  final String? floor; // v1: grid grouped by hammlet (tầng)
  final String? statusCode;
  final String? statusColor;
  final String? image;

  String get priceText {
    if (priceDescription != null && priceDescription!.isNotEmpty) {
      return priceDescription!;
    }
    if (price == null || price == 0) return '—';
    if (price! >= 1e9) return '${(price! / 1e9).toStringAsFixed(1)} tỷ';
    return '${(price! / 1e6).toStringAsFixed(0)} triệu';
  }

  factory Apartment.fromJson(Map d) => Apartment(
        code: (d['apartment_code'] ?? d['code'] ?? d['title'] ?? '—').toString(),
        title: d['title']?.toString(),
        area: asIntOrNull(d['area']),
        price: asDoubleOrNull(d['price']),
        priceDescription: d['price_description']?.toString(),
        direction: d['house_direction']?.toString(),
        bedrooms: asIntOrNull(d['bedrooms']),
        bathrooms: asIntOrNull(d['bathrooms']),
        zone: (d['zone_of_project'] ?? d['hammlet'] ?? d['hamlet'])?.toString(),
        floor: (d['hammlet'] ?? d['hamlet'])?.toString(),
        statusCode: d['status_code']?.toString(),
        statusColor: d['status_color']?.toString(),
        image: AppConfig.imageUrl(d['main_image']?.toString()),
      );
}

/// The subdivision board payload (`apartment_status.json` → `data`).
class SubdivisionBoard {
  const SubdivisionBoard({this.summary = const [], this.apartments = const []});
  final List<ApartmentSummary> summary;
  final List<Apartment> apartments;
}

class ProjectsApi {
  ProjectsApi(this._dio);

  final Dio _dio;

  /// Project detail by project_code — `project_details.json` → `data.project`.
  Future<ProjectDetail> projectDetail(String code) async {
    final res = await _dio.get(
      '${AppConfig.customer}/project_details.json',
      queryParameters: {'id': code},
    );
    final data = res.data;
    final Map root = data is Map
        ? (data['data'] is Map ? data['data'] as Map : data)
        : const {};
    final project = root['project'] is Map ? root['project'] as Map : root;
    return ProjectDetail.fromJson(project);
  }

  /// Sale project boards grouped by project → subdivisions.
  Future<List<ProjectGroup>> boards() async {
    final res =
        await _dio.get('${AppConfig.agent}/real_estate_sale_project.json');
    final raw = _listOf(res.data);
    final items = raw.whereType<Map>().map(SaleProjectItem.fromJson).toList();
    return buildGroups(items);
  }

  /// Register to sell a project/subdivision (unlocks visibility 2/3 boards).
  Future<bool> registerSale({
    required int projectId,
    int realEstateSaleId = 1,
  }) async {
    final res = await _dio.post(
      '${AppConfig.agent}/real_estate_sale_register.json',
      data: {'project_id': projectId, 'real_estate_sale_id': realEstateSaleId},
    );
    final data = res.data;
    if (data is Map) {
      final inner = data['data'] is Map ? data['data'] as Map : data;
      return inner['success'] != false; // success unless explicitly false
    }
    return true;
  }

  /// Apartment board for a subdivision (`apartment_status.json`).
  Future<SubdivisionBoard> subdivision(String projectCode, {String? zone}) async {
    final res = await _dio.get(
      '${AppConfig.agent}/apartment_status.json',
      queryParameters: {
        'project_code': projectCode,
        if (zone != null && zone.isNotEmpty) 'zone_of_project': zone,
      },
    );
    final data = res.data;
    final Map d = data is Map
        ? (data['data'] is Map ? data['data'] as Map : data)
        : const {};
    final apartments = (d['apartments'] is List ? d['apartments'] as List : [])
        .whereType<Map>()
        .map(Apartment.fromJson)
        .toList();
    final summary = (d['summary'] is List ? d['summary'] as List : [])
        .whereType<Map>()
        .map(ApartmentSummary.fromJson)
        .toList();
    return SubdivisionBoard(summary: summary, apartments: apartments);
  }

  List _listOf(Object? data) {
    if (data is Map) {
      if (data['data'] is List) return data['data'] as List;
      if (data['items'] is List) return data['items'] as List;
    }
    if (data is List) return data;
    return const [];
  }
}

final projectsApiProvider =
    Provider<ProjectsApi>((ref) => ProjectsApi(ref.watch(dioProvider)));

final projectGroupsProvider =
    FutureProvider.autoDispose<List<ProjectGroup>>((ref) {
  return ref.watch(projectsApiProvider).boards();
});

final subdivisionProvider = FutureProvider.autoDispose
    .family<SubdivisionBoard, String>((ref, code) {
  return ref.watch(projectsApiProvider).subdivision(code);
});

final projectDetailProvider =
    FutureProvider.autoDispose.family<ProjectDetail, String>((ref, code) {
  return ref.watch(projectsApiProvider).projectDetail(code);
});
