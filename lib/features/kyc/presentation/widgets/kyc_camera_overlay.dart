import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

/// ID-1 card aspect ratio (85.60mm × 53.98mm) — the CCCD viewfinder frame.
const double kId1Aspect = 85.60 / 53.98;

/// Geometry mapping the on-screen viewfinder rect back to the camera preview's
/// native pixel space, so the captured photo can be cropped to the frame.
class PreviewGeometry {
  const PreviewGeometry({
    required this.childSize,
    required this.scale,
    required this.childOffset,
    required this.overlayInParent,
  });

  final Size childSize;
  final double scale;
  final Offset childOffset;
  final Rect overlayInParent;

  /// The viewfinder rect as percentages of the native preview image.
  Rect toCropPct() {
    final inChild = Rect.fromLTWH(
      (overlayInParent.left - childOffset.dx) / scale,
      (overlayInParent.top - childOffset.dy) / scale,
      overlayInParent.width / scale,
      overlayInParent.height / scale,
    );
    return Rect.fromLTWH(
      (inChild.left / childSize.width).clamp(0.0, 1.0),
      (inChild.top / childSize.height).clamp(0.0, 1.0),
      (inChild.width / childSize.width).clamp(0.0, 1.0),
      (inChild.height / childSize.height).clamp(0.0, 1.0),
    );
  }
}

/// Full-bleed camera preview with a darkened mask + ID-1 viewfinder cutout,
/// instruction text, and a shutter button. Reports its [PreviewGeometry] so the
/// host can crop the captured frame to the viewfinder.
class KycCameraPreview extends StatelessWidget {
  const KycCameraPreview({
    super.key,
    required this.controller,
    required this.tip,
    required this.onShutter,
    required this.onTapFocus,
    required this.onGeometry,
  });

  final CameraController controller;
  final String tip;
  final VoidCallback onShutter;
  final Future<void> Function(TapDownDetails, BoxConstraints) onTapFocus;
  final ValueChanged<PreviewGeometry> onGeometry;

  @override
  Widget build(BuildContext context) {
    final Size? ps = controller.value.previewSize;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    final double childW = (ps == null)
        ? MediaQuery.of(context).size.width
        : (isPortrait && ps.width > ps.height)
            ? ps.height
            : ps.width;
    final double childH = (ps == null)
        ? MediaQuery.of(context).size.height
        : (isPortrait && ps.width > ps.height)
            ? ps.width
            : ps.height;

    return LayoutBuilder(
      builder: (ctx, cons) {
        final parentW = cons.maxWidth;
        final parentH = cons.maxHeight;

        final scale = (parentW / childW > parentH / childH)
            ? parentW / childW
            : parentH / childH;
        final offsetX = (parentW - childW * scale) / 2;
        final offsetY = (parentH - childH * scale) / 2;

        double frameW = parentW * 0.98;
        double frameH = frameW / kId1Aspect;
        if (frameH > parentH * 0.70) {
          frameH = parentH * 0.70;
          frameW = frameH * kId1Aspect;
        }
        if (frameH >= frameW) {
          frameH = parentH * 0.65;
          frameW = frameH * kId1Aspect;
        }

        final overlayRect = Rect.fromLTWH(
          (parentW - frameW) / 2,
          (parentH - frameH) / 2,
          frameW,
          frameH,
        );

        onGeometry(PreviewGeometry(
          childSize: Size(childW, childH),
          scale: scale,
          childOffset: Offset(offsetX, offsetY),
          overlayInParent: overlayRect,
        ));

        return Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (d) => onTapFocus(d, cons),
              child: ClipRect(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: childW,
                    height: childH,
                    child: CameraPreview(controller),
                  ),
                ),
              ),
            ),
            IgnorePointer(
              child: CustomPaint(painter: IdCardOverlayPainter(overlayRect)),
            ),
            Column(
              children: [
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(tip,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: GestureDetector(
                    onTap: onShutter,
                    child: Container(
                      width: 86,
                      height: 86,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 5),
                      ),
                      child: const Center(
                        child: CircleAvatar(
                            radius: 33, backgroundColor: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// Darkens everything outside the rounded ID-1 [rect] and draws corner ticks.
class IdCardOverlayPainter extends CustomPainter {
  IdCardOverlayPainter(this.rect);
  final Rect rect;

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = Colors.black.withValues(alpha: 0.55);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(18));
    final path = Path()
      ..addRect(Offset.zero & size)
      ..addRRect(rrect)
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, bg);

    final stroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5;
    canvas.drawRRect(rrect, stroke);

    final corner = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;
    const len = 26.0;
    void tick(Offset a, Offset b) => canvas.drawLine(a, b, corner);
    tick(rect.topLeft + const Offset(0, 10), rect.topLeft + const Offset(0, len));
    tick(rect.topLeft + const Offset(10, 0), rect.topLeft + const Offset(len, 0));
    tick(rect.topRight + const Offset(0, 10), rect.topRight + const Offset(0, len));
    tick(rect.topRight + const Offset(-10, 0), rect.topRight + const Offset(-len, 0));
    tick(rect.bottomLeft + const Offset(0, -10), rect.bottomLeft + const Offset(0, -len));
    tick(rect.bottomLeft + const Offset(10, 0), rect.bottomLeft + const Offset(len, 0));
    tick(rect.bottomRight + const Offset(0, -10), rect.bottomRight + const Offset(0, -len));
    tick(rect.bottomRight + const Offset(-10, 0), rect.bottomRight + const Offset(-len, 0));
  }

  @override
  bool shouldRepaint(covariant IdCardOverlayPainter old) => old.rect != rect;
}
