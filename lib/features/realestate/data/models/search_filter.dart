/// Sort options accepted by `real_estate_v2.json`.
enum PropertySort {
  newest('newest', 'Mới nhất'),
  priceAsc('price_asc', 'Giá thấp → cao'),
  priceDesc('price_desc', 'Giá cao → thấp'),
  areaAsc('area_asc', 'Diện tích nhỏ → lớn'),
  areaDesc('area_desc', 'Diện tích lớn → nhỏ');

  const PropertySort(this.value, this.label);
  final String value;
  final String label;
}

/// Search/filter parameters for the BĐS list.
class SearchFilter {
  const SearchFilter({
    this.keyword,
    this.transactionType,
    this.sort = PropertySort.newest,
    this.minPrice,
    this.maxPrice,
    this.minArea,
    this.maxArea,
    this.bedrooms,
    this.propertyTypes = const [],
    this.cityId,
    this.districtId,
    this.wardId,
    this.locationLabel,
  });

  final String? keyword;

  /// 1 = mua/bán, 2 = thuê, 3 = dự án.
  final int? transactionType;
  final PropertySort sort;
  final double? minPrice;
  final double? maxPrice;
  final int? minArea;
  final int? maxArea;
  final int? bedrooms;
  final List<int> propertyTypes;

  // 3-tier administrative location (string ids — backend uses zero-padded codes).
  final String? cityId;
  final String? districtId;
  final String? wardId;

  /// Human label of the chosen location (for the filter chip).
  final String? locationLabel;

  bool get hasLocation => cityId != null;

  SearchFilter copyWith({
    String? keyword,
    int? transactionType,
    bool clearTransactionType = false,
    PropertySort? sort,
    double? minPrice,
    double? maxPrice,
    int? minArea,
    int? maxArea,
    int? bedrooms,
    List<int>? propertyTypes,
    String? cityId,
    String? districtId,
    String? wardId,
    String? locationLabel,
    bool clearLocation = false,
  }) {
    return SearchFilter(
      keyword: keyword ?? this.keyword,
      transactionType: clearTransactionType
          ? null
          : (transactionType ?? this.transactionType),
      sort: sort ?? this.sort,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minArea: minArea ?? this.minArea,
      maxArea: maxArea ?? this.maxArea,
      bedrooms: bedrooms ?? this.bedrooms,
      propertyTypes: propertyTypes ?? this.propertyTypes,
      cityId: clearLocation ? null : (cityId ?? this.cityId),
      districtId: clearLocation ? null : (districtId ?? this.districtId),
      wardId: clearLocation ? null : (wardId ?? this.wardId),
      locationLabel: clearLocation ? null : (locationLabel ?? this.locationLabel),
    );
  }

  /// Serializes to query params, omitting null/empty values.
  Map<String, dynamic> toQuery({required int page, required int limit}) {
    final q = <String, dynamic>{
      'page': page,
      'limit': limit,
      'sort': sort.value,
    };
    if (keyword != null && keyword!.trim().isNotEmpty) {
      q['keyword'] = keyword!.trim();
    }
    if (transactionType != null) q['transaction_type'] = transactionType;
    if (minPrice != null) q['minPrice'] = minPrice!.toInt();
    if (maxPrice != null) q['maxPrice'] = maxPrice!.toInt();
    if (minArea != null) q['minArea'] = minArea;
    if (maxArea != null) q['maxArea'] = maxArea;
    if (bedrooms != null) q['bedrooms'] = bedrooms;
    if (propertyTypes.isNotEmpty) q['property_types'] = propertyTypes.join(',');
    // Location params match the v1 app: city_id (single), district_ids (CSV),
    // ward_ids (CSV).
    if (cityId != null) q['city_id'] = cityId;
    if (districtId != null) q['district_ids'] = districtId;
    if (wardId != null) q['ward_ids'] = wardId;
    return q;
  }
}
