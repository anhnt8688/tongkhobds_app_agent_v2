import 'package:dio/dio.dart';

import '../storage/token_storage.dart';

/// Injects `Authorization: Bearer <token>` on every request that opts in.
///
/// Public endpoints (login, OTP, register, forgot password) pass
/// `extra: {AuthInterceptor.skipAuthKey: true}` to skip token injection.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStorage);

  static const String skipAuthKey = 'skipAuth';

  final TokenStorage _tokenStorage;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final skip = options.extra[skipAuthKey] == true;
    final token = _tokenStorage.current;
    if (!skip && token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    // GET/DELETE should not carry a content-type body header.
    final method = options.method.toUpperCase();
    if (method == 'GET' || method == 'DELETE') {
      options.headers.remove(Headers.contentTypeHeader);
    }
    handler.next(options);
  }
}
