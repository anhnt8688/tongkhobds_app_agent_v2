import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../home/data/models/quick_tool.dart';
import '../../data/profile_api.dart';

/// "Công cụ nhanh" grid (v1 profile), server-driven from the `menu-admin`
/// folder. Each tile routes by its `description` (a backend-supplied path).
class ProfileQuickTools extends ConsumerWidget {
  const ProfileQuickTools({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(profileQuickToolsProvider);

    return async.when(
      loading: () => _frame(const SizedBox(
        height: 96,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      )),
      error: (_, __) => const SizedBox.shrink(),
      data: (tools) {
        if (tools.isEmpty) return const SizedBox.shrink();
        return _frame(GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tools.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.86,
          ),
          itemBuilder: (context, i) => _Tile(
            tool: tools[i],
            onTap: () => _handleTap(context, tools[i]),
          ),
        ));
      },
    );
  }

  Widget _frame(Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Công cụ nhanh', style: AppTextStyles.bold(17)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: child,
        ),
      ],
    );
  }

  /// Route a tile by its backend `description` path (ported from v1).
  /// `/messaging` is intentionally unmapped (no v2 screen yet).
  void _handleTap(BuildContext context, QuickTool tool) {
    final desc = tool.description;

    final webUrl = _extractWebviewUrl(desc, '/webview3') ??
        _extractWebviewUrl(desc, '/webview2') ??
        _extractWebviewUrl(desc, '/webview');
    if (webUrl != null) {
      final title = tool.name.trim().isEmpty ? 'Xem chi tiết' : tool.name.trim();
      context.push('/webview', extra: {'url': webUrl, 'title': title});
      return;
    }

    if (desc.contains('/create_post')) {
      context.go('/post');
    } else if (desc.contains('/create_demand')) {
      context.push('/demand/create');
    } else if (desc.contains('/list_deposit')) {
      context.push('/deposit');
    } else if (desc.contains('/appointment_schedule')) {
      context.push('/appointments');
    } else if (desc.contains('/legal_lookup')) {
      context.push('/legal-search');
    } else if (desc.contains('/contract_library')) {
      context.push('/contract-library');
    } else if (desc.contains('/favorites')) {
      context.push('/favorites');
    } else if (desc.contains('/utilities')) {
      context.push('/utilities');
    } else {
      debugPrint('QuickTool không match: $desc');
    }
  }

  /// Pull the `url` query param out of a `/webview?url=...` description.
  String? _extractWebviewUrl(String desc, String path) {
    if (!desc.contains(path)) return null;
    final normalized = desc.startsWith('http') ? desc : 'https://dummy$desc';
    final uri = Uri.tryParse(normalized);
    if (uri == null || !uri.path.contains(path)) return null;
    final url = uri.queryParameters['url'];
    if (url == null || url.trim().isEmpty) return null;
    return Uri.decodeFull(url.trim());
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.tool, required this.onTap});
  final QuickTool tool;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: tool.icon.isEmpty
                  ? const Icon(Icons.apps, size: 22, color: AppColors.primary)
                  : CachedNetworkImage(
                      imageUrl: tool.icon,
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                      errorWidget: (_, __, ___) => const Icon(Icons.apps,
                          size: 22, color: AppColors.primary),
                    ),
            ),
            const SizedBox(height: 8),
            Text(
              tool.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.semibold(12),
            ),
          ],
        ),
      ),
    );
  }
}
