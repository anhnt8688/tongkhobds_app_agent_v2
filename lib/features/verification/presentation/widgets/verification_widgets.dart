import 'package:flutter/material.dart';

/// Palette + text styles matching v1's real_estate_verification screens.
class VColors {
  static const bg = Color(0xFFF7F8FA);
  static const line = Color(0xFFE5E7EB);
  static const orange = Color(0xFFFB923C);
  static const orangePale = Color(0xFFFFF7ED);
  static const orangeBorder = Color(0xFFFDBA74);
  static const n800 = Color(0xFF1F2937);
  static const n700 = Color(0xFF374151);
  static const n600 = Color(0xFF4B5563);
  static const n500 = Color(0xFF6B7280);
  static const n400 = Color(0xFF9CA3AF);
  static const n300 = Color(0xFFD1D5DB);
  static const n100 = Color(0xFFF3F4F6);
  static const n50 = Color(0xFFF9FAFB);
  static const red = Color(0xFFEF4444);
  static const redDark = Color(0xFFDC2626);
}

TextStyle vText(double size, FontWeight weight, Color color, {double? height}) =>
    TextStyle(fontSize: size, fontWeight: weight, color: color, height: height);

/// Branded scaffold: white app bar with circular back, title (+optional badge),
/// optional trailing action, 1px divider. Mirrors v1 VerificationScaffold.
class VerificationScaffold extends StatelessWidget {
  const VerificationScaffold({
    super.key,
    required this.title,
    required this.child,
    this.titleWidget,
    this.action,
    this.bottomBar,
    this.showBack = true,
  });

  final String title;
  final Widget child;
  final Widget? titleWidget;
  final Widget? action;
  final Widget? bottomBar;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VColors.bg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(57),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleSpacing: 0,
          toolbarHeight: 56,
          leadingWidth: 56,
          automaticallyImplyLeading: false,
          leading: showBack
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
                  child: VCircleButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    iconColor: VColors.n600,
                    background: const Color(0xFFFAFAF9),
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                )
              : null,
          title: titleWidget ??
              Text(title, style: vText(16, FontWeight.w600, VColors.n800)),
          actions: [
            if (action != null)
              Padding(padding: const EdgeInsets.fromLTRB(0, 8, 16, 8), child: action!),
          ],
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(height: 1, thickness: 1, color: VColors.line),
          ),
        ),
      ),
      body: child,
      bottomNavigationBar: bottomBar,
    );
  }
}

class VCircleButton extends StatelessWidget {
  const VCircleButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.background,
    required this.iconColor,
  });
  final IconData icon;
  final VoidCallback onTap;
  final Color background;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
            color: background, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 16, color: iconColor),
      ),
    );
  }
}

/// Orange square action button used in the app bar (e.g. the filter icon).
class VerificationTopAction extends StatelessWidget {
  const VerificationTopAction({super.key, required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => VCircleButton(
        icon: icon,
        onTap: onTap,
        background: VColors.orange,
        iconColor: Colors.white,
      );
}

class VerificationStatusBadge extends StatelessWidget {
  const VerificationStatusBadge({
    super.key,
    required this.text,
    required this.background,
    required this.foreground,
  });
  final String text;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: foreground.withValues(alpha: 0.22)),
      ),
      child: Text(text, style: vText(13, FontWeight.w600, foreground)),
    );
  }
}

/// White card with optional icon + title header and a child body.
class VerificationInfoCard extends StatelessWidget {
  const VerificationInfoCard({
    super.key,
    required this.title,
    required this.child,
    this.icon,
    this.trailing,
  });
  final String title;
  final Widget child;
  final IconData? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final hasHeader = title.isNotEmpty || icon != null || trailing != null;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: VColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasHeader) ...[
            Row(
              children: [
                if (icon != null) ...[
                  Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                        color: VColors.orangePale, shape: BoxShape.circle),
                    child: Icon(icon, size: 10, color: VColors.orange),
                  ),
                  const SizedBox(width: 6),
                ],
                Expanded(
                    child:
                        Text(title, style: vText(14, FontWeight.w600, VColors.n800))),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 10),
          ],
          child,
        ],
      ),
    );
  }
}

