import 'package:flutter/material.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_network_image.dart';

/// "Mặt bằng dự án" — master-plan image carousel with an index counter; tapping
/// an image opens a zoomable full-screen viewer (v1 `ProjectLayout`).
class ProjectMasterPlanSection extends StatefulWidget {
  const ProjectMasterPlanSection({super.key, required this.images});
  final List<String> images;

  @override
  State<ProjectMasterPlanSection> createState() =>
      _ProjectMasterPlanSectionState();
}

class _ProjectMasterPlanSectionState extends State<ProjectMasterPlanSection> {
  final _page = PageController();
  int _index = 0;

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imgs = widget.images;
    if (imgs.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text('Mặt bằng dự án', style: AppTextStyles.semibold(20)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            children: [
              SizedBox(
                height: 250,
                child: PageView.builder(
                  controller: _page,
                  itemCount: imgs.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (_, i) => GestureDetector(
                    onTap: () => _openViewer(context, imgs[i]),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusLg),
                      child: AppNetworkImage(url: imgs[i], height: 250),
                    ),
                  ),
                ),
              ),
              if (imgs.length > 1)
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('${_index + 1}/${imgs.length}',
                        style: AppTextStyles.semibold(14, color: Colors.white)),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _openViewer(BuildContext context, String url) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black,
      builder: (_) => Stack(
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              minScale: 0.8,
              maxScale: 4,
              child: Center(child: AppNetworkImage(url: url)),
            ),
          ),
          Positioned(
            top: 40,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
