import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../data/models/home_banner.dart';
import '../home_providers.dart';

/// "Sự kiện đang diễn ra" (v1 `eventRunningSection`): a full-width event
/// carousel (radius 16, height 150, auto-play 5s) with a "current/total" counter
/// badge bottom-right. Hidden entirely when the folder is empty.
class HomeEventsCarousel extends ConsumerStatefulWidget {
  const HomeEventsCarousel({super.key});

  @override
  ConsumerState<HomeEventsCarousel> createState() =>
      _HomeEventsCarouselState();
}

class _HomeEventsCarouselState extends ConsumerState<HomeEventsCarousel> {
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
    final events = ref.watch(homeEventsProvider);
    return events.maybeWhen(
      data: (list) {
        if (list.isEmpty) return const SizedBox.shrink();
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _autoPlay(list.length));
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sự kiện đang diễn ra', style: AppTextStyles.bold(22)),
              const SizedBox(height: 12),
              SizedBox(
                height: 150,
                child: PageView.builder(
                  controller: _controller,
                  itemCount: list.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (_, i) => _EventCard(
                    event: list[i],
                    position: '${i + 1}/${list.length}',
                  ),
                ),
              ),
            ],
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event, required this.position});
  final HomeBanner event;
  final String position;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final link = event.link ?? '';
        if (link.startsWith('http')) {
          context.push('/webview',
              extra: {'url': link, 'title': event.title ?? ''});
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AppNetworkImage(url: event.image, fit: BoxFit.cover),
            Positioned(
              right: 10,
              bottom: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(position,
                    style: AppTextStyles.semibold(13, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
