import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Shared building blocks for contract preview screens (v1 KV-style layout):
/// section header with an accent bar, key/value rows, a note card, and an
/// expand/collapse toggle. Styles ported 1:1 from v1 (`AppTextStyles`).

class ContractSectionHeader extends StatelessWidget {
  const ContractSectionHeader(this.title, {super.key});
  final String title;

  static const _accent = Color(0xFFFF7A37); // v1 section accent bar

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 8),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 14,
            decoration: BoxDecoration(
              color: _accent,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Text(title, style: AppTextStyles.semibold(16)),
        ],
      ),
    );
  }
}

class ContractHr extends StatelessWidget {
  const ContractHr({super.key});
  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, color: Color(0xFFF0F2F5));
}

class ContractKV extends StatelessWidget {
  const ContractKV(this.label, this.value, {super.key, this.bold = false});
  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(label,
                style: AppTextStyles.regular(14, color: AppColors.neutral400)),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(value,
                textAlign: TextAlign.right,
                style: bold
                    ? AppTextStyles.semibold(15)
                    : AppTextStyles.regular(15)),
          ),
        ],
      ),
    );
  }
}

class ContractNoteCard extends StatelessWidget {
  const ContractNoteCard({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2, right: 8),
            child: Icon(Icons.sticky_note_2_outlined,
                size: 18, color: Color(0xFFCA8A04)),
          ),
          Expanded(
            child: Text(text,
                style: AppTextStyles.regular(14, color: const Color(0xFF78350F))),
          ),
        ],
      ),
    );
  }
}

/// Centered "Xem thêm" / "Thu gọn" toggle (v1: chevron + label, primary).
class ContractMoreButton extends StatelessWidget {
  const ContractMoreButton(
      {super.key, required this.expanded, required this.onTap});
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: onTap,
        icon: Icon(
            expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
            size: 18,
            color: AppColors.primary),
        label: Text(expanded ? 'Thu gọn' : 'Xem thêm',
            style: AppTextStyles.semibold(14, color: AppColors.primary)),
      ),
    );
  }
}
