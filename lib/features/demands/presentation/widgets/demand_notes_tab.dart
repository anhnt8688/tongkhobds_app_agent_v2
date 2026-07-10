import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/demands_api.dart';
import '../../data/models/consultation_activity.dart';

/// "Ghi chú nội bộ" tab: add-note button, the internal-only lock banner and the
/// comment list (`salesman_comments`). Notes are private to the agent + their
/// support team — never sent to the customer or đầu chủ.
class DemandNotesTab extends ConsumerWidget {
  const DemandNotesTab({
    super.key,
    required this.consultationId,
    required this.onAddNote,
  });

  final int consultationId;
  final VoidCallback onAddNote;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comments = ref.watch(demandCommentsProvider(consultationId));
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 28),
      children: [
        _card(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  _label('Ghi chú nội bộ'),
                  const Spacer(),
                  GestureDetector(
                    onTap: onAddNote,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.add, size: 14, color: AppColors.primary),
                        const SizedBox(width: 2),
                        Text('Thêm',
                            style: AppTypography.caption.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600)),
                      ]),
                    ),
                  ),
                ]),
                const SizedBox(height: 12),
                _lockBanner(),
                const SizedBox(height: 12),
                comments.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                        child:
                            CircularProgressIndicator(color: AppColors.primary)),
                  ),
                  error: (_, __) => _empty('Không tải được ghi chú'),
                  data: (list) => list.isEmpty
                      ? _empty('Chưa có ghi chú nào')
                      : Column(children: [for (final c in list) _noteRow(c)]),
                ),
              ]),
        ),
      ],
    );
  }

  Widget _noteRow(DemandComment c) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(c.content ?? '', style: AppTypography.body),
          const SizedBox(height: 2),
          Text(
              '${c.createdByName ?? ''}${(c.createdAt ?? '').isNotEmpty ? ' · ${c.createdAt}' : ''}',
              style: AppTypography.micro.copyWith(color: AppColors.textMute)),
        ]),
      );

  Widget _lockBanner() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: const Color(0xFFFDE68A)),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.lock_outline, size: 16, color: Color(0xFFB45309)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Ghi chú chỉ hiển thị với bạn và đội nhóm hỗ trợ của bạn — không gửi cho khách hàng hay đầu chủ.',
              style: AppTypography.caption
                  .copyWith(color: const Color(0xFF92400E), height: 1.4),
            ),
          ),
        ]),
      );

  Widget _empty(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          const Icon(Icons.schedule, size: 16, color: AppColors.textMute),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style:
                    AppTypography.caption.copyWith(color: AppColors.textMute)),
          ),
        ]),
      );

  Widget _card({required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          border: Border.all(color: AppColors.border),
        ),
        child: child,
      );

  Widget _label(String text) => Text(text.toUpperCase(),
      style: AppTypography.micro.copyWith(
          color: AppColors.textMute,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4));
}
