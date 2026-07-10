import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// Reject-reason banner shown on a rejected listing. Mirrors v1's red box.
class DetailRejectBanner extends StatelessWidget {
  const DetailRejectBanner({super.key, required this.reason});
  final String reason;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFDECEC),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          'Từ chối: $reason',
          style: AppTextStyles.semibold(15, color: AppColors.danger),
        ),
      ),
    );
  }
}
