import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/biometric_service.dart';
import '../../../core/widgets/app_toast.dart';
import 'controllers/auth_controller.dart';
import 'widgets/require_update_bottom_sheet.dart';
import 'widgets/require_update_dialog.dart';

/// Post-login side effects ported from v1 (`RequireUpdateUtil` +
/// `_maybePromptBiometricForStaff`). Triggered once the user lands in the
/// authenticated shell, plus a periodic address re-check.
class PostLoginFlows {
  PostLoginFlows._();

  // Guards against stacking the require-update dialog (login + periodic tick).
  static bool _isShowing = false;

  /// Runs the one-shot flows after entering the shell. Order matches v1:
  /// require-update first, then the staff biometric opt-in (skipped if the
  /// require-update flow navigated the user away to the edit screen).
  static Future<void> runOnEnter(BuildContext context, WidgetRef ref) async {
    final navigated = await _maybeShowRequireUpdate(context, ref);
    if (!navigated && context.mounted) {
      await _maybePromptBiometricForStaff(context, ref);
    }
  }

  /// Periodic re-check (v1: every 5 min) — re-prompts if address still missing.
  static Future<void> addressCheckTick(
          BuildContext context, WidgetRef ref) async =>
      _maybeShowRequireUpdate(context, ref);

  /// Shows the require-update dialog when the backend flags the account or the
  /// profile is missing an address. On "Tiếp tục" it opens the "Thông tin Agent"
  /// sheet (v1 parity). Returns `true` if it handled the prompt so the caller
  /// can skip the following biometric prompt.
  static Future<bool> _maybeShowRequireUpdate(
      BuildContext context, WidgetRef ref) async {
    if (_isShowing) return false;
    final user = ref.read(currentUserProvider);
    if (user == null) return false;

    final missingAddress = user.address?.trim().isEmpty ?? true;
    if (!user.requireUpdate && !missingAddress) return false;

    _isShowing = true;
    final shouldContinue = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const RequireUpdateDialog(),
    );
    _isShowing = false;

    if (shouldContinue == true && context.mounted) {
      // v1: "Tiếp tục" opens the agent-info bottom sheet (not the full edit
      // screen) to collect the missing fields and grant Agent rights.
      await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const RequireUpdateBottomSheet(),
      );
      return true;
    }
    return false;
  }

  /// Offers a staff user (one time) to enable biometric login (v1
  /// `_maybePromptBiometricForStaff`).
  static Future<void> _maybePromptBiometricForStaff(
      BuildContext context, WidgetRef ref) async {
    final user = ref.read(currentUserProvider);
    if (user == null || !user.checkingStaff) return;

    final bio = ref.read(biometricServiceProvider);
    if (await bio.wasPrompted()) return;
    if (!context.mounted) return;

    final agreed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Bật sinh trắc học?'),
            content: const Text(
                'Dùng vân tay/Face ID để đăng nhập nhanh ở lần sau.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Không'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Bật'),
              ),
            ],
          ),
        ) ??
        false;
    // Only ever ask once, regardless of the answer (matches v1).
    await bio.markPrompted();

    if (!agreed) {
      await bio.disable();
      return;
    }
    if (!await bio.isAvailable()) {
      if (context.mounted) {
        AppToast.error(context,
            'Thiết bị chưa hỗ trợ hoặc chưa thiết lập vân tay/Face ID.');
      }
      await bio.disable();
      return;
    }

    final token = ref.read(authControllerProvider.notifier).currentToken;
    if (token == null || token.isEmpty) return;
    await bio.enable(token);
    if (context.mounted) AppToast.success(context, 'Đã bật sinh trắc học.');
  }
}
