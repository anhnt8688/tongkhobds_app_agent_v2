import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'app_button.dart';

/// Centered confirm dialog matching v1 `DialogUtil.showConfirmDialog`:
/// optional 72×72 icon, bold centered title, description, and a two-button row
/// (cancel on the left, primary on the right). Each button pops the dialog
/// before invoking its callback, so callers navigate with the outer context.
Future<void> showAppConfirmDialog(
  BuildContext context, {
  String? title,
  String? description,
  String? imageAsset,
  required String confirmLabel,
  String? cancelLabel,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  bool showCancel = true,
  AppButtonVariant confirmVariant = AppButtonVariant.primary,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: '',
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (ctx, a1, _, __) {
      return Transform.scale(
        scale: a1.value,
        child: Opacity(
          opacity: a1.value,
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (imageAsset != null) ...[
                      Image.asset(imageAsset,
                          width: 72, height: 72, fit: BoxFit.cover),
                      const SizedBox(height: 8),
                    ],
                    if (title != null)
                      Text(title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'SF Pro Text',
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text,
                          )),
                    if (description != null) ...[
                      const SizedBox(height: 12),
                      Text(description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'SF Pro Text',
                            fontSize: 16,
                            color: AppColors.textSecondary,
                            height: 1.35,
                          )),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        if (showCancel) ...[
                          Expanded(
                            child: AppButton(
                              label: cancelLabel ?? 'Huỷ bỏ',
                              variant: AppButtonVariant.ghost,
                              onPressed: () {
                                Navigator.of(ctx).pop();
                                onCancel?.call();
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                        Expanded(
                          child: AppButton(
                            label: confirmLabel,
                            variant: confirmVariant,
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              onConfirm?.call();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
