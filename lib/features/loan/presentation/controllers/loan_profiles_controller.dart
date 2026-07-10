import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/loan_api.dart';
import '../../data/models/loan.dart';

/// Paginated list state for one status tab (v1 ProfileManagementController).
class LoanListState {
  const LoanListState({
    this.items = const [],
    this.total = 0,
    this.page = 1,
    this.loading = true,
    this.loadingMore = false,
    this.error,
  });

  final List<Loan> items;
  final int total;
  final int page;
  final bool loading;
  final bool loadingMore;
  final Object? error;

  bool get hasMore => items.length < total;

  LoanListState copyWith({
    List<Loan>? items,
    int? total,
    int? page,
    bool? loading,
    bool? loadingMore,
    Object? error,
    bool clearError = false,
  }) =>
      LoanListState(
        items: items ?? this.items,
        total: total ?? this.total,
        page: page ?? this.page,
        loading: loading ?? this.loading,
        loadingMore: loadingMore ?? this.loadingMore,
        error: clearError ? null : (error ?? this.error),
      );
}

/// Family provider holding [LoanListState] per status. Refetches when
/// [loanRefreshProvider] bumps (after create/edit/delete).
final loanProfilesProvider = AutoDisposeNotifierProviderFamily<
    LoanProfilesNotifier, LoanListState, String>(LoanProfilesNotifier.new);

class LoanProfilesNotifier
    extends AutoDisposeFamilyNotifier<LoanListState, String> {
  static const _limit = 20;

  @override
  LoanListState build(String status) {
    ref.watch(loanRefreshProvider); // refetch on create/edit/delete
    _load();
    return const LoanListState();
  }

  Future<void> _load() async {
    try {
      final paged =
          await ref.read(loanApiProvider).list(page: 1, limit: _limit, status: arg);
      state = LoanListState(
        items: paged.items,
        total: paged.total,
        page: paged.page,
        loading: false,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e);
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(loading: true, clearError: true);
    await _load();
  }

  Future<void> loadMore() async {
    if (state.loadingMore || state.loading || !state.hasMore) return;
    state = state.copyWith(loadingMore: true);
    try {
      final paged = await ref
          .read(loanApiProvider)
          .list(page: state.page + 1, limit: _limit, status: arg);
      state = state.copyWith(
        items: [...state.items, ...paged.items],
        total: paged.total,
        page: paged.page,
        loadingMore: false,
      );
    } catch (_) {
      state = state.copyWith(loadingMore: false);
    }
  }
}
