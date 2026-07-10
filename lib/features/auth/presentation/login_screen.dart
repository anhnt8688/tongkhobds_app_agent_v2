import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/segmented_button_slide.dart';
import 'widgets/login_form.dart';
import 'widgets/register_form.dart';

/// Auth entry (v1 `authen_option` parity): a Đăng nhập / Đăng ký segmented
/// toggle. The login tab shows the banner + tagline above the toggle; the
/// register tab shows the sign-up form directly below it.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  int _tab = 0; // 0 = login, 1 = register

  @override
  Widget build(BuildContext context) {
    final isLogin = _tab == 0;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isLogin) _loginHeader(),
              _tabBar(),
              const SizedBox(height: 24),
              isLogin ? const LoginForm() : const RegisterForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginHeader() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/banner_image.png',
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            'Đăng nhập để tiếp tục với TongkhoBDS Agent',
            style: AppTextStyles.regular(17, color: AppColors.neutral400)
                .copyWith(letterSpacing: -0.43),
          ),
          const SizedBox(height: 20),
        ],
      );

  Widget _tabBar() => SegmentedButtonSlide(
        entries: const [
          SegmentedButtonSlideEntry(label: 'Đăng nhập'),
          SegmentedButtonSlideEntry(label: 'Đăng ký'),
        ],
        selectedEntry: _tab,
        onChange: (i) => setState(() => _tab = i),
        colors: const SegmentedButtonSlideColors(
          barColor: AppColors.neutral100,
          backgroundSelectedColor: AppColors.text, // neutral800
        ),
        height: 36,
        padding: const EdgeInsets.all(4),
        borderRadius: BorderRadius.circular(14),
        selectedTextStyle: AppTextStyles.semibold(15, color: Colors.white),
        unselectedTextStyle:
            AppTextStyles.regular(15, color: AppColors.neutral500),
      );
}
