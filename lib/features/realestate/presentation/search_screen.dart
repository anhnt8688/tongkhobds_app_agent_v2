import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../core/widgets/custom_screen.dart';
import '../data/models/filter_config.dart';
import '../data/models/property.dart';
import 'open_property.dart';
import 'search_controller.dart';
import 'search_location_screen.dart';
import 'widgets/filter_sheets.dart';
import 'widgets/property_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _scrollCtrl = ScrollController();
  bool _headerVisible = true;

  static const _tabs = [(1, 'Mua bán'), (2, 'Cho thuê'), (3, 'Dự án')];

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollCtrl.hasClients) return;
    final pos = _scrollCtrl.position;
    if (pos.pixels >= pos.maxScrollExtent - 300) {
      ref.read(searchListControllerProvider.notifier).loadMore();
    }
    if (pos.pixels <= 0 ||
        pos.userScrollDirection == ScrollDirection.forward) {
      if (!_headerVisible) setState(() => _headerVisible = true);
    } else if (pos.userScrollDirection == ScrollDirection.reverse) {
      if (_headerVisible && pos.pixels > 40) {
        setState(() => _headerVisible = false);
      }
    }
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  SearchListController get _controller =>
      ref.read(searchListControllerProvider.notifier);

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchListControllerProvider);

    // Root bottom-nav tab → shared gradient header with no back button
    // (v2 IA has nothing to pop to), matching the Thông báo tab.
    return CustomScreen(
      title: 'Bảng hàng',
      isBack: false,
      child: Column(
        children: [
          // Segmented tabs (fixed).
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: _Segmented(
              tabs: _tabs,
              selected: state.tab,
              onChange: (t) {
                _controller.setTab(t);
                if (_scrollCtrl.hasClients) _scrollCtrl.jumpTo(0);
              },
            ),
          ),
          // Collapsible header: location + dynamic filters.
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: _headerVisible
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        child: _LocationBox(
                          city: state.cityName,
                          district: state.districtLabel,
                          onTap: _openLocation,
                          onClear: state.cityId == null
                              ? null
                              : _controller.clearLocation,
                        ),
                      ),
                      _FilterBar(state: state, controller: _controller),
                      const SizedBox(height: 4),
                    ],
                  )
                : const SizedBox(width: double.infinity),
          ),
          const Divider(height: 1),
          Expanded(
            child: Stack(
              children: [
                _body(state),
                // Thin top progress bar while (re)loading over existing results
                // — e.g. typing in the search box or applying a filter.
                if (state.isLoading && state.items.isNotEmpty)
                  const Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    child: LinearProgressIndicator(
                      minHeight: 2,
                      color: AppColors.primary,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 16,
                  child: Center(child: _mapButton()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openLocation() async {
    final state = ref.read(searchListControllerProvider);
    final sel = await showSearchLocationSheet(
      context,
      args: SearchLocationArgs(
        cityId: state.cityId,
        cityName: state.cityName,
        slugs: state.districtSlugs,
      ),
    );
    if (sel != null) {
      _controller.setLocation(
        cityId: sel.cityId,
        cityName: sel.cityName,
        districtSlugs: sel.districtSlugs,
        districtLabel: sel.districtLabel,
        focusLat: sel.focusLat,
        focusLng: sel.focusLng,
      );
    }
  }

  Widget _mapButton() {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      elevation: 3,
      shadowColor: Colors.black26,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        onTap: () {
          // Focus the map on the chosen area (or detected GPS), like v1.
          final s = ref.read(searchListControllerProvider);
          context.push('/map', extra: (lat: s.focusLat, lng: s.focusLng));
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.map_outlined, size: 18, color: Colors.white),
              SizedBox(width: 8),
              Text('Bản đồ',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body(SearchState state) {
    if (state.isLoading && state.items.isEmpty) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (state.error != null && state.items.isEmpty) {
      final msg = state.error is ApiException
          ? (state.error as ApiException).message
          : 'Đã có lỗi xảy ra';
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.danger, size: 40),
            const SizedBox(height: 12),
            Text(msg, style: AppTypography.subtitle),
            const SizedBox(height: 16),
            TextButton(
                onPressed: _controller.refresh, child: const Text('Thử lại')),
          ],
        ),
      );
    }
    if (state.items.isEmpty) {
      return const Center(child: Text('Không tìm thấy BĐS phù hợp'));
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _controller.refresh,
      child: state.isProjectTab ? _grid(state) : _list(state),
    );
  }

  Widget _list(SearchState state) {
    return ListView.separated(
      controller: _scrollCtrl,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: state.items.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        if (i == state.items.length) return _footer(state);
        final p = state.items[i];
        return PropertyCard(
          property: p,
          hot: state.hasFilterValue('is_hot'),
          onTap: () => openProperty(context, p),
        );
      },
    );
  }

  Widget _grid(SearchState state) {
    return GridView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 240,
      ),
      itemCount: state.items.length,
      itemBuilder: (context, i) {
        final p = state.items[i];
        return _ProjectGridCard(
            property: p, onTap: () => openProperty(context, p));
      },
    );
  }

  Widget _footer(SearchState state) {
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child:
            Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }
    if (!state.hasMore) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text('Đã hiển thị tất cả ${state.total} kết quả',
              style: AppTypography.caption),
        ),
      );
    }
    return const SizedBox(height: 40);
  }
}

