import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/consultation_sell_api.dart';
import '../../data/models/sell_activity.dart';

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

/// HOẠT ĐỘNG section: work-action buttons (Gọi chủ nhà / Ghi chú / Hẹn xem) +
/// the work timeline (`get_activities_consultation_sell`).
class SellActivitySection extends ConsumerWidget {
  const SellActivitySection({
    super.key,
    required this.sellId,
    this.onCall,
    this.onNote,
    this.onAppointment,
  });
  final int sellId;
  final VoidCallback? onCall;
  final VoidCallback? onNote;
  final VoidCallback? onAppointment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final acts = ref.watch(sellActivitiesProvider(sellId));
    return _card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _label('Hoạt động & ghi chú'),
        if (onCall != null || onNote != null || onAppointment != null) ...[
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: [
            if (onCall != null)
              _actionBtn(Icons.call, 'Gọi chủ nhà', onCall!,
                  color: AppColors.success),
            if (onNote != null)
              _actionBtn(Icons.note_alt_outlined, 'Ghi chú', onNote!,
                  filled: true),
            if (onAppointment != null)
              _actionBtn(Icons.event_outlined, 'Hẹn xem', onAppointment!),
          ]),
        ],
        const SizedBox(height: 10),
        acts.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
                child: CircularProgressIndicator(color: AppColors.primary)),
          ),
          error: (_, __) => _empty('Không tải được hoạt động'),
          data: (list) => list.isEmpty
              ? _empty('Chưa có hoạt động nào')
              : Column(children: [for (final w in list) _row(w)]),
        ),
      ]),
    );
  }

  /// A pill work-action button — [filled] uses the primary color, otherwise
  /// an outline tinted with [color] (default primary).
  Widget _actionBtn(IconData icon, String label, VoidCallback onTap,
      {bool filled = false, Color color = AppColors.primary}) {
    final fg = filled ? Colors.white : color;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: filled ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: filled ? null : Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 15, color: fg),
          const SizedBox(width: 6),
          Text(label,
              style: AppTypography.caption
                  .copyWith(color: fg, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

  Widget _row(SellWork w) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(_icon(w.type), size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(w.name ?? w.type ?? 'Hoạt động',
                  style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
              if ((w.meetingPlace ?? '').isNotEmpty)
                Text(w.meetingPlace!, style: AppTypography.caption),
              if (w.depositAmount != null)
                Text('Cọc: ${(w.depositAmount! / 1e6).toStringAsFixed(0)} tr',
                    style: AppTypography.caption),
              if ((w.createdAt ?? '').isNotEmpty)
                Text(w.createdAt!,
                    style: AppTypography.micro
                        .copyWith(color: AppColors.textMute)),
            ]),
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

  IconData _icon(String? type) {
    switch (type) {
      case 'appointment':
        return Icons.event_outlined;
      case 'deposit':
        return Icons.payments_outlined;
      case 'call':
        return Icons.call;
      default:
        return Icons.note_alt_outlined;
    }
  }
}

/// GHI CHÚ NỘI BỘ section: lock banner + "Thêm" + comments list.
class SellNotesSection extends ConsumerWidget {
  const SellNotesSection({super.key, required this.sellId, required this.onAdd});
  final int sellId;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comments = ref.watch(sellCommentsProvider(sellId));
    return _card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          _label('Ghi chú nội bộ'),
          const Spacer(),
          GestureDetector(
            onTap: onAdd,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                border: Border.all(color: AppColors.primary),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.add, size: 14, color: AppColors.primary),
                const SizedBox(width: 2),
                Text('Thêm',
                    style: AppTypography.caption.copyWith(
                        color: AppColors.primary, fontWeight: FontWeight.w600)),
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
                child: CircularProgressIndicator(color: AppColors.primary)),
          ),
          error: (_, __) => _empty(),
          data: (list) => list.isEmpty
              ? _empty()
              : Column(children: [for (final c in list) _noteRow(c)]),
        ),
      ]),
    );
  }

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

  Widget _noteRow(SellComment c) => Container(
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

  Widget _empty() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text('Chưa có ghi chú nào',
            style: AppTypography.caption.copyWith(color: AppColors.textMute)),
      );
}

/// LỊCH SỬ GÁN THẺ section: assign/remove log (`get_entity_tag_history.json`).
class SellTagHistorySection extends ConsumerWidget {
  const SellTagHistorySection({super.key, required this.sellId});
  final int sellId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(sellTagHistoryProvider(sellId));
    return _card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _label('Lịch sử gán thẻ'),
        const SizedBox(height: 10),
        logs.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
                child: CircularProgressIndicator(color: AppColors.primary)),
          ),
          error: (_, __) => _empty('Không tải được lịch sử'),
          data: (list) => list.isEmpty
              ? _empty('Chưa có lịch sử gán thẻ')
              : Column(children: [for (final l in list) _row(l)]),
        ),
      ]),
    );
  }

  Widget _row(SellTagLog log) {
    final removed = log.action == 'remove';
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(removed ? Icons.remove_circle_outline : Icons.add_circle_outline,
            size: 18, color: removed ? AppColors.danger : AppColors.success),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(style: AppTypography.body, children: [
                    TextSpan(
                        text: log.userName ?? 'Hệ thống',
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    TextSpan(
                        text:
                            '  ${log.actionLabel}${(log.tagName ?? '').isNotEmpty ? ': ${log.tagName}' : ''}',
                        style: AppTypography.caption
                            .copyWith(color: AppColors.textMute)),
                  ]),
                ),
              ]),
        ),
        if ((log.createdAt ?? '').isNotEmpty)
          Text(log.createdAt!,
              style: AppTypography.micro.copyWith(color: AppColors.textMute)),
      ]),
    );
  }

  Widget _empty(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(text,
            style: AppTypography.caption.copyWith(color: AppColors.textMute)),
      );
}
