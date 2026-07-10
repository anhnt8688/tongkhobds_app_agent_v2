import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/property_detail.dart';

/// Description block (mirrors v1 `_description`): title (+ status badge),
/// address + time, price line, then bedroom/bathroom/area info chips. Styles
/// ported 1:1 from v1 (`AppTextStyles`, PNG icons).
class DetailHead extends StatelessWidget {
  const DetailHead({super.key, required this.detail});
  final PropertyDetail detail;

  @override
  Widget build(BuildContext context) {
    final d = detail;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/location_icon.png',
                  width: 16, height: 16),
              const SizedBox(width: 4),
              Expanded(child: Text(d.address, style: AppTextStyles.regular(15))),
              if (d.timeAgo != null && d.timeAgo!.isNotEmpty) ...[
                const SizedBox(width: 8),
                Text(d.timeAgo!,
                    style:
                        AppTextStyles.regular(13, color: AppColors.textMute)),
              ],
            ],
          ),
          const SizedBox(height: 16),
          _priceLine(),
          if (_chips().isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(spacing: 16, runSpacing: 8, children: _chips()),
          ],
        ],
      ),
    );
  }

  Widget _title() {
    final label = detail.statusActivityLabel;
    if (label == null || label.isEmpty) {
      return Text(detail.title, style: AppTextStyles.semibold(20));
    }
    return Text.rich(
      TextSpan(
        style: AppTextStyles.semibold(20),
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.success,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(label,
                  style: AppTextStyles.semibold(13, color: Colors.white)),
            ),
          ),
          TextSpan(text: detail.title),
        ],
      ),
    );
  }

  Widget _priceLine() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: detail.priceText,
            style: AppTextStyles.semibold(20, color: AppColors.price),
          ),
          if (detail.areaDisplay.isNotEmpty)
            TextSpan(
              text: '    ${detail.areaDisplay}',
              style: AppTextStyles.semibold(16, color: AppColors.price),
            ),
          if (detail.pricePerMeter != null && detail.pricePerMeter!.isNotEmpty)
            TextSpan(
              text: '    ${detail.pricePerMeter}',
              style: AppTextStyles.semibold(16, color: AppColors.price),
            ),
        ],
      ),
    );
  }

  List<Widget> _chips() {
    final d = detail;
    return <Widget>[
      if (d.bedrooms != null && d.bedrooms! > 0)
        _chip('bed_room_icon', '${d.bedrooms} PN'),
      if (d.bathrooms != null && d.bathrooms! > 0)
        _chip('bad_room_icon', '${d.bathrooms} WC'),
      if (d.area != null) _chip('area_icon', '${d.area!.toInt()}m²'),
    ];
  }

  Widget _chip(String icon, String label) => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.neutral200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/$icon.png', width: 16, height: 16),
            const SizedBox(width: 2),
            Text(label,
                style:
                    AppTextStyles.semibold(15, color: AppColors.textSecondary)),
          ],
        ),
      );
}
