import 'package:flutter/material.dart';

/// Sliding segmented control (port of v1 `SegmentedButtonSlide`).
///
/// A pill-shaped bar with an animated selected background that slides between
/// equal-width segments. Auth uses it for the Đăng nhập / Đăng ký toggle.
class SegmentedButtonSlideEntry {
  const SegmentedButtonSlideEntry({this.label, this.icon});
  final String? label;
  final IconData? icon;
}

class SegmentedButtonSlideColors {
  const SegmentedButtonSlideColors({
    required this.barColor,
    required this.backgroundSelectedColor,
  });
  final Color barColor;
  final Color backgroundSelectedColor;
}

class SegmentedButtonSlide extends StatelessWidget {
  const SegmentedButtonSlide({
    super.key,
    required this.entries,
    required this.selectedEntry,
    required this.onChange,
    required this.colors,
    this.height = 50,
    this.padding,
    this.borderRadius,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.animationDuration = const Duration(milliseconds: 250),
    this.curve = Curves.ease,
  });

  final List<SegmentedButtonSlideEntry> entries;
  final int selectedEntry;
  final void Function(int) onChange;
  final SegmentedButtonSlideColors colors;
  final double height;
  final EdgeInsets? padding;
  final BorderRadiusGeometry? borderRadius;
  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;
  final Duration animationDuration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(height);
    return ClipRRect(
      borderRadius: radius,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(borderRadius: radius, color: colors.barColor),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final segWidth = constraints.maxWidth / entries.length;
            return Stack(
              children: [
                AnimatedPositioned(
                  duration: animationDuration,
                  curve: curve,
                  left: segWidth * selectedEntry,
                  child: Container(
                    height: height,
                    width: segWidth,
                    decoration: BoxDecoration(
                      color: colors.backgroundSelectedColor,
                      borderRadius: radius,
                    ),
                  ),
                ),
                Row(
                  children: [
                    for (final e in entries.asMap().entries)
                      Expanded(
                        child: InkWell(
                          onTap: () => onChange(e.key),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: SizedBox(
                            height: height,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (e.value.icon != null) ...[
                                  Icon(e.value.icon, size: 18),
                                  const SizedBox(width: 12),
                                ],
                                if (e.value.label != null)
                                  AnimatedDefaultTextStyle(
                                    duration: animationDuration,
                                    curve: curve,
                                    style: (e.key == selectedEntry
                                            ? selectedTextStyle
                                            : unselectedTextStyle) ??
                                        const TextStyle(),
                                    child: Text(e.value.label!),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
