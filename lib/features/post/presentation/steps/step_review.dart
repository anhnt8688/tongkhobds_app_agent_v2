import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../realestate/data/models/property.dart' show formatVnd;
import '../post_controller.dart';
import '../widgets/listing_location_map.dart';

/// Step 3 — "Xác nhận thông tin": a rich preview of the listing mirroring v1
/// `step_three` (carousel + white info card + legal + map).
class StepReview extends ConsumerWidget {
  const StepReview({super.key});

  static const _divider = Divider(
      height: 32, thickness: 0.5, color: AppColors.border); // neutral200

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final d = ref.watch(postControllerProvider);
    final media = [...d.videos, ...d.images];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Xem lại tin đăng', style: AppTextStyles.semibold(20)),
        const SizedBox(height: 12),
        if (media.isNotEmpty) ...[
          _MediaCarousel(videoCount: d.videos.length, media: media),
          const SizedBox(height: 16),
        ],
        _infoCard(d),
      ],
    );
  }

  Widget _infoCard(PostDraft d) {
    const hPad = EdgeInsets.symmetric(horizontal: 16);
    final perM2 = (d.price != null && d.area != null && d.area! > 0)
        ? '${formatVnd(d.price! / d.area!)}/m²'
        : '';
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: hPad,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(d.title.isEmpty ? '(Chưa có tiêu đề)' : d.title,
                style: AppTextStyles.semibold(17)),
            if (d.fullAddress.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Image.asset('assets/images/location_icon.png',
                    width: 16, height: 16),
                const SizedBox(width: 4),
                Expanded(
                    child: Text(d.fullAddress,
                        style: AppTextStyles.regular(13,
                            color: AppColors.textSecondary))),
              ]),
            ],
            const SizedBox(height: 12),
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(formatVnd(d.price),
                          style: AppTextStyles.semibold(20,
                              color: AppColors.price)),
                      if (perM2.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(perM2,
                            style: AppTextStyles.regular(15,
                                color: AppColors.textMute)),
                      ],
                    ]),
              ),
              ..._statBoxes(d),
            ]),
          ]),
        ),
        if (d.htmlContent.isNotEmpty || d.description.isNotEmpty) ...[
          _divider,
          Padding(
            padding: hPad,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mô tả chi tiết', style: AppTextStyles.semibold(20)),
                  const SizedBox(height: 8),
                  d.htmlContent.isNotEmpty
                      ? HtmlWidget(d.htmlContent)
                      : Text(d.description, style: AppTextStyles.regular(15)),
                ]),
          ),
        ],
        if (d.legalDocs.isNotEmpty) ...[
          _divider,
          Padding(
            padding: hPad,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Giấy tờ pháp lý', style: AppTextStyles.semibold(20)),
                  const SizedBox(height: 12),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    for (final url in d.legalDocs) _LegalThumb(url: url),
                  ]),
                ]),
          ),
        ],
        if (d.lat != null && d.lng != null) ...[
          _divider,
          Padding(
            padding: hPad,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Vị trí trên bản đồ', style: AppTextStyles.semibold(20)),
                  if (d.fullAddress.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(d.fullAddress, style: AppTextStyles.regular(14)),
                  ],
                  const SizedBox(height: 12),
                  ListingLocationMap(lat: d.lat!, lng: d.lng!),
                ]),
          ),
        ],
      ]),
    );
  }

  /// The right-hand PN / WC / DT stat boxes (v1: icon + value chips).
  List<Widget> _statBoxes(PostDraft d) {
    Widget box(String asset, String value) => Container(
          margin: const EdgeInsets.only(left: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.bg, // #FAFAF9
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Image.asset(asset, width: 16, height: 16),
            const SizedBox(height: 2),
            Text(value,
                style: AppTextStyles.medium(13, color: AppColors.neutral400)),
          ]),
        );
    return [
      if (d.bedrooms > 0) box('assets/images/bed_room_icon.png', '${d.bedrooms}'),
      if (d.bathrooms > 0)
        box('assets/images/bad_room_icon.png', '${d.bathrooms}'),
      if (d.area != null)
        box('assets/images/area_icon.png', '${d.area!.toInt()} m²'),
    ];
  }
}

/// A 1:1 media carousel with a bottom-right "index/total" counter (v1 uses
/// `libraryIcon`). Videos are shown before images.
class _MediaCarousel extends StatefulWidget {
  const _MediaCarousel({required this.videoCount, required this.media});
  final int videoCount;
  final List<String> media;

  @override
  State<_MediaCarousel> createState() => _MediaCarouselState();
}

class _MediaCarouselState extends State<_MediaCarousel> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(fit: StackFit.expand, children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.media.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (_, i) {
              final isVideo = i < widget.videoCount;
              if (isVideo) {
                return Container(
                  color: Colors.black87,
                  child: const Center(
                      child: Icon(Icons.play_circle_fill,
                          color: Colors.white, size: 48)),
                );
              }
              return AppNetworkImage(url: widget.media[i], fit: BoxFit.cover);
            },
          ),
          Positioned(
            right: 8,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Image.asset('assets/images/libraryIcon.png',
                    width: 16, height: 16),
                const SizedBox(width: 4),
                Text('${_index + 1}/${widget.media.length}',
                    style: AppTextStyles.medium(14, color: Colors.white)),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}

/// Small legal-document thumbnail (PDF icon or image), 80×80 rounded.
class _LegalThumb extends StatelessWidget {
  const _LegalThumb({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    final isPdf = url.toLowerCase().endsWith('.pdf');
    return SizedBox(
      width: 80,
      height: 80,
      child: isPdf
          ? Container(
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                  child: Icon(Icons.picture_as_pdf,
                      color: Color(0xFFFF3B30), size: 32)),
            )
          : AppNetworkImage(url: url, borderRadius: BorderRadius.circular(12)),
    );
  }
}
