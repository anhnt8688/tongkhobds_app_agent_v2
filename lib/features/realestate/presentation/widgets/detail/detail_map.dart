import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// Static map preview centered on the listing's coordinates.
class DetailMap extends StatelessWidget {
  const DetailMap({super.key, required this.lat, required this.lng});
  final double lat;
  final double lng;

  @override
  Widget build(BuildContext context) {
    final pos = LatLng(lat, lng);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Vị trí trên bản đồ', style: AppTextStyles.semibold(20)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            child: SizedBox(
              height: 180,
              child: AbsorbPointer(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(target: pos, zoom: 15),
                  markers: {
                    Marker(markerId: const MarkerId('listing'), position: pos),
                  },
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text('$lat, $lng',
              style: AppTextStyles.regular(11, color: AppColors.textMute)),
        ],
      ),
    );
  }
}
