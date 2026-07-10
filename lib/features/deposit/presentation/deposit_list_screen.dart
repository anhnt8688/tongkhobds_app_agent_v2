import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/custom_screen.dart';
import '../data/deposit_models.dart';
import '../data/deposit_api.dart';

Color depositStatusColor(DepositStatusEnum s) => switch (s) {
      DepositStatusEnum.pendingPayment => AppColors.warning,
      DepositStatusEnum.paid => AppColors.success,
      DepositStatusEnum.cancelled => AppColors.textMute,
      DepositStatusEnum.forfeited => AppColors.danger,
      DepositStatusEnum.refunded => AppColors.info,
    };

/// "Ký gửi / Đặt cọc" — deposit works grouped by status tabs.
class DepositListScreen extends ConsumerWidget {
  const DepositListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(depositStatusGroupsProvider);
    return CustomScreen(
      title: 'Ký gửi / Đặt cọc',
      backgroundColor: AppColors.bg,
      child: AsyncView<List<DepositStatusGroup>>(
        value: groups,
        onRetry: () => ref.invalidate(depositStatusGroupsProvider),
        data: (list) {
          final tabs = [
            const DepositStatusGroup(label: 'Tất cả', key: 'all', optionsRaw: null),
            ...list,
          ];
          return DefaultTabController(
            length: tabs.length,
            child: Column(
              children: [
                Material(
                  color: AppColors.surface,
                  child: TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicatorColor: AppColors.primary,
                    tabs: [for (final g in tabs) Tab(text: g.label)],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [for (final g in tabs) _DepositList(group: g)],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DepositList extends ConsumerWidget {
  const _DepositList({required this.group});
  final DepositStatusGroup group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final csv = group.optionsList.join(',');
    final list = ref.watch(depositListProvider(csv));
    return AsyncView<List<DepositWork>>(
      value: list,
      onRetry: () => ref.invalidate(depositListProvider(csv)),
      data: (items) {
        if (items.isEmpty) {
          return const Center(child: Text('Chưa có giao dịch ký gửi'));
        }
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async => ref.invalidate(depositListProvider(csv)),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) => _DepositCard(item: items[i]),
          ),
        );
      },
    );
  }
}

class _DepositCard extends StatelessWidget {
  const _DepositCard({required this.item});
  final DepositWork item;
  @override
  Widget build(BuildContext context) {
    final color = depositStatusColor(item.status);
    return GestureDetector(
      onTap: () => context.push('/deposit/${item.id}'),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              child: SizedBox(
                width: 72,
                height: 72,
                child: (item.estate.image ?? '').isNotEmpty
                    ? AppNetworkImage(url: item.estate.image, width: 72, height: 72)
                    : Container(
                        color: AppColors.primarySoft,
                        child: const Icon(Icons.home_work_outlined,
                            color: AppColors.primary)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.estate.title.isNotEmpty
                              ? item.estate.title
                              : item.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.body
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(item.statusText,
                            style: AppTypography.micro.copyWith(
                                color: color, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (item.estate.address.isNotEmpty)
                    Text(item.estate.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.caption
                            .copyWith(color: AppColors.textMute)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (item.customer != null) ...[
                        const Icon(Icons.person_outline,
                            size: 13, color: AppColors.textMute),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(item.customer!.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.caption
                                  .copyWith(color: AppColors.textMute)),
                        ),
                      ],
                      if ((item.createdAt ?? '').isNotEmpty)
                        Text(item.createdAt!,
                            style: AppTypography.micro
                                .copyWith(color: AppColors.textMute)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
