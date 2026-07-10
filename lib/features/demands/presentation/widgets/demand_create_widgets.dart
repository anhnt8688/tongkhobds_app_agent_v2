import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// White rounded section card with an orange left-bar header — the building
/// block of the "Tạo nhu cầu" form (Khách hàng, Tiêu chí BĐS, …).
class DemandSectionCard extends StatelessWidget {
  const DemandSectionCard({
    super.key,
    required this.title,
    required this.children,
    this.required = false,
    this.trailing,
  });

  final String title;
  final bool required;
  final Widget? trailing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 3,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(title, style: AppTypography.title),
              if (required)
                Text('  *',
                    style: AppTypography.title.copyWith(color: AppColors.danger)),
              if (trailing != null) ...[const Spacer(), trailing!],
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

/// Small grey label sitting above a field (matches the web form labels).
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key, this.required = false});
  final String text;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          text: text,
          style: AppTypography.subtitle.copyWith(color: AppColors.textSecondary),
          children: required
              ? const [TextSpan(text: ' *', style: TextStyle(color: AppColors.danger))]
              : null,
        ),
      ),
    );
  }
}

/// A two-option segmented control (e.g. Mua bds / Thuê bds).
class DemandSegmented extends StatelessWidget {
  const DemandSegmented({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < options.length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: Container(
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: i == selectedIndex
                      ? AppColors.primarySoft
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(
                    color: i == selectedIndex
                        ? AppColors.primary
                        : AppColors.inputBorder,
                    width: i == selectedIndex ? 1.5 : 1,
                  ),
                ),
                child: Text(
                  options[i],
                  style: AppTypography.subtitle.copyWith(
                    color: i == selectedIndex
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// A wrap of selectable pill chips (Hướng nhà, Pháp lý).
class DemandSelectChips extends StatelessWidget {
  const DemandSelectChips({
    super.key,
    required this.options,
    required this.selected,
    required this.onToggle,
  });

  final List<String> options;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final o in options)
          GestureDetector(
            onTap: () => onToggle(o),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: selected.contains(o)
                    ? AppColors.primarySoft
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                border: Border.all(
                  color: selected.contains(o)
                      ? AppColors.primary
                      : AppColors.border,
                ),
              ),
              child: Text(
                o,
                style: AppTypography.caption.copyWith(
                  color: selected.contains(o)
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
