import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../my_listings_controller.dart';
import 'listing_filter_sheets.dart';
import 'listing_range_sheet.dart';

/// Horizontal filter-chip row for "BĐS của tôi" (parity with v1's
/// `FilterTypeProduct` row): source, property type, price, area, bedrooms,
/// house direction, balcony direction. Each chip opens its bottom sheet and
/// pushes the selection back through the controller.
class ListingFilterBar extends ConsumerWidget {
  const ListingFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(myListingsControllerProvider);
    final c = ref.read(myListingsControllerProvider.notifier);
    final f = s.filters;

    final chips = <Widget>[
      _chip('Nguồn', s.source?.name, () {
        showSingleSelectSheet(context,
            title: 'Nguồn đăng',
            values: f.sources,
            selected: s.source,
            onSelected: c.setSource);
      }),
      _chip(
        'Loại hình',
        s.propertyTypes.isEmpty
            ? null
            : s.propertyTypes.map((e) => e.name).join(', '),
        () {
          showMultiSelectSheet(context,
              title: 'Loại BĐS',
              values: f.propertyTypes,
              selected: s.propertyTypes,
              onSelected: c.setPropertyTypes);
        },
      ),
      _chip('Giá', _rangeLabel(s.priceRange, money: true), () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => ListingRangeSheet(
            title: 'Chọn mức giá',
            minTitle: 'Giá thấp nhất (triệu)',
            maxTitle: 'Giá cao nhất (triệu)',
            suffix: 'tr',
            values: f.priceRanges,
            initialRange: s.priceRange,
            onApply: (r) => c.setPrice(null, r),
          ),
        );
      }),
      _chip('Diện tích', _rangeLabel(s.areaRange, money: false), () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => ListingRangeSheet(
            title: 'Chọn diện tích',
            minTitle: 'Diện tích thấp nhất (m²)',
            maxTitle: 'Diện tích cao nhất (m²)',
            suffix: 'm²',
            values: f.areaRanges,
            initialRange: s.areaRange,
            onApply: (r) => c.setArea(null, r),
          ),
        );
      }),
      _chip('Số phòng', s.bedrooms == null ? null : '${s.bedrooms!.name} phòng',
          () {
        showBedroomSheet(context,
            values: f.bedrooms,
            selected: s.bedrooms,
            onSelected: c.setBedrooms);
      }),
      _chip('Hướng nhà', s.houseDirection?.name, () {
        showSingleSelectSheet(context,
            title: 'Hướng nhà',
            values: f.houseDirections,
            selected: s.houseDirection,
            onSelected: c.setHouseDirection);
      }),
      _chip('Hướng ban công', s.balcony?.name, () {
        showSingleSelectSheet(context,
            title: 'Hướng ban công',
            values: f.balconyDirections,
            selected: s.balcony,
            onSelected: c.setBalcony);
      }),
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) => chips[i],
      ),
    );
  }

  Widget _chip(String label, String? value, VoidCallback onTap) {
    final active = value != null && value.isNotEmpty;
    final fg = active ? AppColors.primary : AppColors.text;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? AppColors.primary.withValues(alpha: 0.1)
              : const Color(0xFFF5F5F4),
          borderRadius: BorderRadius.circular(100),
          border: active ? Border.all(color: AppColors.primary) : null,
        ),
        child: Row(
          children: [
            Text(
              active ? _ellipsis(value) : label,
              style: AppTextStyles.semibold(13, color: fg),
            ),
            Icon(Icons.arrow_drop_down, color: fg, size: 20),
          ],
        ),
      ),
    );
  }

  String _ellipsis(String t, {int max = 24}) =>
      t.length <= max ? t : '${t.substring(0, max)}...';

  /// Formats a "min-max" range string for the chip label. [money] values are in
  /// millions (triệu) → render tỷ/triệu; otherwise raw with m².
  String? _rangeLabel(String range, {required bool money}) {
    if (range.isEmpty) return null;
    final parts = range.split('-');
    int? min = parts.isNotEmpty ? int.tryParse(parts[0]) : null;
    int? max = parts.length > 1 ? int.tryParse(parts[1]) : null;
    if (min == 0) min = null;
    if (max == 0) max = null;
    String fmt(int v) => money ? _money(v) : '$v m²';
    if (min != null && max != null) return '${fmt(min)} - ${fmt(max)}';
    if (min != null) return '≥ ${fmt(min)}';
    if (max != null) return '≤ ${fmt(max)}';
    return null;
  }

  String _money(int trieu) {
    if (trieu >= 1000) {
      final ty = trieu / 1000;
      final s = ty == ty.roundToDouble() ? ty.toInt().toString() : '$ty';
      return '$s tỷ';
    }
    return '$trieu tr';
  }
}
