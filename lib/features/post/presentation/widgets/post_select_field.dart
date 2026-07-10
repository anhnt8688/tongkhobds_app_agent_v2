import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A read-only, tappable "select" field row (label on top, value + chevron in a
/// filled box). Used for property type, directions, legal docs, furniture and
/// the address picker. Mirrors v1 `TitleDefaultTextField` read-only look:
/// title `semibold(15)`, grey fill (#F5F5F4), radius 12, arrow suffix.
class PostSelectField extends StatelessWidget {
  const PostSelectField({
    super.key,
    required this.label,
    required this.value,
    required this.hint,
    required this.onTap,
    this.required = false,
  });

  final String label;
  final String value;
  final String hint;
  final VoidCallback onTap;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final empty = value.trim().isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text.rich(TextSpan(
            text: label,
            style: AppTextStyles.semibold(15),
            children: required
                ? [
                    TextSpan(
                        text: ' *',
                        style:
                            AppTextStyles.semibold(15, color: AppColors.danger)),
                  ]
                : null,
          )),
          const SizedBox(height: 8),
        ],
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    empty ? hint : value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.semibold(15,
                        color: empty
                            ? const Color(0xFFD6D3D1) // neutral300 hint
                            : AppColors.text),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_outlined,
                    size: 16, color: AppColors.neutral400),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
