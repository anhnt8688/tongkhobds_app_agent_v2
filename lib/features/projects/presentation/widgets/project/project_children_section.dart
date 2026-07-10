import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_network_image.dart';
import '../../../data/models/project_detail.dart';

/// "Phân khu" — child projects grouped by property type (v1
/// `ChildProjectListView`). Each child card opens its own project-detail page.
class ProjectChildrenSection extends StatelessWidget {
  const ProjectChildrenSection({super.key, required this.groups});
  final List<ProjectChildGroup> groups;

  @override
  Widget build(BuildContext context) {
    final visible = groups.where((g) => g.children.isNotEmpty).toList();
    if (visible.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final g in visible) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(g.title.isEmpty ? 'Phân khu' : g.title,
                style: AppTextStyles.semibold(20)),
          ),
          for (final c in g.children) _ChildCard(item: c),
        ],
      ],
    );
  }
}

class _ChildCard extends StatelessWidget {
  const _ChildCard({required this.item});
  final ProjectChildItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.code.isEmpty
          ? null
          : () => context.push(
              '/project-detail/${Uri.encodeComponent(item.code)}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 110,
              height: 110,
              child: AppNetworkImage(
                url: item.image,
                width: 110,
                height: 110,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                placeholder: Container(
                  color: AppColors.primarySoft,
                  alignment: Alignment.center,
                  child: const Icon(Icons.apartment_rounded,
                      color: AppColors.primary, size: 28),
                ),
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
                      style: AppTextStyles.semibold(15)),
                  const SizedBox(height: 6),
                  if (item.areaText.isNotEmpty)
                    _meta(Icons.straighten, item.areaText),
                  if (item.totalUnits != null)
                    _meta(Icons.home_work_outlined, '${item.totalUnits} căn'),
                  if ((item.address ?? '').isNotEmpty)
                    _meta(Icons.location_on_outlined, item.address!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _meta(IconData icon, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 14, color: AppColors.textMute),
            const SizedBox(width: 6),
            Expanded(
              child: Text(text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.regular(13,
                      color: AppColors.textSecondary)),
            ),
          ],
        ),
      );
}
