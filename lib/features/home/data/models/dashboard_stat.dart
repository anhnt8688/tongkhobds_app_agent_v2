import '../../../../core/utils/json_parse.dart';

/// A single KPI card value from `dashboard_stats.json`.
class DashboardStat {
  const DashboardStat({
    required this.key,
    required this.title,
    required this.value,
    this.unit,
    this.change,
    this.icon,
  });

  final String key;
  final String title;
  final double value;
  final String? unit;
  final double? change;

  /// Inline SVG markup for the card icon (v1 `DashboardStatsModel.icon`).
  final String? icon;

  factory DashboardStat.fromJson(Map data) => DashboardStat(
        key: (data['key'] ?? '').toString(),
        title: (data['title'] ?? '').toString(),
        value: asDouble(data['value']),
        unit: data['unit']?.toString(),
        change: asDoubleOrNull(data['change'] ?? data['change_percent']),
        icon: data['icon']?.toString(),
      );

  /// Compact display of the value (money keys are shortened to triệu/tỷ).
  String get displayValue {
    final isMoney = unit == 'VND' ||
        key == 'deposit_invoices' ||
        key == 'commission';
    if (isMoney) {
      if (value >= 1e9) return '${(value / 1e9).toStringAsFixed(1)} tỷ';
      if (value >= 1e6) return '${(value / 1e6).toStringAsFixed(0)} tr';
      return value.toInt().toString();
    }
    return value.toInt().toString();
  }
}
