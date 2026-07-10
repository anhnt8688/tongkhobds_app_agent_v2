import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'work_dialog_kit.dart';

/// "Tạo đặt cọc" dialog. Amount (with quick presets) + deposit type + note.
/// Returns the amount (VND), type code and note, or `null` if cancelled.
Future<({int amount, String type, String note})?> showDepositDialog(
  BuildContext context, {
  required WorkDialogContext ctx,
}) {
  return showDialog<({int amount, String type, String note})>(
    context: context,
    builder: (dctx) {
      final amountCtrl = TextEditingController();
      final noteCtrl = TextEditingController();
      String type = kDepositTypes.first.$1;
      int parse() =>
          int.tryParse(amountCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

      return StatefulBuilder(
        builder: (dctx, setState) => WorkDialogScaffold(
          icon: Icons.payments_outlined,
          title: 'Tạo đặt cọc',
          cancelLabel: 'Huỷ',
          primaryLabel: 'Tạo đặt cọc',
          primaryIcon: Icons.payments_outlined,
          onPrimary: parse() <= 0
              ? null
              : () => Navigator.pop(dctx, (
                    amount: parse(),
                    type: type,
                    note: noteCtrl.text.trim()
                  )),
          children: [
            workContactCard(
                role: ctx.contactRole,
                name: ctx.contactName,
                phone: ctx.contactPhone),
            const SizedBox(height: 10),
            workBdsCard(
                code: ctx.bdsCode,
                title: ctx.bdsTitle,
                subtitle: ctx.bdsSubtitle),
            const SizedBox(height: 12),
            workFieldLabel('Số tiền cọc (VND)', required: true),
            workTextField(
              amountCtrl,
              hint: '50.000.000',
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final q in kQuickDeposits)
                  _quickChip(q.$2, () {
                    amountCtrl.text = _fmt(q.$1);
                    setState(() {});
                  }),
              ],
            ),
            const SizedBox(height: 12),
            workFieldLabel('Loại cọc'),
            Row(
              children: [
                for (final t in kDepositTypes)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _typeChip(t.$2, type == t.$1,
                        () => setState(() => type = t.$1)),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            workFieldLabel('Ghi chú'),
            workTextField(noteCtrl,
                hint: 'Ghi chú về điều kiện cọc', maxLines: 2),
          ],
        ),
      );
    },
  );
}

String _fmt(int v) {
  final s = v.toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return b.toString();
}

Widget _quickChip(String label, VoidCallback onTap) => GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(label,
            style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
      ),
    );

Widget _typeChip(String label, bool on, VoidCallback onTap) => GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: on ? AppColors.primarySoft : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: on ? AppColors.primary : AppColors.border),
        ),
        child: Text(label,
            style: AppTypography.caption.copyWith(
                color: on ? AppColors.primaryDark : AppColors.text,
                fontWeight: on ? FontWeight.w600 : FontWeight.w500)),
      ),
    );
