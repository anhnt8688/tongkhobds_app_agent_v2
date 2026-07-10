import '../../../../core/utils/json_parse.dart';
import '../../../../core/widgets/status_pill.dart';

/// Demand (nhu cầu mua / consultation) status.
enum DemandStatus {
  newd('new', 'Mới', StatusTone.blue),
  active('active', 'Đang diễn ra', StatusTone.amber),
  inTransaction('in_transaction', 'Đang giao dịch', StatusTone.amber),
  completed('completed', 'Kết thúc', StatusTone.green),
  cancelled('cancelled', 'Đã huỷ', StatusTone.red);

  const DemandStatus(this.api, this.label, this.tone);
  final String api;
  final String label;
  final StatusTone tone;

  static DemandStatus? fromApi(String? v) {
    for (final s in values) {
      if (s.api == v) return s;
    }
    return null;
  }
}

/// Status display from the backend (`demand_status_name: {name, color}`).
class DemandStatusName {
  const DemandStatusName({this.name, this.color});
  final String? name;
  final String? color; // hex

  factory DemandStatusName.fromJson(Map d) => DemandStatusName(
      name: d['name']?.toString(), color: d['color']?.toString());
}

/// A tag chip (list_tags / item tags).
class DemandTag {
  const DemandTag({required this.id, required this.name, this.color, this.icon});
  final int id;
  final String name;
  final String? color; // hex
  final String? icon;

  factory DemandTag.fromJson(Map d) => DemandTag(
        id: asInt(d['tag_id'] ?? d['id']),
        name: (d['tag_name'] ?? d['name'] ?? '').toString(),
        color: (d['tag_color'] ?? d['color'])?.toString(),
        icon: (d['tag_icon'] ?? d['icon'])?.toString(),
      );
}

/// A status tab with count (`list_status[]`).
class StatusTab {
  const StatusTab(
      {required this.id, required this.name, this.count = 0, this.color});
  final String id;
  final String name;
  final int count;
  final String? color;

  factory StatusTab.fromJson(Map d) => StatusTab(
        id: (d['id'] ?? '').toString(),
        name: (d['name'] ?? '').toString(),
        count: asInt(d['count']),
        color: d['color']?.toString(),
      );
}

/// A demand list item.
class Demand {
  const Demand({
    required this.id,
    this.code,
    this.customerName,
    this.customerPhone,
    this.status,
    this.statusName,
    this.budgetMin,
    this.budgetMax,
    this.areaMin,
    this.areaMax,
    this.locationNames = const [],
    this.tags = const [],
    this.supportName,
    this.officeName,
    this.createdAt,
  });

  final int id;
  final String? code;
  final String? customerName;
  final String? customerPhone;
  final String? status;
  final DemandStatusName? statusName;
  final double? budgetMin;
  final double? budgetMax;
  final num? areaMin;
  final num? areaMax;
  final List<String> locationNames;
  final List<DemandTag> tags;
  final String? supportName;
  final String? officeName;
  final String? createdAt;

  DemandStatus? get statusEnum => DemandStatus.fromApi(status);
  String get statusLabel =>
      statusName?.name ?? statusEnum?.label ?? (status ?? '');

  factory Demand.fromJson(Map d) {
    final req = d['property_requirements'];
    final reqMap = req is Map ? req : const {};
    double? rangeVal(Object? range, String key) =>
        range is Map ? asDoubleOrNull(range[key]) : null;

    final locs = <String>[];
    final il = d['interested_locations'];
    if (il is List) {
      for (final e in il) {
        if (e is Map && (e['name'] ?? '').toString().trim().isNotEmpty) {
          locs.add(e['name'].toString());
        }
      }
    }

    final customer = d['customer'];
    final support = d['user_support'] ?? d['agent_support'];

    return Demand(
      id: asInt(d['id'] ?? d['consultation_id']),
      code: (d['consultation_code'] ?? d['demand_code'] ?? d['code'])?.toString(),
      customerName: (d['full_name'] ??
              (customer is Map ? customer['name'] : null) ??
              d['customer_name'])
          ?.toString(),
      customerPhone: (d['phone_number'] ?? d['customer_phone'])?.toString(),
      status: (d['status'] ?? d['demand_status'])?.toString(),
      statusName: d['demand_status_name'] is Map
          ? DemandStatusName.fromJson(d['demand_status_name'] as Map)
          : null,
      budgetMin: asDoubleOrNull(d['budget_min'] ?? d['min_price']) ??
          rangeVal(reqMap['budget_range'], 'min'),
      budgetMax: asDoubleOrNull(d['budget_max'] ?? d['max_price']) ??
          rangeVal(reqMap['budget_range'], 'max'),
      areaMin: asDoubleOrNull(d['area_min'] ?? d['min_area']) ??
          rangeVal(reqMap['area_range'], 'min'),
      areaMax: asDoubleOrNull(d['area_max'] ?? d['max_area']) ??
          rangeVal(reqMap['area_range'], 'max'),
      locationNames: locs,
      tags: (d['tags'] is List ? d['tags'] as List : const [])
          .whereType<Map>()
          .map(DemandTag.fromJson)
          .where((t) => t.name.isNotEmpty)
          .toList(),
      supportName: support is Map ? support['name']?.toString() : null,
      officeName: d['post_office_name']?.toString(),
      createdAt: (d['created_at'] ?? d['created_on'])?.toString(),
    );
  }
}

