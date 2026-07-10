import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../data/models/loan_mortgage.dart';
import 'loan_sheet_header.dart';

/// Result of the collateral picker: the chosen [mortgage] + free-text [note].
typedef LoanCollateralResult = ({LoanMortgage mortgage, String note});

/// Collateral picker bottom sheet (v1 BuildBottomSheetCollateral): radio list of
/// mortgage types + a description field (20–50 chars). Confirms both.
class LoanCollateralSheet extends StatefulWidget {
  const LoanCollateralSheet({
    super.key,
    required this.mortgages,
    this.selected,
    this.note = '',
  });

  final List<LoanMortgage> mortgages;
  final LoanMortgage? selected;
  final String note;

  @override
  State<LoanCollateralSheet> createState() => _LoanCollateralSheetState();
}

class _LoanCollateralSheetState extends State<LoanCollateralSheet> {
  late final TextEditingController _desc =
      TextEditingController(text: widget.note);
  LoanMortgage? _temp;

  @override
  void initState() {
    super.initState();
    _temp = widget.selected;
  }

  @override
  void dispose() {
    _desc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const LoanSheetHeader('Tài sản thế chấp'),
              for (final m in widget.mortgages) _option(m),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _desc,
                  maxLines: 5,
                  style: AppTypography.body,
                  decoration: const InputDecoration(
                    hintText: 'Mô tả loại tài sản thế chấp- từ 20-50 ký tự',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: AppButton(
                  label: 'Xác nhận',
                  onPressed: _temp?.id == null
                      ? null
                      : () => Navigator.pop(
                            context,
                            (mortgage: _temp!, note: _desc.text),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _option(LoanMortgage m) {
    final isSelected = _temp?.id == m.id;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _temp = m),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(m.name ?? m.title ?? '',
                  style: AppTypography.body.copyWith(
                    color: isSelected ? AppColors.primary : AppColors.text,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  )),
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
