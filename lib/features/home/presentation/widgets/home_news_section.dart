import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../data/models/home_banner.dart';
import '../home_providers.dart';

/// "🔥 Tin tức BĐS" (v1 `RealEstateNewsView`): a horizontal rail of news cards
/// (image 160×144, radius 8, 3-line title). A card with an http link opens the
/// in-app webview. Hidden while empty/failed.
class HomeNewsSection extends ConsumerWidget {
  const HomeNewsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final news = ref.watch(homeNewsProvider);
    return news.maybeWhen(
      data: (list) {
        if (list.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _NewsHeader(),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < list.length; i++) ...[
                    if (i > 0) const SizedBox(width: 16),
                    _NewsCard(news: list[i]),
                  ],
                ],
              ),
            ),
          ],
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _NewsHeader extends StatelessWidget {
  const _NewsHeader();
  @override
  Widget build(BuildContext context) =>
      Text('🔥 Tin tức BĐS', style: AppTextStyles.semibold(20));
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({required this.news});
  final HomeBanner news;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final link = news.link ?? '';
        if (link.startsWith('http')) {
          context.push('/webview',
              extra: {'url': link, 'title': news.title ?? ''});
        }
      },
      child: SizedBox(
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AppNetworkImage(
                url: news.image,
                width: 160,
                height: 144,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Text(
                news.title ?? '',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.semibold(15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
