// Defensive parsing helpers for the loosely-typed Web2py backend, where
// numbers may arrive as ints, doubles, or numeric strings.

int asInt(Object? value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value.trim()) ?? fallback;
  return fallback;
}

int? asIntOrNull(Object? value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) {
    final t = value.trim();
    if (t.isEmpty) return null;
    return int.tryParse(t);
  }
  return null;
}

double asDouble(Object? value, {double fallback = 0}) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value.trim()) ?? fallback;
  return fallback;
}

double? asDoubleOrNull(Object? value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) {
    final t = value.trim();
    if (t.isEmpty) return null;
    return double.tryParse(t);
  }
  return null;
}

String asString(Object? value, {String fallback = ''}) {
  if (value == null) return fallback;
  return value.toString();
}

/// Parses a comma-separated field (e.g. "5,6,7") into a list of ints. Also
/// accepts a real JSON list.
List<int> asIntCsv(Object? value) {
  if (value == null) return const [];
  if (value is List) {
    return value.map(asIntOrNull).whereType<int>().toList();
  }
  if (value is String) {
    return value
        .split(',')
        .map((e) => int.tryParse(e.trim()))
        .whereType<int>()
        .toList();
  }
  return const [];
}

/// Parses a list field that may be a real JSON list or a single value.
List<String> asStringList(Object? value) {
  if (value == null) return const [];
  if (value is List) return value.map((e) => e.toString()).toList();
  if (value is String && value.isNotEmpty) return [value];
  return const [];
}
