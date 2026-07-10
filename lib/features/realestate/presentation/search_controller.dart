import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/location/location_cache.dart';
import '../data/models/filter_config.dart';
import '../data/models/property.dart';
import '../data/models/search_filter.dart';
import '../data/realestate_api.dart';

/// State for the BĐS search list with v1-style dynamic filters.
class SearchState {
  const SearchState({
    this.tab = 1, // transaction_type: 1=Mua bán, 2=Cho thuê, 3=Dự án
    this.sort = PropertySort.newest,
    this.cityId,
    this.cityName,
    this.districtSlugs = const [],
    this.districtLabel,
    this.focusLat,
    this.focusLng,
    this.filterValues = const {},
    this.filterConfig = const [],
    this.items = const [],
    this.total = 0,
    this.page = 1,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
  });

  final int tab;
  final PropertySort sort;
  final String? cityId;
  final String? cityName;

  /// Selected district slugs — the backend filters by `locations_slug` (CSV of
  /// slugs), NOT by district ids.
  final List<String> districtSlugs;
  final String? districtLabel;

  /// Map-focus coordinates for the "Bản đồ" button (chosen area, else detected).
  final double? focusLat;
  final double? focusLng;

  /// key → value (String / num / List) for the active dynamic filters.
  final Map<String, dynamic> filterValues;
  final List<FilterOption> filterConfig;

  final List<Property> items;
  final int total;
  final int page;
  final bool isLoading;
  final bool isLoadingMore;
  final Object? error;

  bool get isProjectTab => tab == 3;
  bool get hasMore => items.length < total;

  SearchState copyWith({
    int? tab,
    PropertySort? sort,
    String? cityId,
    String? cityName,
    List<String>? districtSlugs,
    String? districtLabel,
    double? focusLat,
    double? focusLng,
    bool clearLocation = false,
    Map<String, dynamic>? filterValues,
    List<FilterOption>? filterConfig,
    List<Property>? items,
    int? total,
    int? page,
    bool? isLoading,
    bool? isLoadingMore,
    Object? error,
    bool clearError = false,
  }) {
    return SearchState(
      tab: tab ?? this.tab,
      sort: sort ?? this.sort,
      cityId: clearLocation ? null : (cityId ?? this.cityId),
      cityName: clearLocation ? null : (cityName ?? this.cityName),
      districtSlugs:
          clearLocation ? const [] : (districtSlugs ?? this.districtSlugs),
      districtLabel:
          clearLocation ? null : (districtLabel ?? this.districtLabel),
      focusLat: clearLocation ? null : (focusLat ?? this.focusLat),
      focusLng: clearLocation ? null : (focusLng ?? this.focusLng),
      filterValues: filterValues ?? this.filterValues,
      filterConfig: filterConfig ?? this.filterConfig,
      items: items ?? this.items,
      total: total ?? this.total,
      page: page ?? this.page,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: clearError ? null : (error ?? this.error),
    );
  }

  bool hasFilterValue(String key) {
    final v = filterValues[key];
    if (v == null) return false;
    if (v is num) return v != 0;
    if (v is List) return v.isNotEmpty;
    if (v is String) return v.isNotEmpty;
    return true;
  }
}

class SearchListController extends AutoDisposeNotifier<SearchState> {
  RealEstateApi get _api => ref.read(realEstateApiProvider);
  Timer? _debounce;

  /// True once the user manually changes the location — stops late location
  /// detection from overriding their choice.
  bool _locationTouched = false;

  @override
  SearchState build() {
    ref.onDispose(() => _debounce?.cancel());
    // Apply detection the moment it resolves (it often finishes AFTER this tab
    // is first built and the tab stays alive in the indexedStack shell).
    ref.listen(detectedLocationProvider, (_, next) {
      if (next != null) _applyDetectedLocation(next, reload: true);
    });
    Future.microtask(_bootstrap);
    return const SearchState(isLoading: true);
  }

  Future<void> _bootstrap() async {
    // Seed from whatever location is already known (no reload — done below).
    final known = ref.read(detectedLocationProvider);
    if (known != null) _applyDetectedLocation(known, reload: false);
    await _loadConfig();
    await refresh();
  }

  /// Scopes the list to the device's detected district — matching v1. Skipped
  /// once the user has picked their own location.
  void _applyDetectedLocation(CachedLocation loc, {required bool reload}) {
    if (_locationTouched || state.cityId != null) return;
    if (!loc.isFresh()) return;
    state = state.copyWith(
      cityId: loc.cityId,
      cityName: loc.cityName,
      districtSlugs: loc.slug.isEmpty ? const [] : [loc.slug],
      districtLabel: loc.districtName,
      // GPS coords as the map-focus fallback until the user picks an area.
      focusLat: loc.lat,
      focusLng: loc.lng,
    );
    if (reload) {
      _loadConfig();
      refresh();
    }
  }

