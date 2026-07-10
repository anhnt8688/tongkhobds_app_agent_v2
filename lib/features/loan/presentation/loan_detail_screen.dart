import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_confirm_dialog.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/custom_screen.dart';
import '../../../core/widgets/status_pill.dart';
import '../data/loan_api.dart';
import '../data/loan_enums.dart';
import '../data/loan_format.dart';
import '../data/models/loan.dart';
import 'widgets/loan_detail_info_card.dart';
import 'widgets/loan_form_fields.dart';

/// Loan profile detail (v1 LoanDetailProfilePage): status card, read-only info,
/// status dates, processing timeline. Edit/delete only while status = "0".
class LoanDetailScreen extends ConsumerWidget {
  const LoanDetailScreen({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(loanDetailProvider(id));
    return CustomScreen(
      title: 'Chi tiết hồ sơ',
      backgroundColor: AppColors.bg,
      child: AsyncView<Loan>(
        value: async,
        onRetry: () => ref.invalidate(loanDetailProvider(id)),
        data: (loan) => _body(context, ref, loan),
      ),
    );
  }

  Widget _body(BuildContext context, WidgetRef ref, Loan loan) {
    final editable = loan.status == '0';
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _statusCard(loan),
                const SizedBox(height: 16),
                LoanDetailInfoCard(loan: loan),
                const SizedBox(height: 16),
                _datesCard(loan),
                if (loan.tracking.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _timelineCard(loan),
                ],
              ],
            ),
          ),
        ),
        if (editable) _actions(context, ref, loan),
      ],
    );
  }

  Widget _statusCard(Loan loan) {
    final status = loanStatusFromValue(loan.status);
    return _card(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Hồ sơ #${loan.id}',
              style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
          StatusPill(label: status.title, tone: status.tone),
        ],
      ),
    );
  }

  Widget _datesCard(Loan loan) {
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Trạng thái hồ sơ',
              style: AppTypography.title.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          LoanReadonlyField(title: 'Ngày tạo hồ sơ', value: loanDate(loan.createdOn)),
          const SizedBox(height: 16),
          LoanReadonlyField(
              title: 'Ngày cập nhật gần nhất', value: loanDate(loan.updatedOn)),
        ],
      ),
    );
  }

  Widget _timelineCard(Loan loan) {
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Lịch sử xử lý hồ sơ',
              style: AppTypography.title.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          for (var i = 0; i < loan.tracking.length; i++)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: AppColors.primary),
                      ),
                      if (i != loan.tracking.length - 1)
                        const Expanded(
                          child: VerticalDivider(
                              width: 2, thickness: 2, color: AppColors.primary),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(loan.tracking[i].title ?? '',
                              style: AppTypography.body
                                  .copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const FaIcon(FontAwesomeIcons.clock,
                                  size: 14, color: AppColors.textMute),
                              const SizedBox(width: 4),
                              Text(loanDate(loan.tracking[i].createdOn, withTime: true),
                                  style: AppTypography.caption
                                      .copyWith(color: AppColors.textMute)),
                            ],
                          ),
                          if ((loan.tracking[i].note ?? '').isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(loan.tracking[i].note!,
                                style: AppTypography.body
                                    .copyWith(fontWeight: FontWeight.w600)),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _actions(BuildContext context, WidgetRef ref, Loan loan) {
    return SafeArea(
      top: false,
      child: Container(
        color: AppColors.surface,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                label: 'Xoá',
                variant: AppButtonVariant.danger,
                onPressed: () => _confirmDelete(context, ref, loan.id!),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppButton(
                label: 'Chỉnh sửa',
                onPressed: () => context.push('/loan/create', extra: {'data': loan}),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, int loanId) {
    showAppConfirmDialog(
      context,
      title: 'Xoá hồ sơ vay!',
      description: 'Bạn có chắc chắn muốn xoá hồ sơ vay này không?',
      confirmLabel: 'Xoá',
      confirmVariant: AppButtonVariant.danger,
      onConfirm: () async {
        try {
          await ref.read(loanApiProvider).delete(loanId);
          ref.read(loanRefreshProvider.notifier).state++;
          if (context.mounted) {
            AppToast.success(context, 'Xoá thành công');
            context.pop();
          }
        } catch (_) {
          if (context.mounted) AppToast.error(context, 'Không thể xoá hồ sơ');
        }
      },
    );
  }

  Widget _card(Widget child) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20),
          ],
        ),
        child: child,
      );
}
