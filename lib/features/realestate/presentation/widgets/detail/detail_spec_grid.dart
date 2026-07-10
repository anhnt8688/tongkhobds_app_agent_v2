import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/property_detail.dart';

/// "Đặc điểm bất động sản" — a label/value table (icon + label left, value
/// right, thin divider between rows). Mirrors v1 `PropertyFeatures`.
class DetailSpecGrid extends StatelessWidget {
  const DetailSpecGrid({super.key, required this.detail});
  final PropertyDetail detail;

  @override
  Widget build(BuildContext context) {
    final d = detail;
    // (asset name under assets/images/, label, value) — v1 `PropertyFeatures`
    // uses PNG icons per feature type.
    final rows = <(String, String, String)>[
      if (d.priceText.isNotEmpty) ('ic_price', 'Mức giá', d.priceText),
      if (d.areaDisplay.isNotEmpty) ('area_icon', 'Diện tích', d.areaDisplay),
      if (d.pricePerMeter != null && d.pricePerMeter!.isNotEmpty)
        ('ic_price', 'Giá/m²', d.pricePerMeter!),
      if (d.legalStatus != null && d.legalStatus!.isNotEmpty)
        ('ic_paper', 'Giấy tờ pháp lý', d.legalStatus!),
      if (d.bedrooms != null && d.bedrooms! > 0)
        ('bed_room_icon', 'Số phòng ngủ', '${d.bedrooms} phòng'),
      if (d.bathrooms != null && d.bathrooms! > 0)
        ('bad_room_icon', 'Số WC', '${d.bathrooms} phòng'),
      if (d.interior != null && d.interior!.isNotEmpty)
        ('ic_status_interior', 'Tình trạng nội thất', d.interior!),
      if (d.direction != null && d.direction!.isNotEmpty)
        ('area_icon', 'Hướng nhà', d.direction!),
      if (d.balconyDirection != null && d.balconyDirection!.isNotEmpty)
        ('area_icon', 'Hướng ban công', d.balconyDirection!),
      for (final k in d.keyAttributes)
        if (k.title != null && k.title!.isNotEmpty)
          ('ic_paper_bds', k.title!, k.value!),
    ];
    if (rows.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Đặc điểm bất động sản', style: AppTextStyles.semibold(20)),
          const SizedBox(height: 8),
          for (final r in rows) ...[
            _row(r.$1, r.$2, r.$3),
            const Divider(
                height: 0,
                thickness: 0.5,
                indent: 32,
                color: AppColors.border),
          ],
        ],
      ),
    );
  }

  Widget _row(String asset, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/images/$asset.png', width: 24, height: 24),
            const SizedBox(width: 8),
            Text(label, style: AppTextStyles.regular(15)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(value,
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.semibold(15)),
            ),
          ],
        ),
      );
}
