import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/custom_screen.dart';
import '../../auth/presentation/controllers/auth_controller.dart';

/// "Thông tin tài khoản" view — mirrors v1 InformationPage's 3 KYC states:
/// • step 1 (chưa xác thực): basic fields only + "Xác thực ngay".
/// • step 2 (chờ duyệt): "Chờ duyệt" pill + full KYC info + "Quay lại / Xác thực lại".
/// • step 3 (đã duyệt): verified avatar + full KYC info, no action bar.
/// The pencil action opens the edit screen (Email is the only editable field).
class AccountInfoScreen extends ConsumerStatefulWidget {
  const AccountInfoScreen({super.key});

  @override
  ConsumerState<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends ConsumerState<AccountInfoScreen> {
  @override
  void initState() {
    super.initState();
    // Always pull the freshest full profile (CCCD, ảnh CCCD, step…) on open,
    // matching v1 which re-fetches get_user_profile rather than trusting a
    // lighter login payload.
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.read(authControllerProvider.notifier).refreshProfile());
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final step = user?.step ?? 1;
    final verified = step == 3;

    return CustomScreen(
      title: 'Thông tin tài khoản',
      backgroundColor: Colors.white,
      action: IconButton(
        icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
        onPressed: () => context.push('/edit-profile/edit'),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      _avatar(user?.image, verified),
                      if (step == 2) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF4E5),
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusPill),
                          ),
                          child: Text('Chờ duyệt',
                              style: AppTypography.caption.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ]),
                  ),
                  const SizedBox(height: 16),
                  _row('Họ và tên', user?.fullName),
                  _row('Số điện thoại', user?.phone),
                  _row('Email', user?.email),
                  if (step != 1) ...[
                    _row('CCCD', user?.idCard),
                    _row('Giới tính', _sexLabel(user?.sex)),
                    _row('Ngày sinh', _fmtDate(user?.birthday)),
                    _row('Địa chỉ thường trú', user?.address, multiline: true),
                    _row('Ngày cấp', _fmtDate(user?.idDay)),
                    const SizedBox(height: 16),
                    Text('Ảnh CCCD',
                        style: AppTypography.subtitle
                            .copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Row(children: [
                      Expanded(
                          child: _cccdImage('Mặt trước', user?.citizenIdFront)),
                      const SizedBox(width: 8),
                      Expanded(
                          child: _cccdImage('Mặt sau', user?.citizenIdBack)),
                    ]),
                  ],
                ],
              ),
            ),
          ),
          if (step != 3)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: _actionBar(context, step),
              ),
            ),
        ],
      ),
    );
  }

  Widget _actionBar(BuildContext context, int step) {
    if (step == 1) {
      return AppButton(
        label: 'Xác thực ngay',
        onPressed: () => context.push('/kyc'),
      );
    }
    return Row(children: [
      Expanded(
        child: AppButton(
          label: 'Quay lại',
          variant: AppButtonVariant.ghost,
          onPressed: () => context.pop(),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: AppButton(
          label: 'Xác thực lại',
          onPressed: () => context.push('/kyc'),
        ),
      ),
    ]);
  }

  Widget _avatar(String? url, bool verified) => Stack(children: [
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
              child: const Icon(Icons.verified,
                  size: 22, color: AppColors.primary),
            ),
          ),
      ]);

  Widget _row(String label, String? value, {bool multiline = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment:
              multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 110,
              child: Text(label,
                  style: AppTypography.caption
                      .copyWith(color: AppColors.textMute)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text((value ?? '').isEmpty ? '-' : value!,
                  style: AppTypography.body.copyWith(
                      color: AppColors.text, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      );

  Widget _cccdImage(String label, String? url) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              child: (url != null && url.isNotEmpty)
                  ? Image.network(url, fit: BoxFit.cover)
                  : Container(
                      color: AppColors.bg,
                      child: const Icon(Icons.image_outlined,
                          color: AppColors.textMute),
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(label,
              style:
                  AppTypography.caption.copyWith(color: AppColors.textMute)),
        ],
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
