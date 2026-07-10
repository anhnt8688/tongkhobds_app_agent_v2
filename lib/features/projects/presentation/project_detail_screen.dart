import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/share_util.dart';
import '../../../core/widgets/async_view.dart';
import '../../realestate/presentation/widgets/detail/detail_description.dart';
import '../../realestate/presentation/widgets/detail/detail_gallery.dart';
import '../data/projects_api.dart';
import 'widgets/project/project_bottom_bar.dart';
import 'widgets/project/project_children_section.dart';
import 'widgets/project/project_info_section.dart';
import 'widgets/project/project_masterplan_section.dart';
import 'widgets/project/project_products_section.dart';
import 'widgets/project/project_utilities_section.dart';

/// Project ("dự án") detail from `project_details.json`. Full v1
/// `detail_project_page` parity (minus chat): hero gallery, key info, bảng hàng,
/// mô tả, phân khu, tiện ích, mặt bằng, sản phẩm dự án, sticky bottom bar.
class ProjectDetailScreen extends ConsumerWidget {
  const ProjectDetailScreen({super.key, required this.code});
  final String code;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(projectDetailProvider(code));
    final project = detail.valueOrNull;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: AsyncView<ProjectDetail>(
        value: detail,
        onRetry: () => ref.invalidate(projectDetailProvider(code)),
        data: (p) => CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 300,
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.text,
              scrolledUnderElevation: 0,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              leading: IconButton(
                icon: Image.asset('assets/images/back_bg.png',
                    width: 32, height: 32),
                onPressed: () => context.pop(),
              ),
              actions: [
                IconButton(
                  icon: Image.asset('assets/images/icShare.png',
                      width: 32, height: 32),
                  tooltip: 'Chia sẻ',
                  onPressed: () => shareProject(
                    title: p.name,
                    slug: p.slug,
                    context: context,
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: DetailGallery(
                  images: p.heroImages,
                  code: p.codeShow ?? p.code,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                ProjectInfoSection(project: p),
                if (p.code.isNotEmpty) _boardButton(context, p),
                _description(p),
                ProjectChildrenSection(groups: p.childGroups),
                ProjectUtilitiesSection(utilities: p.utilities),
                ProjectMasterPlanSection(images: p.masterPlanImages),
                ProjectProductsSection(projectCode: p.code),
                const SizedBox(height: 24),
              ]),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          project == null ? null : ProjectBottomBar(project: project),
    );
  }

  Widget _boardButton(BuildContext context, ProjectDetail p) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: () => context.push(
              '/project/${Uri.encodeComponent(p.code)}?name=${Uri.encodeComponent(p.name)}'),
          icon: const Icon(Icons.grid_view_rounded),
          label: const Text('Xem bảng hàng'),
        ),
      ),
    );
  }

  Widget _description(ProjectDetail p) {
    final hasHtml = (p.htmlContent ?? '').trim().isNotEmpty;
    final hasText = (p.description ?? '').trim().isNotEmpty;
    if (!hasHtml && !hasText) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text('Mô tả', style: AppTextStyles.semibold(20)),
        ),
        DetailDescription(html: p.htmlContent, text: p.description),
      ],
    );
  }
}
