import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/utils/auth_validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/custom_screen.dart';
import '../../auth/presentation/controllers/auth_controller.dart';
import '../data/profile_api.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});
  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _form = GlobalKey<FormState>();
  final _old = TextEditingController();
  final _new = TextEditingController();
  final _confirm = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _old.dispose();
    _new.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(profileApiProvider)
          .changePassword(_old.text.trim(), _new.text.trim());
      if (!mounted) return;
      AppToast.success(context, 'Đổi mật khẩu thành công');
      // v1 forces a re-login after a successful change; the router then
      // redirects to /login once the session is cleared.
      await ref.read(authControllerProvider.notifier).logout();
    } on ApiException catch (e) {
      if (mounted) AppToast.error(context, e.message);
    } catch (_) {
      if (mounted) AppToast.error(context, 'Không đổi được mật khẩu');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'Đổi mật khẩu',
      child: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AppTextField(
              label: 'Mật khẩu hiện tại *',
              controller: _old,
              obscureText: true,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Vui lòng nhập mật khẩu cũ' : null,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Mật khẩu mới *',
              controller: _new,
              obscureText: true,
              validator: (v) {
                final s = v?.trim() ?? '';
                if (!isValidPassword(s)) {
                  return 'Mật khẩu phải chứa ít nhất 6 kí tự, ngắn hơn 15 kí tự, gồm chữ và số.';
                }
                if (s == _old.text.trim()) {
                  return 'Mật khẩu mới không được trùng mật khẩu cũ.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Nhập lại mật khẩu mới *',
              controller: _confirm,
              obscureText: true,
              validator: (v) => (v?.trim() ?? '') != _new.text.trim()
                  ? 'Trường “Xác nhận mật khẩu” phải trùng khớp với trường “Mật khẩu”.'
                  : null,
            ),
            const SizedBox(height: 20),
            AppButton(label: 'Đổi mật khẩu', loading: _saving, onPressed: _save),
          ],
        ),
      ),
    );
  }
}