/// A page of demands + the status tabs.
class PagedDemands {
  const PagedDemands({
    required this.items,
    this.total = 0,
    this.page = 1,
    this.totalPages = 1,
    this.statusTabs = const [],
  });
  final List<Demand> items;
  final int total;
  final int page;
  final int totalPages;
  final List<StatusTab> statusTabs;

  bool get hasMore => page < totalPages;
}

/// Typed property requirements (detail).
class DemandRequirements {
  const DemandRequirements({
    this.propertyType,
    this.transactionType,
    this.budgetMin,
    this.budgetMax,
    this.areaMin,
    this.areaMax,
    this.bedroomsMin,
    this.bedroomsMax,
    this.bathroomsMin,
    this.floorsMin,
    this.floorsMax,
  });
  final String? propertyType;
  final String? transactionType;
  final double? budgetMin;
  final double? budgetMax;
  final num? areaMin;
  final num? areaMax;
  final int? bedroomsMin;
  final int? bedroomsMax;
  final int? bathroomsMin;
  final int? floorsMin;
  final int? floorsMax;

  factory DemandRequirements.fromJson(Map d) {
    double? r(Object? range, String k) =>
        range is Map ? asDoubleOrNull(range[k]) : null;
    int? ri(Object? range, String k) =>
        range is Map ? asIntOrNull(range[k]) : null;
    final beds = d['bedrooms'];
    return DemandRequirements(
      propertyType: _label(d['property_type']),
      transactionType: _txLabel(d['transaction_type'] ?? d['transaction_type_id']),
      budgetMin: asDoubleOrNull(d['budget_min']) ?? r(d['budget_range'], 'min'),
      budgetMax: asDoubleOrNull(d['budget_max']) ?? r(d['budget_range'], 'max'),
      areaMin: asDoubleOrNull(d['area_min']) ?? r(d['area_range'], 'min'),
      areaMax: asDoubleOrNull(d['area_max']) ?? r(d['area_range'], 'max'),
      bedroomsMin: asIntOrNull(d['bedrooms_min']) ??
          (beds is List && beds.isNotEmpty ? asIntOrNull(beds.first) : null),
      bedroomsMax: asIntOrNull(d['bedrooms_max']),
      bathroomsMin: asIntOrNull(d['bathrooms_min']),
      floorsMin: ri(d['floors_range'], 'min'),
      floorsMax: ri(d['floors_range'], 'max'),
    );
  }

  /// Transaction type label: code 1 = Mua bán, 2 = Cho thuê; else falls back to
  /// the backend-provided name.
  static String? _txLabel(Object? v) {
    // May arrive as int, numeric string, {id,title}, or [{id,title}].
    final first = v is List ? (v.isEmpty ? null : v.first) : v;
    final id = first is Map ? asIntOrNull(first['id']) : asIntOrNull(first);
    const map = {1: 'Mua bán', 2: 'Cho thuê'};
    if (id != null && map.containsKey(id)) return map[id];
    return _label(v);
  }

  static String? _label(Object? v) {
    if (v == null) return null;
    if (v is Map) {
      return (v['name'] ?? v['label'] ?? v['title'] ?? v['id'])?.toString();
    }
    if (v is List) {
      return v.isEmpty ? null : v.map(_label).whereType<String>().join(', ');
    }
    final s = v.toString();
    return s.isEmpty ? null : s;
  }
}

