import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/utils/json_parse.dart';

part 'property.freezed.dart';
part 'property.g.dart';

/// A real-estate listing item from `real_estate_v2.json`.
@freezed
abstract class Property with _$Property {
  const factory Property({
    @JsonKey(readValue: _id) @Default(0) int id,
    @JsonKey(readValue: _title) @Default('') String title,
    @JsonKey(readValue: _address) @Default('') String address,
    @JsonKey(readValue: _price) double? price,
    @JsonKey(name: 'price_display', readValue: _priceDisplay) String? priceDisplay,
    @JsonKey(readValue: _area) double? area,
    @JsonKey(readValue: _bedrooms) int? bedrooms,
    @JsonKey(readValue: _bathrooms) int? bathrooms,
    @JsonKey(name: 'property_type_name', readValue: _propertyTypeName)
    String? propertyTypeName,
    @JsonKey(name: 'transaction_type', readValue: _transactionType)
    int? transactionType,
    @JsonKey(readValue: _image) String? image,
    @JsonKey(readValue: _slug) String? slug,
    @JsonKey(readValue: _status) String? status,
    @JsonKey(name: 'status_activity_label', readValue: _statusActivityLabel)
    String? statusActivityLabel,
    @JsonKey(name: 'status_activity', readValue: _statusActivity)
    int? statusActivity,
    @JsonKey(name: 'is_hot', readValue: _isHot) @Default(false) bool isHot,
    @JsonKey(name: 'real_estate_code', readValue: _code) String? code,
    @JsonKey(name: 'city', readValue: _city) String? city,
    @JsonKey(name: 'district', readValue: _district) String? district,
    @JsonKey(name: 'is_favorite', readValue: _isFavorite) @Default(false) bool isFavorite,
    @JsonKey(name: 'is_verified', readValue: _verified) @Default(false) bool isVerified,
    @JsonKey(name: 'project_code', readValue: _projectCode) String? projectCode,
    @JsonKey(name: 'parent_name', readValue: _parentName) String? parentName,
    // --- "BĐS của tôi" (my listings) fields, parity with v1 ProductModel ---
    @JsonKey(name: 'price_description', readValue: _priceDescription)
    String? priceDescription,
    @JsonKey(name: 'created_on', readValue: _createdOn) String? createdOn,
    @JsonKey(name: 'status_name', readValue: _statusInfoName) String? statusName,
    @JsonKey(name: 'status_color', readValue: _statusInfoColor)
    String? statusColor,
    @JsonKey(name: 'label_list', readValue: _labels) List<String>? labelList,
    @JsonKey(name: 'source_get', readValue: _sourceGet) String? sourceGet,
    @JsonKey(name: 'is_verify_real_estate', readValue: _isVerifyRe)
    @Default(false) bool isVerifyRealEstate,
    @JsonKey(name: 'is_request_signing', readValue: _isRequestSigning)
    @Default(false) bool isRequestSigning,
  }) = _Property;

  const Property._();

  factory Property.fromJson(Map<String, dynamic> json) =>
      _$PropertyFromJson(json);

  /// Best-effort human price (uses backend display, else formats VND).
  String get priceText {
    if (priceDisplay != null && priceDisplay!.isNotEmpty) return priceDisplay!;
    return formatVnd(price);
  }

  String get areaText => area == null ? '—' : '${_trim(area!)} m²';

  /// Server-driven label badges for the listing card (never null).
  List<String> get labels => labelList ?? const [];

  /// True when this list item is a project (dự án), not a single listing.
  /// Project items carry a `project_code` and open the project-detail flow.
  bool get isProject => projectCode != null && projectCode!.trim().isNotEmpty;

  /// Verification/activity badge label shown on the card. Uses the backend's
  /// raw `status_activity_label` first, then maps the `status_activity` code.
  /// This is distinct from `status` (the listing state, e.g. "Đang bán"), which
  /// must NOT be shown as the verification badge.
  String? get statusBadge {
    final raw = statusActivityLabel?.trim();
    if (raw != null && raw.isNotEmpty) return raw;
    switch (statusActivity) {
      case 1:
        return 'Xác thực CTV';
      case 2:
        return 'Xác thực chủ nhà';
      case 4:
        return 'Đã ký hợp đồng';
      default:
        return null;
    }
  }

  /// Short address for cards: "District, City".
  String get shortAddress {
    final parts = [district, city]
        .map((e) => e?.trim() ?? '')
        .where((e) => e.isNotEmpty)
        .toList();
    return parts.isNotEmpty ? parts.join(', ') : address;
  }
}

String _trim(double v) =>
    v == v.roundToDouble() ? v.toInt().toString() : v.toString();

