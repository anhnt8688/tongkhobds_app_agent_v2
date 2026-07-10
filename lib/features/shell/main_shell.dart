import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/force_update_service.dart';
import '../../core/theme/app_colors.dart';
import '../auth/presentation/post_login_flows.dart';

/// Bottom-navigation shell hosting the 5 primary tabs.
class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  static const _tabs = [
    (icon: Icons.home_rounded, label: 'Trang chủ'),
    (icon: Icons.search_rounded, label: 'Bảng hàng'),
    (icon: Icons.add_circle_outline_rounded, label: 'Đăng tin'),
    (icon: Icons.notifications_none_rounded, label: 'Thông báo'),
    (icon: Icons.person_outline_rounded, label: 'Cá nhân'),
  ];

  Timer? _addressTimer;

  @override
  void initState() {
    super.initState();
    // Run the v1 post-login flows once the shell is mounted.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      PostLoginFlows.runOnEnter(context, ref);
      // Force-update gate (v1 parity): prompt when the store has a newer build.
      ForceUpdateService().checkAndForceUpdate(context);
    });
    // v1 nags every 5 minutes while the profile address is still missing.
    _addressTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      if (mounted) PostLoginFlows.addressCheckTick(context, ref);
    });
  }

  @override
  void dispose() {
    _addressTimer?.cancel();
    super.dispose();
  }

  void _onTap(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          top: false,
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: AppColors.surface,
              indicatorColor: AppColors.primarySoft,
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                final selected = states.contains(WidgetState.selected);
                return TextStyle(
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected ? AppColors.primary : AppColors.textMute,
                );
              }),
              iconTheme: WidgetStateProperty.resolveWith((states) {
                final selected = states.contains(WidgetState.selected);
                return IconThemeData(
                  size: 22,
                  color: selected ? AppColors.primary : AppColors.textMute,
                );
              }),
            ),
            child: NavigationBar(
              height: 64,
              selectedIndex: widget.navigationShell.currentIndex,
              onDestinationSelected: _onTap,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: [
                for (final t in _tabs)
                  NavigationDestination(icon: Icon(t.icon), label: t.label),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
