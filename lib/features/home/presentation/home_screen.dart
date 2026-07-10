import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import 'home_providers.dart';
import 'widgets/home_banner_carousel.dart';
import 'widgets/home_blocks_section.dart';
import 'widgets/home_events_carousel.dart';
import 'widgets/home_management_grid.dart';
import 'widgets/home_menu_bar.dart';
import 'widgets/home_news_section.dart';
import 'widgets/home_quick_tools.dart';
import 'widgets/home_stats_section.dart';
import 'widgets/home_transactions_section.dart';

/// Home tab, rebuilt to match v1 `HomePage`: a full-bleed banner carousel with
/// the body pulled up 32px over it, then the v1 sections in order (menu, events,
/// stats, quick tools, transactions, blocks, news), each 32px apart.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(homeBannersProvider);
    ref.invalidate(homeEventsProvider);
    ref.invalidate(dashboardStatsProvider);
    ref.invalidate(quickToolsProvider);
    ref.invalidate(homeTransactionsProvider);
    ref.invalidate(homeBlocksProvider);
    ref.invalidate(homeNewsProvider);
    // Wait on the above-the-fold sections so the spinner reflects real work;
    // swallow errors so pull-to-refresh always settles.
    try {
      await Future.wait([
        ref.read(homeBannersProvider.future),
        ref.read(dashboardStatsProvider.future),
      ]);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => _refresh(ref),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const HomeBannerCarousel(),
            Transform.translate(
              offset: const Offset(0, -32),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeMenuBar(),
                  SizedBox(height: 32),
                  HomeEventsCarousel(),
                  SizedBox(height: 32),
                  HomeStatsSection(),
                  SizedBox(height: 32),
                  HomeManagementGrid(),
                  SizedBox(height: 32),
                  HomeQuickTools(),
                  SizedBox(height: 32),
                  HomeTransactionsSection(),
                  SizedBox(height: 32),
                  HomeBlocksSection(),
                  SizedBox(height: 32),
                  HomeNewsSection(),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
