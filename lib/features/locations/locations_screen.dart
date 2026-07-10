import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../../core/network/dio_client.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/async_view.dart';
import 'address_picker_chrome.dart';

/// A province/district/ward entry. Ids are kept as STRINGS because the backend
/// uses zero-padded codes (e.g. city_id "01") that must round-trip exactly.
class LocationItem {
  const LocationItem({
    required this.id,
    required this.name,
    this.hasChild = true,
    this.lat,
    this.lng,
    this.slug,
  });
  final String id;
  final String name;
  final bool hasChild;
  final double? lat;
  final double? lng;

  /// URL slug (e.g. "quan-dong-da") — used for the search `locations_slug`
  /// filter, which is what the backend filters districts by.
  final String? slug;

  factory LocationItem.fromJson(Map d) {
    final id = (d['id'] ??
            d['city_id'] ??
            d['district_id'] ??
            d['ward_id'] ??
            d['code'] ??
            '')
        .toString();
    final name = (d['name'] ??
            d['title'] ??
            d['full_name'] ??
            d['n_name'] ??
            d['city'] ??
            '')
        .toString();
    double? toD(Object? v) => v == null ? null : double.tryParse(v.toString());
    return LocationItem(
      id: id,
      name: name,
      hasChild: d['has_child'] == null
          ? true
          : (d['has_child'] == true || d['has_child'] == 1),
      lat: toD(d['lat'] ?? d['latitude']),
      lng: toD(d['long'] ?? d['lng'] ?? d['longitude']),
      slug: (d['slug'] ?? d['n_slug'])?.toString(),
    );
  }
}

/// Result returned by [LocationsScreen] (any tier may be null below city).
class LocationSelection {
  const LocationSelection({
    required this.cityId,
    required this.cityName,
    this.districtId,
    this.districtName,
    this.wardId,
    this.wardName,
    this.cityLat,
    this.cityLng,
    this.districtLat,
    this.districtLng,
  });

  final String cityId;
  final String cityName;
  final String? districtId;
  final String? districtName;
  final String? wardId;
  final String? wardName;
  final double? cityLat;
  final double? cityLng;
  final double? districtLat;
  final double? districtLng;

  /// "Ward, District, City" trimmed to the deepest chosen level.
  String get label {
    final parts = [wardName, districtName, cityName]
        .where((e) => e != null && e.trim().isNotEmpty)
        .map((e) => e!)
        .toList();
    return parts.join(', ');
  }
}

/// A cascade step: which administrative level + the parent id to expand.
/// step 0 = provinces (no parent), 1 = districts of city, 2 = wards of district.
class LocationQuery {
  const LocationQuery(this.step, this.parentId);
  final int step;
  final String? parentId;

  @override
  bool operator ==(Object other) =>
      other is LocationQuery && other.step == step && other.parentId == parentId;
  @override
  int get hashCode => Object.hash(step, parentId);
}

/// Fetches one level from `/api_agent/locations.json` (matches v1 app):
/// provinces use layer 0; districts of a city use `id=cityId&layer=1`;
/// wards of a district use `id=districtId&layer=2`. `grant=1` keeps cascading.
final locationChildrenProvider = FutureProvider.autoDispose
    .family<List<LocationItem>, LocationQuery>((ref, q) async {
  final Dio dio = ref.watch(dioProvider);
  final Response res;
  if (q.step == 0) {
    // Provinces/cities come from a dedicated endpoint in the v1 app.
    res = await dio.get('${AppConfig.public}/cities', queryParameters: {'limit': 100});
  } else {
    res = await dio.get(
      '${AppConfig.agent}/locations.json',
      queryParameters: {'id': q.parentId ?? '', 'layer': q.step, 'grant': 1},
    );
  }
  final data = res.data;
  final List raw = data is Map
      ? (data['data'] ?? data['items'] ?? data['locations'] ?? []) as List
      : (data is List ? data : const []);
  return raw.whereType<Map>().map(LocationItem.fromJson).toList();
});

/// Shows the cascading Tỉnh → Huyện → Xã picker as a v1-style bottom sheet
/// (rounded top, ~92% height). Returns the chosen [LocationSelection] or null.
Future<LocationSelection?> showLocationPickerSheet(BuildContext context) {
  return showModalBottomSheet<LocationSelection>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: const LocationsScreen(asSheet: true),
      ),
    ),
  );
}

