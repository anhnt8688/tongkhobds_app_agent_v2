import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../data/models/property.dart';

/// "BĐS của tôi" list item — faithful port of v1 `MyProductItemVertical`:
/// a 135×180 thumbnail beside a column with the activity-label + title, the
/// city / created-date row, the price, the bath/bed/area chips, and the
/// status-info + label + source badges.
class MyListingCard extends StatelessWidget {
  const MyListingCard({super.key, required this.property, this.onTap});

  final Property property;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final p = property;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // v1 `MyProductItemVertical`: square thumbnail (no corner radius).
          AppNetworkImage(
            url: p.image,
            width: 135,
            height: 180,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title(),
                const SizedBox(height: 6),
                if (p.city != null && p.city!.isNotEmpty) _cityRow(),
                const SizedBox(height: 6),
                Text(
                  p.priceDescription ?? p.priceText,
                  style: AppTextStyles.semibold(17, color: AppColors.price),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                _attrChips(),
                const SizedBox(height: 10),
                _badges(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _title() {
    final label = property.statusBadge;
    final titleStyle = AppTextStyles.semibold(15);
    if (label == null) {
      return Text(property.title,
          style: titleStyle, maxLines: 2, overflow: TextOverflow.ellipsis);
    }
    return Text.rich(
      TextSpan(
        style: titleStyle,
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.success,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(label,
                  style: AppTextStyles.semibold(13, color: Colors.white)),
            ),
          ),
          const WidgetSpan(child: SizedBox(width: 6)),
          TextSpan(text: property.title),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _cityRow() {
    final muted = AppTextStyles.regular(15, color: AppColors.neutral400);
    return Row(
      children: [
        Image.asset('assets/images/location_icon.png', width: 16, height: 16),
        const SizedBox(width: 3),
        Expanded(
          child: Text(property.city ?? '',
              style: muted, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        if (property.createdOn != null && property.createdOn!.isNotEmpty) ...[
          const Icon(Icons.date_range, size: 16, color: AppColors.neutral400),
          const SizedBox(width: 3),
          Text(property.createdOn!, style: muted),
        ],
      ],
    );
  }

  Widget _attrChips() {
    final chips = <Widget>[
      if ((property.bathrooms ?? 0) > 1) _chip('${property.bathrooms} PT'),
      if ((property.bedrooms ?? 0) > 1) _chip('${property.bedrooms} PN'),
      if (property.area != null && property.area! > 0)
        _chip('${_trimArea(property.area!)} m²'),
    ];
    return Wrap(spacing: 8, runSpacing: 8, children: chips);
  }

  Widget _badges() {
    final badges = <Widget>[
      if (property.statusName != null && property.statusName!.isNotEmpty)
        _chip(property.statusName!, colorCode: property.statusColor),
      ...property.labels.map(_chip),
      if (property.sourceGet != null && property.sourceGet!.isNotEmpty)
        _chip(property.sourceGet == 'mine' ? 'Tôi đăng' : property.sourceGet!),
    ];
    if (badges.isEmpty) return const SizedBox.shrink();
    return Wrap(spacing: 8, runSpacing: 8, children: badges);
  }

  Widget _chip(String text, {String? colorCode}) {
    final color = colorCode != null ? AppColors.fromHex(colorCode) : null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: color != null
            ? color.withValues(alpha: 0.2)
            : AppColors.border,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: AppTextStyles.semibold(13,
            color: color ?? AppColors.textSecondary),
      ),
    );
  }

  String _trimArea(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();
}
