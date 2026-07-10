import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_toast.dart';
import 'work_dialog_kit.dart';

/// "Gọi khách hàng" / "Gọi chủ nhà" dialog. Returns the chosen call result +
/// note, or `null` if cancelled. [title] sets the action label (call target).
Future<({String result, String note})?> showCallDialog(
  BuildContext context, {
  required WorkDialogContext ctx,
  String title = 'Gọi khách hàng',
}) {
  return showDialog<({String result, String note})>(
    context: context,
    builder: (dctx) {
      String? result;
      final noteCtrl = TextEditingController();
      return StatefulBuilder(
        builder: (dctx, setState) => WorkDialogScaffold(
          icon: Icons.call,
          title: title,
          primaryLabel: 'Lưu kết quả',
          primaryIcon: Icons.save_outlined,
          onPrimary: result == null
              ? null
              : () => Navigator.pop(
                  dctx, (result: result!, note: noteCtrl.text.trim())),
          children: [
            workContactCard(
              role: ctx.contactRole,
              name: ctx.contactName,
              phone: ctx.contactPhone,
              onCopy: () {
                Clipboard.setData(ClipboardData(text: ctx.contactPhone ?? ''));
                AppToast.info(dctx, 'Đã chép số');
              },
              onCall: () {
                final p = ctx.contactPhone;
                if (p != null && p.trim().isNotEmpty) {
                  launchUrl(Uri.parse('tel:$p'));
                }
              },
            ),
            const SizedBox(height: 12),
            workFieldLabel('Kết quả cuộc gọi'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final r in kCallResults)
                  _resultChip(r.$2, result == r.$1,
                      () => setState(() => result = r.$1)),
              ],
            ),
            const SizedBox(height: 12),
            workFieldLabel('Ghi chú'),
            workTextField(noteCtrl,
                hint: 'Nội dung trao đổi với khách hàng...', maxLines: 3),
          ],
        ),
      );
    },
  );
}

Widget _resultChip(String label, bool on, VoidCallback onTap) => GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
