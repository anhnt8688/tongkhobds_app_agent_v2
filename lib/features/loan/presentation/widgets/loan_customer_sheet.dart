import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/loan_customer.dart';
import 'loan_sheet_header.dart';

/// Customer picker bottom sheet (v1 CustomerPickerBottomSheet). Tap a row to
/// select — returns the [LoanCustomer] immediately via `Navigator.pop`.
class LoanCustomerSheet extends StatelessWidget {
  const LoanCustomerSheet({super.key, required this.customers, this.selected});

  final List<LoanCustomer> customers;
  final LoanCustomer? selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const LoanSheetHeader('Chọn khách hàng'),
          Expanded(
            child: customers.isEmpty
                ? const Center(child: Text('Không tìm thấy khách hàng'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: customers.length,
                    itemBuilder: (_, i) => _item(context, customers[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, LoanCustomer c) {
    final isSelected = selected?.id == c.id;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pop(context, c),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.bg,
              child: Icon(Icons.person, color: AppColors.textMute),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.name ?? 'N/A',
                      style: AppTypography.body
                          .copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 18, color: AppColors.textMute),
                      const SizedBox(width: 6),
                      Text(c.phone ?? 'N/A',
                          style: AppTypography.caption
                              .copyWith(color: AppColors.textMute)),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.primary : AppColors.inputBorder,
            ),
          ],
        ),
      ),
    );
  }
}
