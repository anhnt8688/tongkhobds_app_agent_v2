import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/custom_screen.dart';
import '../data/loan_enums.dart';
import 'controllers/loan_profiles_controller.dart';
import 'widgets/loan_profile_card.dart';

/// Loan profile management (v1 ProfileManagementPage): 4 status tabs, each a
/// pull-to-refresh + infinite-scroll list.
class LoanProfilesScreen extends StatelessWidget {
  const LoanProfilesScreen({super.key});

  static const _tabs = LoanStatus.values;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: CustomScreen(
        title: 'Quản lý hồ sơ',
        backgroundColor: AppColors.bg,
        child: Column(
          children: [
            TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.center,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.text,
              labelStyle:
                  AppTypography.subtitle.copyWith(fontWeight: FontWeight.w600),
              tabs: [for (final s in _tabs) Tab(text: s.title)],
            ),
            Expanded(
              child: TabBarView(
                children: [for (final s in _tabs) _LoanTab(status: s.value)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoanTab extends ConsumerStatefulWidget {
  const _LoanTab({required this.status});
  final String status;

  @override
  ConsumerState<_LoanTab> createState() => _LoanTabState();
}

class _LoanTabState extends ConsumerState<_LoanTab>
    with AutomaticKeepAliveClientMixin {
  final _scroll = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 200) {
        ref.read(loanProfilesProvider(widget.status).notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final state = ref.watch(loanProfilesProvider(widget.status));
    final notifier = ref.read(loanProfilesProvider(widget.status).notifier);

    if (state.loading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (state.error != null) {
      return _empty(
        state.error is ApiException
            ? (state.error as ApiException).message
            : 'Đã có lỗi xảy ra',
      );
    }
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: notifier.refresh,
      child: state.items.isEmpty
          ? ListView(children: [const SizedBox(height: 120), _empty('Chưa có hồ sơ')])
          : ListView.separated(
              controller: _scroll,
              padding: const EdgeInsets.all(16),
              itemCount: state.items.length + (state.hasMore ? 1 : 0),
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, i) {
                if (i >= state.items.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                        child: CircularProgressIndicator(color: AppColors.primary)),
                  );
                }
                final loan = state.items[i];
                return LoanProfileCard(
                  loan: loan,
                  onTap: () => context.push('/loan/profile/${loan.id}'),
                );
              },
            ),
    );
  }

  Widget _empty(String message) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(message,
              style: AppTypography.body.copyWith(color: AppColors.textMute)),
        ),
      );
}
