import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/custom_screen.dart';
import '../data/contracts_api.dart';
import 'widgets/library_file_preview_screen.dart';

class LibraryDetailScreen extends ConsumerWidget {
  const LibraryDetailScreen({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(libraryDetailProvider(id));
    return CustomScreen(
      title: 'Chi tiết hợp đồng',
      child: AsyncView<LibraryDetail>(
        value: detail,
        onRetry: () => ref.invalidate(libraryDetailProvider(id)),
        data: (d) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(d.name, style: AppTextStyles.semibold(20)),
            if ((d.createdOn ?? '').isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(d.createdOn!,
                  style: AppTextStyles.regular(13, color: AppColors.textMute)),
            ],
            const SizedBox(height: 12),
            if (d.gallery.isNotEmpty) ...[
              Text('Tệp đính kèm', style: AppTextStyles.semibold(20)),
              const SizedBox(height: 8),
              for (final f in d.gallery)
                _FileTile(file: f, onOpen: () => _openInApp(context, f)),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
            ],
            if (d.htmlContent.trim().isNotEmpty)
              HtmlWidget(d.htmlContent)
            else if (d.gallery.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Center(
                    child: Text('Không có nội dung',
                        style: AppTextStyles.regular(15,
                            color: AppColors.textMute))),
              ),
          ],
        ),
      ),
    );
  }

  void _openInApp(BuildContext context, GalleryFile file) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => LibraryFilePreviewScreen(url: file.url, name: file.name),
    ));
  }
}

/// v1 file gallery row: filled neutral-200 box, file name + download/open icon.
class _FileTile extends StatelessWidget {
  const _FileTile({required this.file, required this.onOpen});
  final GalleryFile file;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.neutral200, // v1 #E7E5E4
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(file.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.semibold(15)),
              ),
              const SizedBox(width: 12),
              Icon(file.isPdf ? Icons.picture_as_pdf_outlined : Icons.download,
                  size: 18, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
