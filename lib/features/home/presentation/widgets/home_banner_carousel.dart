import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_network_image.dart';
import '../../data/models/home_banner.dart';
import '../home_providers.dart';

/// Top banner carousel (v1 `banner()`): full-bleed slides at 295/392 aspect
/// ratio, radius 8, auto-play every 5s. No gradient, no dots, no overlay — just
/// the image, matching v1. A slide taps through to its project detail.
class HomeBannerCarousel extends ConsumerStatefulWidget {
  const HomeBannerCarousel({super.key});

  @override
  ConsumerState<HomeBannerCarousel> createState() => _HomeBannerCarouselState();
}

class _HomeBannerCarouselState extends ConsumerState<HomeBannerCarousel> {
  final _controller = PageController();
  Timer? _timer;
  int _index = 0;
  int _count = 0;

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _autoPlay(int count) {
    if (count == _count) return;
    _count = count;
    _timer?.cancel();
    if (count <= 1) return;
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_controller.hasClients) return;
      final next = (_index + 1) % count;
      _controller.animateToPage(next,
          duration: const Duration(milliseconds: 400), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    final banners = ref.watch(homeBannersProvider);
    final width = MediaQuery.of(context).size.width;
    final height = width * 295 / 392;

    return banners.maybeWhen(
      data: (list) {
        if (list.isEmpty) return SizedBox(height: height, child: _blank());
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _autoPlay(list.length));
        return SizedBox(
          height: height,
          child: PageView.builder(
            controller: _controller,
            itemCount: list.length,
            onPageChanged: (i) => _index = i,
            itemBuilder: (_, i) => _Slide(banner: list[i]),
          ),
        );
      },
      // While loading / on error, show the blank banner like v1.
      orElse: () => SizedBox(height: height, child: _blank()),
    );
  }

  Widget _blank() => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset('assets/images/blank_banner.jpg',
            fit: BoxFit.cover, width: double.infinity),
      );
}

class _Slide extends StatelessWidget {
  const _Slide({required this.banner});
  final HomeBanner banner;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final pid = banner.projectId;
        if (pid != null) {
          context.push('/project-detail/${Uri.encodeComponent(pid)}');
          return;
        }
        final link = banner.link ?? '';
        if (link.startsWith('http')) {
          context.push('/webview',
              extra: {'url': link, 'title': banner.title ?? ''});
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AppNetworkImage(
          url: banner.image,
          fit: BoxFit.cover,
          errorWidget: Image.asset('assets/images/blank_banner.jpg',
              fit: BoxFit.cover, width: double.infinity),
        ),
      ),
    );
  }
}
