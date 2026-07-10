import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography scale from the design system.
///
/// Font family is "SF Pro Text" (bundled ttf, weights 400/500/600/700) so v2
/// renders identical to v1 on both platforms. `letterSpacing: -0.4` matches v1.
class AppTypography {
  AppTypography._();

  static const String fontFamily = 'SF Pro Text';

  static const TextStyle display = TextStyle(
    fontFamily: fontFamily,
    letterSpacing: -0.4,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
  );

  static const TextStyle heading = TextStyle(
    fontFamily: fontFamily,
    letterSpacing: -0.4,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    letterSpacing: -0.4,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    letterSpacing: -0.4,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.text,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: fontFamily,
    letterSpacing: -0.4,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    letterSpacing: -0.4,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMute,
  );

  static const TextStyle micro = TextStyle(
    fontFamily: fontFamily,
    letterSpacing: -0.4,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textMute,
  );
}
