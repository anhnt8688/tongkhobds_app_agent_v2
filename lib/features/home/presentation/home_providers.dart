import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/location/location_cache.dart';
import '../../auth/presentation/controllers/auth_controller.dart';
import '../../transactions/data/models/transaction.dart';
import '../../transactions/data/transactions_api.dart';
import '../data/home_api.dart';
import '../data/models/dashboard_stat.dart';
import '../data/models/home_banner.dart';
import '../data/models/home_block.dart';
import '../data/models/quick_tool.dart';

/// Selected date range for the dashboard stats (null = server default period).
final dashStatsRangeProvider =
    StateProvider<(DateTime, DateTime)?>((ref) => null);

final dashboardStatsProvider =
    FutureProvider.autoDispose<List<DashboardStat>>((ref) {
  final range = ref.watch(dashStatsRangeProvider);
  return ref.watch(homeApiProvider).dashboardStats(
        start: range?.$1,
        end: range?.$2,
      );
});

final homeBannersProvider =
    FutureProvider.autoDispose<List<HomeBanner>>((ref) {
  return ref.watch(homeApiProvider).banners();
});

/// "Công cụ nhanh" quick tools — server-driven (v1 folder=19).
final quickToolsProvider =
    FutureProvider.autoDispose<List<QuickTool>>((ref) {
  return ref.watch(homeApiProvider).quickTools();
});

/// "Sự kiện đang diễn ra" (v1 folder=lucky-program).
final homeEventsProvider =
    FutureProvider.autoDispose<List<HomeBanner>>((ref) {
  return ref.watch(homeApiProvider).events();
});

/// "Tin tức BĐS" (v1 folder=11).
final homeNewsProvider = FutureProvider.autoDispose<List<HomeBanner>>((ref) {
  return ref.watch(homeApiProvider).news();
});

/// "BĐS phù hợp" titled blocks (v1 `home_blocks.json`), scoped to the user's
/// detected area + id like v1's fetchHomeBlock.
final homeBlocksProvider =
    FutureProvider.autoDispose<List<HomeBlock>>((ref) {
  final loc = ref.watch(detectedLocationProvider);
  final user = ref.watch(currentUserProvider);
  return ref.watch(homeApiProvider).homeBlocks(
        cityId: loc?.cityId,
        slug: loc?.slug,
        userId: user?.id,
      );
});

/// "Giao dịch" preview on home — the 3 most recent (v1 limit 3, status 1).
final homeTransactionsProvider =
    FutureProvider.autoDispose<List<TransactionItem>>((ref) {
  return ref.watch(transactionsApiProvider).list(status: '1', limit: 3);
});
