import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/auth_validators.dart';
import '../../../core/utils/device_info.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/custom_app_bar.dart';
import 'controllers/auth_controller.dart';

/// OTP login/verify. When [phone] is supplied the code is sent on open and the
/// screen shows the v1 pin-entry layout; otherwise it first asks for the phone.
class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key, this.phone, this.isSignup = false});

  final String? phone;
  final bool isSignup;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _phoneCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  bool _codeSent = false;
  bool _loading = false;
  String? _error;
  int _countdown = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final handoff = widget.phone?.trim() ?? '';
    if (handoff.isNotEmpty) {
      _phoneCtrl.text = handoff;
      WidgetsBinding.instance.addPostFrameCallback((_) => _sendOtp());
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phoneCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

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

  Future<void> _sendOtp() async {
    final phone = _phoneCtrl.text.trim();
    if (!isValidVietnamPhone(phone)) {
      setState(() => _error =
          'Số điện thoại không đúng định dạng. Vui lòng nhập 10 chữ số, bắt đầu bằng 0 hoặc +84.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final deviceId = await getDeviceId();
      await ref.read(authControllerProvider.notifier).sendOtp(phone, deviceId);
      _otpCtrl.clear();
      setState(() => _codeSent = true);
      _startCountdown(60);
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _verify() async {
    final otp = _otpCtrl.text.trim();
    if (otp.length != 6) {
      setState(() => _error = 'Vui lòng nhập đủ 6 số OTP');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref
          .read(authControllerProvider.notifier)
          .verifyOtp(_phoneCtrl.text.trim(), otp);
      if (mounted) {
        AppToast.success(
          context,
          widget.isSignup ? 'Đăng kí thành công' : 'Đăng nhập thành công',
        );
      }
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: const CustomAppBar(),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _codeSent ? _codeStep() : _phoneStep(),
          ),
        ),
      ),
    );
  }

  // Fallback phone-entry step (standalone OTP login, no handoff).
  List<Widget> _phoneStep() => [
        Text('Xác thực số điện thoại', style: AppTextStyles.bold(28)),
        const SizedBox(height: 4),
        Text('Chúng tôi sẽ gửi mã OTP tới số điện thoại của bạn',
            style: AppTextStyles.regular(17, color: AppColors.neutral400)),
        const SizedBox(height: 36),
        AppTextField(
          label: 'Số điện thoại',
          controller: _phoneCtrl,
          hint: 'Nhập số điện thoại',
          keyboardType: TextInputType.phone,
        ),
        if (_error != null) ...[
          const SizedBox(height: 8),
          Text(_error!, style: AppTextStyles.regular(13, color: AppColors.danger)),
        ],
        const SizedBox(height: 16),
        AppButton(label: 'Gửi mã OTP', loading: _loading, onPressed: _sendOtp),
      ];

  // v1 pin-entry step.
  List<Widget> _codeStep() {
    final phone = _phoneCtrl.text.trim();
    return [
      Text('Nhập mã OTP', style: AppTextStyles.bold(28)),
      const SizedBox(height: 4),
      Text.rich(
        TextSpan(
          style: AppTextStyles.regular(17, color: AppColors.neutral400),
          children: [
            const TextSpan(text: 'Mã OTP đã gửi tới '),
            TextSpan(
                text: phone,
                style: AppTextStyles.semibold(17, color: AppColors.neutral400)),
            const TextSpan(text: '\nVui lòng nhập mã để xác minh'),
          ],
        ),
      ),
      const SizedBox(height: 36),
      Text('Mã OTP', style: AppTextStyles.bold(13, color: AppColors.neutral400)),
      const SizedBox(height: 12),
      Center(child: _pinput()),
      if (_error != null) ...[
        const SizedBox(height: 8),
        Text(_error!, style: AppTextStyles.regular(13, color: AppColors.danger)),
      ],
      const SizedBox(height: 12),
      AppButton(
        label: widget.isSignup ? 'Đăng kí' : 'Đăng nhập',
        loading: _loading,
        onPressed: _verify,
      ),
      const SizedBox(height: 12),
      Center(child: _resend()),
    ];
  }

  Widget _pinput() {
    final base = PinTheme(
      width: 50,
      height: 55,
      textStyle: AppTextStyles.semibold(17),
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
    );
    return Pinput(
      length: 6,
      controller: _otpCtrl,
      defaultPinTheme: base,
      focusedPinTheme: base.copyBorderWith(
          border: Border.all(color: AppColors.primary)),
      errorPinTheme: base.copyBorderWith(
          border: Border.all(color: AppColors.danger)),
      onChanged: (_) {
        if (_error != null) setState(() => _error = null);
      },
      onCompleted: (_) => _verify(),
    );
  }

  Widget _resend() {
    if (_countdown > 0) {
      return Text.rich(
        TextSpan(
          style: AppTextStyles.regular(15, color: AppColors.neutral400),
          children: [
            const TextSpan(text: 'Gửi lại mã OTP trong '),
            TextSpan(
                text: '${_countdown}s',
                style: AppTextStyles.semibold(15, color: AppColors.text)),
          ],
        ),
      );
    }
    return GestureDetector(
      onTap: _loading ? null : _sendOtp,
      child: Text('Gửi lại mã',
          style: AppTextStyles.semibold(15, color: AppColors.primary)),
    );
  }
}
