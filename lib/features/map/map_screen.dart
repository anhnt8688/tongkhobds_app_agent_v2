import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/location/location_cache.dart';
import '../../core/location/location_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_toast.dart';
import '../../core/widgets/custom_screen.dart';
import '../locations/locations_screen.dart';
import 'data/map_api.dart';
import 'widgets/map_project_sheet.dart';
import 'widgets/map_sheet_widgets.dart';

/// BĐS trên bản đồ (Google Maps) — markers giá theo viewport, tap mở xem nhanh.
/// Mirrors v1 RealEstateMapPage.
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key, this.initialLat, this.initialLng});
  final double? initialLat;
  final double? initialLng;

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  static const _defaultCenter = LatLng(10.770622, 106.670172); // HCM

  GoogleMapController? _map;
  final _markers = <Marker>{};
  final _iconCache = <String, BitmapDescriptor>{};
  bool _loading = false;

  LatLng? _lastCenter;
  Timer? _debounce;

  LatLng get _initialCenter {
    if (widget.initialLat != null && widget.initialLng != null) {
      return LatLng(widget.initialLat!, widget.initialLng!);
    }
    // Fall back to the location detected at startup, then HCM.
    final c = ref.read(detectedLocationProvider) ??
        ref.read(locationCacheProvider).current;
    if (c?.lat != null && c?.lng != null) {
      return LatLng(c!.lat!, c.lng!);
    }
    return _defaultCenter;
  }

  /// Centers the map on the device's current position (live read).
  Future<void> _recenterToMe() async {
    final pos = await LocationService.initLocationOnce();
    if (pos == null || _map == null) return;
    await _map!.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(pos.latitude, pos.longitude), 15),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _map?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController c) {
    _map = c;
    _scheduleFetch();
  }

  void _onCameraMove(CameraPosition p) {
    _lastCenter = p.target;
  }

  void _scheduleFetch() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), _fetchMarkers);
  }

  Future<void> _fetchMarkers() async {
    if (_map == null) return;
    final center = _lastCenter ?? _initialCenter;
    if (mounted) setState(() => _loading = true);
    try {
      final bounds = await _map!.getVisibleRegion();
      final radius = _radiusKm(center, bounds);
      final api = ref.read(mapApiProvider);
      final results = await Future.wait([
        api.fetchMap(
            lat: center.latitude,
            lng: center.longitude,
            radiusKm: radius,
            limit: 50),
        api.fetchMap(
            lat: center.latitude,
            lng: center.longitude,
            radiusKm: radius,
            limit: 50,
            transactionType: 3),
      ]);
      final normal = await _buildMarkers(results[0], isProject: false);
      final projects = await _buildMarkers(results[1], isProject: true);
      if (!mounted) return;
      setState(() {
        _markers
          ..clear()
          ..addAll(normal)
          ..addAll(projects);
      });
    } catch (_) {
      // Silent: panning produces frequent fetches; ignore transient errors.
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  double _radiusKm(LatLng center, LatLngBounds bounds) {
    final ne = bounds.northeast;
    final d = _haversineKm(
        center.latitude, center.longitude, ne.latitude, ne.longitude);
    if (d.isNaN || d.isInfinite) return 5;
    return max(1, min(d, 50));
  }

  double _haversineKm(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0;
    double rad(double d) => d * pi / 180.0;
    final dLat = rad(lat2 - lat1);
    final dLon = rad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(rad(lat1)) * cos(rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    return r * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  Future<Set<Marker>> _buildMarkers(
    List<RealEstateMapItem> items, {
    required bool isProject,
  }) async {
    final valid = items.where((e) => e.hasLatLng).toList();
    final out = <Marker>{};
    for (final item in valid) {
      final label = isProject
          ? '${item.realEstateCount} tin'
          : (item.priceDescription.isNotEmpty ? item.priceDescription : '—');
      final icon = await _labelIcon(
          label, isProject ? const Color(0xFF2563EB) : const Color(0xFF2B2B2B));
      out.add(Marker(
        markerId: MarkerId('${isProject ? 'p' : 're'}_${item.id}'),
        position: LatLng(item.lat, item.lng),
        icon: icon,
        onTap: () =>
            isProject ? _openProject(item) : _openPropertyPreview(item),
      ));
    }
    return out;
  }

  /// Renders a rounded price-pill bitmap for a marker (ported from v1).
  Future<BitmapDescriptor> _labelIcon(String text, Color color) async {
    final key = '${color.toARGB32()}|$text';
    final cached = _iconCache[key];
    if (cached != null) return cached;

    const padX = 10.0, padY = 6.0, radius = 12.0;
    final tp = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: text,
        style: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
      ),
    )..layout();

    final w = tp.width + padX * 2;
    final h = tp.height + padY * 2;
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder)..scale(dpr, dpr);
    final paint = Paint()..color = color.withValues(alpha: 0.92);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, w, h), const Radius.circular(radius)),
      paint,
    );
    tp.paint(canvas, const Offset(padX, padY));
    final image =
        await recorder.endRecording().toImage((w * dpr).ceil(), (h * dpr).ceil());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    // imagePixelRatio tells Maps the bitmap is rendered at `dpr` scale, so it
    // draws the marker at its logical size instead of dpr× too large.
    final desc = BitmapDescriptor.bytes(
      bytes!.buffer.asUint8List(),
      imagePixelRatio: dpr,
    );
    _iconCache[key] = desc;
    return desc;
  }

  Future<void> _openPropertyPreview(RealEstateMapItem item) async {
    try {
      final detail = await ref.read(mapApiProvider).propertyDetail(item.id);
      if (!mounted) return;
      if (detail == null) {
        AppToast.info(context, 'Không tìm thấy thông tin BĐS');
        return;
      }
      showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => _PreviewSheet(
          detail: detail,
          onDetail: () {
            Navigator.pop(context);
            context.push('/property/${item.id}');
          },
        ),
      );
    } catch (_) {
      if (mounted) AppToast.error(context, 'Không tải được BĐS');
    }
  }

  void _openProject(RealEstateMapItem item) {
    if (item.projectCode.isEmpty) {
      AppToast.info(context, 'Không tìm thấy mã dự án');
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => MapProjectSheet(
        projectId: item.id,
        projectCode: item.projectCode,
        onItemTap: (id) {
          Navigator.pop(context);
          context.push('/property/$id');
        },
        onProjectDetail: () {
          Navigator.pop(context);
          context.push(
              '/project-detail/${Uri.encodeComponent(item.projectCode)}');
        },
      ),
    );
  }

  Future<void> _search() async {
    final sel = await showLocationPickerSheet(context);
    if (sel == null || _map == null) return;
    final lat = sel.districtLat ?? sel.cityLat;
    final lng = sel.districtLng ?? sel.cityLng;
    if (lat != null && lng != null) {
      await _map!.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14));
    } else if (mounted) {
      AppToast.info(context, 'Khu vực chưa có toạ độ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'Bản đồ BĐS',
      action: IconButton(
        onPressed: _search,
        icon: const Icon(Icons.search),
        tooltip: 'Tìm khu vực',
      ),
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: _initialCenter, zoom: 14),
            onMapCreated: _onMapCreated,
            onCameraMove: _onCameraMove,
            onCameraIdle: _scheduleFetch,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: true,
            zoomControlsEnabled: false,
          ),
          if (_loading)
            const Positioned(right: 16, top: 16, child: _LoadingPill()),
          Positioned(
            right: 16,
            bottom: 24,
            child: FloatingActionButton.small(
              heroTag: 'map_my_location',
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              onPressed: _recenterToMe,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingPill extends StatelessWidget {
  const _LoadingPill();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: AppColors.primary)),
          const SizedBox(width: 8),
          Text('Đang tải', style: AppTypography.caption),
        ],
      ),
    );
  }
}

/// "Xem nhanh BĐS" sheet — 1:1 with v1 `MapPropertyPreviewSheet`.
class _PreviewSheet extends StatelessWidget {
  const _PreviewSheet({required this.detail, required this.onDetail});
  final PropertyMapDetail detail;
  final VoidCallback onDetail;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MapSheetHeader('Xem nhanh BĐS'),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MapProductItem(
                  imageUrl: detail.image,
                  title: detail.title,
                  price: detail.priceDescription,
                  area: detail.area,
                  bedrooms: detail.bedrooms,
                  bathrooms: detail.bathrooms,
                ),
                const SizedBox(height: 16),
                AppButton(label: 'Xem chi tiết', onPressed: onDetail),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
