import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/auth_interceptor.dart';
import '../../../core/network/dio_client.dart';
import 'models/login_response.dart';
import 'models/user.dart';

/// Thin wrapper over the auth endpoints. Responses are already envelope-unwrapped
/// by [EnvelopeInterceptor], so `response.data` is the inner `data` payload.
class AuthApi {
  AuthApi(this._dio);

  final Dio _dio;

  static final _skipAuth = Options(extra: {AuthInterceptor.skipAuthKey: true});

  Future<LoginResponse> login({
    required String userName,
    required String password,
  }) async {
    final res = await _dio.get(
      '${AppConfig.agent}/login',
      queryParameters: {'user_name': userName, 'password': password},
      options: _skipAuth,
    );
    return LoginResponse.fromJson(_asMap(res.data));
  }

  /// Register a new agent account — `register.json`. Body keys mirror v1:
  /// phone, fullname, password, city_id, district_id, ward_id, address, email,
  /// birthday, yoe. On success the backend sends an OTP to verify.
  Future<void> register(Map<String, dynamic> data) async {
    await _dio.post('${AppConfig.agent}/register.json',
        data: data, options: _skipAuth);
  }

  Future<void> sendOtp({required String phone, required String deviceId}) async {
    await _dio.get(
      '${AppConfig.agent}/send_otp.json',
      queryParameters: {'phone': phone, 'id_device': deviceId},
      options: _skipAuth,
    );
  }

  Future<LoginResponse> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    final res = await _dio.get(
      '${AppConfig.agent}/login_otp.json',
      queryParameters: {'phone': phone, 'otp': otp},
      options: _skipAuth,
    );
    return LoginResponse.fromJson(_asMap(res.data));
  }

  /// Resets the password after an OTP verification in the forgot-password flow.
  /// The OTP token is passed explicitly (not via [TokenStorage]) so the global
  /// session stays logged out during the reset.
  Future<void> createNewPassword({
    required String newPassword,
    required String token,
  }) async {
    await _dio.post(
      '${AppConfig.agent}/create_new_password',
      data: {'new_password': newPassword},
      options: Options(
        extra: {AuthInterceptor.skipAuthKey: true},
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  }

  Future<User> getUserProfile() async {
    final res = await _dio.get('${AppConfig.agent}/get_user_profile.json');
    final data = _asMap(res.data);
    final profile = data['user_profile'] ?? data['user'] ?? data;
    return User.fromJson(_asMap(profile));
  }

  Future<void> logout() async {
    await _dio.get('${AppConfig.agent}/logout.json');
  }

  Map<String, dynamic> _asMap(Object? data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return <String, dynamic>{};
  }
}

final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi(ref.watch(dioProvider));
});
