import 'dart:async';

import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/chat_api.dart';
import '../../data/models/chat_message.dart';
import '../../data/rocket_auth_store.dart';
import '../../data/rocket_message_mapper.dart';
import '../../data/rocket_realtime_service.dart';
import '../../data/rocket_rest_api.dart';

/// Navigation args for a chat room (from the inbox tile or a deep link).
class ChatRoomArgs {
  const ChatRoomArgs({
    this.roomId,
    this.name,
    this.botId,
    this.projectId = 0,
    this.initialContent,
  });

  final String? roomId;
  final String? name;
  final String? botId;
  final int projectId;
  final String? initialContent;

  @override
  bool operator ==(Object other) =>
      other is ChatRoomArgs &&
      other.roomId == roomId &&
      other.name == name &&
      other.botId == botId &&
      other.projectId == projectId;

  @override
  int get hashCode => Object.hash(roomId, name, botId, projectId);
}

class ChatRoomState {
  const ChatRoomState({this.loading = true, this.roomId, this.error});
  final bool loading;
  final String? roomId;
  final String? error;

  ChatRoomState copyWith({bool? loading, String? roomId, String? error}) =>
      ChatRoomState(
        loading: loading ?? this.loading,
        roomId: roomId ?? this.roomId,
        error: error,
      );
}

class ChatRoomController
    extends AutoDisposeFamilyNotifier<ChatRoomState, ChatRoomArgs> {
  final InMemoryChatController chatController = InMemoryChatController();
  RocketMessageMapper _mapper = const RocketMessageMapper(null);
  StreamSubscription<ChatMessage>? _sub;
  String? _roomId;

  RocketRestApi get _rest => ref.read(rocketRestApiProvider);
  RocketRealtimeService get _rt => ref.read(rocketRealtimeProvider);
  String get myUserId => ref.read(rocketAuthStoreProvider).current?.userId ?? '';

  @override
  ChatRoomState build(ChatRoomArgs args) {
    ref.onDispose(() {
      _sub?.cancel();
      chatController.dispose();
    });
    Future.microtask(() => _init(args));
    return const ChatRoomState();
  }

  Future<void> _init(ChatRoomArgs args) async {
    try {
      final auth = await ref.read(rocketAuthStoreProvider).ensure();
      _mapper = RocketMessageMapper(auth);

      var roomId = args.roomId;
      if (roomId == null || roomId.isEmpty) {
        roomId = await ref.read(chatApiProvider).createRoom(
              name: args.name ?? '',
              botId: args.botId,
              projectId: args.projectId,
            );
      }
      if (roomId == null || roomId.isEmpty) {
        state = state.copyWith(loading: false, error: 'Không mở được phòng chat');
        return;
      }
      _roomId = roomId;

      final history = await _rest.fetchHistory(roomId);
      await chatController.setMessages(history.map(_mapper.toUi).toList());

      await _rt.subscribeToRoom(roomId);
      _sub = _rt.messages.listen(_onRemote);

      final username = auth?.username;
      if (username != null) {
        unawaited(ref.read(chatApiProvider).resetUnread(roomId, username));
      }
      state = state.copyWith(loading: false, roomId: roomId);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  void _onRemote(ChatMessage m) {
    if (m.rid != _roomId) return;
    if (m.user?.id != null && m.user?.id == myUserId) return; // own echo
    chatController.insertMessage(_mapper.toUi(m));
  }

  /// Sends text optimistically (sending → sent / error).
  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _roomId == null) return;
    final local = TextMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      authorId: myUserId,
      text: trimmed,
      createdAt: DateTime.now(),
      status: MessageStatus.sending,
    );
    await chatController.insertMessage(local);
    try {
      final server = await _rest.sendMessage(_roomId!, trimmed);
      await chatController.updateMessage(
        local,
        local.copyWith(
          id: server?.id ?? local.id,
          createdAt: RocketMessageMapper.tryTs(server?.ts) ?? local.createdAt,
          status: MessageStatus.sent,
        ),
      );
    } catch (_) {
      await chatController.updateMessage(
        local,
        local.copyWith(status: MessageStatus.error, failedAt: DateTime.now()),
      );
    }
  }

  Future<void> retry(TextMessage failed) async {
    await chatController.removeMessage(failed);
    await send(failed.text);
  }

  /// Uploads a picked file and shows the returned message.
  Future<void> sendFile(String path, String name) async {
    if (_roomId == null) return;
    try {
      final msg = await _rest.uploadFile(_roomId!, path, name);
      if (msg != null) await chatController.insertMessage(_mapper.toUi(msg));
    } catch (_) {}
  }
}

final chatRoomControllerProvider = AutoDisposeNotifierProviderFamily<
    ChatRoomController, ChatRoomState, ChatRoomArgs>(ChatRoomController.new);
