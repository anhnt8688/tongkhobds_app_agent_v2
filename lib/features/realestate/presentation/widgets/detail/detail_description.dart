import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../../../../core/theme/app_text_styles.dart';

/// Listing description — renders HTML content when available, else plain text.
/// Mirrors v1 `noteView` (inline, no card chrome).
class DetailDescription extends StatelessWidget {
  const DetailDescription({super.key, this.html, this.text});
  final String? html;
  final String? text;

  bool get _hasHtml => html != null && html!.trim().isNotEmpty;
  bool get _hasText => text != null && text!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    if (!_hasHtml && !_hasText) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _hasHtml
          ? HtmlWidget(html!)
          : Text(text!, style: AppTextStyles.regular(15).copyWith(height: 1.5)),
    );
  }
}
