import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'work_dialog_kit.dart';

/// "Yêu cầu xác thực BĐS" dialog. When an owner (đầu chủ) exists it reminds
/// them; otherwise it sends the request into the pool. Returns the note (may be
/// empty) on confirm, or `null` if cancelled.
Future<({String note})?> showVerifyDialog(
  BuildContext context, {
  required WorkDialogContext ctx,
}) {
  return showDialog<({String note})>(
    context: context,
    builder: (dctx) {
      final ctrl = TextEditingController();
      final hasOwner = ctx.hasOwner;
      return WorkDialogScaffold(
        icon: Icons.verified_outlined,
        title: 'Yêu cầu xác thực BĐS',
        primaryLabel: hasOwner ? 'Gửi nhắc nhở' : 'Tạo yêu cầu',
        primaryIcon: Icons.verified_outlined,
        onPrimary: () => Navigator.pop(dctx, (note: ctrl.text.trim())),
        children: [
          workBdsCard(code: ctx.bdsCode, title: ctx.bdsTitle),
          const SizedBox(height: 10),
          _ownerBanner(hasOwner, ctx.ownerName),
          const SizedBox(height: 12),
          workFieldLabel('Ghi chú'),
          workTextField(ctrl,
              hint: 'Mô tả thêm cho đầu chủ sẽ nhận yêu cầu...', maxLines: 3),
        ],
      );
    },
  );
}

Widget _ownerBanner(bool hasOwner, String? ownerName) {
  final (bg, fg, icon, title, sub) = hasOwner
      ? (
          AppColors.blueBg,
          AppColors.blueFg,
          Icons.person_outline,
          'Gửi nhắc tới đầu chủ ${ownerName ?? ''}'.trim(),
          'Đầu chủ sẽ nhận thông báo xác thực BĐS này.',
        )
      : (
          AppColors.amberBg,
          AppColors.amberFg,
          Icons.person_add_alt,
          'Chưa có đầu chủ nhận xác thực',
          'Yêu cầu sẽ được gửi vào pool, đầu chủ rảnh sẽ nhận xử lý.',
        );
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: fg),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: AppTypography.caption
                      .copyWith(color: fg, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(sub,
                  style: AppTypography.micro.copyWith(color: fg)),
            ],
          ),
        ),
      ],
    ),
  );
}
