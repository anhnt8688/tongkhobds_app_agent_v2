import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../data/models/loan_bank.dart';
import 'loan_sheet_header.dart';

/// Bank picker bottom sheet (v1 BankPickerBottomSheet). Search by abbreviation
/// or code, single-select with confirm. Returns the chosen [LoanBank] via
/// `Navigator.pop`, or null when cancelled.
class LoanBankSheet extends StatefulWidget {
  const LoanBankSheet({super.key, required this.banks, this.selected});
  final List<LoanBank> banks;
  final LoanBank? selected;

  @override
  State<LoanBankSheet> createState() => _LoanBankSheetState();
}

class _LoanBankSheetState extends State<LoanBankSheet> {
  final _search = TextEditingController();
  String _query = '';
  LoanBank? _temp;

  @override
  void initState() {
    super.initState();
    _temp = widget.selected;
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<LoanBank> get _filtered {
    if (_query.trim().isEmpty) return widget.banks;
    final q = _query.toLowerCase();
    return widget.banks.where((b) {
      final t = (b.abbreviations ?? '').toLowerCase();
      final s = (b.bankCodeVn ?? '').toLowerCase();
      return t.contains(q) || s.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const LoanSheetHeader('Chọn ngân hàng'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _search,
                onChanged: (v) => setState(() => _query = v),
                decoration: const InputDecoration(
                  hintText: 'Nhập ngân hàng',
                  prefixIcon: Icon(Icons.search, color: AppColors.textMute),
                ),
              ),
            ),
            Expanded(
              child: list.isEmpty
                  ? const Center(child: Text('Không tìm thấy ngân hàng'))
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: list.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1, color: AppColors.border),
                      itemBuilder: (_, i) => _item(list[i]),
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
                        onPressed: _temp == null
                            ? null
                            : () => Navigator.pop(context, _temp),
                      ),
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

  Widget _item(LoanBank bank) {
    final selected = _temp?.id == bank.id;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _temp = bank),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F4),
                shape: BoxShape.circle,
              ),
              child: AppNetworkImage(
                url: bank.image,
                width: 28,
                height: 28,
                fit: BoxFit.contain,
                backgroundColor: Colors.transparent,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bank.abbreviations ?? '',
                      style: AppTypography.body
                          .copyWith(fontWeight: FontWeight.w600, color: AppColors.text)),
                  if ((bank.bankCodeVn ?? '').isNotEmpty)
                    Text(bank.bankCodeVn!,
                        style: AppTypography.caption
                            .copyWith(color: AppColors.textMute)),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.check_box_rounded
                  : Icons.check_box_outline_blank_rounded,
              color: selected ? AppColors.primary : AppColors.inputBorder,
            ),
          ],
        ),
      ),
    );
  }
}
