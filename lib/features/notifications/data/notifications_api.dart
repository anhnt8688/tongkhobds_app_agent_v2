import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/json_parse.dart';
import 'models/app_notification.dart';

/// One page of notifications + the per-tab unread counters (v1 list_tmessage).
class NotificationPageResult {
  const NotificationPageResult({
    required this.items,
    required this.countOrder,
    required this.countPromotion,
    required this.page,
    required this.totalPages,
  });
  final List<AppNotification> items;
  final int countOrder;
  final int countPromotion;
  final int page;
  final int totalPages;
}

class NotificationsApi {
  NotificationsApi(this._dio);
  final Dio _dio;
  String get _a => AppConfig.agent;

  /// `type` 1 = Giao dịch, 2 = Hệ thống.
  Future<NotificationPageResult> fetch({
    required int type,
    int page = 1,
    int limit = 20,
  }) async {
    final res = await _dio.get('$_a/list_tmessage.json', queryParameters: {
      'type': type,
      'page': page,
      'limit': limit,
      'app': 'agent',
    });
    // Envelope already unwrapped `{status,data}` → res.data is the data payload.
    final d = res.data is Map ? res.data as Map : const {};
    final raw = d['result'] is List ? d['result'] as List : const [];
    return NotificationPageResult(
      items: raw.whereType<Map>().map(AppNotification.fromJson).toList(),
      countOrder: asInt(d['countOrder']),
      countPromotion: asInt(d['countPromotion']),
      page: asInt(d['page'], fallback: page),
      totalPages: asInt(d['total_pages']),
    );
  }

  Future<void> markRead({required int id, required int type}) async {
    await _dio.get('$_a/set_read_tmessage.json',
        queryParameters: {'tmessageId': id, 'tmessageType': type});
  }

  Future<void> markAllRead({required int type}) async {
    await _dio.get('$_a/set_read_all.json',
        queryParameters: {'tmessageType': type});
  }

  Future<void> delete(int id) async {
    await _dio.get('$_a/delete_tmessage.json', queryParameters: {'tmessageId': id});
  }

  /// Stop receiving notifications from this entity.
  Future<void> denied({String? tablename, int? tableId}) async {
    await _dio.post('$_a/denied_tmessage.json',
        data: {'tablename': tablename, 'tableid': tableId});
  }
}

final notificationsApiProvider =
    Provider<NotificationsApi>((ref) => NotificationsApi(ref.watch(dioProvider)));

/// Kept for the home "việc cần làm" card — first page of "Giao dịch".
final notificationsProvider =
    FutureProvider.autoDispose<List<AppNotification>>((ref) async {
  final res = await ref.watch(notificationsApiProvider).fetch(type: 1);
  return res.items;
});

// ── screen controller (2 tabs + counts + pagination) ──

class NotificationsState {
  const NotificationsState({
    this.tab = 0,
    this.items = const [],
    this.countOrder = 0,
    this.countPromotion = 0,
    this.loading = true,
    this.loadingMore = false,
    this.page = 1,
    this.totalPages = 1,
    this.error,
  });
  final int tab; // 0 = Giao dịch, 1 = Hệ thống
  final List<AppNotification> items;
  final int countOrder;
  final int countPromotion;
  final bool loading;
  final bool loadingMore;
  final int page;
  final int totalPages;
  final String? error;

  bool get hasMore => page < totalPages;

  NotificationsState copyWith({
    int? tab,
    List<AppNotification>? items,
    int? countOrder,
    int? countPromotion,
    bool? loading,
    bool? loadingMore,
    int? page,
    int? totalPages,
    String? error,
    bool clearError = false,
  }) =>
      NotificationsState(
        tab: tab ?? this.tab,
        items: items ?? this.items,
        countOrder: countOrder ?? this.countOrder,
        countPromotion: countPromotion ?? this.countPromotion,
        loading: loading ?? this.loading,
        loadingMore: loadingMore ?? this.loadingMore,
        page: page ?? this.page,
        totalPages: totalPages ?? this.totalPages,
        error: clearError ? null : (error ?? this.error),
      );
}

class NotificationsController extends AutoDisposeNotifier<NotificationsState> {
  NotificationsApi get _api => ref.read(notificationsApiProvider);
  int get _type => state.tab + 1;

  @override
  NotificationsState build() {
    Future.microtask(refresh);
    return const NotificationsState();
  }

  Future<void> setTab(int tab) async {
    if (tab == state.tab) return;
    state = state.copyWith(tab: tab, items: const [], loading: true);
    await refresh();
  }

  Future<void> refresh() async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      final res = await _api.fetch(type: _type, page: 1);
      state = state.copyWith(
        items: res.items,
        countOrder: res.countOrder,
        countPromotion: res.countPromotion,
        page: res.page,
        totalPages: res.totalPages,
        loading: false,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.loadingMore || !state.hasMore) return;
    state = state.copyWith(loadingMore: true);
    try {
      final res = await _api.fetch(type: _type, page: state.page + 1);
      state = state.copyWith(
        items: [...state.items, ...res.items],
        page: res.page,
        totalPages: res.totalPages,
        loadingMore: false,
      );
    } catch (_) {
      state = state.copyWith(loadingMore: false);
    }
  }

  Future<void> markRead(AppNotification n) async {
    if (n.isRead || n.id == null) return;
    try {
      await _api.markRead(id: n.id!, type: _type);
      ref.invalidate(notificationsProvider);
      await refresh();
    } catch (_) {}
  }

  Future<void> markAllRead() async {
    try {
      await _api.markAllRead(type: _type);
      ref.invalidate(notificationsProvider);
      await refresh();
    } catch (_) {}
  }

  Future<void> remove(AppNotification n) async {
    if (n.id == null) return;
    state =
        state.copyWith(items: state.items.where((e) => e.id != n.id).toList());
    try {
      await _api.delete(n.id!);
      ref.invalidate(notificationsProvider);
    } catch (_) {}
  }

  Future<void> denied(AppNotification n) async {
    try {
      await _api.denied(tablename: n.tablename, tableId: n.tableId);
    } catch (_) {}
  }
}

final notificationsControllerProvider =
    AutoDisposeNotifierProvider<NotificationsController, NotificationsState>(
        NotificationsController.new);
