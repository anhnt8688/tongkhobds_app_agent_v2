import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/biometric_service.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/auth_validators.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../controllers/auth_controller.dart';
import 'domain_picker_sheet.dart';

/// v1 login form: phone + password (title-above fields, no prefix icons),
/// "Đăng nhập" primary button, "Quên mật khẩu" link, "Hoặc" divider, then a
/// Google-icon outline button for OTP login. Tapping "Hoặc" 10× opens the
/// hidden domain switcher (v1 behaviour).
class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  bool _biometricReady = false;
  bool _isOtp = true; // v1 default: OTP mode (password field hidden).
  int _orTaps = 0;
  String? _error;

  void _toggleType() => setState(() {
        _isOtp = !_isOtp;
        _error = null;
      });

  /// OTP mode: validate phone then hand off to the OTP screen (auto-sends the
  /// code). v1 gated on a duplicate-phone check first; here the backend's
  /// send_otp surfaces "chưa đăng ký" itself, so we go straight to /otp.
  void _submitOtp() {
    final phone = _userCtrl.text.trim();
    if (!isValidVietnamPhone(phone)) {
      setState(() => _error =
          'Số điện thoại không đúng định dạng. Vui lòng nhập 10 chữ số, bắt đầu bằng 0 hoặc +84.');
      return;
    }
    context.push('/otp', extra: {'phone': phone});
  }

  @override
  void initState() {
    super.initState();
    _checkBiometric();
  }

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _checkBiometric() async {
    final svc = ref.read(biometricServiceProvider);
    final ready =
        await svc.isEnabled() && await svc.hasToken() && await svc.isAvailable();
    if (mounted) setState(() => _biometricReady = ready);
  }

  void _onOrTap() {
    if (++_orTaps < 10) return;
    _orTaps = 0;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (_) => const DomainPickerSheet(),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref
          .read(authControllerProvider.notifier)
          .loginWithPassword(_userCtrl.text.trim(), _passCtrl.text);
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } catch (_) {
      setState(() => _error = 'Đăng nhập thất bại, vui lòng thử lại');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _biometricLogin() async {
    final svc = ref.read(biometricServiceProvider);
    final res = await svc.authenticate();
    if (!res.success) {
      if (mounted && res.message != null) setState(() => _error = res.message);
      return;
    }
    final token = await svc.savedToken();
    if (token == null || token.isEmpty) return;
    setState(() => _loading = true);
    try {
      await ref.read(authControllerProvider.notifier).loginWithToken(token);
    } catch (_) {
      await svc.disable();
      if (mounted) {
        setState(() {
          _biometricReady = false;
          _error = 'Phiên đã hết hạn, vui lòng đăng nhập lại';
        });
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            label: 'Số điện thoại',
            controller: _userCtrl,
            hint: 'Nhập số điện thoại',
            keyboardType: TextInputType.phone,
            textInputAction: _isOtp ? TextInputAction.done : TextInputAction.next,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Vui lòng nhập tài khoản' : null,
          ),
          if (!_isOtp) ...[
            const SizedBox(height: 16),
            AppTextField(
              label: 'Mật khẩu',
              controller: _passCtrl,
              hint: 'Nhập mật khẩu',
              obscureText: _obscure,
              textInputAction: TextInputAction.done,
              suffixIcon: IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Image.asset(
                  _obscure
                      ? 'assets/images/ic_eye_outlined.png'
                      : 'assets/images/ic_eye_filled.png',
                  width: 16,
                  height: 16,
                  color: AppColors.textMute,
                ),
              ),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Vui lòng nhập mật khẩu' : null,
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: AppTextStyles.regular(13, color: AppColors.danger)),
          ],
          const SizedBox(height: 16),
          AppButton(
            label: 'Đăng nhập',
            loading: _loading,
            onPressed: _isOtp ? _submitOtp : _submit,
          ),
          const SizedBox(height: 16),
          Center(
            child: GestureDetector(
              onTap: () => context.push('/forgot'),
              child: Text('Quên mật khẩu',
                  style: AppTextStyles.semibold(15, color: AppColors.primary)),
            ),
          ),
          const SizedBox(height: 24),
          _orDivider(),
          const SizedBox(height: 24),
          // v1 toggle: switches between password and OTP login in place.
          AppButton(
            label: _isOtp ? 'Đăng nhập bằng mật khẩu' : 'Đăng nhập bằng OTP',
            variant: AppButtonVariant.ghost,
            onPressed: _loading ? null : _toggleType,
          ),
          if (_biometricReady) ...[
            const SizedBox(height: 12),
            AppButton(
              label: 'Đăng nhập bằng sinh trắc học',
              variant: AppButtonVariant.ghost,
              icon: Icons.fingerprint,
              onPressed: _loading ? null : _biometricLogin,
            ),
          ],
        ],
      ),
    );
  }

  Widget _orDivider() => Row(
        children: [
          const Expanded(child: Divider(color: AppColors.neutral200)),
          GestureDetector(
            onTap: _onOrTap,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Hoặc',
                  style: AppTextStyles.semibold(15, color: AppColors.neutral400)),
            ),
          ),
          const Expanded(child: Divider(color: AppColors.neutral200)),
        ],
      );
}
