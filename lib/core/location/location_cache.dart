import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// The user's current location resolved to an administrative area, cached so we
/// don't re-prompt / re-geocode on every launch.
class CachedLocation {
  const CachedLocation({
    required this.slug,
    required this.cityId,
    required this.cityName,
    this.districtName,
    this.lat,
    this.lng,
    this.resolvedAt,
  });

  /// District slug for the `locations_slug` search filter (e.g. "quan-1").
  final String slug;
  final String cityId;
  final String cityName;
  final String? districtName;
  final double? lat;
  final double? lng;
  final DateTime? resolvedAt;

  bool isFresh({Duration ttl = const Duration(hours: 24)}) {
    if (slug.isEmpty || cityId.isEmpty) return false;
    final at = resolvedAt;
    if (at == null) return false;
    return DateTime.now().difference(at) < ttl;
  }

  Map<String, dynamic> toJson() => {
        'slug': slug,
        'city_id': cityId,
        'city_name': cityName,
        'district_name': districtName,
        'lat': lat,
        'lng': lng,
        'resolved_at': resolvedAt?.millisecondsSinceEpoch,
      };

  factory CachedLocation.fromJson(Map<String, dynamic> j) => CachedLocation(
        slug: (j['slug'] ?? '').toString(),
        cityId: (j['city_id'] ?? '').toString(),
        cityName: (j['city_name'] ?? '').toString(),
        districtName: j['district_name']?.toString(),
        lat: (j['lat'] as num?)?.toDouble(),
        lng: (j['lng'] as num?)?.toDouble(),
        resolvedAt: j['resolved_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(j['resolved_at'] as int),
      );
}

/// Persists [CachedLocation] in secure storage (one JSON blob).
class LocationCache {
  LocationCache(this._storage);

  static const _key = 'detected_location';
  final FlutterSecureStorage _storage;

  CachedLocation? _cached;

  /// In-memory value (valid after [load]); lets synchronous callers read it.
  CachedLocation? get current => _cached;

  Future<CachedLocation?> load() async {
    final raw = await _storage.read(key: _key);
    if (raw == null || raw.isEmpty) return null;
    try {
      _cached = CachedLocation.fromJson(
          json.decode(raw) as Map<String, dynamic>);
    } catch (_) {
      _cached = null;
    }
    return _cached;
  }

  Future<void> save(CachedLocation loc) async {
    _cached = loc;
    await _storage.write(key: _key, value: json.encode(loc.toJson()));
  }
}

final locationCacheProvider = Provider<LocationCache>((ref) {
  return LocationCache(const FlutterSecureStorage());
});

/// Reactive current location: null until resolved (from cache or fresh GPS).
/// Watched by Bảng hàng + Home so they update the moment detection completes,
/// instead of reading a one-shot snapshot that races with startup.
final detectedLocationProvider = StateProvider<CachedLocation?>((ref) => null);
