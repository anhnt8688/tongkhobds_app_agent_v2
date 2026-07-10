import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/listing_manager_models.dart';
import 'models/verification_models.dart';
import 'verification_api.dart';

// ── filter meta (cached, lazy) ──

final verificationOfficesProvider =
    FutureProvider.autoDispose<List<VerificationOfficeOption>>((ref) {
  ref.keepAlive();
  return ref.watch(verificationApiProvider).fetchOfficeOptions();
});

final verificationSalesUsersProvider =
    FutureProvider.autoDispose<List<VerificationSalesUserOption>>((ref) {
  ref.keepAlive();
  return ref.watch(verificationApiProvider).fetchSalesUserOptions();
});

final verificationTagsProvider =
    FutureProvider.autoDispose<List<VerificationTagOption>>((ref) {
  ref.keepAlive();
  return ref.watch(verificationApiProvider).fetchVerificationTags();
});

// ── detail ──

final verificationDetailProvider = FutureProvider.autoDispose
    .family<VerificationSalesmanDetailResponse, int>((ref, id) {
  return ref.watch(verificationApiProvider).fetchVerificationDetail(id);
});

final verificationPublicProductProvider = FutureProvider.autoDispose
    .family<VerificationRealEstateDetail, int>((ref, id) {
  return ref.watch(verificationApiProvider).fetchPublicProductDetail(id);
});

// ── listing managers (đầu chủ tree) ──

final listingManagersProvider =
    FutureProvider.autoDispose<ListingManagerResponse>((ref) {
  return ref.watch(verificationApiProvider).fetchListingManagers();
});

// ── list controller ──

class VerificationListState {
  final List<VerificationStatusFilter> statusFilters;
  final int selectedStatusId;
  final List<VerificationItem> items;
  final int total;
  final bool isLoadingFilters;
  final bool isLoadingList;
  final bool isLoadingMore;
  final bool hasMore;
  final String? error;
  final VerificationListFilterState filters;

  const VerificationListState({
    this.statusFilters = const [],
    this.selectedStatusId = 0,
    this.items = const [],
    this.total = 0,
    this.isLoadingFilters = false,
    this.isLoadingList = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.error,
    this.filters = const VerificationListFilterState(),
  });

  VerificationListState copyWith({
    List<VerificationStatusFilter>? statusFilters,
    int? selectedStatusId,
    List<VerificationItem>? items,
    int? total,
    bool? isLoadingFilters,
    bool? isLoadingList,
    bool? isLoadingMore,
    bool? hasMore,
    String? error,
    bool clearError = false,
    VerificationListFilterState? filters,
  }) {
    return VerificationListState(
      statusFilters: statusFilters ?? this.statusFilters,
      selectedStatusId: selectedStatusId ?? this.selectedStatusId,
      items: items ?? this.items,
      total: total ?? this.total,
      isLoadingFilters: isLoadingFilters ?? this.isLoadingFilters,
      isLoadingList: isLoadingList ?? this.isLoadingList,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      error: clearError ? null : (error ?? this.error),
      filters: filters ?? this.filters,
    );
  }

  int get activeFilterCount {
    var c = 0;
    if (filters.statusIds.isNotEmpty) c++;
    if (filters.datePreset != VerificationDatePreset.all) c++;
    if (filters.officeId != null) c++;
    if (filters.salesOffId != null) c++;
    if (filters.verifyingAgentIds.isNotEmpty) c++;
    if (filters.createdType != null) c++;
    if (filters.tagIds.isNotEmpty) c++;
    if (filters.tagOperator.trim().toLowerCase() == 'and') c++;
    if (filters.agentScope != VerificationAgentScope.office) c++;
    if (filters.hasCustomDateRange) c++;
    return c;
  }
}

