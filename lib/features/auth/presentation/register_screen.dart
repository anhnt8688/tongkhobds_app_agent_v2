import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import 'widgets/register_form.dart';

/// Standalone registration route. The combined auth entry (`/login`) hosts the
/// same [RegisterForm] under its "Đăng ký" tab; this screen serves direct
/// navigation to `/register` with a titled back bar.
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: CustomAppBar(title: 'Đăng ký tài khoản'),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Đăng ký', style: AppTextStyles.bold(28)),
              const SizedBox(height: 4),
              Text('Tạo tài khoản agent để bắt đầu',
                  style: AppTextStyles.regular(17, color: AppColors.neutral400)),
              const SizedBox(height: 24),
              const RegisterForm(),
            ],
          ),
        ),
      ),
    );
  }
}
