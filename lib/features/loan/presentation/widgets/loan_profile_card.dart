import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/money_format.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../data/loan_enums.dart';
import '../../data/loan_format.dart';
import '../../data/models/loan.dart';

/// Loan profile list card (v1 profile_management `itemView`): id + status pill,
/// property header, and customer/bank/amount/term/updated rows.
class LoanProfileCard extends StatelessWidget {
  const LoanProfileCard({super.key, required this.loan, this.onTap});

  final Loan loan;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final status = loanStatusFromValue(loan.status);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Hồ sơ #${loan.id}',
                    style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                StatusPill(label: status.title, tone: status.tone),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                AppNetworkImage(
                  url: loan.transaction?.product?.mainImage,
                  width: 60,
                  height: 60,
                  borderRadius: BorderRadius.circular(8),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(loan.transaction?.product?.title ?? '',
                      style: AppTypography.body
                          .copyWith(fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const Divider(height: 32, thickness: 0.5, color: AppColors.border),
            _row('Tên khách hàng', loan.customer?.name ?? ''),
            _row('Ngân hàng', loan.loanPackage?.bank?.name ?? '',
                image: loan.loanPackage?.bank?.image),
            _row('Số tiền vay', formatMoney(loan.loanAmount)),
            _row('Thời hạn vay', '${loan.loanTerm} tháng'),
            _row('Ngày cập nhật gần nhất', loanDate(loan.updatedOn)),
          ],
        ),
      ),
    );
  }

  Widget _row(String title, String value, {String? image}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(title,
                style: AppTypography.subtitle
                    .copyWith(color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Row(
              children: [
                if (image != null && image.isNotEmpty) ...[
                  AppNetworkImage(
                    url: image,
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(width: 6),
                ],
                Expanded(
                  child: Text(value,
                      textAlign: TextAlign.end,
                      style: AppTypography.body
                          .copyWith(fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
