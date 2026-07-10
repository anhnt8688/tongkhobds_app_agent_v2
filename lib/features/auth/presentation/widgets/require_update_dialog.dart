import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Non-dismissible prompt shown after login when the backend flags the account
/// as needing a profile/agent update (v1 `RequireUpdateDialog`). Pops `true`
/// when the user chooses to continue to the update flow, `false` on cancel.
class RequireUpdateDialog extends StatelessWidget {
  const RequireUpdateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_rounded,
                  size: 72, color: AppColors.warning),
              const SizedBox(height: 16),
              Text(
                'Bạn chưa đăng ký Agent',
                textAlign: TextAlign.center,
                style: AppTypography.heading.copyWith(color: AppColors.text),
              ),
              const SizedBox(height: 10),
              Text(
                'Số điện thoại của bạn đã được đăng ký trên hệ thống nhưng chưa '
                'được cấp quyền Agent. Bạn có muốn trở thành Agent của '
                'TongkhoBDS?',
                textAlign: TextAlign.center,
                style: AppTypography.subtitle.copyWith(
                  color: AppColors.textMute,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: FilledButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.bg,
                        foregroundColor: AppColors.text,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Huỷ'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: FilledButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Tiếp tục'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