  Future<void> _loadConfig() async {
    try {
      final config = await _api.getFilterConfig(
        transactionType: state.tab,
        cityId: state.cityId,
      );
      state = state.copyWith(filterConfig: config);
    } catch (_) {
      state = state.copyWith(filterConfig: const []);
    }
  }

  /// Builds the `real_estate_v2.json` query (mirrors v1 `_buildBaseParams`).
  Map<String, dynamic> _params({required int page}) {
    final p = <String, dynamic>{
      'limit': 30,
      'page': page,
      'transaction_type': state.tab,
      // Sorting is driven by the string `sort` param (newest / price_asc / …);
      // the legacy integer `type` param is ignored by the backend.
      'sort': state.sort.value,
      if (state.cityId != null) 'city_id': state.cityId,
      if (state.cityName != null) 'city': state.cityName,
      // District filtering is by slug via `locations_slug` (CSV); the backend
      // ignores `district_ids`.
      if (state.districtSlugs.isNotEmpty)
        'locations_slug': state.districtSlugs.join(','),
    };
    state.filterValues.forEach((key, value) {
      if (value == null) return;
      if (value is List && value.isEmpty) return;
      if (value is String && value.isEmpty) return;
      if (key == 'price' && value is String) {
        p[key] = value.replaceAll(RegExp(r'[^0-9\-]'), '');
      } else {
        p[key] = value;
      }
    });
    return p;
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final res = await _api.searchDynamic(_params(page: 1), page: 1);
      state = state.copyWith(
        items: res.items,
        total: res.total,
        page: 1,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final next = state.page + 1;
      final res = await _api.searchDynamic(_params(page: next), page: next);
      state = state.copyWith(
        items: [...state.items, ...res.items],
        total: res.total,
        page: next,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e);
    }
  }

  void _debouncedRefresh() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), refresh);
  }

  // ---- mutations ----

  Future<void> setTab(int tab) async {
    if (tab == state.tab) return;
    // Switching segment resets dynamic filters (config differs per type) and
    // clears the old list so the loader shows instead of stale results.
    state = state.copyWith(
      tab: tab,
      filterValues: const {},
      items: const [],
      total: 0,
      isLoading: true,
    );
    await _loadConfig();
    await refresh();
  }

  void setSort(PropertySort sort) {
    state = state.copyWith(sort: sort);
    refresh();
  }

  Future<void> setLocation({
    required String cityId,
    required String cityName,
    List<String> districtSlugs = const [],
    String? districtLabel,
    double? focusLat,
    double? focusLng,
  }) async {
    _locationTouched = true;
    state = state.copyWith(
      cityId: cityId,
      cityName: cityName,
      districtSlugs: districtSlugs,
      districtLabel: districtLabel,
      focusLat: focusLat,
      focusLng: focusLng,
      items: const [],
      total: 0,
      isLoading: true,
    );
    await _loadConfig();
    await refresh();
  }

  Future<void> clearLocation() async {
    _locationTouched = true;
    state = state.copyWith(
      clearLocation: true,
      items: const [],
      total: 0,
      isLoading: true,
    );
    await _loadConfig();
    await refresh();
  }

  void setFilterValue(String key, dynamic value) {
    final next = Map<String, dynamic>.from(state.filterValues);
    if (value == null || (value is List && value.isEmpty)) {
      next.remove(key);
    } else {
      next[key] = value;
    }
    state = state.copyWith(filterValues: next);
    _debouncedRefresh();
  }

  void toggleSwitch(String key) {
    final next = Map<String, dynamic>.from(state.filterValues);
    final on = next[key] == 1;
    if (on) {
      next.remove(key);
    } else {
      next[key] = 1;
    }
    state = state.copyWith(filterValues: next);
    refresh();
  }

  void clearFilter(String key) {
    final next = Map<String, dynamic>.from(state.filterValues)..remove(key);
    state = state.copyWith(filterValues: next);
    refresh();
  }
}

final searchListControllerProvider =
    AutoDisposeNotifierProvider<SearchListController, SearchState>(
        SearchListController.new);

/// Key for [propertyDetailProvider]: property id + whether it is the agent's
/// own listing (selects the agent vs public detail endpoint).
typedef PropertyDetailKey = ({int id, bool owned});

/// Detail provider keyed by property id + ownership.
final propertyDetailProvider =
    FutureProvider.autoDispose.family((ref, PropertyDetailKey key) {
  return ref.watch(realEstateApiProvider).detail(id: key.id, owned: key.owned);
});
