import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/money_format.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../data/models/loan.dart';
import 'loan_form_fields.dart';

/// Read-only "Thông tin hồ sơ" card on the loan detail screen (v1 InfoProfile).
class LoanDetailInfoCard extends StatelessWidget {
  const LoanDetailInfoCard({super.key, required this.loan});

  final Loan loan;

  String _years(String? months) =>
      ((int.tryParse(months ?? '0') ?? 0) ~/ 12).toString();

  @override
  Widget build(BuildContext context) {
    final pkg = loan.loanPackage;
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Thông tin hồ sơ',
              style: AppTypography.title.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          const LoanFieldLabel(title: 'Ngân hàng vay', required: true),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F4),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: Row(
              children: [
                AppNetworkImage(
                  url: pkg?.bank?.image,
                  width: 28,
                  height: 28,
                  fit: BoxFit.contain,
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(width: 12),
                Text(pkg?.bank?.name ?? '',
                    style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          LoanReadonlyField(
            title: 'Số tiền vay',
            value: formatMoney(loan.loanAmount, currency: ''),
            suffixText: 'VNĐ',
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: LoanReadonlyField(
                  title: 'Lãi suất ưu đãi',
                  value: pkg?.interestRate ?? '',
                  suffixText: '% / năm',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: LoanReadonlyField(
                  title: 'Thời hạn ưu đãi',
                  value: _years(pkg?.termMonths),
                  suffixText: 'năm',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: LoanReadonlyField(
                  title: 'Lãi suất thả nổi',
                  required: true,
                  value: pkg?.interestRateFloat ?? '',
                  suffixText: '% / năm',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: LoanReadonlyField(
                  title: 'Thời hạn vay',
                  required: true,
                  value: _years(loan.loanTerm),
                  suffixText: 'năm',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LoanReadonlyField(
              title: 'Tên khách hàng', value: loan.customer?.name ?? ''),
          const SizedBox(height: 16),
          LoanReadonlyField(
              title: 'Số điện thoại', value: loan.customer?.phone ?? ''),
          const SizedBox(height: 16),
          LoanReadonlyField(
              title: 'Giao dịch cần vay',
              value: loan.transaction?.transactionTitle ?? ''),
          const SizedBox(height: 16),
          LoanReadonlyField(
              title: 'Tài sản thế chấp',
              value: loan.mortgage?.title ?? loan.mortgage?.name ?? ''),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) => Container(
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
