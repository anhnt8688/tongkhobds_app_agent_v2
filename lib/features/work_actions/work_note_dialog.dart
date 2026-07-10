import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'work_dialog_kit.dart';

/// "Thêm ghi chú" dialog. Returns the note content (non-empty), or `null` if
/// cancelled. Shows a live 0/500 counter and the timeline-log hint.
Future<String?> showNoteDialog(
  BuildContext context, {
  required WorkDialogContext ctx,
}) {
  return showDialog<String>(
    context: context,
    builder: (dctx) {
      final ctrl = TextEditingController();
      return StatefulBuilder(
        builder: (dctx, setState) => WorkDialogScaffold(
          icon: Icons.edit_note_outlined,
          title: 'Thêm ghi chú',
          badge: ctx.entityBadge,
          primaryLabel: 'Lưu ghi chú',
          onPrimary: ctrl.text.trim().isEmpty
              ? null
              : () => Navigator.pop(dctx, ctrl.text.trim()),
          children: [
            workTextField(
              ctrl,
              hint: 'Nhập nội dung ghi chú...',
              maxLines: 5,
              maxLength: 500,
              autofocus: true,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.info_outline,
                    size: 14, color: AppColors.textMute),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Ghi chú sẽ được ghi log và hiển thị trong timeline',
                    style: AppTypography.micro
                        .copyWith(color: AppColors.textMute),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
