import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_toast.dart';
import '../../auth/presentation/controllers/auth_controller.dart';
import '../data/profile_api.dart';
import 'widgets/profile_company_info.dart';
import 'widgets/profile_quick_tools.dart';
import 'widgets/profile_settings_section.dart';
import 'widgets/profile_toggle_rows.dart';
import 'widgets/profile_user_card.dart';

/// Profile tab — faithful port of the v1 layout: orange header card with
/// award/CTV/contract banners, flat info settings list, "Công cụ nhanh" grid,
/// legal/account list, and the company-info HTML block.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final award = ref.watch(awardProvider).valueOrNull;
    final top = MediaQuery.of(context).padding.top;
    final showStaff = user?.checkingStaff ?? false;
    final step = user?.step ?? 1;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, top + 20, 16, 20),
        children: [
          if (user != null) ProfileUserCard(user: user, award: award),
          const SizedBox(height: 24),

          // Info settings (matches v1 order; Checkin vé hidden — no v2 route).
          // BĐS của tôi, Khách hàng, Nhu cầu mua/bán, Quản lý hợp đồng and
          // Đội nhóm were relocated to the Home tab's "Quản lý" grid.
          ProfileSettingsSection(children: [
            ProfileMenuFaItem(
              faIcon: FontAwesomeIcons.solidComments,
              title: 'Tin nhắn',
              onTap: () => context.push('/messages'),
            ),
            ProfileMenuImageItem(
              iconPath: 'assets/images/key_icon.png',
              title: 'Đổi mật khẩu',
              onTap: () => context.push('/change-password'),
            ),
            if (step != 3)
              ProfileMenuImageItem(
                iconPath: 'assets/images/key_icon.png',
                title: 'Xác thực thông tin',
                onTap: () => context.push('/kyc'),
              ),
            ProfileMenuFaItem(
              faIcon: FontAwesomeIcons.rightLeft,
              title: 'So sánh BDS',
              onTap: () => context.push('/compare'),
            ),
            ProfileMenuFaItem(
              faIcon: FontAwesomeIcons.mapLocationDot,
              title: 'Bản đồ BDS',
              onTap: () => context.push('/map'),
            ),
            ProfileMenuImageItem(
              iconPath: 'assets/images/ic_legal_gradient.png',
              title: 'Quản lý xác thực BĐS',
              onTap: () => context.push('/real-estate-verification'),
            ),
            ProfileMenuImageItem(
              iconPath: 'assets/images/ic_share.png',
              title: 'Giới thiệu môi giới',
              onTap: () => context.push('/referral'),
            ),
            if (showStaff) const BiometricToggleRow(),
            const NotificationToggleRow(),
          ]),

          const SizedBox(height: 24),
          const ProfileQuickTools(),

          const SizedBox(height: 24),
          ProfileSettingsSection(children: [
            ProfileMenuImageItem(
              iconPath: 'assets/images/document_icon.png',
              title: 'Điều khoản sử dụng',
              onTap: () => _openWeb(context,
                  'https://tongkhobds.com/tin/dieu-khoan-thoa-thuan.html',
                  'Điều khoản sử dụng'),
            ),
            ProfileMenuImageItem(
              iconPath: 'assets/images/private_icon.png',
              title: 'Chính sách bảo mật',
              onTap: () => _openWeb(context,
                  'https://tongkhobds.com/tin/chinh-sach-bao-mat-1.html',
                  'Chính sách bảo mật'),
            ),
            ProfileMenuFaItem(
              faIcon: FontAwesomeIcons.userSlash,
              title: 'Yêu cầu xoá tài khoản',
              onTap: () => _confirmDelete(context, ref),
            ),
            ProfileMenuFaItem(
              faIcon: FontAwesomeIcons.rightFromBracket,
              title: 'Đăng xuất',
              onTap: () => _confirmLogout(context, ref),
            ),
          ]),

          const ProfileCompanyInfo(),
        ],
      ),
    );
  }

  void _openWeb(BuildContext context, String url, String title) {
    context.push('/webview', extra: {'url': url, 'title': title});
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Đăng xuất?'),
        content:
            const Text('Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng không'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Huỷ')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Đăng xuất',
                style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(authControllerProvider.notifier).logout();
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Bạn có chắc muốn xoá tài khoản?'),
        content: const Text(
            'Toàn bộ dữ liệu sẽ bị xoá và không thể khôi phục lại.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Huỷ')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Xóa tài khoản',
                style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final user = ref.read(currentUserProvider);
    try {
      await ref.read(profileApiProvider).deleteAccount(user?.phone ?? '');
      await ref.read(authControllerProvider.notifier).logout();
    } catch (_) {
      if (context.mounted) AppToast.error(context, 'Xoá tài khoản thất bại');
    }
  }
}