/// Section header: orange accent bar + title (+ optional subtitle/trailing).
class VerificationSectionTitle extends StatelessWidget {
  const VerificationSectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });
  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
              color: VColors.orange, borderRadius: BorderRadius.circular(999)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: vText(14, FontWeight.w600, VColors.n800)),
              if (subtitle != null) ...[
                const SizedBox(height: 3),
                Text(subtitle!, style: vText(12, FontWeight.w400, VColors.n500)),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

/// Boxed label + value pair (on a light gray background).
class VerificationPairInfo extends StatelessWidget {
  const VerificationPairInfo({super.key, required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: VColors.n50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: VColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: vText(12, FontWeight.w400, VColors.n500)),
          const SizedBox(height: 3),
          Text(value, style: vText(14, FontWeight.w600, VColors.n800)),
        ],
      ),
    );
  }
}

/// Inline search field for the list screen. Mirrors v1's VerificationSearchBar
/// placeholder but is fully functional (debounced setter lives in the controller).
class VerificationSearchBar extends StatefulWidget {
  const VerificationSearchBar({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.hint = 'Tìm theo tên BĐS, địa chỉ ...',
  });

  final String initialValue;
  final ValueChanged<String> onChanged;
  final String hint;

  @override
  State<VerificationSearchBar> createState() => _VerificationSearchBarState();
}

class _VerificationSearchBarState extends State<VerificationSearchBar> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialValue);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: VColors.line),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 16, color: VColors.n400),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              textInputAction: TextInputAction.search,
              style: vText(14, FontWeight.w400, VColors.n800),
              cursorColor: VColors.orange,
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: widget.hint,
                hintStyle: vText(14, FontWeight.w400, VColors.n400),
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (_, value, __) => value.text.isEmpty
                ? const SizedBox.shrink()
                : GestureDetector(
                    onTap: () {
                      _controller.clear();
                      widget.onChanged('');
                    },
                    child: const Icon(Icons.close_rounded,
                        size: 16, color: VColors.n400),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Small orange pill badge (e.g. "2 chủ"). Mirrors v1 `_SmallOrangeBadge`.
class VSmallOrangeBadge extends StatelessWidget {
  const VSmallOrangeBadge({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: VColors.orangePale,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: VColors.orangeBorder),
      ),
      child: Text(text, style: vText(12, FontWeight.w600, VColors.orange)),
    );
  }
}

/// Gradient media slot with a number/label chip; shows a local file or remote
/// image when present, else a gradient placeholder (+ optional play icon).
/// Mirrors v1 `_MiniMediaThumb`.
class VMiniMediaThumb extends StatelessWidget {
  const VMiniMediaThumb({
    super.key,
    required this.title,
    required this.toneA,
    required this.toneB,
    this.withPlay = false,
    this.imageWidget,
    this.onTap,
  });
  final String title;
  final Color toneA;
  final Color toneB;
  final bool withPlay;

  /// Pre-built image (Image.file / AppNetworkImage) when a media is present.
  final Widget? imageWidget;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageWidget != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 74,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: hasImage
              ? null
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [toneA, toneB],
                ),
        ),
        child: Stack(
          children: [
            if (hasImage)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageWidget,
                ),
              )
            else if (withPlay)
              const Center(
                child: Icon(Icons.play_circle_fill_rounded,
                    size: 28, color: Colors.white),
              )
            else
              const Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.image_rounded, size: 18, color: Colors.white),
                ),
              ),
            Positioned(
              left: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(title, style: vText(11, FontWeight.w600, VColors.n700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dashed-style "add media" tile next to the gradient slots (v1 `_AddThumb`).
class VAddThumb extends StatelessWidget {
  const VAddThumb({super.key, required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 74,
        height: 74,
        decoration: BoxDecoration(
          color: VColors.orangePale,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: VColors.orangeBorder),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, size: 22, color: VColors.orange),
            Text('Thêm', style: vText(11, FontWeight.w600, VColors.orange)),
          ],
        ),
      ),
    );
  }
}

/// Pill drag handle for bottom sheets.
class VSheetHandle extends StatelessWidget {
  const VSheetHandle({super.key});
  @override
  Widget build(BuildContext context) => Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
            color: VColors.n300, borderRadius: BorderRadius.circular(999)),
      );
}