/// 3-way segmented control (Mua bán / Cho thuê / Dự án).
class _Segmented extends StatelessWidget {
  const _Segmented({
    required this.tabs,
    required this.selected,
    required this.onChange,
  });
  final List<(int, String)> tabs;
  final int selected;
  final ValueChanged<int> onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F4),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          for (final t in tabs)
            Expanded(
              child: GestureDetector(
                onTap: () => onChange(t.$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected == t.$1 ? AppColors.text : null,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Text(
                    t.$2,
                    style: selected == t.$1
                        ? AppTextStyles.semibold(13, color: Colors.white)
                        : AppTextStyles.regular(13,
                            color: AppColors.neutral500),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Search-box styled location selector showing city + districts.
class _LocationBox extends StatelessWidget {
  const _LocationBox({
    required this.city,
    required this.district,
    required this.onTap,
    this.onClear,
  });
  final String? city;
  final String? district;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on_outlined,
                size: 20, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (city == null || city!.isEmpty) ? 'Cả nước' : city!,
                    style: AppTextStyles.semibold(13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    (district == null || district!.isEmpty)
                        ? 'Thêm quận / huyện'
                        : district!,
                    style: AppTextStyles.regular(13, color: AppColors.neutral500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (onClear != null)
              GestureDetector(
                onTap: onClear,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.close, size: 18, color: AppColors.textMute),
                ),
              )
            else
              const Icon(Icons.chevron_right, color: AppColors.textMute),
          ],
        ),
      ),
    );
  }
}

