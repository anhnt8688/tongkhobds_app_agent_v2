import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_network_image.dart';
import '../../../../../core/widgets/app_toast.dart';
import '../property_card.dart';

/// Full-bleed image carousel used as the collapsing header background. Shows an
/// image counter (bottom-left) and a copyable property code chip (bottom-right),
/// matching v1's `productSlide`.
class DetailGallery extends StatefulWidget {
  const DetailGallery({
    super.key,
    required this.images,
    this.videoCount = 0,
    this.code,
  });

  final List<String> images;
  final int videoCount;
  final String? code;

  @override
  State<DetailGallery> createState() => _DetailGalleryState();
}

class _DetailGalleryState extends State<DetailGallery> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final imgs = widget.images;
    final total = imgs.isEmpty ? 0 : imgs.length;
    return Stack(
      fit: StackFit.expand,
      children: [
        imgs.isEmpty
            ? const Positioned.fill(
                child: PropertyImage(height: 300, radius: BorderRadius.zero))
            : PageView.builder(
                itemCount: imgs.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) => AppNetworkImage(
                  url: imgs[i],
                  errorWidget: const PropertyImage(radius: BorderRadius.zero),
                ),
              ),
        if (total > 0)
          Positioned(
            left: 16,
            bottom: 16,
            child: _chip(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/libraryIcon.png',
                      width: 16, height: 16),
                  const SizedBox(width: 4),
                  Text('${_index + 1}/$total',
                      style: AppTextStyles.medium(14, color: Colors.white)),
                ],
              ),
            ),
          ),
        if (widget.code != null && widget.code!.isNotEmpty)
          Positioned(
            right: 16,
            bottom: 16,
            child: GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: widget.code!));
                AppToast.info(context, 'Đã sao chép mã ${widget.code}');
              },
              child: _chip(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(widget.code!,
                        style: AppTextStyles.semibold(13, color: Colors.white)),
                    const SizedBox(width: 6),
                    const Icon(Icons.copy, size: 12, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _chip({required Widget child}) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(6),
        ),
        child: child,
      );
}
