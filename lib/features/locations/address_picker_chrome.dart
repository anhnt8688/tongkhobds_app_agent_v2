import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Shared chrome for the v1 `AddressPickerSheet` look, reused by the register
/// province picker and the search location picker so both sheets match exactly.

/// Orange gradient bar: translucent white back circle, centred "Chọn địa chỉ"
/// title, optional trailing action. Drops the status-bar inset in sheet mode.
class AddressGradientHeader extends StatelessWidget {
  const AddressGradientHeader({
    super.key,
    required this.onBack,
    this.title = 'Chọn địa chỉ',
    this.trailing,
    this.asSheet = false,
  });

  final VoidCallback onBack;
  final String title;
  final Widget? trailing;
  final bool asSheet;

  @override
  Widget build(BuildContext context) {
    final top = asSheet ? 0.0 : MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.fromLTRB(16, top + 8, 16, 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFA24C), Color(0xFFFF7A37)],
        ),
      ),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onBack,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          Expanded(
            child: Text(title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bold(20, color: Colors.white)),
          ),
          trailing ?? const SizedBox(width: 36),
        ],
      ),
    );
  }
}

/// One row of [AddressStepIndicator]: a label plus whether a value was chosen.
class AddressStep {
  const AddressStep(this.title, {this.done = false});
  final String title;
  final bool done;
}

/// Vertical numbered stepper (Tỉnh → Huyện → Xã). The [activeIndex] step is
/// highlighted; earlier chosen steps show a check. Wrapped in a white bar with a
/// thick neutral bottom border, matching v1.
class AddressStepIndicator extends StatelessWidget {
  const AddressStepIndicator(
      {super.key, required this.steps, required this.activeIndex});
  final List<AddressStep> steps;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.neutral100, width: 10),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(steps.length, (i) {
          final s = steps[i];
          final active = i == activeIndex;
          final done = s.done && !active;
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: _StepRow(
              index: i + 1,
              title: s.title,
              active: active,
              done: done,
              showLine: i < steps.length - 1,
            ),
          );
        }),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.index,
    required this.title,
    required this.active,
    required this.done,
    required this.showLine,
  });
  final int index;
  final String title;
  final bool active;
  final bool done;
  final bool showLine;

  @override
  Widget build(BuildContext context) {
    final on = done || active;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done
                    ? AppColors.primary
                    : active
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.neutral200,
                border: Border.all(
                    color: on ? AppColors.primary : AppColors.neutral200),
              ),
              child: done
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : Text('$index',
                      style: AppTextStyles.semibold(13,
                          color:
                              active ? AppColors.primary : AppColors.neutral500)),
            ),
            if (showLine)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 2,
                height: 24,
                color: on ? AppColors.primary : AppColors.neutral200,
              ),
          ],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(title, style: AppTextStyles.semibold(15)),
          ),
        ),
      ],
    );
  }
}
