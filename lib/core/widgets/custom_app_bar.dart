import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// v1 `CustomAppBar` port: 56h bar, optional orange gradient flexibleSpace, a
/// 32×32 rounded back button (FA arrow-left), and a centred semibold-17 title.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actionButton,
    this.onBackPress,
    this.enableBack = true,
    this.centerTitle = true,
    this.enableGradient = false,
    this.height = 56,
    this.heightGradient = 148,
    this.backgroundColor,
    this.titleColor,
  });

  final String? title;
  final Widget? titleWidget;
  final Widget? actionButton;
  final VoidCallback? onBackPress;
  final bool enableBack;
  final bool centerTitle;
  final bool enableGradient;
  final double height;
  final double heightGradient;
  final Color? backgroundColor;
  final Color? titleColor;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      elevation: 0,
      toolbarHeight: height,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColors.bg,
      flexibleSpace: enableGradient
          ? Container(
              height: heightGradient,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFFF1913D),
                    Color(0xFFF3802F),
                    AppColors.primary,
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            )
          : null,
      leading: enableBack
          ? IconButton(
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                if (onBackPress != null) {
                  onBackPress!();
                } else {
                  Navigator.of(context).maybePop();
                }
              },
              icon: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAF9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: FaIcon(FontAwesomeIcons.arrowLeft,
                      size: 16, color: AppColors.text),
                ),
              ),
            )
          : null,
      title: title != null
          ? Text(
              title!,
              textAlign: centerTitle ? TextAlign.center : TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.semibold(17,
                  color: titleColor ?? (enableGradient ? Colors.white : AppColors.text)),
            )
          : titleWidget,
      actions: actionButton != null ? [actionButton!] : null,
    );
  }
}
