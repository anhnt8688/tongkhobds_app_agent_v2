import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../config/app_config.dart';
import '../network/dio_client.dart';
import 'location_cache.dart';

/// Detects the device's current location once, resolves it to an administrative
/// area via the backend, and caches the result. Mirrors the v1 splash flow.
class LocationService {
  LocationService(this._ref);

  final Ref _ref;

  /// Requests permission (if needed) and returns a position, or null if denied
  /// / unavailable. Prefers the last known fix for speed, falls back to a live
  /// read with a short timeout.
  static Future<Position?> initLocationOnce() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      if (permission == LocationPermission.deniedForever) return null;

      final last = await Geolocator.getLastKnownPosition();
      if (last != null) return last;

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (_) {
      return null;
    }
  }

  /// Full startup flow: skip if a fresh cache exists, otherwise get a position,
  /// reverse-geocode it, ask the backend which province/district it maps to,
  /// and cache the slug + city. Fully guarded — never throws.
  Future<void> detectAndCache() async {
    final cache = _ref.read(locationCacheProvider);
    final existing = cache.current ?? await cache.load();
    if (existing?.isFresh() == true) {
      // Publish the cached value so watchers pick it up immediately.
      _ref.read(detectedLocationProvider.notifier).state = existing;
      return;
    }

    final pos = await initLocationOnce()
        .timeout(const Duration(seconds: 30), onTimeout: () => null);
    if (pos == null) return;

    final address = await _reverseGeocode(pos.latitude, pos.longitude);
    try {
      final dio = _ref.read(dioProvider);
      final res = await dio.get(
        '${AppConfig.public}/location_searching_by_province.json',
        queryParameters: {
          if (address != null && address.isNotEmpty) 'text': address,
          'lat': pos.latitude.toStringAsFixed(6),
          'lng': pos.longitude.toStringAsFixed(6),
        },
      ).timeout(const Duration(seconds: 5));

      // EnvelopeInterceptor unwraps to the inner data: {total, result, ...}.
      final data = res.data;
      final result = data is Map ? data['result'] : null;
      if (result is! Map) return;
      final slug = (result['slug'] ?? '').toString();
      final cityId = (result['city_id'] ?? '').toString();
      if (slug.isEmpty || cityId.isEmpty) return;

      final loc = CachedLocation(
        slug: slug,
        cityId: cityId,
        cityName: (result['city_name'] ?? '').toString(),
        districtName: (result['district_name'] ?? result['name'])?.toString(),
        lat: pos.latitude,
        lng: pos.longitude,
        resolvedAt: DateTime.now(),
      );
      await cache.save(loc);
      // Notify watchers (Bảng hàng / Home / Bản đồ) so they apply it live.
      _ref.read(detectedLocationProvider.notifier).state = loc;
    } catch (_) {
      // Network/parse failure — leave cache untouched, try again next launch.
    }
  }

  Future<String?> _reverseGeocode(double lat, double lng) async {
    try {
      await setLocaleIdentifier('vi_VN');
      final list = await placemarkFromCoordinates(lat, lng)
          .timeout(const Duration(seconds: 4));
      if (list.isEmpty) return null;
      final p = list.first;
      final parts = [
        p.street,
        p.subLocality,
        p.locality,
        p.administrativeArea,
        p.country,
      ].whereType<String>().where((s) => s.trim().isNotEmpty).toList();
      return parts.isEmpty ? null : parts.join(', ');
    } catch (_) {
      return null;
    }
  }
}

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService(ref);
});
