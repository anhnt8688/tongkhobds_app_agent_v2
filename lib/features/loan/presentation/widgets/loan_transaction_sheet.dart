import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../data/models/loan_transaction.dart';
import 'loan_sheet_header.dart';

/// Transaction picker bottom sheet (v1 TransactionPickerBottomSheet). Cards show
/// "Giao dịch #code" + the linked property. Tap returns the [LoanTransaction].
class LoanTransactionSheet extends StatelessWidget {
  const LoanTransactionSheet({super.key, required this.transactions, this.selected});

  final List<LoanTransaction> transactions;
  final LoanTransaction? selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const LoanSheetHeader('Chọn giao dịch'),
          if (transactions.isEmpty)
            const Padding(
              padding: EdgeInsets.all(50),
              child: Text('Không tìm thấy giao dịch'),
            )
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                itemCount: transactions.length,
                itemBuilder: (_, i) => _item(context, transactions[i]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, LoanTransaction t) {
    final isSelected = selected?.id == t.id;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pop(context, t),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Giao dịch #${t.transactionCode ?? ''}',
                style: AppTypography.title.copyWith(fontWeight: FontWeight.w600)),
            if (t.product != null) ...[
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppNetworkImage(
                    url: t.product?.mainImage,
                    width: 60,
                    height: 60,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(t.product?.title ?? '',
                        style: AppTypography.body
                            .copyWith(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
