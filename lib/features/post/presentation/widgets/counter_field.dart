import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A labelled stepper (− value +) for integer fields like bedrooms / floors.
class CounterField extends StatelessWidget {
  const CounterField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final int min;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: AppTextStyles.semibold(15))),
        _btn(Icons.remove, value > min ? () => onChanged(value - 1) : null),
        Container(
          width: 44,
          alignment: Alignment.center,
          child: Text('$value', style: AppTextStyles.semibold(15)),
        ),
        _btn(Icons.add, () => onChanged(value + 1)),
      ],
    );
  }

  Widget _btn(IconData icon, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: onTap == null ? AppColors.surface : AppColors.primarySoft,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon,
            size: 18,
            color: onTap == null ? AppColors.textMute : AppColors.primary),
      ),
    );
  }
}
