import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/auth/biometric_service.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import 'profile_settings_section.dart';

/// "Bật sinh trắc học" row (shown only for checking-staff accounts, like v1).
/// Availability is verified on toggle; enabling stashes the current session
/// token so the biometric login flow can restore it.
class BiometricToggleRow extends ConsumerStatefulWidget {
  const BiometricToggleRow({super.key});

  @override
  ConsumerState<BiometricToggleRow> createState() => _BiometricToggleRowState();
}

class _BiometricToggleRowState extends ConsumerState<BiometricToggleRow> {
  bool _enabled = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final enabled = await ref.read(biometricServiceProvider).isEnabled();
    if (mounted) setState(() => _enabled = enabled);
  }

  Future<void> _toggle(bool value) async {
    if (_busy) return;
    final svc = ref.read(biometricServiceProvider);
    setState(() => _busy = true);
    if (value) {
      if (!await svc.isAvailable()) {
        if (mounted) {
          AppToast.error(context, 'Thiết bị không hỗ trợ sinh trắc học.');
          setState(() => _busy = false);
        }
        return;
      }
      final res = await svc.authenticate(
          reason: 'Xác thực để bật đăng nhập sinh trắc học');
      if (res.success) {
        final token = ref.read(authControllerProvider.notifier).currentToken;
        if (token != null && token.isNotEmpty) {
          await svc.enable(token);
          if (mounted) {
            setState(() => _enabled = true);
            AppToast.success(context, 'Đã bật sinh trắc học.');
          }
        } else if (mounted) {
          AppToast.error(context, 'Không lấy được phiên đăng nhập');
        }
      } else if (mounted && res.message != null) {
        AppToast.error(context, res.message!);
      }
    } else {
      await svc.disable();
      if (mounted) {
        setState(() => _enabled = false);
        AppToast.success(context, 'Đã tắt sinh trắc học.');
      }
    }
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    return ProfileMenuImageItem(
      iconPath: 'assets/images/key_icon.png',
      title: 'Bật sinh trắc học',
      trailing: Switch(
        value: _enabled,
        onChanged: _busy ? null : _toggle,
        activeThumbColor: Colors.green,
      ),
    );
  }
}

/// "Cài đặt thông báo" row — reflects OS notification permission, tapping the
/// switch opens system settings (v1 behavior).
class NotificationToggleRow extends StatefulWidget {
  const NotificationToggleRow({super.key});

  @override
  State<NotificationToggleRow> createState() => _NotificationToggleRowState();
}

class _NotificationToggleRowState extends State<NotificationToggleRow>
    with WidgetsBindingObserver {
  bool _on = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refresh();
  }

  Future<void> _refresh() async {
    final status = await Permission.notification.status;
    if (mounted) setState(() => _on = status.isGranted);
  }

  @override
  Widget build(BuildContext context) {
    return ProfileMenuImageItem(
      iconPath: 'assets/images/noti_icon.png',
      title: 'Cài đặt thông báo',
      trailing: Switch(
        value: _on,
        onChanged: (_) => openAppSettings(),
        activeThumbColor: Colors.green,
      ),
    );
  }
}
