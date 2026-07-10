import 'package:flutter/material.dart';

import 'app_colors.dart';

/// v1-parity text styles (ported from v1 `AppTextStyles`). Same base:
/// SF Pro Text, `letterSpacing: -0.4`, default color neutral800 (#292524).
///
/// v1 exposed `semibold15()`, `bold28()`, etc. Here the size is a parameter to
/// stay DRY — e.g. `AppTextStyles.semibold(15)`, `AppTextStyles.bold(28)`.
/// Weights map to v1: regular→w400, medium→w500, semibold→w600, bold→w700.
class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'SF Pro Text';

  static const TextStyle _base = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.text,
    letterSpacing: -0.4,
  );

  static TextStyle _s(double size, FontWeight weight, Color? color) =>
      _base.copyWith(fontSize: size, fontWeight: weight, color: color);

  static TextStyle regular(double size, {Color? color}) =>
      _s(size, FontWeight.w400, color);
  static TextStyle medium(double size, {Color? color}) =>
      _s(size, FontWeight.w500, color);
  static TextStyle semibold(double size, {Color? color}) =>
      _s(size, FontWeight.w600, color);
  static TextStyle bold(double size, {Color? color}) =>
      _s(size, FontWeight.w700, color);
}
