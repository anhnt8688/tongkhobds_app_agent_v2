import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_exception.dart';

/// Logs every API call (method, full URL, query params, body) and its
/// response/error. Active only in debug builds; never logs the bearer token.
class LoggingInterceptor extends Interceptor {
  const LoggingInterceptor();

  static const _startKey = '_logStart';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      options.extra[_startKey] = DateTime.now().millisecondsSinceEpoch;
      final url = '${options.baseUrl}${options.path}';
      debugPrint('┌─ → ${options.method} $url');
      if (options.queryParameters.isNotEmpty) {
        debugPrint('│  query: ${_fmt(options.queryParameters)}');
      }
      if (options.data != null) {
        debugPrint('│  body: ${_body(options.data)}');
      }
      debugPrint('└─ auth: ${options.headers.containsKey('Authorization') ? 'Bearer ✓' : 'none'}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      final ms = _elapsed(response.requestOptions);
      final path = response.requestOptions.path;
      debugPrint('← ${response.statusCode} $path (${ms}ms)');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      final ms = _elapsed(err.requestOptions);
      final path = err.requestOptions.path;
      final code = err.response?.statusCode;
      final msg = err.error is ApiException
          ? (err.error as ApiException).message
          : err.message;
      debugPrint('✖ ${code ?? '-'} ${err.requestOptions.method} $path (${ms}ms) → $msg');
    }
    handler.next(err);
  }

  int _elapsed(RequestOptions o) {
    final start = o.extra[_startKey];
    if (start is int) return DateTime.now().millisecondsSinceEpoch - start;
    return 0;
  }

  String _fmt(Map<String, dynamic> m) {
    try {
      return jsonEncode(m);
    } catch (_) {
      return m.toString();
    }
  }

  String _body(Object? data) {
    if (data is FormData) {
      final fields = {for (final f in data.fields) f.key: f.value};
      final files = data.files.map((f) => f.key).toList();
      return 'FormData fields=$fields files=$files';
    }
    try {
      final s = jsonEncode(data);
      return s.length > 1000 ? '${s.substring(0, 1000)}…' : s;
    } catch (_) {
      return data.toString();
    }
  }
}
