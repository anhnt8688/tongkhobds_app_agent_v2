import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/chat_api.dart';
import '../../data/models/chat_message.dart';
import '../../data/models/chat_room.dart';
import '../../data/rocket_auth_store.dart';
import '../../data/rocket_realtime_service.dart';

/// Inbox state: two tabs (Tư vấn / Giao dịch) of conversations plus realtime
/// unread/preview updates.
class InboxState {
  const InboxState({
    this.tab = 0,
    this.consult = const [],
    this.transaction = const [],
    this.loading = true,
    this.error,
  });

  final int tab; // 0 = Tư vấn, 1 = Giao dịch
  final List<ChatRoom> consult;
  final List<ChatRoom> transaction;
  final bool loading;
  final String? error;

  List<ChatRoom> get current => tab == 0 ? consult : transaction;

  InboxState copyWith({
    int? tab,
    List<ChatRoom>? consult,
    List<ChatRoom>? transaction,
    bool? loading,
    String? error,
    bool clearError = false,
  }) =>
      InboxState(
        tab: tab ?? this.tab,
        consult: consult ?? this.consult,
        transaction: transaction ?? this.transaction,
        loading: loading ?? this.loading,
        error: clearError ? null : (error ?? this.error),
      );
}

class InboxController extends AutoDisposeNotifier<InboxState> {
  ChatApi get _api => ref.read(chatApiProvider);
  RocketRealtimeService get _rt => ref.read(rocketRealtimeProvider);
  String? get _myUserId => ref.read(rocketAuthStoreProvider).current?.userId;
  String? get _myUsername => ref.read(rocketAuthStoreProvider).current?.username;

  StreamSubscription<ChatMessage>? _sub;
  String? _activeRoomId;

  @override
  InboxState build() {
    _sub = _rt.messages.listen(_onMessage);
    ref.onDispose(() => _sub?.cancel());
    Future.microtask(refresh);
    return const InboxState();
  }

  Future<void> refresh() async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      final results = await Future.wait([
        _api.fetchConsultRooms(),
        _api.fetchTransactionRooms(),
      ]);
      state = state.copyWith(
          consult: results[0], transaction: results[1], loading: false);
      await _subscribeAll();
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  void setTab(int tab) {
    if (tab != state.tab) state = state.copyWith(tab: tab);
  }

  /// Mark a room active (its screen is open) so realtime doesn't bump unread.
  void enter(String? roomId) {
    _activeRoomId = roomId;
    if (roomId != null) markSeen(roomId);
  }

  void leave(String? roomId) {
    if (_activeRoomId == roomId) _activeRoomId = null;
  }

  Future<void> markSeen(String roomId) async {
    _mutateRoom(roomId, (r) => r.copyWith(countMiss: 0));
    final user = _myUsername;
    if (user != null) {
      try {
        await _api.resetUnread(roomId, user);
      } catch (_) {}
    }
  }

  Future<void> _subscribeAll() async {
    for (final r in [...state.consult, ...state.transaction]) {
      final id = r.roomId;
      if (id != null && id.isNotEmpty) await _rt.subscribeToRoom(id);
    }
  }

  void _onMessage(ChatMessage m) {
    final roomId = m.rid;
    if (roomId == null) return;
    final fromSelf = m.user?.id != null && m.user?.id == _myUserId;
    final active = roomId == _activeRoomId;
    _mutateRoom(roomId, (r) => r.copyWith(
          messageContent: m.msg,
          messageTime: m.ts,
          countMiss: (fromSelf || active) ? r.countMiss : r.countMiss + 1,
        ));
  }

  /// Applies [f] to the room with [roomId] in whichever tab holds it.
  void _mutateRoom(String roomId, ChatRoom Function(ChatRoom) f) {
    List<ChatRoom> apply(List<ChatRoom> list) => list
        .map((r) => r.roomId == roomId ? f(r) : r)
        .toList();
    state = state.copyWith(
      consult: apply(state.consult),
      transaction: apply(state.transaction),
    );
  }
}

final inboxControllerProvider =
    AutoDisposeNotifierProvider<InboxController, InboxState>(
        InboxController.new);