/// Formats a VND amount into a compact Vietnamese string (tỷ / triệu).
String formatVnd(double? amount) {
  if (amount == null || amount <= 0) return 'Thỏa thuận';
  if (amount >= 1e9) {
    final v = amount / 1e9;
    return '${_trim(double.parse(v.toStringAsFixed(2)))} tỷ';
  }
  if (amount >= 1e6) {
    final v = amount / 1e6;
    return '${_trim(double.parse(v.toStringAsFixed(1)))} triệu';
  }
  return '${amount.toInt()} đ';
}

Object? _id(Map m, String _) => asInt(m['id'] ?? m['real_estate_id']);
Object? _title(Map m, String _) => (m['title'] ?? m['name'] ?? '').toString();
Object? _address(Map m, String _) {
  final a = m['address'] ?? m['street_address'];
  if (a != null && a.toString().trim().isNotEmpty) return a.toString();
  // Fall back to composing from ward/district/city parts.
  final parts = [m['ward'], m['district'], m['city']]
      .map((e) => e?.toString().trim() ?? '')
      .where((e) => e.isNotEmpty)
      .toList();
  return parts.join(', ');
}
Object? _price(Map m, String _) => asDoubleOrNull(m['price'] ?? m['price_min']);
Object? _priceDisplay(Map m, String _) =>
    (m['price_display'] ?? m['price_description'])?.toString();
Object? _area(Map m, String _) => asDoubleOrNull(m['area']);
Object? _bedrooms(Map m, String _) => asIntOrNull(m['bedrooms'] ?? m['bedroom']);
Object? _bathrooms(Map m, String _) =>
    asIntOrNull(m['bathrooms'] ?? m['bathroom'] ?? m['toilet']);
Object? _transactionType(Map m, String _) => asIntOrNull(m['transaction_type']);
Object? _status(Map m, String _) => m['status']?.toString();
Object? _statusActivityLabel(Map m, String _) =>
    m['status_activity_label']?.toString();
Object? _statusActivity(Map m, String _) => asIntOrNull(m['status_activity']);
Object? _isHot(Map m, String _) =>
    m['is_hot'] == true || m['is_hot'] == 1 || m['is_hot'] == '1';
Object? _slug(Map m, String _) => m['slug']?.toString();

Object? _image(Map m, String _) {
  final img = m['main_image'] ?? m['image'] ?? m['thumbnail'] ?? m['avatar'];
  if (img != null && img.toString().isNotEmpty) {
    return AppConfig.imageUrl(img.toString());
  }
  final images = m['images'];
  if (images is List && images.isNotEmpty) {
    final first = images.first;
    if (first is String) return AppConfig.imageUrl(first);
    if (first is Map) {
      return AppConfig.imageUrl((first['url'] ?? first['thumb'])?.toString());
    }
  }
  return null;
}

Object? _propertyTypeName(Map m, String _) {
  final pt = m['property_type'];
  if (pt is Map) return pt['name']?.toString();
  if (pt is String) return pt;
  return m['property_type_name']?.toString();
}

Object? _code(Map m, String _) =>
    (m['real_estate_code'] ?? m['code'])?.toString();
Object? _projectCode(Map m, String _) {
  final c = (m['project_code'] ?? '').toString().trim();
  return c.isEmpty ? null : c;
}
Object? _parentName(Map m, String _) => m['parent_name']?.toString();
Object? _city(Map m, String _) => m['city']?.toString();
Object? _district(Map m, String _) => m['district']?.toString();
Object? _isFavorite(Map m, String _) =>
    m['is_favorite'] == true || m['is_favorite'] == 1;
Object? _verified(Map m, String _) =>
    m['is_verified'] == true ||
    m['is_verified'] == 1 ||
    m['is_verify_real_estate'] == true;

Object? _priceDescription(Map m, String _) =>
    (m['price_description'] ?? m['price_display'])?.toString();
Object? _createdOn(Map m, String _) =>
    (m['created_on'] ?? m['created'])?.toString();

/// `status_info` is an object `{name, code, color, icon}`; pull name + color.
Object? _statusInfoName(Map m, String _) {
  final s = m['status_info'];
  if (s is Map) return (s['name'] ?? s['status_name'])?.toString();
  return null;
}

Object? _statusInfoColor(Map m, String _) {
  final s = m['status_info'];
  if (s is Map) return (s['color'] ?? s['color_code'])?.toString();
  return null;
}

/// `label_list` is `[{label_name, label_link}]`; flatten to display names.
Object? _labels(Map m, String _) {
  final raw = m['label_list'];
  if (raw is! List) return const <String>[];
  return raw
      .whereType<Map>()
      .map((e) => (e['label_name'] ?? e['name'] ?? '').toString())
      .where((e) => e.isNotEmpty)
      .toList();
}

Object? _sourceGet(Map m, String _) => m['source_get']?.toString();
Object? _isVerifyRe(Map m, String _) =>
    m['is_verify_real_estate'] == true || m['is_verify_real_estate'] == 1;
Object? _isRequestSigning(Map m, String _) =>
    m['is_request_signing'] == true || m['is_request_signing'] == 1;
