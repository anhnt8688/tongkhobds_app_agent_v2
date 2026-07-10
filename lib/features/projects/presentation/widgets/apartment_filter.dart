import '../../data/projects_api.dart';

/// One selectable value inside a filter (value used for matching, label shown).
class ApartmentFilterOption {
  const ApartmentFilterOption(this.value, this.label);
  final String value;
  final String label;
}

/// A bảng-hàng filter definition (a chip + its bottom-sheet options). All are
/// multi-select and derived client-side from the apartment list (v1 derives the
/// same "filter_to_map" options from the apartments it received).
class ApartmentFilterDef {
  const ApartmentFilterDef({
    required this.key,
    required this.title,
    required this.options,
  });
  final String key;
  final String title;
  final List<ApartmentFilterOption> options;
}

int _naturalCompare(String a, String b) {
  final ai = num.tryParse(a), bi = num.tryParse(b);
  if (ai != null && bi != null) return ai.compareTo(bi);
  return a.compareTo(b);
}

/// The value an apartment exposes for a given filter key.
String? _valueOf(Apartment a, String key) => switch (key) {
      'zone' => a.zone,
      'floor' => a.floor,
      'direction' => a.direction,
      'bedrooms' => a.bedrooms?.toString(),
      _ => null,
    };

/// Build the available filters from the current apartments. A filter is only
/// offered when it has 2+ distinct values (nothing to pick from otherwise).
List<ApartmentFilterDef> deriveApartmentFilters(List<Apartment> apts) {
  List<ApartmentFilterOption> opts(String key, String Function(String) label) {
    final set = <String>{};
    for (final a in apts) {
      final v = _valueOf(a, key)?.trim();
      if (v != null && v.isNotEmpty) set.add(v);
    }
    final values = set.toList()..sort(_naturalCompare);
    return values.map((v) => ApartmentFilterOption(v, label(v))).toList();
  }

  final defs = <ApartmentFilterDef>[
    ApartmentFilterDef(key: 'zone', title: 'Phân khu', options: opts('zone', (v) => v)),
    ApartmentFilterDef(key: 'floor', title: 'Tầng', options: opts('floor', (v) => v)),
    ApartmentFilterDef(
        key: 'direction', title: 'Hướng', options: opts('direction', (v) => v)),
    ApartmentFilterDef(
        key: 'bedrooms',
        title: 'Phòng ngủ',
        options: opts('bedrooms', (v) => '$v PN')),
  ];
  return defs.where((d) => d.options.length >= 2).toList();
}

/// Keep only apartments matching every active (non-empty) selection.
List<Apartment> applyApartmentFilters(
  List<Apartment> apts,
  Map<String, List<String>> selected,
) {
  return apts.where((a) {
    for (final e in selected.entries) {
      if (e.value.isEmpty) continue;
      final v = _valueOf(a, e.key)?.trim();
      if (v == null || !e.value.contains(v)) return false;
    }
    return true;
  }).toList();
}
