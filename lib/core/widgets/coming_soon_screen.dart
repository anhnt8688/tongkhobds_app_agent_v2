import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'custom_screen.dart';

/// Simple placeholder for screens not yet built (kept clearly labelled so it
/// is never mistaken for real, wired functionality).
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: title,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.construction_rounded,
                size: 56, color: AppColors.textMute),
            const SizedBox(height: 16),
            Text('Đang phát triển', style: AppTypography.title),
            const SizedBox(height: 6),
            Text('Màn "$title" sẽ có ở phiên bản tiếp theo',
                style: AppTypography.subtitle),
          ],
        ),
      ),
    );
  }
}
