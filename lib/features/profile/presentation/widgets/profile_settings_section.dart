import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// v1 settings group: rounded light-gray container with hairline dividers
/// indented past the leading icon (indent 56). Mirrors v1 `_buildSettingsSection`.
class ProfileSettingsSection extends StatelessWidget {
  const ProfileSettingsSection({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F4), // v1 neutral100
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              const Divider(height: 1, thickness: 1, indent: 56),
          ],
        ],
      ),
    );
  }
}

/// v1 row label: regular 17, neutral800, letterSpacing -0.4.
final _itemTitle = AppTextStyles.regular(17);

/// Settings row with a PNG asset icon (v1 `_buildItemWithImageIcon`).
/// When [trailing] is a [Switch] the row tap is disabled (toggle only).
class ProfileMenuImageItem extends StatelessWidget {
  const ProfileMenuImageItem({
    super.key,
    required this.iconPath,
    required this.title,
    this.trailing,
    this.onTap,
  });

  final String iconPath;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isSwitch = trailing is Switch;
    return InkWell(
      onTap: isSwitch ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 60,
              child: Image.asset(iconPath, fit: BoxFit.contain),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: _itemTitle)),
            trailing ??
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.neutral400),
          ],
        ),
      ),
    );
  }
}

/// Settings row with a FontAwesome icon (v1 `_buildItemWithFaIcon`).
class ProfileMenuFaItem extends StatelessWidget {
  const ProfileMenuFaItem({
    super.key,
    required this.faIcon,
    required this.title,
    this.onTap,
  });

  final IconData faIcon;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 60,
              child: Center(
                child: FaIcon(faIcon, size: 18, color: AppColors.neutral400),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: _itemTitle)),
            const Icon(Icons.chevron_right_rounded, color: AppColors.neutral400),
          ],
        ),
      ),
    );
  }
}
