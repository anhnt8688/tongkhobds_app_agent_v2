import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

enum StatusTone { amber, blue, green, red, neutral }

/// Rounded status pill (radius 999) used for transaction/contract states.
class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.label, this.tone = StatusTone.neutral});

  final String label;
  final StatusTone tone;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (tone) {
      StatusTone.amber => (AppColors.amberBg, AppColors.amberFg),
      StatusTone.blue => (AppColors.blueBg, AppColors.blueFg),
      StatusTone.green => (AppColors.greenBg, AppColors.greenFg),
      StatusTone.red => (AppColors.redBg, AppColors.redFg),
      StatusTone.neutral => (const Color(0xFFF5F5F4), AppColors.textSecondary),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Text(
        label,
        style: AppTypography.micro.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
