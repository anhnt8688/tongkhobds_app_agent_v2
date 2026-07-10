import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import 'models/chat_message.dart';
import 'rocket_auth_store.dart';

/// RocketChat REST API (message history, send, upload). Uses its own [Dio] with
/// the Rocket host as base URL and Rocket auth headers — it does NOT go through
/// the app's envelope/auth interceptors. On a 401 the token is refreshed once
/// and the request retried (matches v1's DDP + REST 401 handling).
class RocketRestApi {
  RocketRestApi(this._ref)
      : _dio = Dio(BaseOptions(
          baseUrl: AppConfig.rocketApi,
          connectTimeout: AppConfig.connectTimeout,
          receiveTimeout: AppConfig.receiveTimeout,
        ));

  final Ref _ref;
  final Dio _dio;

  RocketAuthStore get _store => _ref.read(rocketAuthStoreProvider);

  Future<Options> _authHeaders({bool force = false}) async {
    final auth = await _store.ensure(force: force);
    return Options(headers: {
      'X-User-Id': auth?.userId ?? '',
      'X-Auth-Token': auth?.token ?? '',
    });
  }

  /// Runs [request] with auth headers; on 401 refreshes the token once + retries.
  Future<Response> _withAuthRetry(
      Future<Response> Function(Options opts) request) async {
    try {
      return await request(await _authHeaders());
    } on DioException catch (e) {
      if (e.response?.statusCode != 401) rethrow;
      return request(await _authHeaders(force: true));
    }
  }

  /// Message history for a room, oldest→newest (Rocket returns newest first).
  Future<List<ChatMessage>> fetchHistory(String roomId) async {
    final res = await _withAuthRetry((opts) => _dio.get(
          '/groups.messages',
          queryParameters: {'roomId': roomId},
          options: opts,
        ));
    final d = res.data is Map ? res.data as Map : const {};
    final list = d['messages'] is List ? d['messages'] as List : const [];
    final msgs = list.whereType<Map>().map(ChatMessage.fromJson).toList();
    return msgs.reversed.toList();
  }

  Future<ChatMessage?> sendMessage(String roomId, String text) async {
    final res = await _withAuthRetry((opts) => _dio.post(
          '/chat.postMessage',
          data: {'roomId': roomId, 'text': text},
          options: opts,
        ));
    final d = res.data is Map ? res.data as Map : const {};
    return d['message'] is Map
        ? ChatMessage.fromJson(d['message'] as Map)
        : null;
  }

  Future<ChatMessage?> uploadFile(
      String roomId, String filePath, String fileName) async {
    final res = await _withAuthRetry((opts) async {
      final form = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
      });
      return _dio.post('/rooms.upload/$roomId', data: form, options: opts);
    });
    final d = res.data is Map ? res.data as Map : const {};
    return d['message'] is Map
        ? ChatMessage.fromJson(d['message'] as Map)
        : null;
  }
}

final rocketRestApiProvider =
    Provider<RocketRestApi>((ref) => RocketRestApi(ref));
