import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../contracts/presentation/widgets/library_file_preview_screen.dart';
import '../../../data/models/property_detail.dart';

/// "Giấy tờ pháp lý" — grey rounded cards, tap to open in the in-app viewer.
/// Mirrors v1 `legalDocuments`.
class DetailLegalDocs extends StatelessWidget {
  const DetailLegalDocs({super.key, required this.docs});
  final List<LegalDocFile> docs;

  @override
  Widget build(BuildContext context) {
    if (docs.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Giấy tờ pháp lý', style: AppTextStyles.semibold(20)),
          const SizedBox(height: 16),
          for (var i = 0; i < docs.length; i++) ...[
            _card(context, docs[i]),
            if (i != docs.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  Widget _card(BuildContext context, LegalDocFile d) {
    final name =
        (d.title == null || d.title!.isEmpty) ? 'Tài liệu pháp lý' : d.title!;
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => LibraryFilePreviewScreen(url: d.url!, name: name),
      )),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.description_outlined,
                size: 20, color: AppColors.primary),
            const SizedBox(width: 10),
            Expanded(child: Text(name, style: AppTextStyles.regular(15))),
            const Icon(Icons.chevron_right, size: 20, color: AppColors.textMute),
          ],
        ),
      ),
    );
  }
}
