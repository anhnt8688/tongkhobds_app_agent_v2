import '../../../../core/utils/json_parse.dart';

/// Project images live on the giaodich host (relative paths). Shared by the
/// project detail + its child items.
String? projectImageUrl(String? path) {
  if (path == null || path.isEmpty) return null;
  if (path.startsWith('http')) return path;
  return 'https://giaodich.tongkhobds.com/${path.replaceFirst(RegExp(r'^/'), '')}';
}

/// A child project (phân khu) shown under a [ProjectChildGroup]. Mirrors v1
/// `ProjectChildModel`.
class ProjectChildItem {
  const ProjectChildItem({
    required this.code,
    required this.name,
    this.image,
    this.area,
    this.areaUnit,
    this.totalUnits,
    this.address,
  });

  final String code;
  final String name;
  final String? image;
  final String? area;
  final String? areaUnit;
  final int? totalUnits;
  final String? address;

  String get areaText =>
      (area == null || area!.isEmpty) ? '' : '$area ${areaUnit ?? ''}'.trim();

  factory ProjectChildItem.fromJson(Map d) => ProjectChildItem(
        code: (d['project_code'] ?? '').toString(),
        name: (d['project_name'] ?? '').toString(),
        image: projectImageUrl(d['main_image']?.toString()),
        area: d['project_area']?.toString(),
        areaUnit: d['area_unit']?.toString(),
        totalUnits: asIntOrNull(d['total_units']),
        address: d['street_address']?.toString(),
      );
}

/// A group of child projects by property type (e.g. "Căn hộ", "Biệt thự").
/// Mirrors v1 `PropertyTypeChildrenModel`.
class ProjectChildGroup {
  const ProjectChildGroup({
    required this.title,
    this.projectType,
    this.children = const [],
  });

  final String title;
  final int? projectType;
  final List<ProjectChildItem> children;

  factory ProjectChildGroup.fromJson(Map d) {
    final raw = d['project_childs'];
    final children = (raw is List)
        ? raw.whereType<Map>().map(ProjectChildItem.fromJson).toList()
        : <ProjectChildItem>[];
    return ProjectChildGroup(
      title: (d['title'] ?? '').toString(),
      projectType: asIntOrNull(d['project_type']),
      children: children,
    );
  }
}

/// Full project info from `project_details.json` (`data.project`). Field set and
/// section data mirror v1 `ProjectModel` + `detail_project_page`.
class ProjectDetail {
  const ProjectDetail({
    required this.code,
    required this.name,
    this.codeShow,
    this.slug,
    this.description,
    this.htmlContent,
    this.status,
    this.area,
    this.areaUnit,
    this.developerName,
    this.developerLogo,
    this.legalStatus,
    this.totalUnits,
    this.totalTowers,
    this.address,
    this.contactPhone,
    this.priceDescription,
    this.isShowInventory = false,
    this.lat,
    this.lng,
    this.image,
    this.gallery = const [],
    this.masterPlanImages = const [],
    this.utilities = const [],
    this.childGroups = const [],
  });

  final String code;
  final String name;
  final String? codeShow;
  final String? slug;
  final String? description;
  final String? htmlContent;
  final String? status;
  final String? area;
  final String? areaUnit;
  final String? developerName;
  final String? developerLogo;
  final String? legalStatus;
  final int? totalUnits;
  final int? totalTowers;
  final String? address;
  final String? contactPhone;
  final String? priceDescription;
  final bool isShowInventory;
  final double? lat;
  final double? lng;
  final String? image;
  final List<String> gallery;
  final List<String> masterPlanImages;
  final List<String> utilities;
  final List<ProjectChildGroup> childGroups;

  String get areaText =>
      (area == null || area!.isEmpty) ? '' : '$area ${areaUnit ?? ''}'.trim();

  bool get hasChildren => childGroups.any((g) => g.children.isNotEmpty);

  /// All carousel images (hero + gallery), main image first, de-duplicated.
  List<String> get heroImages {
    final out = <String>[];
    if (image != null && image!.isNotEmpty) out.add(image!);
    for (final g in gallery) {
      if (!out.contains(g)) out.add(g);
    }
    return out;
  }

  static List<String> _imgList(Object? raw) {
    if (raw is! List) return const [];
    final out = <String>[];
    for (final g in raw) {
      final u = projectImageUrl(g?.toString());
      if (u != null) out.add(u);
    }
    return out;
  }

  /// Utilities may arrive as bare strings or as objects `{name|title}`.
  static List<String> _utilities(Object? raw) {
    if (raw is! List) return const [];
    final out = <String>[];
    for (final u in raw) {
      String? name;
      if (u is String) {
        name = u;
      } else if (u is Map) {
        name = (u['name'] ?? u['title'] ?? u['utility_name'])?.toString();
      }
      if (name != null && name.trim().isNotEmpty) out.add(name.trim());
    }
    return out;
  }

  factory ProjectDetail.fromJson(Map p) {
    final addr = [p['street_address'], p['ward'], p['district'], p['city']]
        .map((e) => (e ?? '').toString().trim())
        .where((e) => e.isNotEmpty)
        .join(', ');
    final groupsRaw = p['property_types_childrens'];
    final childGroups = (groupsRaw is List)
        ? groupsRaw.whereType<Map>().map(ProjectChildGroup.fromJson).toList()
        : <ProjectChildGroup>[];
    return ProjectDetail(
      code: (p['project_code'] ?? p['project_code_show'] ?? '').toString(),
      name: (p['project_name'] ?? 'Dự án').toString(),
      codeShow: p['project_code_show']?.toString(),
      slug: p['slug']?.toString(),
      description: p['description']?.toString(),
      htmlContent: p['html_content']?.toString(),
      status: p['project_status']?.toString(),
      area: p['project_area']?.toString(),
      areaUnit: p['area_unit']?.toString(),
      developerName: p['developer_name']?.toString(),
      developerLogo: projectImageUrl(p['developer_logo']?.toString()),
      legalStatus: p['legal_status']?.toString(),
      totalUnits: asIntOrNull(p['total_units']),
      totalTowers: asIntOrNull(p['total_towers']),
      address: addr.isEmpty ? null : addr,
      contactPhone: p['contact_phone']?.toString(),
      priceDescription: p['price_description']?.toString(),
      isShowInventory: p['is_show_inventory'] == true ||
          p['is_show_inventory'] == 1 ||
          p['is_show_inventory'] == '1',
      lat: asDoubleOrNull(p['latitude'] ?? p['lat']),
      lng: asDoubleOrNull(p['longitude'] ?? p['lng'] ?? p['long']),
      image: projectImageUrl(p['main_image']?.toString()),
      gallery: _imgList(p['gallery_images']),
      masterPlanImages: _imgList(p['master_plan_images']),
      utilities: _utilities(p['utilities']),
      childGroups: childGroups,
    );
  }
}
