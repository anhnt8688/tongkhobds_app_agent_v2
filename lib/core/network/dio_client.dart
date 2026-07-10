import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../storage/token_storage.dart';
import 'api_exception.dart';
import 'auth_interceptor.dart';
import 'envelope_interceptor.dart';
import 'logging_interceptor.dart';
import 'session_signal.dart';

/// Provides the configured [Dio] instance shared by all API clients.
final dioProvider = Provider<Dio>((ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);

  // Rebuilds whenever the active domain changes (in-app domain switcher).
  final baseUrl = ref.watch(domainProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      sendTimeout: AppConfig.sendTimeout,
      responseType: ResponseType.json,
    ),
  );

  dio.interceptors.addAll([
    AuthInterceptor(tokenStorage),
    const EnvelopeInterceptor(),
    const LoggingInterceptor(),
    InterceptorsWrapper(
      onError: (err, handler) {
        final error = err.error;
        final unauthorized = err.response?.statusCode == 401 ||
            (error is ApiException && error.unauthorized);
        // Only signal an expired session when we actually had a token, so the
        // login screen's own auth failures don't trigger a redirect loop.
        if (unauthorized && tokenStorage.hasToken) {
          ref.read(sessionExpiredProvider.notifier).state++;
        }
        handler.next(err);
      },
    ),
  ]);

  return dio;
});
