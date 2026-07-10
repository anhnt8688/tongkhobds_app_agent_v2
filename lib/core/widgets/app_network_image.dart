import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Network image with sane performance defaults for the whole app.
///
/// The backend serves large originals (~1500-1800px). Decoding them at full
/// resolution is the main cause of jank, so this widget downscales the decode
/// to the actual display size (`memCacheWidth/Height = logical px × DPR`) using
/// a [LayoutBuilder], and caps the on-disk cache the same way. It also caches
/// to disk (via cached_network_image) and fades in to avoid flashes.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.backgroundColor,
  });

  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    Widget child = LayoutBuilder(
      builder: (ctx, constraints) {
        if (url == null || url!.isEmpty) return _fallback(placeholder);

        final dpr = MediaQuery.devicePixelRatioOf(ctx);

        // Prefer the bounded width for the decode size (most images are
        // landscape / width-constrained); fall back to height. Passing a single
        // dimension preserves the decoded bitmap's aspect ratio.
        double? logicalW = width;
        if (logicalW == null || !logicalW.isFinite) {
          logicalW = constraints.hasBoundedWidth ? constraints.maxWidth : null;
        }
        double? logicalH = height;
        if (logicalH == null || !logicalH.isFinite) {
          logicalH = constraints.hasBoundedHeight ? constraints.maxHeight : null;
        }

        int? memW;
        int? memH;
        if (logicalW != null && logicalW.isFinite && logicalW > 0) {
          memW = (logicalW * dpr).round();
        } else if (logicalH != null && logicalH.isFinite && logicalH > 0) {
          memH = (logicalH * dpr).round();
        }

        return CachedNetworkImage(
          imageUrl: url!,
          fit: fit,
          width: width,
          height: height,
          memCacheWidth: memW,
          memCacheHeight: memW == null ? memH : null,
          maxWidthDiskCache: memW,
          maxHeightDiskCache: memW == null ? memH : null,
          fadeInDuration: const Duration(milliseconds: 150),
          fadeOutDuration: const Duration(milliseconds: 100),
          placeholder: (_, __) => _fallback(placeholder),
          errorWidget: (_, __, ___) => _fallback(errorWidget ?? placeholder),
        );
      },
    );

    if (borderRadius != null) {
      child = ClipRRect(borderRadius: borderRadius!, child: child);
    }
    return child;
  }

  Widget _fallback(Widget? custom) {
    if (custom != null) return custom;
    return Container(
      color: backgroundColor ?? AppColors.primarySoft,
      alignment: Alignment.center,
      child: const Icon(Icons.image_outlined, color: AppColors.primary),
    );
  }
}
