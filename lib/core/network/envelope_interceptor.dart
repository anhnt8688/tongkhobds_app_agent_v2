import 'dart:convert';

import 'package:dio/dio.dart';

import 'api_exception.dart';

/// Unwraps the backend envelope `{status, message, data}`.
///
/// On success (`status == 1`) the response payload is replaced with `data`.
/// On envelope error (`status == 0`) or HTTP 401 it converts the failure into
/// an [ApiException] so callers get a single, typed error type.
class EnvelopeInterceptor extends Interceptor {
  const EnvelopeInterceptor();

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Some backend endpoints (e.g. /api/cities) reply with the JSON body but a
    // `text/html` content-type, so Dio leaves `response.data` as a raw String.
    // Decode it here so every caller still gets a Map/List.
    if (response.data is String) {
      final text = (response.data as String).trim();
      if (text.startsWith('{') || text.startsWith('[')) {
        try {
          response.data = jsonDecode(text);
        } catch (_) {
          // Not JSON after all — leave the original String untouched.
        }
      }
    }

    final data = response.data;
    if (data is Map) {
      final status = data['status'];
      final message = (data['message'] ?? '').toString();
      // status may arrive as int or string depending on endpoint.
      final isError = status == 0 || status == '0';
      if (isError) {
        final unauthorized = _looksUnauthorized(message);
        handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
            error: ApiException(
              message.isEmpty ? 'Đã có lỗi xảy ra' : message,
              statusCode: response.statusCode,
              unauthorized: unauthorized,
            ),
          ),
        );
        return;
      }
      // Some endpoints (e.g. the referral APIs) carry their real payload in the
      // `message` key while `data` is just a flag (`data: 1`). Unwrapping to
      // `data` there would discard `message`, so callers can opt out via
      // `Options(extra: {'rawEnvelope': true})` and read the full map themselves.
      final rawEnvelope = response.requestOptions.extra['rawEnvelope'] == true;
      // Success: hand back the inner data payload.
      if (!rawEnvelope && data.containsKey('data')) {
        response.data = data['data'];
      }
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final status = err.response?.statusCode;
    final serverMessage = _extractMessage(err.response?.data);
    final apiError = ApiException(
      serverMessage ?? _defaultMessage(err),
      statusCode: status,
      unauthorized: status == 401,
    );
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: apiError,
      ),
    );
  }

  String? _extractMessage(dynamic data) {
    if (data is Map && data['message'] != null) {
      final m = data['message'].toString();
      return m.isEmpty ? null : m;
    }
    return null;
  }

  bool _looksUnauthorized(String message) {
    final m = message.toLowerCase();
    return m.contains('token') ||
        m.contains('đăng nhập') ||
        m.contains('phiên') ||
        m.contains('unauthor');
  }

  String _defaultMessage(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Kết nối quá hạn, vui lòng thử lại';
      case DioExceptionType.connectionError:
        return 'Không có kết nối mạng';
      default:
        return 'Đã có lỗi xảy ra';
    }
  }
}
