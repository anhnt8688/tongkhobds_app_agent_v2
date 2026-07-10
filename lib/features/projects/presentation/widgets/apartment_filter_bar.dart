import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'apartment_filter.dart';
import 'apartment_filter_sheet.dart';

/// Horizontal row of v1-style filter chips (`DynamicFilterButton`). Each chip
/// opens its multi-select sheet; active chips turn primary and show the picked
/// label (or "title · N" when several values are chosen).
class ApartmentFilterBar extends StatelessWidget {
  const ApartmentFilterBar({
    super.key,
    required this.defs,
    required this.selected,
    required this.onChanged,
  });

  final List<ApartmentFilterDef> defs;
  final Map<String, List<String>> selected;
  final void Function(String key, List<String> values) onChanged;

  String _chipText(ApartmentFilterDef d, List<String> vals) {
    if (vals.isEmpty) return d.title;
    if (vals.length == 1) {
      final o = d.options.where((e) => e.value == vals.first);
      final label = o.isEmpty ? vals.first : o.first.label;
      return label.length <= 24 ? label : '${label.substring(0, 24)}...';
    }
    return '${d.title} · ${vals.length}';
  }

  @override
  Widget build(BuildContext context) {
    if (defs.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: defs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final d = defs[i];
          final vals = selected[d.key] ?? const [];
          final active = vals.isNotEmpty;
          final fg = active ? AppColors.primary : AppColors.text;
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () async {
              final res = await showApartmentFilterSheet(context,
                  def: d, selected: vals);
              if (res != null) onChanged(d.key, res);
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: active
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : AppColors.neutral100,
                borderRadius: BorderRadius.circular(100),
                border: active ? Border.all(color: AppColors.primary) : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_chipText(d, vals),
                      style: AppTextStyles.semibold(13, color: fg)),
                  const SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down, size: 16, color: fg),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
