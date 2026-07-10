import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../data/models/loan_package.dart';
import 'loan_package_card.dart';
import 'loan_sheet_header.dart';

/// Loan package picker bottom sheet (v1 BuildBottomSheetBankCalculator). Cards
/// list the package terms; single-select with confirm. Returns the chosen
/// [LoanPackage] via `Navigator.pop`.
class LoanPackageSheet extends StatefulWidget {
  const LoanPackageSheet({
    super.key,
    required this.packages,
    this.selected,
    this.title = 'Chọn gói vay',
  });

  final List<LoanPackage> packages;
  final LoanPackage? selected;
  final String title;

  @override
  State<LoanPackageSheet> createState() => _LoanPackageSheetState();
}

class _LoanPackageSheetState extends State<LoanPackageSheet> {
  LoanPackage? _temp;

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
          LoanSheetHeader(widget.title),
          Expanded(
            child: widget.packages.isEmpty
                ? const Center(child: Text('Chưa có gói vay phù hợp'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: widget.packages.length,
                    itemBuilder: (_, i) => _item(widget.packages[i]),
                  ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Hủy',
                      variant: AppButtonVariant.ghost,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton(
                      label: 'Xác nhận',
                      onPressed:
                          _temp == null ? null : () => Navigator.pop(context, _temp),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(LoanPackage p) {
    final selected = identical(_temp, p) || _temp?.id == p.id;
    return GestureDetector(
      onTap: () => setState(() => _temp = p),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.text : AppColors.border,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                AppNetworkImage(
                  url: p.bank?.image,
                  width: 28,
                  height: 28,
                  fit: BoxFit.contain,
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(width: 8),
                Text(p.bank?.abbreviations ?? p.bank?.name ?? '',
                    style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            LoanPackageInfoRows(package: p),
          ],
        ),
      ),
    );
  }
}
