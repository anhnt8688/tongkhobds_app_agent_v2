import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import 'models/dashboard_stat.dart';
import 'models/home_banner.dart';
import 'models/home_block.dart';
import 'models/quick_tool.dart';

class HomeApi {
  HomeApi(this._dio);

  final Dio _dio;

  Future<List<DashboardStat>> dashboardStats({
    DateTime? start,
    DateTime? end,
  }) async {
    String d(DateTime x) => x.toIso8601String().split('T').first;
    final res = await _dio.get(
      '${AppConfig.agent}/dashboard_stats.json',
      queryParameters: {
        if (start != null) 'start_date': d(start),
        if (end != null) 'end_date': d(end),
      },
    );
    final data = res.data;
    Object? list;
    if (data is Map) {
      final stats = data['stats'];
      list = stats is Map ? stats['data'] : null;
    }
    if (list is! List) return const [];
    return list.whereType<Map>().map(DashboardStat.fromJson).toList();
  }

  /// Fetches a `news_by_folder.json` folder and maps each entry to a
  /// [HomeBanner] (shape `{ avatar, name, link }`). Banners, events (sự kiện)
  /// and news (tin tức) all share this endpoint — only namespace + folder vary.
  Future<List<HomeBanner>> _newsByFolder(String namespace, String folder) async {
    final res = await _dio.get(
      '$namespace/news_by_folder.json',
      queryParameters: {'folder': folder},
    );
    final data = res.data;
    final raw =
        (data is Map ? (data['result'] ?? data['items'] ?? data['data']) : data) ??
            const [];
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map(HomeBanner.fromJson)
        .where((b) => b.image.isNotEmpty)
        .toList();
  }

  /// Top banners (v1 folder `thumbnail-agnet`, api_customer).
  Future<List<HomeBanner>> banners() =>
      _newsByFolder(AppConfig.customer, 'thumbnail-agnet');

  /// "Sự kiện đang diễn ra" (v1 folder `lucky-program`, api_agent).
  Future<List<HomeBanner>> events() =>
      _newsByFolder(AppConfig.agent, 'lucky-program');

  /// "Tin tức BĐS" (v1 folder `11`, api_customer).
  Future<List<HomeBanner>> news() => _newsByFolder(AppConfig.customer, '11');

  /// "BĐS phù hợp" blocks (v1 `home_blocks.json`). Scoped to the user's area
  /// via [slug]/[cityId] and personalised via [userId] like v1's fetchHomeBlock.
  Future<List<HomeBlock>> homeBlocks({
    String? cityId,
    String? slug,
    int? userId,
  }) async {
    final res = await _dio.get(
      '${AppConfig.agent}/home_blocks.json',
      queryParameters: {
        if (cityId != null && cityId.isNotEmpty) 'city_id': cityId,
        if (slug != null && slug.isNotEmpty) 'locations_slug': slug,
        if (userId != null && userId != 0) 'user_id': userId,
      },
    );
    final data = res.data;
    final raw = (data is Map
            ? (data['data'] ?? data['blocks'] ?? data['result'])
            : data) ??
        const [];
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map(HomeBlock.fromJson)
        .where((b) => b.products.isNotEmpty)
        .toList();
  }

  /// "Công cụ nhanh" tools, server-driven from the agent news folder 19
  /// (matches v1): `GET /api_agent/news_by_folder.json?folder=19`
  /// → `data.result[] { name, avatar, description }`.
  Future<List<QuickTool>> quickTools() async {
    final res = await _dio.get(
      '${AppConfig.agent}/news_by_folder.json',
      queryParameters: {'folder': '19'},
    );
    final data = res.data;
    final raw = (data is Map
            ? (data['result'] ?? data['items'] ?? data['data'])
            : data) ??
        const [];
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map(QuickTool.fromJson)
        .where((t) => t.name.isNotEmpty)
        .toList();
  }
}

final homeApiProvider = Provider<HomeApi>((ref) {
  return HomeApi(ref.watch(dioProvider));
});
