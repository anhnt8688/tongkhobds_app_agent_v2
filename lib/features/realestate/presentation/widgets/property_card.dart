import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../favorites/favorites_actions.dart';
import '../../data/models/property.dart';

/// Property thumbnail placeholder / image (used by cards and detail gallery).
class PropertyImage extends StatelessWidget {
  const PropertyImage({super.key, this.url, this.height = 130, this.radius});

  final String? url;
  final double height;
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    final r = radius ?? BorderRadius.circular(AppSpacing.radiusLg);
    return SizedBox(
      height: height,
      width: double.infinity,
      child: AppNetworkImage(
        url: url,
        height: height,
        borderRadius: r,
        placeholder: _placeholder(),
      ),
    );
  }

  Widget _placeholder() => Container(
        color: const Color(0xFFFFF4E6),
        child: const Icon(Icons.apartment_rounded,
            color: AppColors.primary, size: 32),
      );
}

/// Horizontal list card — faithful port of v1 `ProductItemVertical`: a square
/// image (heart overlay top-right) beside a column of title (with optional inline
/// activity badge) · price · address · bed/bath/area meta. [imageSize] shrinks
/// the whole card for constrained layouts (compare slots, horizontal blocks).
class PropertyCard extends ConsumerStatefulWidget {
  const PropertyCard({
    super.key,
    required this.property,
    this.onTap,
    this.onRemoveFavorite,
    this.hot = false,
    this.imageSize = 150,
  });

  final Property property;
  final VoidCallback? onTap;
  final Future<void> Function()? onRemoveFavorite;

  /// Kept for call-site compatibility; v1's card has no HOT tag so it is unused.
  final bool hot;

  /// Side length of the square thumbnail (and the content column height).
  final double imageSize;

  @override
  ConsumerState<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends ConsumerState<PropertyCard> {
  late bool _fav = widget.property.isFavorite;
  bool _busy = false;

  Property get p => widget.property;

  Future<void> _toggleFavorite() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      if (widget.onRemoveFavorite != null) {
        await widget.onRemoveFavorite!();
        return;
      }
      final added = await showSaveToFavoriteSheet(context, ref, p.id);
      if (added && mounted) setState(() => _fav = true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.imageSize;
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _image(size),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: size,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _title(),
                      Text(
                        p.priceText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.semibold(17, color: AppColors.price),
                      ),
                      if (p.shortAddress.isNotEmpty) _address(),
                      _meta(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _image(double size) {
    return Stack(
      children: [
        AppNetworkImage(
          url: p.image,
          width: size,
          height: size,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          placeholder: _thumbPlaceholder(),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: InkWell(
            onTap: _toggleFavorite,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Image.asset(
                _fav
                    ? 'assets/images/favorited.png'
                    : 'assets/images/icHeartOutline.png',
                width: 32,
                height: 32,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// v1 `_buildTitle`: an inline solid activity badge (if any) preceding the
  /// title, both in semibold-15.
  Widget _title() {
    final badge = p.statusBadge ?? (p.isVerified ? 'Đã xác thực' : null);
    if (badge == null) {
      return Text(p.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.semibold(15));
    }
    return Text.rich(
      TextSpan(
        style: AppTextStyles.semibold(15),
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.success,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(badge,
                  style: AppTextStyles.semibold(13, color: Colors.white)),
            ),
          ),
          const WidgetSpan(child: SizedBox(width: 6)),
          TextSpan(text: p.title),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _address() {
    return Row(
      children: [
        Image.asset('assets/images/location_icon.png', width: 16, height: 16),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            p.shortAddress,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.regular(15, color: AppColors.neutral400),
          ),
        ),
      ],
    );
  }

  Widget _meta() {
    final items = <Widget>[
      if (p.bedrooms != null)
        _iconInfo('assets/images/bed_room_icon.png', '${p.bedrooms}'),
      if (p.bathrooms != null)
        _iconInfo('assets/images/bad_room_icon.png', '${p.bathrooms}'),
      if (p.area != null)
        _iconInfo('assets/images/area_icon.png', p.areaText),
    ];
    if (items.isEmpty) return const SizedBox.shrink();
    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(width: 16),
          items[i],
        ],
      ],
    );
  }

  Widget _iconInfo(String icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(icon, width: 16, height: 16),
        const SizedBox(width: 4),
        Text(value,
            style: AppTextStyles.regular(15, color: AppColors.neutral400)),
      ],
    );
  }

  Widget _thumbPlaceholder() => Container(
        color: const Color(0xFFFFF4E6),
        child: const Icon(Icons.image_outlined,
            color: Color(0xFFF1913D), size: 28),
      );
}
