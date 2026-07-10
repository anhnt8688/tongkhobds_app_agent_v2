import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_toast.dart';
import 'work_dialog_kit.dart';

/// "Gửi khách hàng" dialog. Recipient + BĐS cards, an editable share link, an
/// optional message, and a channel selector. Returns the chosen channel +
/// message + link, or `null` if cancelled.
Future<({String channel, String message, String link})?> showSendCustomerDialog(
  BuildContext context, {
  required WorkDialogContext ctx,
}) {
  return showDialog<({String channel, String message, String link})>(
    context: context,
    builder: (dctx) {
      String? channel;
      final msgCtrl = TextEditingController();
      final linkCtrl = TextEditingController(text: ctx.postLink ?? '');
      void openChannel() {
        final link = linkCtrl.text.trim();
        if (link.isNotEmpty) {
          Clipboard.setData(ClipboardData(text: link));
          launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
        }
      }

      return StatefulBuilder(
        builder: (dctx, setState) => WorkDialogScaffold(
          icon: Icons.send_outlined,
          title: 'Gửi khách hàng',
          primaryLabel: 'Xác nhận đã gửi',
          primaryIcon: Icons.send,
          onPrimary: channel == null
              ? null
              : () => Navigator.pop(
                  dctx,
                  (
                    channel: channel!,
                    message: msgCtrl.text.trim(),
                    link: linkCtrl.text.trim(),
                  )),
          children: [
            workContactCard(
                role: ctx.contactRole,
                name: ctx.contactName,
                phone: ctx.contactPhone),
            const SizedBox(height: 10),
            workBdsCard(code: ctx.bdsCode, title: ctx.bdsTitle),
            const SizedBox(height: 12),
            workFieldLabel('Link chia sẻ'),
            Row(
              children: [
                Expanded(
                  child: workTextField(linkCtrl, hint: 'Dán link bài viết...'),
                ),
                IconButton(
                  onPressed: () {
                    final link = linkCtrl.text.trim();
                    if (link.isEmpty) return;
                    Clipboard.setData(ClipboardData(text: link));
                    AppToast.info(dctx, 'Đã chép link');
                  },
                  icon: const Icon(Icons.copy_outlined, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 8),
            workFieldLabel('Lời nhắn'),
            workTextField(msgCtrl,
                hint: 'Nhập ghi chú gửi kèm cho khách hàng...', maxLines: 3),
            const SizedBox(height: 12),
            workFieldLabel('Gửi qua'),
            Row(
              children: [
                for (final c in kSendChannels)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _channelCard(c.$2, c.$3, channel == c.$1, () {
                        setState(() => channel = c.$1);
                        openChannel();
                      }),
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

Widget _channelCard(String label, IconData icon, bool on, VoidCallback onTap) =>
    GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: on ? AppColors.primarySoft : AppColors.bg,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: on ? AppColors.primary : AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon,
                size: 22, color: on ? AppColors.primaryDark : AppColors.textSecondary),
            const SizedBox(height: 6),
            Text(label,
                textAlign: TextAlign.center,
                style: AppTypography.micro.copyWith(
                    color: on ? AppColors.primaryDark : AppColors.textSecondary,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
