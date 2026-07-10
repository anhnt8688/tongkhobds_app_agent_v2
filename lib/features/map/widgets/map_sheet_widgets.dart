import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_network_image.dart';

/// Shared bottom-sheet building blocks for the map, ported 1:1 from v1
/// (`SheetHeader`, `_MapProductItem`, `_InfoIcon`).

/// Centered sheet title with a bottom divider (v1 `SheetHeader`, 64px tall).
class MapSheetHeader extends StatelessWidget {
  const MapSheetHeader(this.title, {super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF292524)),
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
          ),
        ],
      ),
    );
  }
}

/// A listing row used inside the map sheets — 150×150 image, title, price, and
/// the bed / bath / area icon row (v1 `_MapProductItem`).
class MapProductItem extends StatelessWidget {
  const MapProductItem({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.area,
    this.bedrooms,
    this.bathrooms,
  });

  final String? imageUrl;
  final String title;
  final String price;
  final String area;
  final int? bedrooms;
  final int? bathrooms;

  bool get _showInfo =>
      (bedrooms != null && bedrooms != 0) ||
      (bathrooms != null && bathrooms != 0) ||
      area.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppNetworkImage(
          url: imageUrl,
          width: 150,
          height: 150,
          borderRadius: BorderRadius.circular(12),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              if (price.isNotEmpty)
                Text(price,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.price),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              if (_showInfo) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (bedrooms != null && bedrooms != 0)
                      _InfoIcon(
                          icon: 'assets/images/bed_room_icon.png',
                          value: '$bedrooms'),
                    if (bathrooms != null && bathrooms != 0)
                      _InfoIcon(
                          icon: 'assets/images/bad_room_icon.png',
                          value: '$bathrooms'),
                    if (area.isNotEmpty)
                      _InfoIcon(
                          icon: 'assets/images/area_icon.png',
                          value: '$area m²'),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoIcon extends StatelessWidget {
  const _InfoIcon({required this.icon, required this.value});
  final String icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        children: [
          Image.asset(icon, width: 16, height: 16),
          const SizedBox(width: 4),
          Text(value,
              style: const TextStyle(fontSize: 15, color: Color(0xFFA8A29E))),
        ],
      ),
    );
  }
}
