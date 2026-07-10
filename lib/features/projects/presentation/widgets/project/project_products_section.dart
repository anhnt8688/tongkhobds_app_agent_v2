import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../realestate/data/models/filter_config.dart';
import '../../../../realestate/presentation/open_property.dart';
import '../../../../realestate/presentation/widgets/filter_sheets.dart';
import '../../../../realestate/presentation/widgets/property_card.dart';
import '../../project_products_controller.dart';

/// "Sản phẩm dự án" — Mua bán/Cho thuê tabs + dynamic filter chips + product
/// list, scoped to a project_code (v1 product tab inside detail_project_page).
/// Renders as a non-scrolling Column to nest inside the page's scroll view.
class ProjectProductsSection extends ConsumerWidget {
  const ProjectProductsSection({super.key, required this.projectCode});
  final String projectCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(projectProductsControllerProvider(projectCode));
    final n = ref.read(projectProductsControllerProvider(projectCode).notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text('Sản phẩm dự án', style: AppTextStyles.semibold(20)),
        ),
        _tabs(state.tab, n.setTab),
        if (state.filterConfig.isNotEmpty)
          _filterBar(context, state, n),
        const SizedBox(height: 12),
        _body(context, state, n),
      ],
    );
  }

  Widget _tabs(int tab, ValueChanged<int> onTab) {
    const items = [(1, 'Mua bán'), (2, 'Cho thuê')];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            for (final (value, label) in items)
              Expanded(
                child: GestureDetector(
                  onTap: () => onTab(value),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: value == tab ? AppColors.primary : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(label,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.semibold(15,
                            color: value == tab
                                ? Colors.white
                                : AppColors.textSecondary)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _filterBar(BuildContext context, ProjectProductsState state,
      ProjectProductsController n) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: SizedBox(
        height: 38,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: state.filterConfig.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final o = state.filterConfig[i];
            return _chip(
              label: _chipLabel(o, state),
              active: state.hasFilterValue(o.key),
              onTap: () => _openFilter(context, o, state, n),
            );
          },
        ),
      ),
    );
  }

  String _chipLabel(FilterOption o, ProjectProductsState state) {
    final v = state.filterValues[o.key];
    if (v == null) return o.title;
    for (final opt in o.options) {
      if (opt.value?.toString() == v.toString()) return opt.label;
    }
    return o.title;
  }

  void _openFilter(BuildContext context, FilterOption o,
      ProjectProductsState state, ProjectProductsController n) {
    if (o.isSwitch) {
      n.toggleSwitch(o.key);
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => o.isRange
          ? DynamicRangeSheet(
              option: o,
              selected: state.filterValues[o.key]?.toString(),
              onApply: (v) => n.setFilterValue(o.key, v),
            )
          : DynamicSelectSheet(
              option: o,
              selected: state.filterValues[o.key],
              onApply: (v) => n.setFilterValue(o.key, v),
            ),
    );
  }

  Widget _chip(
      {required String label,
      required bool active,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.primarySoft : const Color(0xFFF5F5F4),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
              color: active ? AppColors.primary : Colors.transparent),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label,
                style: AppTextStyles.semibold(13,
                    color:
                        active ? AppColors.primary : AppColors.textSecondary)),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down,
                size: 16,
                color: active ? AppColors.primary : AppColors.textMute),
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context, ProjectProductsState state,
      ProjectProductsController n) {
    if (state.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state.items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text('Chưa có sản phẩm',
              style: AppTextStyles.regular(15, color: AppColors.textMute)),
        ),
      );
    }
    return Column(
      children: [
        for (final p in state.items)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: PropertyCard(
              property: p,
              onTap: () => openProperty(context, p),
            ),
          ),
        if (state.hasMore)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: state.isLoadingMore
                ? const CircularProgressIndicator()
                : OutlinedButton(
                    onPressed: n.loadMore,
                    child: const Text('Xem thêm'),
                  ),
          ),
      ],
    );
  }
}
