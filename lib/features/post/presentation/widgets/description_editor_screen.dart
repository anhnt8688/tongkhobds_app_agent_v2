import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_screen.dart';

/// Result of the rich-text editor: HTML markup + its plain-text projection.
class DescriptionResult {
  const DescriptionResult(this.html, this.plain);
  final String html;
  final String plain;
}

/// Full-screen rich-text editor for the listing description (matches v1's quill
/// popup). Returns a [DescriptionResult] on "Xong", or null if dismissed.
class DescriptionEditorScreen extends StatefulWidget {
  const DescriptionEditorScreen({super.key, this.initialPlain = ''});
  final String initialPlain;

  @override
  State<DescriptionEditorScreen> createState() =>
      _DescriptionEditorScreenState();
}

class _DescriptionEditorScreenState extends State<DescriptionEditorScreen> {
  late final quill.QuillController _controller;
  final _focus = FocusNode();
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = quill.QuillController.basic();
    if (widget.initialPlain.isNotEmpty) {
      _controller.document.insert(0, widget.initialPlain);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _done() {
    final delta = _controller.document.toDelta();
    final html = QuillDeltaToHtmlConverter(
      delta.toJson(),
      ConverterOptions.forEmail(),
    ).convert();
    final plain = _controller.document.toPlainText().trim();
    Navigator.pop(context, DescriptionResult(html, plain));
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'Chỉnh sửa mô tả',
      backgroundColor: Colors.white,
      // White text — the action sits on the orange gradient header (primary
      // colour would be invisible orange-on-orange).
      action: TextButton(
        onPressed: _done,
        child: Text('Xong',
            style: AppTextStyles.semibold(15, color: Colors.white)),
      ),
      child: Column(
        children: [
          quill.QuillSimpleToolbar(
            controller: _controller,
            config: const quill.QuillSimpleToolbarConfig(
              multiRowsDisplay: false,
              showAlignmentButtons: false,
              showCodeBlock: false,
              showInlineCode: false,
              showColorButton: false,
              showBackgroundColorButton: false,
              showFontFamily: false,
              showFontSize: false,
              showSearchButton: false,
              showLink: false,
              showSubscript: false,
              showSuperscript: false,
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: quill.QuillEditor(
                controller: _controller,
                focusNode: _focus,
                scrollController: _scroll,
                config: const quill.QuillEditorConfig(
                  autoFocus: true,
                  placeholder: 'Nhập mô tả chi tiết...',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
