import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// A small, non-interactive map preview centred on the listing's coordinates
/// (v1 `GoogleMapPreviewFromAddress`). Renders nothing useful without a
/// lat/lng, so callers should gate on that.
class ListingLocationMap extends StatelessWidget {
  const ListingLocationMap({
    super.key,
    required this.lat,
    required this.lng,
    this.height = 200,
  });

  final double lat;
  final double lng;
  final double height;

  @override
  Widget build(BuildContext context) {
    final target = LatLng(lat, lng);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: height,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(target: target, zoom: 16),
          markers: {
            Marker(markerId: const MarkerId('listing'), position: target),
          },
          liteModeEnabled: true, // static-ish preview (Android)
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          compassEnabled: false,
          mapToolbarEnabled: false,
        ),
      ),
    );
  }
}
