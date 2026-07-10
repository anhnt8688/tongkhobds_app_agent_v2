import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/demands_api.dart';
import '../../data/models/consultation_activity.dart';
import 'demand_work_actions.dart';

/// Inline expansion shown under a BĐS tile when tapped ("công việc của BĐS").
/// Holds the per-BĐS action chips (target consultation_interest) and the BĐS's
/// own work log. Only one is expanded at a time (parent tracks the open id).
class DemandBdsExpanded extends ConsumerWidget {
  const DemandBdsExpanded({
    super.key,
    required this.interest,
    required this.consultationId,
    this.customerName,
    this.customerPhone,
  });

  final ConsultationInterest interest;
  final int consultationId;
  final String? customerName;
  final String? customerPhone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a = DemandWorkActions(ref, consultationId,
        interest: interest,
        customerName: customerName,
        customerPhone: customerPhone);
    final acts = ref.watch(demandInterestActivitiesProvider(interest.id));

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _label('Thao tác'),
        const SizedBox(height: 10),
        Wrap(spacing: 8, runSpacing: 8, children: [
          _chip(Icons.call, 'Gọi đầu chủ', AppColors.greenFg,
              () => a.callOwner(context)),
          _chip(Icons.share_outlined, 'Gửi khách hàng', AppColors.info,
              () => a.sendCustomer(context)),
          _chip(Icons.description_outlined, 'Ghi chú',
              AppColors.textSecondary, () => a.note(context)),
          _chip(Icons.verified_user_outlined, 'Nhắc xác thực',
              AppColors.warning, () => a.remindVerify(context)),
          _chip(Icons.calendar_month_outlined, 'Hẹn xem', AppColors.primary,
              () => a.appointment(context)),
          _chip(Icons.attach_money, 'Đặt cọc', AppColors.success,
              () => a.deposit(context)),
          _chip(Icons.block, 'Không phù hợp', AppColors.danger,
              () => a.notSuitable(context)),
          if (interest.realEstateId != null)
            _chip(Icons.open_in_new, 'Chi tiết BĐS', AppColors.text,
                () => context.push('/property/${interest.realEstateId}')),
        ]),
        const SizedBox(height: 14),
        _label('Hoạt động & log công việc'),
        const SizedBox(height: 8),
        acts.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(12),
            child: Center(
                child: CircularProgressIndicator(color: AppColors.primary)),
          ),
          error: (_, __) => _empty('Không tải được hoạt động'),
          data: (list) => list.isEmpty
              ? _empty('Chưa có công việc nào')
              : Column(children: [for (final w in list) _workRow(w)]),
        ),
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
        padding: const EdgeInsets.only(bottom: 10),
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
              if ((w.createdByName ?? '').isNotEmpty ||
                  (w.createdAt ?? '').isNotEmpty)
                Text(
                    '${w.createdByName ?? ''}${(w.createdAt ?? '').isNotEmpty ? ' · ${w.createdAt}' : ''}',
                    style:
                        AppTypography.micro.copyWith(color: AppColors.textMute)),
            ]),
          ),
        ]),
      );

  Widget _empty(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
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
