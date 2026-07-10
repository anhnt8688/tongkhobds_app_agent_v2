import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/demands_api.dart';
import '../../data/models/consultation_activity.dart';
import 'demand_work_actions.dart';

/// "Khách hàng" tab body: customer-facing work actions (gọi khách hàng, ghi
/// chú, lịch hẹn) plus the work/activity timeline (hoạt động + log công việc).
/// Per-BĐS actions live in the BĐS tab's work sheet; notes in their own tab.
class DemandCustomerActivityTab extends ConsumerWidget {
  const DemandCustomerActivityTab({
    super.key,
    required this.consultationId,
    this.customerName,
    this.customerPhone,
  });

  final int consultationId;
  final String? customerName;
  final String? customerPhone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final acts = ref.watch(demandActivitiesProvider(consultationId));
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 28),
      children: [
        _workCard(context, ref),
        const SizedBox(height: 14),
        _card(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label('Hoạt động & log công việc'),
                const SizedBox(height: 10),
                acts.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                        child:
                            CircularProgressIndicator(color: AppColors.primary)),
                  ),
                  error: (_, __) => _empty('Không tải được hoạt động'),
                  data: (list) => list.isEmpty
                      ? _empty('Chưa có hoạt động nào')
                      : Column(children: [for (final w in list) _workRow(w)]),
                ),
              ]),
        ),
      ],
    );
  }

  /// CÔNG VIỆC block: Gọi khách hàng + the action chips (consultation-level).
  Widget _workCard(BuildContext context, WidgetRef ref) {
    final a = DemandWorkActions(ref, consultationId,
        customerName: customerName, customerPhone: customerPhone);
    return _card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          _label('Công việc'),
          const Spacer(),
          GestureDetector(
            onTap: () => a.callCustomer(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.greenBg,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.call, size: 14, color: AppColors.greenFg),
                const SizedBox(width: 6),
                Text('Gọi khách hàng',
                    style: AppTypography.caption.copyWith(
                        color: AppColors.greenFg, fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
        ]),
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8, children: [
          _chip(Icons.description_outlined, 'Ghi chú',
              AppColors.textSecondary, () => a.note(context)),
          _chip(Icons.calendar_month_outlined, 'Lịch hẹn', AppColors.primary,
              () => a.appointment(context)),
        ]),
      ]),
    );
  }

  Widget _chip(IconData icon, String label, Color color, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 6),
            Text(label,
                style: AppTypography.caption.copyWith(
                    color: AppColors.text, fontWeight: FontWeight.w600)),
          ]),
        ),
      );

  Widget _workRow(ActivityWork w) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(_icon(w.subtype), size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(w.name ?? w.subtype ?? 'Hoạt động',
                  style:
                      AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
              if ((w.description ?? '').isNotEmpty)
                Text(w.description!, style: AppTypography.caption),
              if ((w.meetingPlace ?? '').isNotEmpty)
                Text(w.meetingPlace!, style: AppTypography.caption),
              if (w.depositAmount != null)
                Text('Cọc: ${(w.depositAmount! / 1e6).toStringAsFixed(0)} tr',
                    style: AppTypography.caption),
              if ((w.createdByName ?? '').isNotEmpty ||
                  (w.createdAt ?? '').isNotEmpty)
                Text(
                    '${w.createdByName ?? ''}${(w.createdAt ?? '').isNotEmpty ? ' · ${w.createdAt}' : ''}',
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

  IconData _icon(String? type) {
    switch (type) {
      case 'appointment':
        return Icons.event_outlined;
      case 'deposit':
        return Icons.payments_outlined;
      case 'call_owner':
        return Icons.call;
      case 'send_customer':
        return Icons.share_outlined;
      case 'request_verification':
        return Icons.verified_user_outlined;
      case 'not_suitable':
        return Icons.block;
      default:
        return Icons.note_alt_outlined;
    }
  }
}