/// Cascading Tỉnh → Huyện → Xã picker (v1 `AddressPickerSheet` styling): orange
/// gradient header, a vertical numbered step indicator, a search box and a plain
/// row list. Returns a [LocationSelection]. Prefer [showLocationPickerSheet].
class LocationsScreen extends ConsumerStatefulWidget {
  const LocationsScreen({super.key, this.asSheet = false});

  /// When true the gradient header drops the status-bar inset (the sheet does
  /// not sit under the status bar).
  final bool asSheet;

  @override
  ConsumerState<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends ConsumerState<LocationsScreen> {
  int _step = 0; // 0=city, 1=district, 2=ward
  String _query = '';

  LocationItem? _city;
  LocationItem? _district;

  LocationQuery get _locQuery => switch (_step) {
        0 => const LocationQuery(0, null),
        1 => LocationQuery(1, _city?.id),
        _ => LocationQuery(2, _district?.id),
      };

  void _select(LocationItem item) {
    if (_step == 0) {
      _city = item;
      if (item.hasChild) {
        setState(() {
          _step = 1;
          _query = '';
        });
        return;
      }
      _finish();
    } else if (_step == 1) {
      _district = item;
      if (item.hasChild) {
        setState(() {
          _step = 2;
          _query = '';
        });
        return;
      }
      _finish();
    } else {
      _finish(ward: item);
    }
  }

  /// Header back: step up one level (clearing that level's picked value), or
  /// pop the screen from the first step — mirrors v1.
  void _back() {
    if (_step == 0) {
      Navigator.pop(context);
      return;
    }
    setState(() {
      if (_step == 2) {
        _step = 1;
        _district = null;
      } else {
        _step = 0;
        _city = null;
      }
      _query = '';
    });
  }

  void _finish({LocationItem? ward}) {
    Navigator.pop(
      context,
      LocationSelection(
        cityId: _city!.id,
        cityName: _city!.name,
        districtId: _district?.id,
        districtName: _district?.name,
        wardId: ward?.id,
        wardName: ward?.name,
        cityLat: _city!.lat,
        cityLng: _city!.lng,
        districtLat: _district?.lat,
        districtLng: _district?.lng,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final children = ref.watch(locationChildrenProvider(_locQuery));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          AddressGradientHeader(onBack: _back, asSheet: widget.asSheet),
          AddressStepIndicator(
            activeIndex: _step,
            steps: [
              AddressStep(_city?.name ?? 'Chọn tỉnh/thành phố',
                  done: _city != null),
              if (_step >= 1)
                AddressStep(_district?.name ?? 'Chọn quận/huyện',
                    done: _district != null),
              if (_step >= 2)
                const AddressStep('Chọn phường/xã'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) => setState(() => _query = v.toLowerCase()),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: AppColors.neutral400),
                hintText: 'Tìm kiếm',
                hintStyle: AppTextStyles.regular(15, color: AppColors.neutral400),
                filled: true,
                fillColor: const Color(0xFFF2F5F7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: AsyncView<List<LocationItem>>(
              value: children,
              onRetry: () =>
                  ref.invalidate(locationChildrenProvider(_locQuery)),
              data: (list) {
                final filtered = _query.isEmpty
                    ? list
                    : list
                        .where((e) => e.name.toLowerCase().contains(_query))
                        .toList();
                if (filtered.isEmpty) {
                  return Center(
                    child: Text('Không tìm thấy',
                        style: AppTextStyles.regular(15,
                            color: AppColors.neutral500)),
                  );
                }
                final selectedName = switch (_step) {
                  0 => _city?.name,
                  1 => _district?.name,
                  _ => null,
                };
                return ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  itemBuilder: (_, i) {
                    final p = filtered[i];
                    final selected = selectedName != null && selectedName == p.name;
                    return ListTile(
                      title: Text(p.name, style: AppTextStyles.regular(15)),
                      trailing: selected
                          ? const Icon(Icons.check, color: AppColors.primary)
                          : null,
                      onTap: () => _select(p),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