/// Horizontal dynamic filter chips (Sort + filters from get_filter_config).
class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.state, required this.controller});
  final SearchState state;
  final SearchListController controller;

  @override
  Widget build(BuildContext context) {
    final filters = state.filterConfig;
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final o = filters[i];
          if (o.isSwitch) {
            return _SwitchChip(
              option: o,
              active: state.hasFilterValue(o.key),
              onToggle: () => controller.toggleSwitch(o.key),
            );
          }
          return _Chip(
            label: _chipLabel(o),
            active: state.hasFilterValue(o.key),
            showCaret: true,
            onTap: () => _openFilter(context, o),
          );
        },
      ),
    );
  }

  String _chipLabel(FilterOption o) {
    final v = state.filterValues[o.key];
    if (v == null) return o.title;
    // Show the matching option label when possible.
    for (final opt in o.options) {
      if (opt.value?.toString() == v.toString()) return opt.label;
    }
    return o.title;
  }

  void _openFilter(BuildContext context, FilterOption o) {
    if (o.isSwitch) {
      controller.toggleSwitch(o.key);
      return;
    }
    showModalBottomSheet(
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
              onApply: (v) => controller.setFilterValue(o.key, v),
            )
          : DynamicSelectSheet(
              option: o,
              selected: state.filterValues[o.key],
              onApply: (v) => controller.setFilterValue(o.key, v),
            ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.active,
    required this.onTap,
    this.showCaret = false,
  });
  final String label;
  final bool active;
  final VoidCallback onTap;
  final bool showCaret;

  @override
  Widget build(BuildContext context) {
    final fg = active ? AppColors.primary : AppColors.text;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: active
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.neutral100,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          border: active ? Border.all(color: AppColors.primary) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: AppTextStyles.semibold(13, color: fg)),
            if (showCaret) ...[
              const SizedBox(width: 2),
              Icon(Icons.keyboard_arrow_down, size: 16, color: fg),
            ],
          ],
        ),
      ),
    );
  }
}

/// Switch-style filter chip (Nổi bật / Xác thực) with a mini toggle — matches
/// v1 DynamicFilterButton: amber accent for is_hot, green for is_verified.
class _SwitchChip extends StatelessWidget {
  const _SwitchChip({
    required this.option,
    required this.active,
    required this.onToggle,
  });
  final FilterOption option;
  final bool active;
  final VoidCallback onToggle;

  bool get _isHot =>
      option.key == 'is_hot' || option.title.toLowerCase().contains('nổi bật');
  bool get _isVerified =>
      option.key == 'is_verified' ||
      option.title.toLowerCase().contains('xác thực');

  @override
  Widget build(BuildContext context) {
    final accent = _isHot
        ? const Color(0xFFF59E0B)
        : _isVerified
            ? const Color(0xFF10B981)
            : AppColors.primary;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: active
              ? accent.withValues(alpha: 0.16)
              : const Color(0xFFF5F5F4),
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          border: Border.all(
            color: active ? accent.withValues(alpha: 0.30) : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_isHot ? Icons.auto_awesome_rounded : Icons.verified_rounded,
                size: 15, color: accent),
            const SizedBox(width: 4),
            Text(
              option.title,
              style: AppTypography.subtitle.copyWith(
                color: active ? accent : AppColors.text,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            _MiniToggle(value: active, accent: accent),
          ],
        ),
      ),
    );
  }
}

class _MiniToggle extends StatelessWidget {
  const _MiniToggle({required this.value, required this.accent});
  final bool value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 26,
      height: 15,
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        color: value ? accent.withValues(alpha: 0.28) : const Color(0xFFE7E5E4),
        borderRadius: BorderRadius.circular(999),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 160),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 11,
          height: 11,
          decoration: BoxDecoration(
            color: value ? accent : Colors.white,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                  blurRadius: 1, offset: Offset(0, 0.5), color: Color(0x22000000)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Project (dự án) grid tile for the Dự án tab.
class _ProjectGridCard extends StatelessWidget {
  const _ProjectGridCard({required this.property, required this.onTap});
  final Property property;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 130,
                width: double.infinity,
                child: AppNetworkImage(
                  url: property.image,
                  height: 130,
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppSpacing.radiusLg)),
                  placeholder: Container(
                    color: AppColors.primarySoft,
                    alignment: Alignment.center,
                    child: const Icon(Icons.location_city_rounded,
                        color: AppColors.primary, size: 36),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(property.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.subtitle
                            .copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 13, color: AppColors.textMute),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            property.shortAddress,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.caption
                                .copyWith(color: AppColors.textMute),
                          ),
                        ),
                      ],
                    ),
                    if ((property.status ?? '').isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(property.status!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.caption
                              .copyWith(color: AppColors.primary)),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
