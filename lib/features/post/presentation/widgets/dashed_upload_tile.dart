import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// v1 "Tải ảnh / Tải video / Tải file đính kèm" upload placeholder: a dashed
/// rounded box (bg #FAFAF9, dashed neutral200) with an upload icon + label.
class DashedUploadTile extends StatelessWidget {
  const DashedUploadTile({
    super.key,
    required this.label,
    required this.onTap,
    this.loading = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: AppColors.border, // neutral200
          radius: 16,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.bg, // #FAFAF9
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppColors.primary),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const FaIcon(FontAwesomeIcons.arrowUpFromBracket,
                          size: 20, color: AppColors.neutral400),
                      const SizedBox(height: 4),
                      Text(label,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.regular(15,
                              color: AppColors.neutral400)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Paints a dashed rounded-rect border (dash 10, gap 5) — matches v1's
/// `DottedBorder` without pulling in the package.
class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);

    const dash = 10.0;
    const gap = 5.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final len = distance + dash < metric.length
            ? dash
            : metric.length - distance;
        canvas.drawPath(
          metric.extractPath(distance, distance + len),
          paint,
        );
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) =>
      old.color != color || old.radius != radius;
}
