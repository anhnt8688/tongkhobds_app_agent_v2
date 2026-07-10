import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/sell_lead.dart';

/// THẺ GẮN card: chips + "Quản lý" button that opens the tag picker.
class SellTagsCard extends StatelessWidget {
  const SellTagsCard({super.key, required this.tags, required this.onManage});
  final List<SellTag> tags;
  final VoidCallback? onManage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('THẺ GẮN',
              style: AppTypography.micro.copyWith(
                  color: AppColors.textMute, fontWeight: FontWeight.w700)),
          const Spacer(),
          if (onManage != null)
            GestureDetector(
              onTap: onManage,
              child: Text('Quản lý',
                  style: AppTypography.caption.copyWith(
                      color: AppColors.primary, fontWeight: FontWeight.w600)),
            ),
        ]),
        const SizedBox(height: 10),
        if (tags.isEmpty)
          Text('Chưa gắn thẻ nào',
              style: AppTypography.caption.copyWith(color: AppColors.textMute))
        else
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final t in tags) _chip(t),
          ]),
      ]),
    );
  }

  Widget _chip(SellTag t) {
    final c = AppColors.fromHex(t.color, fallback: AppColors.primary);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Text(t.name,
          style: AppTypography.caption
              .copyWith(color: c, fontWeight: FontWeight.w600)),
    );
  }
}
