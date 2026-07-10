import 'package:freezed_annotation/freezed_annotation.dart';

import 'user.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

/// Payload of `/api_agent/login` and `/login_otp.json` (after envelope unwrap).
@freezed
abstract class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    @Default('') String token,
    User? user,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
