import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

enum AppButtonVariant { primary, success, info, danger, ghost }

/// Button matching v1: height 50, radius 12. Filled variants use semibold-17
/// white text; `ghost` is the v1 outline style (transparent, 1px border,
/// regular-17 text). Disabled filled → neutral-200 bg + neutral-400 text.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.leading,
    this.loading = false,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;

  /// Custom leading widget (e.g. an `Image.asset` icon) shown before the label.
  final Widget? leading;
  final bool loading;
  final bool expand;

  static const double _height = 50;
  static const Color _disabledBg = AppColors.border; // neutral200 #E7E5E4
  static const Color _disabledFg = Color(0xFFA8A29E); // neutral400

  @override
  Widget build(BuildContext context) {
    final isOutline = variant == AppButtonVariant.ghost;
    final enabled = onPressed != null && !loading;

    final Color bg;
    final Color fg;
    if (isOutline) {
      bg = Colors.transparent;
      fg = AppColors.text;
    } else if (!enabled) {
      bg = _disabledBg;
      fg = _disabledFg;
    } else {
      bg = switch (variant) {
        AppButtonVariant.success => AppColors.success,
        AppButtonVariant.info => AppColors.info,
        AppButtonVariant.danger => AppColors.danger,
        _ => AppColors.primary,
      };
      fg = Colors.white;
    }

    final textStyle = isOutline
        ? AppTextStyles.regular(17, color: fg)
        : AppTextStyles.semibold(17, color: fg);

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Container(
          height: _height,
          width: expand ? double.infinity : null,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: isOutline ? Border.all(color: AppColors.border) : null,
          ),
          child: Row(
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (loading) ...[
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(fg),
                  ),
                ),
                const SizedBox(width: 8),
              ] else if (leading != null) ...[
                leading!,
                const SizedBox(width: 16),
              ] else if (icon != null) ...[
                Icon(icon, size: 18, color: fg),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(label,
                    style: textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