class VerificationListController
    extends AutoDisposeNotifier<VerificationListState> {
  static const int _limit = 10;
  int _offset = 0;
  Timer? _searchDebounce;

  VerificationApi get _api => ref.read(verificationApiProvider);

  @override
  VerificationListState build() {
    // Kick off initial load after first frame of state.
    Future.microtask(_fetchFilters);
    ref.onDispose(() => _searchDebounce?.cancel());
    return const VerificationListState(isLoadingFilters: true, isLoadingList: true);
  }

  Future<void> _fetchFilters() async {
    state = state.copyWith(isLoadingFilters: true);
    try {
      final parsed = await _api.fetchStatusFilters();
      state = state.copyWith(
        statusFilters: _mergeAllFilter(parsed.map(_normalize).toList()),
        isLoadingFilters: false,
      );
    } catch (_) {
      state = state.copyWith(
        statusFilters: _mergeAllFilter(const [
          VerificationStatusFilter(id: 1, name: 'Chờ duyệt', code: 'PENDING_APPROVAL', description: 'Chờ duyệt'),
          VerificationStatusFilter(id: 2, name: 'Đã duyệt', code: 'APPROVED', description: 'Đã duyệt'),
          VerificationStatusFilter(id: 3, name: 'Từ chối', code: 'REJECTED', description: 'Từ chối'),
          VerificationStatusFilter(id: 4, name: 'Chờ gán', code: 'PENDING_ASSIGN', description: 'Chờ gán'),
          VerificationStatusFilter(id: 5, name: 'Chờ xác nhận', code: 'PENDING_CONFIRM', description: 'Chờ xác nhận'),
        ]),
        isLoadingFilters: false,
      );
    }
    await refresh();
  }

  VerificationStatusFilter _normalize(VerificationStatusFilter f) {
    switch (f.code.trim().toUpperCase()) {
      case 'PENDING_APPROVAL':
        return const VerificationStatusFilter(id: 1, name: 'Chờ duyệt', code: 'PENDING_APPROVAL', description: 'Chờ duyệt');
      case 'APPROVED':
        return VerificationStatusFilter(id: f.id, name: 'Đã duyệt', code: 'APPROVED', description: 'Đã duyệt');
      case 'PENDING_CONFIRM':
        return VerificationStatusFilter(id: f.id, name: 'Chờ xác nhận', code: 'PENDING_CONFIRM', description: 'Chờ xác nhận');
      case 'PENDING_ASSIGN':
        return VerificationStatusFilter(id: f.id, name: 'Chờ gán', code: 'PENDING_ASSIGN', description: 'Chờ gán');
      case 'REJECTED':
        return VerificationStatusFilter(id: f.id, name: 'Từ chối', code: 'REJECTED', description: 'Từ chối');
      default:
        return f;
    }
  }

  List<VerificationStatusFilter> _mergeAllFilter(
      List<VerificationStatusFilter> filters) {
    final out = <VerificationStatusFilter>[
      const VerificationStatusFilter(id: 0, name: 'Tất cả', code: 'ALL', description: 'Tất cả'),
    ];
    for (final f in filters) {
      if (f.code.trim().toUpperCase() == 'ALL' || f.name.trim() == 'Tất cả') continue;
      out.add(f);
    }
    return out;
  }

  List<int> _effectiveStatusIds() {
    if (state.filters.statusIds.isNotEmpty) return state.filters.statusIds;
    final id = state.selectedStatusId;
    return id == 0 ? const [] : [id];
  }

  Future<void> refresh() async {
    _offset = 0;
    state = state.copyWith(items: const [], total: 0, hasMore: false);
    await _fetchPage(reset: true);
  }

  Future<void> retry() => refresh();

  Future<void> selectStatus(VerificationStatusFilter f) async {
    if (state.selectedStatusId == f.id) return;
    state = state.copyWith(selectedStatusId: f.id);
    await refresh();
  }

  /// Inline search field handler — debounced so we don't refetch on every keystroke.
  void setSearch(String text) {
    final value = text.trim();
    if (value == state.filters.searchText) return;
    state = state.copyWith(filters: state.filters.copyWith(searchText: value));
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), refresh);
  }

  Future<void> applyFilters(VerificationListFilterState filters) async {
    var selected = state.selectedStatusId;
    if (filters.statusIds.length == 1) {
      selected = filters.statusIds.first;
    } else if (filters.statusIds.isEmpty) {
      selected = 0;
    }
    state = state.copyWith(filters: filters, selectedStatusId: selected);
    await refresh();
  }

  Future<void> resetFilters() async {
    state = state.copyWith(
        filters: const VerificationListFilterState(), selectedStatusId: 0);
    await refresh();
  }

  Future<void> loadMore() async {
    if (state.isLoadingList || state.isLoadingMore || !state.hasMore) return;
    await _fetchPage(reset: false);
  }

  Future<void> _fetchPage({required bool reset}) async {
    state = reset
        ? state.copyWith(isLoadingList: true, clearError: true)
        : state.copyWith(isLoadingMore: true, clearError: true);
    try {
      final f = state.filters;
      final effective = _effectiveStatusIds();
      final res = await _api.fetchVerificationList(
        limit: _limit,
        offset: _offset,
        statusIds: effective.isEmpty ? null : effective,
        search: f.searchText.isEmpty ? null : f.searchText,
        dateFrom: f.dateFrom != null ? _fmt(f.dateFrom!) : null,
        dateTo: f.dateTo != null ? _fmt(f.dateTo!) : null,
        timeField: f.timeField,
        office: f.officeId,
        salesOff: f.salesOffId,
        verifyingAgentIds:
            f.verifyingAgentIds.isEmpty ? null : f.verifyingAgentIds,
        createdType: f.createdType?.value,
        tags: f.tagIds.isEmpty ? null : f.tagIds,
        tagOperator: f.tagOperator,
      );
      final mapped = res.items.map((e) => e.toUiItem()).toList();
      final items = reset ? mapped : [...state.items, ...mapped];
      _offset = items.length;
      state = state.copyWith(
        items: items,
        total: res.total,
        hasMore: _offset < res.total,
        isLoadingList: false,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoadingList: false,
        isLoadingMore: false,
      );
    }
  }

  void updateAssignedToName(int itemId, String name) {
    state = state.copyWith(
      items: [
        for (final it in state.items)
          it.id == itemId ? it.copyWith(assignedToName: name.trim()) : it,
      ],
    );
  }

  void updateAgentSupportName(int itemId, String name) {
    state = state.copyWith(
      items: [
        for (final it in state.items)
          it.id == itemId ? it.copyWith(agentSupportName: name.trim()) : it,
      ],
    );
  }

  String _fmt(DateTime d) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }
}

final verificationListControllerProvider = AutoDisposeNotifierProvider<
    VerificationListController, VerificationListState>(
  VerificationListController.new,
);
