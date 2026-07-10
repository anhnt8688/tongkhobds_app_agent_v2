import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../data/models/quick_tool.dart';
import '../home_nav.dart';
import '../home_providers.dart';

/// "Công cụ nhanh" (v1 `QuickTool`): a 4-per-row wrap of server-driven tools
/// (folder=19). Icons are remote images on a soft square; the tap destination
/// is decoded from each item's `description`. Hidden while empty/failed.
class HomeQuickTools extends ConsumerWidget {
  const HomeQuickTools({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tools = ref.watch(quickToolsProvider);
    return tools.when(
      loading: () => const _QuickToolsSkeleton(),
      error: (_, __) => const SizedBox.shrink(),
      data: (list) =>
          list.isEmpty ? const SizedBox.shrink() : _grid(context, list),
    );
  }

  Widget _grid(BuildContext context, List<QuickTool> tools) {
    final itemWidth = (MediaQuery.of(context).size.width - 80) / 4;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Công cụ nhanh', style: AppTextStyles.bold(22)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (final t in tools)
                SizedBox(
                  width: itemWidth,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => onTapTool(context, t),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: AppNetworkImage(
                            url: t.icon,
                            width: 24,
                            height: 24,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(t.name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.semibold(13)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Loading placeholder mirroring the quick-tools grid (header + a row of 4).
class _QuickToolsSkeleton extends StatelessWidget {
  const _QuickToolsSkeleton();

  @override
  Widget build(BuildContext context) {
    final w = (MediaQuery.of(context).size.width - 80) / 4;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AppShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShimmerBox(width: 160, height: 22),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var i = 0; i < 4; i++)
                  SizedBox(
                    width: w,
                    child: const Column(
                      children: [
                        ShimmerBox(width: 48, height: 48, radius: 8),
                        SizedBox(height: 8),
                        ShimmerBox(width: 40, height: 10),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Resolves a tool's `description` to an action (v1 `QuickTool` routing):
/// embedded webviews, e-learning, messaging, or a known in-app route.
Future<void> onTapTool(BuildContext context, QuickTool tool) async {
  final desc = tool.description;

  final webUrl = _webviewUrl(desc);
  if (webUrl != null) {
    context.push('/webview', extra: {'url': webUrl, 'title': tool.name});
    return;
  }
  if (desc.contains('/elearning') || desc.contains('/e-learning')) {
    context.push('/webview',
        extra: {'url': AppConfig.eLearningUrl, 'title': 'E-learning'});
    return;
  }
  if (desc.contains('/messaging')) {
    AppToast.info(context, 'Tính năng nhắn tin sắp ra mắt');
    return;
  }

  final route = _routeFor(desc);
  if (route != null && context.mounted) navTo(context, route);
}

/// Maps a known description path to a go_router route, mirroring v1.
String? _routeFor(String desc) {
  if (desc.contains('/create_post')) return '/post';
  if (desc.contains('/create_demand')) return '/demand/create';
  if (desc.contains('/list_deposit')) return '/deposit';
  if (desc.contains('/appointment_schedule')) return '/appointments';
  if (desc.contains('/legal_lookup')) return '/legal-search';
  if (desc.contains('/contract_library')) return '/contracts';
  if (desc.contains('/favorites')) return '/favorites';
  if (desc.contains('/utilities')) return '/utilities';
  // "Bảng hàng" listing board → the search tab.
  if (desc.contains('/inventory') ||
      desc.contains('/bang_hang') ||
      desc.contains('/banghang') ||
      desc.contains('/list_real_estate')) {
    return '/search';
  }
  return null;
}

/// Extracts the embedded `url` query param from a `/webview[2|3]` description.
String? _webviewUrl(String desc) {
  for (final path in const ['/webview3', '/webview2', '/webview']) {
    if (!desc.contains(path)) continue;
    final normalized = desc.startsWith('http') ? desc : 'https://dummy$desc';
    final uri = Uri.tryParse(normalized);
    if (uri == null || !uri.path.contains(path)) continue;
    final url = uri.queryParameters['url'];
    if (url == null || url.trim().isEmpty) return null;
    return Uri.decodeFull(url.trim());
  }
  return null;
}
