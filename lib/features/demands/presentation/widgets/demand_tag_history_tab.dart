import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/demands_api.dart';
import '../../data/models/consultation_activity.dart';
import '../demands_screen.dart' show hexColor;

/// Lịch sử gán thẻ tab: a log of tag assign/remove actions
/// (`get_entity_tag_history.json`) — user + action + tag chip + time.
class DemandTagHistoryTab extends ConsumerWidget {
  const DemandTagHistoryTab({super.key, required this.consultationId});

  final int consultationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(demandTagHistoryProvider(consultationId));
    return logs.when(
      loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary)),
      error: (_, __) => _empty('Không tải được lịch sử'),
      data: (list) => list.isEmpty
          ? _empty('Chưa có lịch sử gán thẻ')
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) => _row(list[i]),
            ),
    );
  }

  Widget _row(DemandTagLog log) {
    final removed = log.action == 'remove';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(removed ? Icons.remove_circle_outline : Icons.add_circle_outline,
              size: 18, color: removed ? AppColors.danger : AppColors.success),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(style: AppTypography.body, children: [
                TextSpan(
                    text: log.userName ?? 'Hệ thống',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                TextSpan(
                    text: '  ${log.actionLabel}',
                    style: AppTypography.caption
                        .copyWith(color: AppColors.textMute)),
              ]),
            ),
          ),
          if ((log.createdAt ?? '').isNotEmpty)
            Text(log.createdAt!,
                style:
                    AppTypography.micro.copyWith(color: AppColors.textMute)),
        ]),
        if ((log.tagName ?? '').isNotEmpty) ...[
          const SizedBox(height: 8),
          _tagChip(log.tagName!, hexColor(log.tagColor) ?? AppColors.primary),
        ],
      ]),
    );
  }

  Widget _tagChip(String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        ),
        child: Text(label,
            style: AppTypography.micro
                .copyWith(color: color, fontWeight: FontWeight.w600)),
      );

  Widget _empty(String text) => Center(
        child: Text(text,
            style: AppTypography.caption.copyWith(color: AppColors.textMute)),
      );
}
