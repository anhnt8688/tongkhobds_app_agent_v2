import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/async_view.dart';
import '../../locations/address_picker_chrome.dart';
import '../../locations/locations_screen.dart';

/// Shows the search location picker as a v1-style bottom sheet (rounded top,
/// ~92% height). Returns the chosen [SearchLocationResult] or null.
Future<SearchLocationResult?> showSearchLocationSheet(
  BuildContext context, {
  SearchLocationArgs? args,
}) {
  return showModalBottomSheet<SearchLocationResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: SearchLocationScreen(args: args, asSheet: true),
      ),
    ),
  );
}

/// Result of the Bảng hàng location picker: a city plus the chosen districts.
class SearchLocationResult {
  const SearchLocationResult({
    required this.cityId,
    required this.cityName,
    this.districtSlugs = const [],
    this.districtLabel,
    this.focusLat,
    this.focusLng,
  });

  final String cityId;
  final String cityName;
  final List<String> districtSlugs;
  final String? districtLabel;

  /// Map-focus coordinates: first selected district, else the city. Mirrors v1's
  /// "Bản đồ" button which focuses the chosen area.
  final double? focusLat;
  final double? focusLng;
}

/// 2-level location picker for search: pick a Tỉnh/Thành, then multi-select
/// Quận/Huyện. The backend filters listings by district slug (`locations_slug`),
/// so this captures slugs rather than ids. Matches the v1 search flow.
class SearchLocationScreen extends ConsumerStatefulWidget {
  const SearchLocationScreen({super.key, this.args, this.asSheet = false});

  /// Current selection — when a city is given, the picker opens straight on its
  /// district list with the selected districts pre-ticked (e.g. jumping to the
  /// detected location instead of the province list).
  final SearchLocationArgs? args;

  /// Presented inside a bottom sheet → drop the status-bar inset on the header.
  final bool asSheet;

  @override
  ConsumerState<SearchLocationScreen> createState() =>
      _SearchLocationScreenState();
}

/// Inbound args for [SearchLocationScreen] (passed via go_router `extra`).
class SearchLocationArgs {
  const SearchLocationArgs({
    this.cityId,
    this.cityName,
    this.slugs = const [],
  });
  final String? cityId;
  final String? cityName;
  final List<String> slugs;
}

class _SearchLocationScreenState extends ConsumerState<SearchLocationScreen> {
  LocationItem? _city; // null → city step; set → district step
  String _query = '';
  final _pickedSlugs = <String>{}; // selected district slugs
  final _pickedItems = <String, LocationItem>{}; // slug → item (for labels)

  @override
  void initState() {
    super.initState();
    final a = widget.args;
    // Jump straight to the district step of the current/detected city.
    if (a?.cityId != null && a!.cityId!.isNotEmpty) {
      _city = LocationItem(id: a.cityId!, name: a.cityName ?? '');
      _pickedSlugs.addAll(a.slugs);
    }
  }

  LocationQuery get _locQuery => _city == null
      ? const LocationQuery(0, null)
      : LocationQuery(1, _city!.id);

  void _pickCity(LocationItem city) {
    setState(() {
      _city = city;
      _query = '';
      _pickedSlugs.clear();
      _pickedItems.clear();
    });
  }

  void _toggleDistrict(LocationItem d) {
    final slug = d.slug ?? d.id;
    setState(() {
      if (_pickedSlugs.contains(slug)) {
        _pickedSlugs.remove(slug);
        _pickedItems.remove(slug);
      } else {
        _pickedSlugs.add(slug);
        _pickedItems[slug] = d;
      }
    });
  }

  void _applyCityOnly() {
    Navigator.pop(
      context,
      SearchLocationResult(
        cityId: _city!.id,
        cityName: _city!.name,
        focusLat: _city!.lat,
        focusLng: _city!.lng,
      ),
    );
  }

  void _applyDistricts() {
    final slugs = _pickedSlugs.toList();
    final names = slugs.map((s) => _pickedItems[s]?.name ?? s).toList();
    final label = slugs.isEmpty
        ? null
        : (slugs.length <= 2
            ? names.join(', ')
            : '${slugs.length} quận/huyện');
    // Focus the first selected district with coordinates, else the city.
    final focus = slugs
            .map((s) => _pickedItems[s])
            .firstWhere((d) => d?.lat != null, orElse: () => null) ??
        _city;
    Navigator.pop(
      context,
      SearchLocationResult(
        cityId: _city!.id,
        cityName: _city!.name,
        districtSlugs: slugs,
        districtLabel: label,
        focusLat: focus?.lat ?? _city!.lat,
        focusLng: focus?.lng ?? _city!.lng,
      ),
    );
  }

  void _backToCity() => setState(() {
        _city = null;
        _query = '';
        _pickedSlugs.clear();
        _pickedItems.clear();
      });

  @override
  Widget build(BuildContext context) {
    final isCity = _city == null;
    final children = ref.watch(locationChildrenProvider(_locQuery));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          AddressGradientHeader(
            asSheet: widget.asSheet,
            onBack: isCity ? () => Navigator.pop(context) : _backToCity,
            trailing: isCity
                ? null
                : GestureDetector(
                    onTap: _applyCityOnly,
                    child: Text('Cả tỉnh',
                        style: AppTextStyles.semibold(15, color: Colors.white)),
                  ),
          ),
          AddressStepIndicator(
            activeIndex: isCity ? 0 : 1,
            steps: [
              AddressStep(_city?.name ?? 'Chọn tỉnh/thành phố',
                  done: _city != null),
              if (!isCity)
                AddressStep(
                  _pickedSlugs.isEmpty
                      ? 'Chọn quận/huyện'
                      : (_pickedSlugs.length <= 2
                          ? _pickedSlugs
                              .map((s) => _pickedItems[s]?.name ?? s)
                              .join(', ')
                          : '${_pickedSlugs.length} quận/huyện'),
                  done: _pickedSlugs.isNotEmpty,
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) => setState(() => _query = v.toLowerCase()),
              decoration: InputDecoration(
                hintText: isCity
                    ? 'Tìm tỉnh/thành...'
                    : 'Tìm quận/huyện trong ${_city!.name}...',
                prefixIcon:
                    const Icon(Icons.search, color: AppColors.neutral400),
                hintStyle:
                    AppTextStyles.regular(15, color: AppColors.neutral400),
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
            return const Center(child: Text('Không tìm thấy'));
          }
          return ListView.separated(
            itemCount: filtered.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: Color(0xFFE5E7EB)),
            itemBuilder: (_, i) {
              final item = filtered[i];
              if (isCity) {
                // v1 plain row: title + check when selected (no leading/chevron).
                final selected = _city?.id == item.id;
                return ListTile(
                  title:
                      Text(item.name, style: AppTextStyles.regular(15)),
                  trailing: selected
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () => _pickCity(item),
                );
              }
              final slug = item.slug ?? item.id;
              final checked = _pickedSlugs.contains(slug);
                      return CheckboxListTile(
                        value: checked,
                        activeColor: AppColors.primary,
                        controlAffinity: ListTileControlAffinity.leading,
                        title:
                            Text(item.name, style: AppTextStyles.regular(15)),
                        onChanged: (_) => _toggleDistrict(item),
                      );
                    },
                  );
                },
              ),
            ),
          if (!isCity)
            SafeArea(
              top: false, // header already handles the top inset
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: AppButton(
                  label: _pickedSlugs.isEmpty
                      ? 'Chọn cả tỉnh'
                      : 'Áp dụng (${_pickedSlugs.length})',
                  onPressed:
                      _pickedSlugs.isEmpty ? _applyCityOnly : _applyDistricts,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
