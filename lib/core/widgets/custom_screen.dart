import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'custom_app_bar.dart';

/// v1 `CustomScreen` shell port — the standard screen frame across the app:
/// a gradient [CustomAppBar] (orange gradient + white centred title + rounded
/// back button) over a body that shows an 8px orange gradient sliver behind a
/// rounded-top-16 background container holding [child].
///
/// Use this instead of `Scaffold(appBar: AppBar(...))` for titled list/detail/
/// form screens. Screens with their own header (auth, webview, camera, chat
/// room, SliverAppBar detail pages) keep their bespoke scaffolds.
class CustomScreen extends StatelessWidget {
  const CustomScreen({
    super.key,
    required this.title,
    required this.child,
    this.isBack = true,
    this.action,
    this.actions,
    this.titleWidget,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.onBackPress,
    this.backgroundColor = AppColors.bg,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset = true,
  });

  final String title;
  final Widget child;
  final bool isBack;

  /// Single trailing action. For multiple, pass [actions] (rendered as a Row).
  final Widget? action;
  final List<Widget>? actions;
  final Widget? titleWidget;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final VoidCallback? onBackPress;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.bg;
    // Collapse action/actions into CustomAppBar's single actionButton slot.
    final Widget? actionButton = action ??
        (actions == null || actions!.isEmpty
            ? null
            : Row(mainAxisSize: MainAxisSize.min, children: actions!));

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: bg,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        appBar: CustomAppBar(
          title: title,
          titleWidget: titleWidget,
          enableBack: isBack,
          enableGradient: true,
          actionButton: actionButton,
          onBackPress: onBackPress,
        ),
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        bottomNavigationBar: bottomNavigationBar,
        // Thin gradient sliver behind a rounded-top body (v1 CustomScreen body).
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 8),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFFF1913D), Color(0xFFF3802F), AppColors.primary],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: bg,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            clipBehavior: Clip.antiAlias,
            child: child,
          ),
        ),
      ),
    );
  }
}
