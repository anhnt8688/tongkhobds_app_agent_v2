import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/contracts_api.dart';

/// Maps the segmented-tab index to v1's `description` filter.
const _tabDescriptions = ['muaban', 'datcoc', 'thue'];

/// State for the "Thư viện hợp đồng" list (3 tabs + debounced search).
class ContractLibraryState {
  const ContractLibraryState({
    this.tab = 0,
    this.keyword = '',
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  /// 0 = Mua bán, 1 = Đặt cọc, 2 = Thuê.
  final int tab;
  final String keyword;
  final List<LibraryItem> items;
  final bool isLoading;
  final Object? error;

  ContractLibraryState copyWith({
    int? tab,
    String? keyword,
    List<LibraryItem>? items,
    bool? isLoading,
    Object? error,
    bool clearError = false,
  }) {
    return ContractLibraryState(
      tab: tab ?? this.tab,
      keyword: keyword ?? this.keyword,
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Library list controller — mirrors v1 `ContractLibraryController`
/// (changeIndex clears + refetches; search is debounced 500ms).
class ContractLibraryController extends AutoDisposeNotifier<ContractLibraryState> {
  ContractsApi get _api => ref.read(contractsApiProvider);
  Timer? _debounce;

  @override
  ContractLibraryState build() {
    ref.onDispose(() => _debounce?.cancel());
    Future.microtask(refresh);
    return const ContractLibraryState(isLoading: true);
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final list = await _api.library(
        description: _tabDescriptions[state.tab],
        key: state.keyword.trim(),
      );
      state = state.copyWith(items: list, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  void setTab(int tab) {
    if (tab == state.tab) return;
    // Switching segment clears the current list then refetches (v1 parity).
    state = state.copyWith(tab: tab, items: const [], isLoading: true);
    refresh();
  }

  void setKeyword(String keyword) {
    state = state.copyWith(keyword: keyword);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), refresh);
  }
}

final contractLibraryControllerProvider = AutoDisposeNotifierProvider<
    ContractLibraryController, ContractLibraryState>(
  ContractLibraryController.new,
);
