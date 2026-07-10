import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../data/models/loan_package.dart';

/// Key/value row on a loan package (v1 `_infoBank`): grey label + orange value
/// with a trailing unit.
class LoanPackageInfoRow extends StatelessWidget {
  const LoanPackageInfoRow({
    super.key,
    required this.title,
    required this.value,
    this.unit = '',
    this.highlight = false,
  });

  final String title;
  final String value;
  final String unit;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        decoration: BoxDecoration(
          color: highlight ? AppColors.primarySoft : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(title,
                  style: AppTypography.subtitle.copyWith(color: AppColors.textSecondary)),
            ),
            Expanded(
              flex: 2,
              child: Text.rich(
                textAlign: TextAlign.end,
                TextSpan(
                  children: [
                    TextSpan(
                      text: value,
                      style: AppTypography.subtitle.copyWith(
                          color: AppColors.primary, fontWeight: FontWeight.w600),
                    ),
                    TextSpan(
                      text: unit,
                      style: AppTypography.subtitle
                          .copyWith(color: AppColors.text, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The set of info rows for a package (bank header optional), reused by the
/// hub carousel, the package picker sheet, and the packages list.
class LoanPackageInfoRows extends StatelessWidget {
  const LoanPackageInfoRows({super.key, required this.package});
  final LoanPackage package;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LoanPackageInfoRow(title: 'Tên gói vay', value: package.name ?? ''),
        LoanPackageInfoRow(
            title: 'Lãi suất độc quyền chỉ từ',
            value: '${package.interestRate ?? ''} %',
            unit: ' / năm'),
        LoanPackageInfoRow(
            title: 'Thời gian ưu đãi', value: package.termMonths ?? '', unit: ' tháng'),
        LoanPackageInfoRow(
            title: 'Kỳ hạn tối đa', value: package.maxTermMonths ?? '', unit: ' tháng'),
        LoanPackageInfoRow(
            title: 'Ân hạn nợ gốc',
            value: package.gracePeriod ?? '',
            unit: ' tháng',
            highlight: true),
      ],
    );
  }
}

/// Partner-bank / loan package card (v1 LoanPackgeItem). `showMore` renders the
/// "Xem thêm" button that opens the bank's full package list.
class LoanPackageCard extends StatelessWidget {
  const LoanPackageCard({super.key, required this.package, this.showMore = false});
  final LoanPackage package;
  final bool showMore;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppNetworkImage(
                url: package.bank?.image,
                width: 28,
                height: 28,
                fit: BoxFit.contain,
                backgroundColor: Colors.transparent,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(package.bank?.name ?? '',
                    style: AppTypography.body
                        .copyWith(fontWeight: FontWeight.w600, color: AppColors.text)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LoanPackageInfoRows(package: package),
          if (showMore) ...[
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => context.push('/loan/packages/${package.bank?.id ?? 0}'),
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('Xem thêm',
                    style: AppTypography.body
                        .copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
