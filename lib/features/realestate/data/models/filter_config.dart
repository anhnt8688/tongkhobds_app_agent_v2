/// One selectable option inside a [FilterOption] (e.g. "Dưới 800 triệu" →
/// "0-800000000").
class FilterOptionItem {
  const FilterOptionItem({required this.label, required this.value});
  final String label;
  final dynamic value;

  factory FilterOptionItem.fromJson(Map d) => FilterOptionItem(
        // Prefer the Vietnamese label; `title` from the backend is English
        // (e.g. property types: "Apartment" vs vietnamese "Bán căn hộ chung cư").
        label: (d['vietnamese'] ?? d['label'] ?? d['title'] ?? '').toString(),
        value: d['value'],
      );
}

/// A dynamic filter from `get_filter_config.json` (`data.filters.filters`).
/// `key` is the query-param key sent back to `real_estate_v2.json`.
class FilterOption {
  const FilterOption({
    required this.key,
    required this.title,
    required this.type,
    this.single = false,
    this.multiple = false,
    this.options = const [],
  });

  final String key;
  final String title;
  final String type; // switch | range | select | text
  final bool single;
  final bool multiple;
  final List<FilterOptionItem> options;

  bool get isSwitch => type == 'switch';
  bool get isRange => type == 'range';
  bool get isSelect => type == 'select';

  factory FilterOption.fromEntry(String mapKey, Map v) {
    final opts = (v['options'] is List ? v['options'] as List : const [])
        .whereType<Map>()
        .map(FilterOptionItem.fromJson)
        .toList();
    return FilterOption(
      // The query-param key is the config map key. The inner `key` field is
      // unreliable — the backend returns "bed_room" for BOTH bedrooms and
      // bathrooms (a dead param the API ignores), which would collapse the two
      // filters onto one value. The map key (bedrooms / bathrooms / price / …)
      // is what the search endpoint actually filters on.
      key: mapKey,
      title: (v['title'] ?? mapKey).toString(),
      type: (v['type'] ?? 'select').toString(),
      single: v['single'] == true,
      multiple: v['multiple'] == true,
      options: opts,
    );
  }
}

/// Parses the `data.filters.filters` map into an ordered list of [FilterOption].
/// Skips scalar entries (transaction_type, transaction_name).
///
/// "Loại hình" (property_types) is pulled to the front — the backend returns it
/// last, but it is the primary filter agents reach for first.
List<FilterOption> parseFilterConfig(Object? filtersMap) {
  if (filtersMap is! Map) return const [];
  final result = <FilterOption>[];
  filtersMap.forEach((k, v) {
    if (v is Map && v['type'] != null) {
      result.add(FilterOption.fromEntry(k.toString(), v));
    }
  });
  final propertyTypeIndex =
      result.indexWhere((o) => o.key == 'property_types');
  if (propertyTypeIndex > 0) {
    final pt = result.removeAt(propertyTypeIndex);
    result.insert(0, pt);
  }
  return result;
}
