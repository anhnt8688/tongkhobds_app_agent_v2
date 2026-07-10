import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../realestate/data/models/filter_config.dart';
import '../../realestate/data/models/property.dart';
import '../../realestate/data/realestate_api.dart';

/// State for the embedded "Sản phẩm dự án" list inside the project detail page.
/// Mirrors v1 `detail_project_controller`'s product tab (Mua bán/Cho thuê) +
/// dynamic filters + pagination over `real_estate_v2.json`.
class ProjectProductsState {
  const ProjectProductsState({
    this.tab = 1, // transaction_type: 1 = Mua bán, 2 = Cho thuê
    this.filterValues = const {},
    this.filterConfig = const [],
    this.items = const [],
    this.total = 0,
    this.page = 1,
    this.isLoading = true,
    this.isLoadingMore = false,
    this.error,
  });

  final int tab;
  final Map<String, dynamic> filterValues;
  final List<FilterOption> filterConfig;
  final List<Property> items;
  final int total;
  final int page;
  final bool isLoading;
  final bool isLoadingMore;
  final Object? error;

  bool get hasMore => items.length < total;

  bool hasFilterValue(String key) {
    final v = filterValues[key];
    if (v == null) return false;
    if (v is num) return v != 0;
    if (v is List) return v.isNotEmpty;
    if (v is String) return v.isNotEmpty;
    return true;
  }

  ProjectProductsState copyWith({
    int? tab,
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
    return ProjectProductsState(
      tab: tab ?? this.tab,
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
}

class ProjectProductsController
    extends AutoDisposeFamilyNotifier<ProjectProductsState, String> {
  RealEstateApi get _api => ref.read(realEstateApiProvider);
  Timer? _debounce;
  late String _projectCode;

  @override
  ProjectProductsState build(String projectCode) {
    _projectCode = projectCode;
    ref.onDispose(() => _debounce?.cancel());
    Future.microtask(_bootstrap);
    return const ProjectProductsState(isLoading: true);
  }

  Future<void> _bootstrap() async {
    await _loadConfig();
    await refresh();
  }

  Future<void> _loadConfig() async {
    try {
      final config = await _api.getFilterConfig(transactionType: state.tab);
      state = state.copyWith(filterConfig: config);
    } catch (_) {
      state = state.copyWith(filterConfig: const []);
    }
  }

  Map<String, dynamic> _params({required int page}) {
    final p = <String, dynamic>{
      'limit': 20,
      'page': page,
      'transaction_type': state.tab,
      'project_code': _projectCode,
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

  /// Switch Mua bán / Cho thuê — resets filters (config differs per type).
  Future<void> setTab(int tab) async {
    if (tab == state.tab) return;
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
    if (next[key] == 1) {
      next.remove(key);
    } else {
      next[key] = 1;
    }
    state = state.copyWith(filterValues: next);
    refresh();
  }

  void _debouncedRefresh() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), refresh);
  }
}

final projectProductsControllerProvider = AutoDisposeNotifierProviderFamily<
    ProjectProductsController, ProjectProductsState, String>(
  ProjectProductsController.new,
);
