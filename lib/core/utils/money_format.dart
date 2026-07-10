import 'package:intl/intl.dart';

/// Money formatting ported from v1 `AppUtil` for parity with the team/contract
/// screens. Amounts arrive loosely typed (int/double/String) from the backend.

double _toDouble(Object? value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

final NumberFormat _grouped = NumberFormat('###,###', 'en_US');

/// Grouped integer + currency suffix, e.g. `1,500,000 đ` (v1 `formatMoney`).
String formatMoney(Object? money, {String currency = 'đ'}) {
  var m = _toDouble(money);
  if (m.isNaN) m = 0;
  return '${_grouped.format(m)} $currency';
}

/// Compact amount with a Vietnamese unit, e.g. `1.5 tỷ`, `850 triệu`
/// (v1 `formatMoneyWithUnit`). Returns `0 VND` for zero.
String formatMoneyWithUnit(Object? money, {bool showUnit = true}) {
  var m = _toDouble(money);
  if (m.isNaN) m = 0;
  if (m == 0) return '0 VND';

  const trillion = 1000000000000.0;
  const billion = 1000000000.0;
  const million = 1000000.0;
  const thousand = 1000.0;

  var value = m.abs();
  var unit = '';
  if (value >= trillion) {
    value /= trillion;
    unit = 'nghìn tỷ';
  } else if (value >= billion) {
    value /= billion;
    unit = 'tỷ';
  } else if (value >= million) {
    value /= million;
    unit = 'triệu';
  } else if (value >= thousand) {
    value /= thousand;
    unit = 'nghìn';
  }

  String formatted;
  if (value >= 100) {
    formatted = value.toStringAsFixed(0);
  } else if (value >= 10) {
    formatted = value.toStringAsFixed(1);
  } else {
    formatted = value.toStringAsFixed(2);
  }
  if (formatted.contains('.')) {
    formatted = formatted
        .replaceAll(RegExp(r'0*$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }

  return showUnit && unit.isNotEmpty ? '$formatted $unit' : formatted;
}
