import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../core/config/app_config.dart';
import 'models/chat_message.dart';
import 'rocket_auth_store.dart';

/// RocketChat realtime over DDP (WebSocket). Connects, logs in with the resume
/// token, subscribes to `stream-room-messages` per room, and exposes incoming
/// messages as a broadcast [Stream]. Auto-reconnects and refreshes the token on
/// a login 401 (ported from v1 `RocketChatRealtimeService`).
class RocketRealtimeService {
  RocketRealtimeService(this._ref);

  final Ref _ref;
  WebSocketChannel? _channel;
  String? _token;

  final _messages = StreamController<ChatMessage>.broadcast();
  final Set<String> _rooms = {};
  Completer<void>? _loginCompleter;
  bool _shouldReconnect = true;
  bool _reconnecting = false;
  bool _refreshingToken = false;

  /// Incoming room messages (all subscribed rooms; filter by `rid` downstream).
  Stream<ChatMessage> get messages => _messages.stream;

  Future<void> get _ready => _loginCompleter?.future ?? Future.value();

  /// Opens the socket and logs in (no-op if already connecting/connected).
  Future<void> connect() async {
    final auth = await _ref.read(rocketAuthStoreProvider).ensure();
    _token = auth?.token;
    if (_token == null || _token!.isEmpty) return;
    _shouldReconnect = true;
    _openSocket();
  }

  void _openSocket() {
    try {
      _channel?.sink.close(status.goingAway);
    } catch (_) {}
    _loginCompleter = Completer<void>();

    final ch = WebSocketChannel.connect(Uri.parse(AppConfig.rocketWs));
    _channel = ch;
    ch.stream.listen(
      _onFrame,
      onDone: _onDisconnect,
      onError: (_) => _onDisconnect(),
    );
    _send({'msg': 'connect', 'version': '1', 'support': ['1', 'pre2', 'pre1']});
  }

  Future<void> _onFrame(dynamic raw) async {
    final data = jsonDecode(raw as String);
    if (data is! Map) return;

    switch (data['msg']) {
      case 'ping':
        _send({'msg': 'pong'});
        return;
      case 'connected':
        _login();
        return;
      case 'result':
        if (data['id'] == '1') await _onLoginResult(data);
        return;
      case 'changed':
        if (data['collection'] == 'stream-room-messages') {
          final m = data['fields']?['args']?[0];
          if (m is Map) _messages.add(ChatMessage.fromJson(m));
        }
        return;
    }
  }

  Future<void> _onLoginResult(Map data) async {
    if (data['error'] != null) {
      await _refreshTokenAndRelogin(data['error']);
      return;
    }
    if (!(_loginCompleter?.isCompleted ?? true)) _loginCompleter!.complete();
    for (final rid in _rooms) {
      _send(_subFrame(rid));
    }
  }

  Future<void> _refreshTokenAndRelogin(Object? err) async {
    if (_refreshingToken) return;
    _refreshingToken = true;
    try {
      final auth = await _ref.read(rocketAuthStoreProvider).ensure(force: true);
      if (auth?.token != null && auth!.token!.isNotEmpty) {
        _token = auth.token;
        _login();
      } else {
        debugPrint('Rocket DDP re-login failed: $err');
      }
    } finally {
      _refreshingToken = false;
    }
  }

  void _login() => _send({
        'msg': 'method',
        'method': 'login',
        'id': '1',
        'params': [
          {'resume': _token},
        ],
      });

  Map<String, dynamic> _subFrame(String roomId) => {
        'msg': 'sub',
        'id': 'sub-$roomId',
        'name': 'stream-room-messages',
        'params': [roomId, false],
      };

  /// Subscribes to a room's message stream (connects/logs in first if needed).
  Future<void> subscribeToRoom(String roomId) async {
    if (roomId.isEmpty || _rooms.contains(roomId)) return;
    _rooms.add(roomId);
    if (_channel == null) await connect();
    await _ready;
    _send(_subFrame(roomId));
  }

  void _onDisconnect() {
    _channel = null;
    if (!_shouldReconnect || _reconnecting) return;
    _reconnecting = true;
    Future.delayed(const Duration(seconds: 2), () {
      _reconnecting = false;
      if (_shouldReconnect) _openSocket();
    });
  }

  void _send(Map<String, dynamic> data) => _channel?.sink.add(jsonEncode(data));

  void dispose() {
    _shouldReconnect = false;
    try {
      _channel?.sink.close(status.normalClosure);
    } catch (_) {}
    _channel = null;
    _rooms.clear();
    _messages.close();
  }
}

final rocketRealtimeProvider = Provider<RocketRealtimeService>((ref) {
  final svc = RocketRealtimeService(ref);
  ref.onDispose(svc.dispose);
  return svc;
});
