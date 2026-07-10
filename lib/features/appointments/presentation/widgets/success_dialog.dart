import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';

/// v1 `DialogSuccess` port: a centred card that scales in, with a success
/// image, bold title, muted description, and a single confirm button.
class SuccessDialog {
  /// Shows the dialog. Returns after the user taps the confirm button (or the
  /// route is popped). [onConfirm], if given, runs instead of just closing.
  static Future<void> show(
    BuildContext context, {
    String? title,
    String? description,
    String? confirmLabel,
    VoidCallback? onConfirm,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) => const SizedBox(),
      transitionBuilder: (ctx, a1, __, ___) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/ic_success.png',
                        width: 96,
                        height: 96,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        title ?? 'Yêu cầu của bạn được đặt thành công',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bold(22),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        description ??
                            'Chúng tôi sẽ liên hệ với bạn trong thời gian sớm nhất',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.regular(15,
                            color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 24),
                      AppButton(
                        label: confirmLabel ?? 'Xác nhận',
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          onConfirm?.call();
                        },
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
}
