import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/auth_validators.dart';
import '../../../core/utils/device_info.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/app_toast.dart';
import '../data/auth_api.dart';

/// Forgot-password reset flow as a single 3-step screen:
/// phone → OTP → new password. Runs entirely against [AuthApi] so the global
/// auth state stays logged out (the OTP token is held locally and passed
/// explicitly to `create_new_password`), avoiding a router bounce to /home.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _phone = TextEditingController();
  final _otp = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();

  int _step = 0; // 0 = phone, 1 = otp, 2 = new password
  bool _loading = false;
  String? _error;
  String? _token; // OTP token, used to authorize create_new_password
  int _countdown = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _phone.dispose();
    _otp.dispose();
    _pass.dispose();
    _confirm.dispose();
    super.dispose();
  }

  AuthApi get _api => ref.read(authApiProvider);

  void _startCountdown(int seconds) {
    _timer?.cancel();
    setState(() => _countdown = seconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown <= 1) {
        t.cancel();
        setState(() => _countdown = 0);
      } else {
        setState(() => _countdown--);
      }
    });
  }

  /// Runs an async action with shared loading/error handling.
  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await action();
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) setState(() => _error = 'Đã có lỗi xảy ra, vui lòng thử lại');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _sendOtp() async {
    final phone = _phone.text.trim();
    if (!isValidVietnamPhone(phone)) {
      setState(() => _error =
          'Số điện thoại không đúng định dạng. Vui lòng nhập 10 chữ số, bắt đầu bằng 0 hoặc +84.');
      return;
    }
    await _run(() async {
      await _api.sendOtp(phone: phone, deviceId: await getDeviceId());
      if (mounted) setState(() => _step = 1);
      _startCountdown(60);
    });
  }

  Future<void> _resendOtp() async {
    _otp.clear();
    await _run(() async {
      await _api.sendOtp(phone: _phone.text.trim(), deviceId: await getDeviceId());
      _startCountdown(60);
    });
  }

  Future<void> _verifyOtp() async {
    final otp = _otp.text.trim();
    if (otp.length != 6) {
      setState(() => _error = 'Vui lòng nhập đủ 6 số OTP');
      return;
    }
    await _run(() async {
      final res = await _api.verifyOtp(phone: _phone.text.trim(), otp: otp);
      if (res.token.isEmpty) {
        throw ApiException('Mã xác thực không đúng hoặc đã hết hạn.');
      }
      if (mounted) {
        setState(() {
          _token = res.token;
          _step = 2;
        });
      }
    });
  }

  Future<void> _submitNewPassword() async {
    final pass = _pass.text.trim();
    if (!isValidPassword(pass)) {
      setState(() => _error =
          'Mật khẩu phải chứa ít nhất 6 kí tự, ngắn hơn 15 kí tự, gồm chữ và số.');
      return;
    }
    if (_confirm.text.trim() != pass) {
      setState(() => _error =
          'Trường “Xác nhận mật khẩu” phải trùng khớp với trường “Mật khẩu”.');
      return;
    }
    await _run(() async {
      await _api.createNewPassword(newPassword: pass, token: _token ?? '');
      if (!mounted) return;
      AppToast.success(context, 'Tạo mật khẩu thành công');
      context.go('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    final (title, subtitle) = switch (_step) {
      0 => ('Đặt lại mật khẩu', 'Nhập số điện thoại để nhận mã xác thực'),
      1 => ('Nhập mã xác thực', 'Mã OTP đã gửi tới ${_phone.text.trim()}'),
      _ => ('Mật khẩu mới', 'Thiết lập mật khẩu mới cho tài khoản'),
    };

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: CustomAppBar(title: 'Quên mật khẩu'),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.bold(28)),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: AppTextStyles.regular(17, color: AppColors.neutral400)),
              const SizedBox(height: 36),
              ..._stepFields(),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(
                  _error!,
                  style: AppTextStyles.regular(13, color: AppColors.danger),
                ),
              ],
              const SizedBox(height: 24),
              ..._stepActions(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _stepFields() {
    switch (_step) {
      case 0:
        return [
          AppTextField(
            label: 'Số điện thoại',
            controller: _phone,
            hint: 'Nhập số điện thoại',
            keyboardType: TextInputType.phone,
          ),
        ];
      case 1:
        return [
          AppTextField(
            label: 'Mã OTP',
            controller: _otp,
            hint: 'Nhập 6 chữ số',
            keyboardType: TextInputType.number,
          ),
        ];
      default:
        return [
          AppTextField(
            label: 'Mật khẩu mới',
            controller: _pass,
            hint: 'Nhập mật khẩu mới',
            obscureText: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Xác nhận mật khẩu',
            controller: _confirm,
            hint: 'Nhập lại mật khẩu mới',
            obscureText: true,
          ),
        ];
    }
  }

  List<Widget> _stepActions() {
    switch (_step) {
      case 0:
        return [
          AppButton(
            label: 'Gửi mã xác thực',
            loading: _loading,
            onPressed: _sendOtp,
          ),
        ];
      case 1:
        return [
          AppButton(label: 'Xác nhận', loading: _loading, onPressed: _verifyOtp),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: (_loading || _countdown > 0) ? null : _resendOtp,
              child: Text(
                _countdown > 0 ? 'Gửi lại mã sau ${_countdown}s' : 'Gửi lại mã',
              ),
            ),
          ),
        ];
      default:
        return [
          AppButton(
            label: 'Đặt lại mật khẩu',
            loading: _loading,
            onPressed: _submitNewPassword,
          ),
        ];
    }
  }
}