/// Full demand detail.
class DemandDetail {
  const DemandDetail({
    required this.id,
    this.code,
    this.customerName,
    this.customerPhone,
    this.status,
    this.statusName,
    this.requirements,
    this.directions = const [],
    this.legal = const [],
    this.furniture,
    this.special,
    this.note,
    this.locationNames = const [],
    this.tags = const [],
    this.supportName,
    this.supportPhone,
    this.officeName,
    this.createdAt,
    this.raw = const {},
  });

  final int id;
  final String? code;
  final String? customerName;
  final String? customerPhone;
  final String? status;
  final DemandStatusName? statusName;
  final DemandRequirements? requirements;
  final List<String> directions;
  final List<String> legal;
  final String? furniture;
  final String? special;
  final String? note;
  final List<String> locationNames;
  final List<DemandTag> tags;
  final String? supportName;
  final String? supportPhone;
  final String? officeName;
  final String? createdAt;
  final Map raw;

  DemandStatus? get statusEnum => DemandStatus.fromApi(status);
  String get statusLabel =>
      statusName?.name ?? statusEnum?.label ?? (status ?? '');
  bool get isClosed =>
      statusEnum == DemandStatus.completed ||
      statusEnum == DemandStatus.cancelled;

  factory DemandDetail.fromJson(Map d) {
    final customer = d['customer'];
    final support = d['user_support'] ?? d['agent_support'];
    final pref = d['preferences'];
    final prefMap = pref is Map ? pref : const {};

    final locs = <String>[];
    for (final key in ['location_preferences', 'interested_locations']) {
      final v = d[key];
      if (v is List) {
        for (final e in v) {
          if (e is Map && (e['name'] ?? '').toString().trim().isNotEmpty) {
            locs.add(e['name'].toString());
          }
        }
      }
    }

    return DemandDetail(
      id: asInt(d['id'] ?? d['consultation_id']),
      code: (d['consultation_code'] ?? d['demand_code'] ?? d['code'])?.toString(),
      customerName: (d['full_name'] ??
              (customer is Map ? customer['name'] : null) ??
              d['customer_name'])
          ?.toString(),
      customerPhone: (d['phone_number'] ?? d['customer_phone'])?.toString(),
      status: (d['status'] ?? d['demand_status'])?.toString(),
      statusName: d['demand_status_name'] is Map
          ? DemandStatusName.fromJson(d['demand_status_name'] as Map)
          : null,
      requirements: d['property_requirements'] is Map
          ? DemandRequirements.fromJson(d['property_requirements'] as Map)
          : null,
      directions: asStringList(prefMap['preferred_directions']),
      legal: asStringList(prefMap['legal_requirements']),
      furniture: prefMap['furniture_requirements']?.toString(),
      special: prefMap['special_requirements']?.toString(),
      note: (prefMap['note'] ?? d['notes'])?.toString(),
      locationNames: locs,
      tags: (d['tags'] is List ? d['tags'] as List : const [])
          .whereType<Map>()
          .map(DemandTag.fromJson)
          .where((t) => t.name.isNotEmpty)
          .toList(),
      supportName: support is Map ? support['name']?.toString() : null,
      supportPhone: support is Map ? support['phone']?.toString() : null,
      officeName: d['post_office_name']?.toString(),
      createdAt: (d['created_at'] ?? d['created_on'])?.toString(),
      raw: d,
    );
  }
}

/// Compact VND range label, e.g. "1 tỷ - 2 tỷ".
String budgetRangeText(double? min, double? max) {
  String one(double v) {
    if (v >= 1e9) {
      final b = v / 1e9;
      return '${b == b.roundToDouble() ? b.toInt() : b.toStringAsFixed(1)} tỷ';
    }
    if (v >= 1e6) return '${(v / 1e6).toStringAsFixed(0)} triệu';
    return v.toStringAsFixed(0);
  }

  if (min == null && max == null) return 'Thỏa thuận';
  if (min != null && max != null) return '${one(min)} - ${one(max)}';
  if (min != null) return 'Từ ${one(min)}';
  return 'Đến ${one(max!)}';
}

String areaRangeText(num? min, num? max) {
  String n(num v) => v == v.roundToDouble() ? v.toInt().toString() : v.toString();
  if (min == null && max == null) return '—';
  if (min != null && max != null) return '${n(min)} - ${n(max)} m²';
  if (min != null) return 'Từ ${n(min)} m²';
  return 'Đến ${n(max!)} m²';
}
