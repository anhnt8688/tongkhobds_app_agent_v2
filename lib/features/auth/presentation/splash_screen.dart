import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import 'controllers/auth_controller.dart';

/// Splash screen — restores the session, then the router redirects.
/// Visual matches v1: plain #FAFAF9 background with a centered 100×100 app icon.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authControllerProvider.notifier).bootstrap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.bg, // #FAFAF9
      body: Center(
        child: Image(
          image: AssetImage('assets/images/appIcon.png'),
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}
