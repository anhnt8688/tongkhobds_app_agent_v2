import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A titled, rounded card grouping a form section (v1 `create_news` panels).
///
/// v1 layering: section bg `#FAFAF9` sitting on a `neutral100` page, radius 16,
/// title `semibold(20)`. When [collapsible] is set the title row shows a
/// chevron and the body can be folded away (v1 "Mô tả chính" / "Mô tả thêm" /
/// "Nội dung tin đăng").
class SectionCard extends StatefulWidget {
  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.collapsible = false,
    this.initiallyExpanded = true,
  });

  final String title;
  final Widget child;
  final bool collapsible;
  final bool initiallyExpanded;

  @override
  State<SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<SectionCard> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final header = Row(
      children: [
        Expanded(
          child: Text(widget.title, style: AppTextStyles.semibold(20)),
        ),
        if (widget.collapsible)
          Icon(
            _expanded
                ? Icons.keyboard_arrow_up_sharp
                : Icons.keyboard_arrow_down_sharp,
            color: AppColors.text,
          ),
      ],
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bg, // #FAFAF9 (v1 section fill)
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.collapsible
              ? GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _expanded = !_expanded),
                  child: header,
                )
              : header,
          if (_expanded) ...[
            const SizedBox(height: 16),
            widget.child,
          ],
        ],
      ),
    );
  }
}
