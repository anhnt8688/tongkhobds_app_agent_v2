import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../post_controller.dart';
import '../widgets/dashed_upload_tile.dart';
import '../widgets/media_tile.dart';

/// Step 2 — "Hình ảnh, Video": photos (≥4), video, and legal documents.
class StepMedia extends ConsumerWidget {
  const StepMedia({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final d = ref.watch(postControllerProvider);
    final n = ref.read(postControllerProvider.notifier);

    Future<void> pickImages() async {
      final files = await ImagePicker().pickMultiImage();
      if (files.isNotEmpty) await n.addImages(files.map((f) => f.path).toList());
    }

    Future<void> pickVideo() async {
      final f = await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (f != null) await n.addVideos([f.path]);
    }

    Future<void> pickDocs() async {
      final res = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
      );
      final paths =
          res?.files.map((f) => f.path).whereType<String>().toList() ?? [];
      if (paths.isNotEmpty) await n.addLegalDocs(paths);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _header('Hình ảnh nhà',
            'Đăng tối thiểu 4 hình (không vượt quá 5MB). Video tối đa 100MB.',
            required: true),
        const SizedBox(height: 12),
        _grid([
          for (var i = 0; i < d.images.length; i++)
            MediaTile(
              child: AppNetworkImage(
                  url: d.images[i],
                  borderRadius: BorderRadius.circular(16)),
              onRemove: () => n.removeImage(i),
            ),
          for (var i = 0; i < d.videos.length; i++)
            MediaTile(
              child: const _VideoPlaceholder(),
              onRemove: () => n.removeVideo(i),
            ),
          DashedUploadTile(
              label: 'Tải ảnh', loading: d.uploading, onTap: pickImages),
          DashedUploadTile(label: 'Tải video', onTap: pickVideo),
        ]),
        // v1: legal-documents section appears only once at least one house
        // image has been uploaded.
        if (d.images.isNotEmpty) ...[
          const SizedBox(height: 24),
          _header('Giấy tờ pháp lý',
              'Cung cấp hình ảnh giấy tờ pháp lý tăng thêm độ uy tín cho sản phẩm'),
          const SizedBox(height: 12),
          _grid([
            for (var i = 0; i < d.legalDocs.length; i++)
              MediaTile(
                child: _DocTile(url: d.legalDocs[i]),
                onRemove: () => n.removeLegalDoc(i),
              ),
            DashedUploadTile(label: 'Tải file đính kèm', onTap: pickDocs),
          ]),
        ],
      ],
    );
  }

  Widget _header(String title, String subtitle, {bool required = false}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text.rich(TextSpan(text: title, style: AppTextStyles.semibold(20),
          children: required
              ? [
                  TextSpan(
                      text: ' *',
                      style:
                          AppTextStyles.semibold(20, color: AppColors.danger)),
                ]
              : null)),
      const SizedBox(height: 4),
      Text(subtitle,
          style: AppTextStyles.regular(15, color: AppColors.neutral400)),
    ]);
  }

  Widget _grid(List<Widget> children) => GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: children,
      );
}

class _VideoPlaceholder extends StatelessWidget {
  const _VideoPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: const Center(
          child: Icon(Icons.play_circle_fill, color: Colors.white, size: 32)),
    );
  }
}

class _DocTile extends StatelessWidget {
  const _DocTile({required this.url});
  final String url;
  @override
  Widget build(BuildContext context) {
    final isPdf = url.toLowerCase().endsWith('.pdf');
    if (isPdf) {
      return Container(
        color: AppColors.bg,
        child: const Center(
            child: Icon(Icons.picture_as_pdf, color: Color(0xFFFF3B30), size: 32)),
      );
    }
    return AppNetworkImage(url: url, borderRadius: BorderRadius.circular(16));
  }
}
