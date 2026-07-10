import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../realestate/data/models/property.dart';
import '../../../realestate/presentation/open_property.dart';
import '../../../realestate/presentation/widgets/property_card.dart';
import '../../data/models/home_block.dart';
import '../home_providers.dart';

/// "BĐS phù hợp" titled blocks (v1 `_blockView` + `BlockCard`): each block is a
/// header + either a horizontal rail (`xtype == 1`) or a vertical list of
/// listings. Blocks are separated by 32px. Hidden while empty/failed.
class HomeBlocksSection extends ConsumerWidget {
  const HomeBlocksSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocks = ref.watch(homeBlocksProvider);
    return blocks.when(
      loading: () => const _BlocksSkeleton(),
      error: (_, __) => const SizedBox.shrink(),
      data: (list) {
        final nonEmpty = list.where((b) => b.products.isNotEmpty).toList();
        if (nonEmpty.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < nonEmpty.length; i++) ...[
              if (i > 0) const SizedBox(height: 32),
              _Block(block: nonEmpty[i]),
            ],
          ],
        );
      },
    );
  }
}

/// Loading placeholder mirroring a block (header + a rail of wide cards).
class _BlocksSkeleton extends StatelessWidget {
  const _BlocksSkeleton();

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ShimmerBox(width: 180, height: 20),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 236,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (_, __) => const SizedBox(
                width: 292,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(height: 164, radius: 12),
                    SizedBox(height: 8),
                    ShimmerBox(width: 220, height: 16),
                    SizedBox(height: 8),
                    ShimmerBox(width: 160, height: 14),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({required this.block});
  final HomeBlock block;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(block.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.semibold(20)),
              ),
              if (!block.isHorizontal)
                GestureDetector(
                  onTap: () => context.go('/search'),
                  child: Text('Xem thêm',
                      style: AppTextStyles.semibold(15,
                          color: AppColors.primary)),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        block.isHorizontal ? _horizontal(context) : _vertical(context),
      ],
    );
  }

  Widget _horizontal(BuildContext context) {
    return SizedBox(
      height: 236,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: block.products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (_, i) => _MiniCard(property: block.products[i]),
      ),
    );
  }

  Widget _vertical(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          for (var i = 0; i < block.products.length; i++) ...[
            if (i > 0) const SizedBox(height: 16),
            PropertyCard(
              property: block.products[i],
              onTap: () => openProperty(context, block.products[i]),
            ),
          ],
        ],
      ),
    );
  }
}

/// Featured-project card for the horizontal rail (v1 `ProductItemHozital`):
/// borderless, 292 wide — image 292×164, a 1-line title optionally prefixed by
/// a green activity chip, then a location row. No price (matches v1).
class _MiniCard extends StatelessWidget {
  const _MiniCard({required this.property});
  final Property property;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => openProperty(context, property),
      child: SizedBox(
        width: 292,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PropertyImage(
              url: property.image,
              height: 164,
              radius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            const SizedBox(height: 8),
            _title(),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 16, color: AppColors.neutral400),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(property.shortAddress,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.regular(15,
                          color: AppColors.neutral400)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Title with an inline green activity chip when the listing has one.
  Widget _title() {
    final badge = property.statusBadge;
    if (badge == null || badge.isEmpty) {
      return Text(property.title,
          maxLines: 1,
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
          TextSpan(text: property.title),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
