import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'work_dialog_kit.dart';

final _fmt = DateFormat('HH:mm dd/MM/yyyy');

/// "Tạo lịch hẹn" dialog. Date/time (required, future), location, note and a
/// "notify owner" toggle. Returns the appointment details, or `null` if
/// cancelled.
Future<({DateTime when, String location, String note, bool notifyOwner})?>
    showAppointmentDialog(
  BuildContext context, {
  required WorkDialogContext ctx,
}) {
  return showDialog<
      ({DateTime when, String location, String note, bool notifyOwner})>(
    context: context,
    builder: (dctx) {
      DateTime? when;
      final locCtrl = TextEditingController();
      final noteCtrl = TextEditingController();
      bool notify = true;

      Future<void> pick(StateSetter setState) async {
        final now = DateTime.now();
        final d = await showDatePicker(
          context: dctx,
          initialDate: now,
          firstDate: now,
          lastDate: now.add(const Duration(days: 365)),
        );
        if (d == null || !dctx.mounted) return;
        final t = await showTimePicker(
            context: dctx, initialTime: TimeOfDay.now());
        if (t == null) return;
        setState(() =>
            when = DateTime(d.year, d.month, d.day, t.hour, t.minute));
      }

      return StatefulBuilder(
        builder: (dctx, setState) => WorkDialogScaffold(
          icon: Icons.event_outlined,
          title: 'Tạo lịch hẹn',
          cancelLabel: 'Huỷ',
          primaryLabel: 'Tạo lịch hẹn',
          primaryIcon: Icons.event_available_outlined,
          onPrimary: when == null
              ? null
              : () => Navigator.pop(dctx, (
                    when: when!,
                    location: locCtrl.text.trim(),
                    note: noteCtrl.text.trim(),
                    notifyOwner: notify
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
            workFieldLabel('Thời gian hẹn', required: true),
            InkWell(
              onTap: () => pick(setState),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(
                      color: when == null
                          ? AppColors.inputBorder
                          : AppColors.primary),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 16, color: AppColors.textMute),
                    const SizedBox(width: 8),
                    Text(
                      when == null ? 'Chọn ngày giờ hẹn' : _fmt.format(when!),
                      style: AppTypography.body.copyWith(
                          color: when == null
                              ? AppColors.textMute
                              : AppColors.text),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            workFieldLabel('Địa điểm gặp'),
            workTextField(locCtrl, hint: 'VD: Văn phòng quận 1, số 123 đường X'),
            const SizedBox(height: 12),
            workFieldLabel('Ghi chú'),
            workTextField(noteCtrl,
                hint: 'Nội dung trao đổi cần lưu ý...', maxLines: 2),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.notifications_active_outlined,
                      size: 18, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tự động gửi thông báo cho chủ nhà',
                            style: AppTypography.caption
                                .copyWith(fontWeight: FontWeight.w600)),
                        Text('Sau khi đầu chủ xác nhận lịch hẹn',
                            style: AppTypography.micro
                                .copyWith(color: AppColors.textMute)),
                      ],
                    ),
                  ),
                  Switch(
                    value: notify,
                    activeThumbColor: AppColors.primary,
                    onChanged: (v) => setState(() => notify = v),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
