import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/property_detail.dart';

/// Commission tiers — orange-tinted cards (icon + title left, rate/description
/// right). Mirrors v1 `rateView`.
class DetailCommission extends StatelessWidget {
  const DetailCommission({super.key, required this.detail});
  final PropertyDetail detail;

  @override
  Widget build(BuildContext context) {
    final rates = detail.commissionRates;
    if (rates.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          for (var i = 0; i < rates.length; i++) ...[
            _card(rates[i]),
            if (i != rates.length - 1) const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  Widget _card(CommissionRate r) {
    final sub = (r.description != null && r.description!.isNotEmpty)
        ? r.description!
        : (r.rate != null ? '${r.rate!.toStringAsFixed(1)}%' : '');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.payments_outlined,
              size: 22, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(r.title ?? 'Hoa hồng',
                style: AppTextStyles.semibold(17)),
          ),
          const SizedBox(width: 8),
          Text(sub,
              style: AppTextStyles.semibold(15, color: AppColors.primary)),
        ],
      ),
    );
  }
}
