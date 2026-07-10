import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../data/models/consultation_activity.dart';

/// "BĐS quan tâm" info card. Tapping it toggles the inline "công việc của BĐS"
/// panel below; [expanded] drives the chevron state.
class DemandInterestTile extends StatelessWidget {
  const DemandInterestTile({
    super.key,
    required this.item,
    this.onTap,
    this.expanded = false,
  });

  final ConsultationInterest item;
  final VoidCallback? onTap;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final p = item;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      child: Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppNetworkImage(
            url: p.image,
            width: 56,
            height: 56,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((p.code ?? '').isNotEmpty)
                  Text(p.code!,
                      style: AppTypography.micro.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700)),
                Text(p.title ?? 'BĐS',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.subtitle
                        .copyWith(fontWeight: FontWeight.w600)),
                if ((p.address ?? '').isNotEmpty)
                  Text(p.address!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption
                          .copyWith(color: AppColors.textMute)),
                const SizedBox(height: 2),
                Text(_priceText(p.price, p.area),
                    style: AppTypography.caption.copyWith(
                        color: AppColors.primary, fontWeight: FontWeight.w700)),
                if ((p.agentName ?? '').isNotEmpty)
                  Text('Đầu chủ: ${p.agentName}',
                      style: AppTypography.micro
                          .copyWith(color: AppColors.textMute)),
                if ((p.status ?? '').isNotEmpty)
                  Text(p.status!,
                      style: AppTypography.micro
                          .copyWith(color: AppColors.textMute)),
              ],
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: 4),
            Icon(expanded ? Icons.expand_less : Icons.expand_more,
                size: 22, color: AppColors.textMute),
          ],
        ],
      ),
    ),
    );
  }

  String _priceText(double? price, num? area) {
    String p = '';
    if (price != null) {
      if (price >= 1e9) {
        final b = price / 1e9;
        p = '${b == b.roundToDouble() ? b.toInt() : b.toStringAsFixed(1)} tỷ';
      } else if (price >= 1e6) {
        p = '${(price / 1e6).toStringAsFixed(0)} triệu';
      } else {
        p = price.toStringAsFixed(0);
      }
    }
    final a = area != null
        ? '${area == area.roundToDouble() ? area.toInt() : area} m²'
        : '';
    return [p, a].where((e) => e.isNotEmpty).join(' · ');
  }
}
