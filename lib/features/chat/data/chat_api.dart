import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import 'models/chat_room.dart';
import 'models/rocket_auth.dart';

/// App-backend (Web2py) calls that back the chat feature: conversation lists,
/// room creation, RocketChat token, and unread reset. These endpoints put their
/// payload in the envelope's `message` field, so we opt out of unwrapping with
/// `rawEnvelope` and read `message` ourselves (matches v1).
class ChatApi {
  ChatApi(this._dio);
  final Dio _dio;

  String get _a => AppConfig.agent;
  String get _g => AppConfig.global;
  Options get _raw => Options(extra: const {'rawEnvelope': true});

  /// Tab "Tư vấn" — support/admin conversations (`get_list_message`).
  Future<List<ChatRoom>> fetchConsultRooms() =>
      _fetchRooms('$_a/get_list_message.json');

  /// Tab "Giao dịch" — transaction/project conversations (`get_list_message_transaction`).
  Future<List<ChatRoom>> fetchTransactionRooms() =>
      _fetchRooms('$_a/get_list_message_transaction.json');

  Future<List<ChatRoom>> _fetchRooms(String path) async {
    final res = await _dio.get(path, options: _raw);
    final d = res.data is Map ? res.data as Map : const {};
    final list = d['message'] is List ? d['message'] as List : const [];
    return list.whereType<Map>().map(ChatRoom.fromJson).toList();
  }

  /// Creates (or joins) a room for a support bot / project; returns its roomId.
  Future<String?> createRoom({
    required String name,
    String? botId,
    int projectId = 0,
  }) async {
    final res = await _dio.post(
      '$_a/create_project_group.json',
      data: {'project_name': name, 'id_bot': botId, 'project_id': projectId},
      options: _raw,
    );
    final d = res.data is Map ? res.data as Map : const {};
    final msg = d['message'] is Map ? d['message'] as Map : const {};
    return msg['room_id']?.toString();
  }

  /// Fetches fresh RocketChat credentials (`refresh_token_rocket`).
  Future<RocketAuth?> fetchRocketToken() async {
    final res = await _dio.get('$_a/refresh_token_rocket.json', options: _raw);
    final d = res.data is Map ? res.data as Map : const {};
    final msg = d['message'];
    if (msg is! Map) return null;
    final auth = RocketAuth.fromJson(msg);
    return auth.isValid ? auth : null;
  }

  /// Marks a room as read on the backend (`webhook_rocket`), clearing unread.
  Future<void> resetUnread(String roomId, String userName) async {
    await _dio.post(
      '$_g/webhook_rocket.json',
      data: {
        'channel_id': roomId,
        'user_name': userName,
        'message_refresh': true,
      },
      options: _raw,
    );
  }
}

final chatApiProvider =
    Provider<ChatApi>((ref) => ChatApi(ref.watch(dioProvider)));
