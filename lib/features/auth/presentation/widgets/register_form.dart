import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/auth_validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../locations/locations_screen.dart';
import '../../data/auth_api.dart';

/// New-agent registration form (v1 sign-up styling). Self-contained: owns its
/// controllers + submit. On success the backend sends an OTP → hands off to the
/// OTP screen. Hosted both by the auth tab shell and the standalone /register.
class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _email = TextEditingController();
  final _birthday = TextEditingController();
  LocationSelection? _location;
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    for (final c in [_name, _phone, _password, _confirm, _email, _birthday]) {
      c.dispose();
    }
    super.dispose();
  }

  // v1 params: default ~20yo, range 1950 → today, formatted dd/MM/yyyy.
  Future<void> _pickBirthday() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 20, now.month, now.day),
      firstDate: DateTime(1950),
      lastDate: now,
    );
    if (d != null) {
      String two(int v) => v.toString().padLeft(2, '0');
      _birthday.text = '${two(d.day)}/${two(d.month)}/${d.year}';
      setState(() {});
    }
  }

  Future<void> _pickLocation() async {
    final sel = await showLocationPickerSheet(context);
    if (sel != null) setState(() => _location = sel);
  }

  String? _toApiBirthday() {
    final parts = _birthday.text.split('/');
    if (parts.length != 3) return null;
    return '${parts[0].padLeft(2, '0')}/${parts[1].padLeft(2, '0')}/${parts[2]}';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await ref.read(authApiProvider).register({
        'phone': _phone.text.trim(),
        'fullname': _name.text.trim(),
        'password': _password.text,
        if (_location != null) 'city_id': _location!.cityId,
        if (_location?.districtId != null) 'district_id': _location!.districtId,
        if (_location?.wardId != null) 'ward_id': _location!.wardId,
        if (_location != null) 'address': _location!.label,
        if (_email.text.trim().isNotEmpty) 'email': _email.text.trim(),
        if (_toApiBirthday() != null) 'birthday': _toApiBirthday(),
      });
      if (!mounted) return;
      AppToast.success(context, 'Đăng ký thành công, vui lòng xác thực OTP');
      context.push('/otp', extra: {'phone': _phone.text.trim(), 'isSignup': true});
    } on ApiException catch (e) {
      if (mounted) AppToast.error(context, e.message);
      setState(() => _loading = false);
    } catch (_) {
      if (mounted) AppToast.error(context, 'Đăng ký thất bại, vui lòng thử lại');
      setState(() => _loading = false);
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
            label: 'Họ và tên',
            controller: _name,
            hint: 'Nhập họ và tên',
            required: true,
            validator: _required,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Số điện thoại',
            controller: _phone,
            hint: 'Nhập số điện thoại',
            keyboardType: TextInputType.phone,
            required: true,
            validator: (v) => !isValidVietnamPhone(v?.trim() ?? '')
                ? 'Số điện thoại không đúng định dạng. Vui lòng nhập 10 chữ số, bắt đầu bằng 0 hoặc +84.'
                : null,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Mật khẩu',
            controller: _password,
            hint: 'Nhập mật khẩu',
            obscureText: _obscure,
            required: true,
            suffixIcon: _eyeToggle(),
            validator: (v) => !isValidPassword(v ?? '')
                ? 'Mật khẩu phải chứa ít nhất 6 kí tự, ngắn hơn 15 kí tự, gồm chữ và số.'
                : null,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Xác nhận mật khẩu',
            controller: _confirm,
            hint: 'Nhập lại mật khẩu',
            obscureText: _obscure,
            required: true,
            validator: (v) => v != _password.text
                ? 'Trường “Xác nhận mật khẩu” phải trùng khớp với trường “Mật khẩu”.'
                : null,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Email',
            controller: _email,
            hint: 'Nhập email',
            keyboardType: TextInputType.emailAddress,
            validator: (v) => (v != null && v.trim().isNotEmpty && !isValidEmail(v))
                ? 'Email không đúng định dạng'
                : null,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Ngày sinh',
            controller: _birthday,
            hint: 'Chọn ngày sinh',
            readOnly: true,
            onTap: _pickBirthday,
            suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded,
                color: AppColors.neutral500),
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Khu vực',
            controller: TextEditingController(text: _location?.label ?? ''),
            hint: 'Chọn khu vực',
            readOnly: true,
            onTap: _pickLocation,
            suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded,
                color: AppColors.neutral500),
          ),
          const SizedBox(height: 24),
          AppButton(label: 'Đăng ký', loading: _loading, onPressed: _submit),
        ],
      ),
    );
  }

  Widget _eyeToggle() => IconButton(
        onPressed: () => setState(() => _obscure = !_obscure),
        icon: Image.asset(
          _obscure
              ? 'assets/images/ic_eye_outlined.png'
              : 'assets/images/ic_eye_filled.png',
          width: 16,
          height: 16,
          color: AppColors.textMute,
        ),
      );

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Vui lòng nhập thông tin' : null;
}
