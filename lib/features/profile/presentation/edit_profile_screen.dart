import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/custom_screen.dart';
import '../../auth/presentation/controllers/auth_controller.dart';
import '../data/profile_api.dart';

/// "Thông tin tài khoản" — mirrors v1 InformationEditPage. KYC-sourced fields
/// (họ tên, SĐT, CCCD, giới tính, ngày sinh, địa chỉ thường trú, ngày cấp) are
/// read-only; only Email is editable. Avatar can be changed via "Đổi avatar".
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _email;
  bool _saving = false;
  bool _uploading = false;
  bool _dirty = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: ref.read(currentUserProvider)?.email ?? '');
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
      maxWidth: 1200,
    );
    if (file == null) return;
    setState(() => _uploading = true);
    try {
      await ref.read(profileApiProvider).updateAvatar(file.path);
      await ref.read(authControllerProvider.notifier).refreshProfile();
      if (mounted) AppToast.success(context, 'Cập nhật Avatar thành công');
    } on ApiException catch (e) {
      if (mounted) AppToast.error(context, e.message);
    } catch (_) {
      if (mounted) AppToast.error(context, 'Upload thất bại');
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _save() async {
    final user = ref.read(currentUserProvider);
    final email = _email.text.trim();
    if (email.isNotEmpty && !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      setState(() => _error = 'Email không hợp lệ');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(profileApiProvider).updateProfile(
            fullName: user?.fullName ?? '',
            phone: user?.phone ?? '',
            email: email,
          );
      await ref.read(authControllerProvider.notifier).refreshProfile();
      if (!mounted) return;
      AppToast.success(context, 'Cập nhật tài khoản thành công');
      context.pop();
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } catch (_) {
      setState(() => _error = 'Cập nhật thất bại');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final showKyc = (user?.step ?? 1) != 1;

    return CustomScreen(
      title: 'Thông tin tài khoản',
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: _avatar(user?.image, user?.isVerified ?? false)),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: _uploading ? null : _pickAvatar,
                      child: Text(_uploading ? 'Đang tải…' : 'Đổi avatar',
                          style: AppTypography.subtitle.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _readonly('Họ và tên', user?.fullName),
                  const SizedBox(height: 12),
                  _readonly('Số điện thoại', user?.phone),
                  const SizedBox(height: 12),
                  _emailField(),
                  if (showKyc) ...[
                    const SizedBox(height: 12),
                    _readonly('CCCD', user?.idCard),
                    const SizedBox(height: 12),
                    _readonly('Giới tính', _sexLabel(user?.sex)),
                    const SizedBox(height: 12),
                    _readonly('Ngày sinh', _fmtDate(user?.birthday)),
                    const SizedBox(height: 12),
                    _readonly('Địa chỉ thường trú', user?.address, maxLines: 2),
                    const SizedBox(height: 12),
                    _readonly('Ngày cấp', _fmtDate(user?.idDay)),
                  ],
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  ],
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Hủy',
                      variant: AppButtonVariant.ghost,
                      onPressed: _saving ? null : () => context.pop(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      label: 'Lưu',
                      loading: _saving,
                      onPressed: _dirty ? _save : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatar(String? url, bool verified) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 44,
          backgroundColor: AppColors.bg,
          backgroundImage:
              (url != null && url.isNotEmpty) ? NetworkImage(url) : null,
          child: (url == null || url.isEmpty)
              ? const Icon(Icons.person, size: 44, color: AppColors.textMute)
              : null,
        ),
        if (verified)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.verified, size: 22, color: AppColors.primary),
            ),
          ),
      ],
    );
  }

  Widget _readonly(String label, String? value, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTypography.caption.copyWith(color: AppColors.textMute)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          ),
          child: Text((value ?? '').isEmpty ? '-' : value!,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.body
                  .copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _emailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Email',
            style: AppTypography.caption.copyWith(color: AppColors.textMute)),
        const SizedBox(height: 6),
        TextField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          onChanged: (_) {
            if (!_dirty) setState(() => _dirty = true);
          },
          style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            filled: true,
            fillColor: Colors.white,
            border: _emailBorder(),
            enabledBorder: _emailBorder(),
            focusedBorder: _emailBorder(width: 1.4),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _emailBorder({double width = 1.2}) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        borderSide: BorderSide(color: AppColors.primary, width: width),
      );

  String _sexLabel(String? raw) {
    final s = (raw ?? '').trim().toLowerCase();
    if (s == '1' || s.startsWith('nam')) return 'Nam';
    if (s == '0' || s.startsWith('nữ') || s.startsWith('nu')) return 'Nữ';
    return raw ?? '';
  }

  String _fmtDate(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso);
      final d = dt.day.toString().padLeft(2, '0');
      final m = dt.month.toString().padLeft(2, '0');
      return '$d/$m/${dt.year}';
    } catch (_) {
      return iso;
    }
  }
}
