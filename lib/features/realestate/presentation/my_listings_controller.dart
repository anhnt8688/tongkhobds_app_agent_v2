import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/property.dart';
import '../data/realestate_api.dart';

/// State for "BĐS của tôi" — the agent's own listings with status tabs, search,
/// the full v1 filter set (source/property type/price/area/bedrooms/directions),
/// sort and pagination (parity with v1 `MyProductController`).
class MyListingsState {
  const MyListingsState({
    this.filters = const ListingFilters(),
    this.statusCode,
    this.search = '',
    this.source,
    this.sort,
    this.propertyTypes = const [],
    this.price,
    this.priceRange = '',
    this.area,
    this.areaRange = '',
    this.bedrooms,
    this.houseDirection,
    this.balcony,
    this.items = const [],
    this.total = 0,
    this.page = 1,
    this.isLoading = true,
    this.isLoadingMore = false,
    this.deletingId,
    this.error,
  });

  final ListingFilters filters;
  final String? statusCode; // selected status tab code (v1 currentStatus.code)
  final String search;
  final FilterValue? source;
  final FilterValue? sort;
  final List<FilterValue> propertyTypes;
  final FilterValue? price;
  final String priceRange; // "min-max" custom range
  final FilterValue? area;
  final String areaRange; // "min-max" custom range
  final FilterValue? bedrooms;
  final FilterValue? houseDirection;
  final FilterValue? balcony;
  final List<Property> items;
  final int total;
  final int page;
  final bool isLoading;
  final bool isLoadingMore;
  final int? deletingId;
  final Object? error;

  bool get hasMore => items.length < total;

  MyListingsState copyWith({
    ListingFilters? filters,
    String? statusCode,
    String? search,
    FilterValue? source,
    bool clearSource = false,
    FilterValue? sort,
    List<FilterValue>? propertyTypes,
    FilterValue? price,
    String? priceRange,
    FilterValue? area,
    String? areaRange,
    FilterValue? bedrooms,
    bool clearBedrooms = false,
    FilterValue? houseDirection,
    bool clearHouseDirection = false,
    FilterValue? balcony,
    bool clearBalcony = false,
    List<Property>? items,
    int? total,
    int? page,
    bool? isLoading,
    bool? isLoadingMore,
    int? deletingId,
    bool clearDeleting = false,
    Object? error,
    bool clearError = false,
  }) {
    return MyListingsState(
      filters: filters ?? this.filters,
      statusCode: statusCode ?? this.statusCode,
      search: search ?? this.search,
      source: clearSource ? null : (source ?? this.source),
      sort: sort ?? this.sort,
      propertyTypes: propertyTypes ?? this.propertyTypes,
      price: price ?? this.price,
      priceRange: priceRange ?? this.priceRange,
      area: area ?? this.area,
      areaRange: areaRange ?? this.areaRange,
      bedrooms: clearBedrooms ? null : (bedrooms ?? this.bedrooms),
      houseDirection:
          clearHouseDirection ? null : (houseDirection ?? this.houseDirection),
      balcony: clearBalcony ? null : (balcony ?? this.balcony),
      items: items ?? this.items,
      total: total ?? this.total,
      page: page ?? this.page,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      deletingId: clearDeleting ? null : (deletingId ?? this.deletingId),
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class MyListingsController extends AutoDisposeNotifier<MyListingsState> {
  RealEstateApi get _api => ref.read(realEstateApiProvider);
  Timer? _debounce;

  @override
  MyListingsState build() {
    ref.onDispose(() => _debounce?.cancel());
    Future.microtask(_bootstrap);
    return const MyListingsState();
  }

  Future<void> _bootstrap() async {
    final filters = await _api.myListingFilters();
    // v1 defaults to the first status tab (the API typically supplies "Tất cả").
    state = state.copyWith(
      filters: filters,
      statusCode: filters.statuses.isNotEmpty
          ? (filters.statuses.first.code ?? '')
          : null,
    );
    await refresh();
  }

  String? get _statusId =>
      (state.statusCode != null && state.statusCode!.isNotEmpty)
          ? state.statusCode
          : null;

  /// Switches the active status tab and reloads.
  void setStatus(String? code) {
    if (code == state.statusCode) return;
    state = state.copyWith(statusCode: code ?? '', items: const [], isLoading: true);
    refresh();
  }

  /// Debounced search-by-text (ID / project name).
  void setSearch(String value) {
    state = state.copyWith(search: value);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), refresh);
  }

  void setSource(FilterValue? v) {
    state = v == null
        ? state.copyWith(clearSource: true)
        : state.copyWith(source: v);
    refresh();
  }

  void setSort(FilterValue? v) {
    if (v == null || v == state.sort) return;
    state = state.copyWith(sort: v);
    refresh();
  }

  void setPropertyTypes(List<FilterValue> v) {
    state = state.copyWith(propertyTypes: v);
    refresh();
  }

  /// Price preset + custom "min-max" range (either may be set).
  void setPrice(FilterValue? preset, String range) {
    state = state.copyWith(price: preset, priceRange: range);
    refresh();
  }

  void setArea(FilterValue? preset, String range) {
    state = state.copyWith(area: preset, areaRange: range);
    refresh();
  }

  void setBedrooms(FilterValue? v) {
    state = v == null
        ? state.copyWith(clearBedrooms: true)
        : state.copyWith(bedrooms: v);
    refresh();
  }

  void setHouseDirection(FilterValue? v) {
    state = v == null
        ? state.copyWith(clearHouseDirection: true)
        : state.copyWith(houseDirection: v);
    refresh();
  }

  void setBalcony(FilterValue? v) {
    state = v == null
        ? state.copyWith(clearBalcony: true)
        : state.copyWith(balcony: v);
    refresh();
  }

  String? _idStr(FilterValue? v) => v?.id?.toString();

  Future<PagedProperties> _fetch(int page) {
    return _api.myListings(
      search: state.search,
      statusId: _statusId,
      source: _idStr(state.source),
      sort: _idStr(state.sort),
      propertyTypeIds: state.propertyTypes
          .map((e) => e.id?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList(),
      priceRange: state.priceRange.isNotEmpty
          ? state.priceRange
          : state.price?.name,
      areaRange:
          state.areaRange.isNotEmpty ? state.areaRange : _idStr(state.area),
      bedrooms: _idStr(state.bedrooms),
      houseDirection: _idStr(state.houseDirection),
      balconyDirection: _idStr(state.balcony),
      page: page,
    );
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final res = await _fetch(1);
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
      final res = await _fetch(next);
      state = state.copyWith(
        items: [...state.items, ...res.items],
        total: res.total,
        page: next,
        isLoadingMore: false,
      );
    } catch (_) {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  /// Unpublishes (gỡ tin) a listing, then removes it from the list locally.
  Future<bool> delete(int id) async {
    state = state.copyWith(deletingId: id);
    try {
      await _api.unpublish(id);
      state = state.copyWith(
        items: state.items.where((e) => e.id != id).toList(),
        total: state.total > 0 ? state.total - 1 : 0,
        clearDeleting: true,
      );
      return true;
    } catch (_) {
      state = state.copyWith(clearDeleting: true);
      return false;
    }
  }
}

final myListingsControllerProvider =
    AutoDisposeNotifierProvider<MyListingsController, MyListingsState>(
        MyListingsController.new);
