import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../data/models/dashboard_stat.dart';
import '../home_nav.dart';
import '../home_providers.dart';

/// "Thống kê chỉ số" — the KPI grid (v1 `StatisticView` + `StatisticItem`):
/// a 2-column wrap of bordered cards (leading SVG icon, title, large value,
/// optional trend), with a date-range quick filter in the header.
class HomeStatsSection extends ConsumerWidget {
  const HomeStatsSection({super.key});

  // Stat card → destination, positional like v1.
  static const _routes = <int, String>{
    0: '/my-listings',
    1: '/customers',
    2: '/transactions',
    5: '/wallet',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(dashboardStatsProvider);
    return stats.when(
      loading: () => const _StatsSkeleton(),
      error: (_, __) => const SizedBox.shrink(),
      data: (list) {
        if (list.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Thống kê chỉ số', style: AppTextStyles.bold(22)),
                  const _RangeFilter(),
                ],
              ),
              const SizedBox(height: 16),
              // Rows of 2 with stretched height so both cards in a row match
              // the taller one (keeps the grid even despite variable content).
              for (var i = 0; i < list.length; i += 2) ...[
                if (i > 0) const SizedBox(height: 16),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: _cardAt(context, list, i)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: i + 1 < list.length
                            ? _cardAt(context, list, i + 1)
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _cardAt(BuildContext context, List<DashboardStat> list, int i) =>
      _StatCard(
        stat: list[i],
        onTap: _routes[i] == null ? null : () => navTo(context, _routes[i]!),
      );
}

/// Named quick date ranges (v1 `_quickFilters`), computed at tap time.
final _quickRanges = <String, (DateTime, DateTime) Function()>{
  'Hôm nay': () {
    final n = DateTime.now();
    return (DateTime(n.year, n.month, n.day), DateTime(n.year, n.month, n.day));
  },
  'Tuần này': () {
    final n = DateTime.now();
    final mon = n.subtract(Duration(days: n.weekday - 1));
    return (DateTime(mon.year, mon.month, mon.day), n);
  },
  'Tháng này': () {
    final n = DateTime.now();
    return (DateTime(n.year, n.month, 1), DateTime(n.year, n.month + 1, 0));
  },
  'Tháng trước': () {
    final n = DateTime.now();
    return (DateTime(n.year, n.month - 1, 1), DateTime(n.year, n.month, 0));
  },
  '3 tháng': () =>
      (DateTime.now().subtract(const Duration(days: 90)), DateTime.now()),
  '6 tháng': () =>
      (DateTime.now().subtract(const Duration(days: 180)), DateTime.now()),
};

class _RangeFilter extends ConsumerWidget {
  const _RangeFilter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = ref.watch(dashStatsRangeProvider);
    final label = range == null ? 'Tháng này' : _fmt(range.$1, range.$2);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (d) async {
        final picked = await showMenu<String>(
          context: context,
          color: Colors.white,
          position: RelativeRect.fromLTRB(
              d.globalPosition.dx, d.globalPosition.dy, 0, 0),
          items: [
            for (final k in _quickRanges.keys)
              PopupMenuItem(
                value: k,
                height: 40,
                child: Text(k, style: AppTextStyles.regular(13)),
              ),
          ],
        );
        if (picked != null) {
          ref.read(dashStatsRangeProvider.notifier).state =
              _quickRanges[picked]!();
        }
      },
      child: Row(
        children: [
          Text(label,
              style: AppTextStyles.regular(13, color: AppColors.primary)),
          const SizedBox(width: 4),
          const Icon(Icons.tune_rounded, size: 18, color: AppColors.primary),
        ],
      ),
    );
  }

  String _fmt(DateTime a, DateTime b) {
    String d(DateTime x) => '${x.day}/${x.month}/${x.year}';
    return a == b ? d(a) : '${d(a)} - ${d(b)}';
  }
}

/// Loading placeholder mirroring the stats grid (header + 2×2 cards).
class _StatsSkeleton extends StatelessWidget {
  const _StatsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AppShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShimmerBox(width: 160, height: 22),
            const SizedBox(height: 16),
            for (var r = 0; r < 2; r++) ...[
              if (r > 0) const SizedBox(height: 16),
              const Row(
                children: [
                  Expanded(child: ShimmerBox(height: 92, radius: 16)),
                  SizedBox(width: 16),
                  Expanded(child: ShimmerBox(height: 92, radius: 16)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.stat, this.onTap});
  final DashboardStat stat;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final change = stat.change;
    final isMoney = stat.unit == 'VND' || stat.unit == 'VNĐ';
    final svg = stat.icon;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.neutral100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (svg != null && svg.contains('<svg')) ...[
                  SvgPicture.string(
                    svg,
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                        AppColors.neutral400, BlendMode.srcIn),
                    placeholderBuilder: (_) =>
                        const SizedBox(width: 20, height: 20),
                  ),
                  const SizedBox(width: 5),
                ],
                Expanded(
                  child: Text(stat.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.semibold(13)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(stat.displayValue, style: AppTextStyles.semibold(20)),
            if (!isMoney && change != null) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    change < 0
                        ? Icons.arrow_downward_rounded
                        : Icons.arrow_upward_rounded,
                    size: 12,
                    color: change < 0 ? AppColors.danger : AppColors.success,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${change < 0 ? 'Giảm' : 'Tăng'} ${change.abs().toStringAsFixed(0)}%',
                    style: AppTextStyles.regular(11, color: AppColors.neutral400),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
