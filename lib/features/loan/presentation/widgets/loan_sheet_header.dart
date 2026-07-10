import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Shared bottom-sheet title bar with a close button (v1 SheetHeader).
class LoanSheetHeader extends StatelessWidget {
  const LoanSheetHeader(this.title, {super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 19),
          width: double.infinity,
          child: Text(
            title,
            style: AppTypography.title.copyWith(color: AppColors.text),
          ),
        ),
        const Positioned(right: 8, child: CloseButton(color: AppColors.text)),
      ],
    );
  }
}
