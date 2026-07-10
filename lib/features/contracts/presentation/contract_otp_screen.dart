import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/custom_screen.dart';
import '../../auth/presentation/controllers/auth_controller.dart';
import '../data/contracts_api.dart';
import 'widgets/otp_code_field.dart';

/// Contract signing OTP (v1 contract `OtpPage`): auto-sends a Zalo OTP with a
/// resend countdown, verifies it, then uploads the signature and creates the
/// contract before routing to the success screen.
class ContractOtpScreen extends ConsumerStatefulWidget {
  const ContractOtpScreen({
    super.key,
    required this.phone,
    required this.signature,
    this.infoOffice = 1,
  });

  final String phone;
  final Uint8List? signature;
  final int infoOffice;

  @override
  ConsumerState<ContractOtpScreen> createState() => _ContractOtpScreenState();
}

class _ContractOtpScreenState extends ConsumerState<ContractOtpScreen> {
  final _otpCtrl = TextEditingController();
  bool _busy = false;
  bool _error = false;
  int _countdown = 0;
  Timer? _timer;

  ContractsApi get _api => ref.read(contractsApiProvider);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _sendOtp());
  }

  @override
  void dispose() {
    _timer?.cancel();
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
    try {
      await _api.sendOtp(widget.phone, channel: 'zalo');
      _otpCtrl.clear();
      _startCountdown(60);
    } on ApiException catch (e) {
      if (mounted) AppToast.error(context, e.message);
    }
  }

  Future<void> _verify() async {
    final code = _otpCtrl.text.trim();
    if (code.length != 6) {
      setState(() => _error = true);
      AppToast.error(context, 'Vui lòng nhập đủ 6 số OTP');
      return;
    }
    final sig = widget.signature;
    if (sig == null || sig.isEmpty) {
      AppToast.error(context, 'Thiếu chữ ký. Vui lòng ký trước khi xác thực.');
      return;
    }

    setState(() {
      _busy = true;
      _error = false;
    });
    try {
      final ok = await _api.verifyOtp(widget.phone, code);
      if (!mounted) return;
      if (!ok) {
        setState(() => _error = true);
        AppToast.error(context, 'Mã xác thực không đúng hoặc đã hết hạn.');
        return;
      }

      final signatureUrl = await _api.uploadSignature(sig);
      if (signatureUrl == null || signatureUrl.isEmpty) {
        if (mounted) AppToast.error(context, 'Upload chữ ký thất bại.');
        return;
      }

      final signedAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      final res = await _api.createContract(
        signedAt: signedAt,
        signatureImage: signatureUrl,
        infoOffice: widget.infoOffice,
      );
      if (!res.success) {
        if (mounted) {
          AppToast.error(context,
              res.message ?? 'Tạo hợp đồng thất bại. Vui lòng thử lại.');
        }
        return;
      }

      // Refresh the local user (contract_pdf / step change) before leaving.
      await ref.read(authControllerProvider.notifier).refreshProfile();
      ref.invalidate(contractsProvider);
      if (!mounted) return;
      context.pushReplacement('/contract/sign-success', extra: {
        'contractId': res.contractId,
        'pdfUrl': res.pdf,
      });
    } on ApiException catch (e) {
      if (mounted) AppToast.error(context, e.message);
    } catch (_) {
      if (mounted) AppToast.error(context, 'Có lỗi xảy ra');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: '',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nhập mã OTP', style: AppTextStyles.bold(26)),
            const SizedBox(height: 6),
            RichText(
              text: TextSpan(
                style: AppTextStyles.regular(15, color: AppColors.textSecondary)
                    .copyWith(height: 1.4),
                children: const [
                  TextSpan(text: 'Mã OTP đã gửi qua '),
                  TextSpan(
                      text: 'tài khoản Zalo',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  TextSpan(text: ' của bạn\nVui lòng nhập mã để xác minh'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text('Mã OTP',
                style: AppTextStyles.bold(13, color: AppColors.textSecondary)),
            const SizedBox(height: 12),
            OtpCodeField(
              controller: _otpCtrl,
              error: _error,
              onChanged: (_) {
                if (_error) setState(() => _error = false);
              },
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Xác thực',
              loading: _busy,
              onPressed: _busy ? null : _verify,
            ),
            const SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: (_countdown == 0 && !_busy) ? _sendOtp : null,
                behavior: HitTestBehavior.opaque,
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.regular(15,
                        color: AppColors.textSecondary),
                    children: [
                      if (_countdown > 0)
                        TextSpan(text: 'Gửi lại mã OTP trong ${_countdown}s')
                      else
                        const TextSpan(
                            text: 'Gửi lại mã',
                            style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
