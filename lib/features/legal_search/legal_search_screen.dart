import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_network_image.dart';
import '../../core/widgets/async_view.dart';
import '../../core/widgets/custom_screen.dart';
import 'legal_api.dart';

/// "Tra cứu pháp lý" — searchable list of legal/policy archives + HTML detail.
class LegalSearchScreen extends ConsumerStatefulWidget {
  const LegalSearchScreen({super.key});
  @override
  ConsumerState<LegalSearchScreen> createState() => _LegalSearchScreenState();
}

class _LegalSearchScreenState extends ConsumerState<LegalSearchScreen> {
  final _search = TextEditingController();
  String _keyword = '';
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _onChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400),
        () => setState(() => _keyword = v.trim()));
  }

  @override
  Widget build(BuildContext context) {
    final list = ref.watch(legalSearchProvider(_keyword));
    return CustomScreen(
      title: 'Tra cứu pháp lý',
      backgroundColor: AppColors.bg,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _search,
              onChanged: _onChanged,
              decoration: InputDecoration(
                hintText: 'Tìm văn bản pháp lý...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
              ),
            ),
          ),
          Expanded(
            child: AsyncView<List<LegalItem>>(
              value: list,
              onRetry: () => ref.invalidate(legalSearchProvider(_keyword)),
              data: (items) {
                if (items.isEmpty) {
                  return const Center(child: Text('Không có kết quả'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _LegalCard(
                    item: items[i],
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                LegalDetailScreen(id: items[i].id, fallback: items[i]))),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LegalCard extends StatelessWidget {
  const _LegalCard({required this.item, required this.onTap});
  final LegalItem item;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              child: SizedBox(
                width: 64,
                height: 64,
                child: (item.thumbnail ?? '').isNotEmpty
                    ? AppNetworkImage(url: item.thumbnail, width: 64, height: 64)
                    : Container(
                        color: AppColors.primarySoft,
                        child: const Icon(Icons.gavel_rounded,
                            color: AppColors.primary)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                  if (item.summary.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(item.summary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.caption
                            .copyWith(color: AppColors.textMute)),
                  ],
                  if (item.createdOn.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(item.createdOn,
                        style: AppTypography.micro
                            .copyWith(color: AppColors.textMute)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LegalDetailScreen extends ConsumerWidget {
  const LegalDetailScreen({super.key, required this.id, this.fallback});
  final int id;
  final LegalItem? fallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(legalDetailProvider(id));
    return CustomScreen(
      title: 'Chi tiết',
      backgroundColor: AppColors.bg,
      child: AsyncView<LegalItem>(
        value: detail,
        onRetry: () => ref.invalidate(legalDetailProvider(id)),
        data: (d) {
          final html = (d.htmlContent ?? '').isNotEmpty
              ? d.htmlContent!
              : (fallback?.htmlContent ?? '');
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(d.name.isNotEmpty ? d.name : (fallback?.name ?? ''),
                  style: AppTypography.title),
              if (d.createdOn.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(d.createdOn,
                    style:
                        AppTypography.caption.copyWith(color: AppColors.textMute)),
              ],
              const SizedBox(height: 12),
              if (html.isNotEmpty)
                HtmlWidget(html)
              else
                Text(d.summary.isNotEmpty ? d.summary : 'Chưa có nội dung',
                    style: AppTypography.body),
            ],
          );
        },
      ),
    );
  }
}
