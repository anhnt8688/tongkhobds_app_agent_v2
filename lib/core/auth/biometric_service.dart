import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class BiometricResult {
  const BiometricResult({required this.success, this.message});
  final bool success;
  final String? message;
}

/// Biometric (vân tay / Face ID) login. v2 has no refresh-token flow, so we
/// stash the current bearer token behind the device biometric and restore it
/// on a successful prompt.
class BiometricService {
  BiometricService(this._storage);
  final FlutterSecureStorage _storage;
  final LocalAuthentication _auth = LocalAuthentication();

  static const _enabledKey = 'biometric_enabled';
  static const _tokenKey = 'biometric_token';
  // One-time flag: whether a staff user was already asked to enable biometrics.
  static const _promptedKey = 'biometric_prompted';

  /// Whether the staff biometric opt-in prompt has been shown before.
  Future<bool> wasPrompted() async =>
      (await _storage.read(key: _promptedKey)) == '1';

  Future<void> markPrompted() async =>
      _storage.write(key: _promptedKey, value: '1');

  /// Device supports + has an enrolled biometric.
  Future<bool> isAvailable() async {
    try {
      final supported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      if (!supported || !canCheck) return false;
      final types = await _auth.getAvailableBiometrics();
      return types.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<BiometricResult> authenticate(
      {String reason = 'Xác thực để đăng nhập'}) async {
    try {
      final ok = await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      return BiometricResult(success: ok);
    } on PlatformException catch (e) {
      return BiometricResult(success: false, message: _mapError(e));
    } catch (_) {
      return const BiometricResult(
          success: false, message: 'Xác thực sinh trắc thất bại.');
    }
  }

  Future<bool> isEnabled() async =>
      (await _storage.read(key: _enabledKey)) == '1';

  Future<bool> hasToken() async =>
      (await _storage.read(key: _tokenKey))?.isNotEmpty ?? false;

  Future<String?> savedToken() => _storage.read(key: _tokenKey);

  /// Enable biometric login by stashing the active bearer token.
  Future<void> enable(String token) async {
    await _storage.write(key: _enabledKey, value: '1');
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<void> disable() async {
    await _storage.delete(key: _enabledKey);
    await _storage.delete(key: _tokenKey);
  }

  String _mapError(PlatformException e) {
    switch (e.code) {
      case 'NotAvailable':
      case 'notAvailable':
        return 'Thiết bị không hỗ trợ sinh trắc học.';
      case 'NotEnrolled':
      case 'notEnrolled':
        return 'Chưa thiết lập vân tay/Face ID trên thiết bị.';
      case 'LockedOut':
      case 'lockedOut':
        return 'Sinh trắc học bị khóa tạm thời, thử lại sau.';
      case 'PermanentlyLockedOut':
      case 'permanentlyLockedOut':
        return 'Sinh trắc học bị khóa. Vui lòng dùng mật khẩu/OTP.';
      case 'PasscodeNotSet':
      case 'passcodeNotSet':
        return 'Thiết bị chưa đặt mật khẩu màn hình.';
      default:
        return 'Xác thực sinh trắc thất bại. Vui lòng thử lại.';
    }
  }
}

final biometricServiceProvider = Provider<BiometricService>(
    (ref) => BiometricService(const FlutterSecureStorage()));
