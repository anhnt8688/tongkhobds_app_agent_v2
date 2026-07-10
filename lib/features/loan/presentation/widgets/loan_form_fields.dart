import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_network_image.dart';

/// Field label with optional required marker (v1 `*` in red).
class LoanFieldLabel extends StatelessWidget {
  const LoanFieldLabel({super.key, required this.title, this.required = false});
  final String title;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: title,
        style: AppTypography.subtitle
            .copyWith(color: AppColors.text, fontWeight: FontWeight.w600),
        children: required
            ? [
                TextSpan(
                  text: ' *',
                  style: AppTypography.subtitle.copyWith(color: AppColors.danger),
                ),
              ]
            : null,
      ),
    );
  }
}

/// Labelled text input (v1 TitleDefaultTextField): title + suffix text +
/// formatters + readOnly.
class LoanField extends StatelessWidget {
  const LoanField({
    super.key,
    required this.title,
    this.controller,
    this.hint,
    this.required = false,
    this.readOnly = false,
    this.keyboardType,
    this.inputFormatters,
    this.suffixText,
    this.onChanged,
    this.focusNode,
    this.maxLines = 1,
  });

  final String title;
  final TextEditingController? controller;
  final String? hint;
  final bool required;
  final bool readOnly;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? suffixText;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LoanFieldLabel(title: title, required: required),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          readOnly: readOnly,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          maxLines: maxLines,
          style: AppTypography.body,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffixText == null
                ? null
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      suffixText!,
                      style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
            suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          ),
        ),
      ],
    );
  }
}

/// Read-only labelled value box (v1 detail `TitleDefaultTextField readOnly`).
/// No controller, so it's safe to build inline on every rebuild.
class LoanReadonlyField extends StatelessWidget {
  const LoanReadonlyField({
    super.key,
    required this.title,
    required this.value,
    this.suffixText,
    this.required = false,
  });

  final String title;
  final String value;
  final String? suffixText;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LoanFieldLabel(title: title, required: required),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.inputBorder),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Row(
            children: [
              Expanded(child: Text(value, style: AppTypography.body)),
              if (suffixText != null)
                Text(suffixText!,
                    style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}

/// Dropdown-style selector (v1 CustomDropDown / bank button): shows the current
/// value or a hint and opens a picker on tap.
class LoanSelectField extends StatelessWidget {
  const LoanSelectField({
    super.key,
    required this.title,
    required this.value,
    required this.hint,
    required this.onTap,
    this.required = false,
    this.leadingImageUrl,
    this.enabled = true,
  });

  final String title;
  final String value;
  final String hint;
  final VoidCallback onTap;
  final bool required;
  final String? leadingImageUrl;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final hasValue = value.trim().isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LoanFieldLabel(title: title, required: required),
        const SizedBox(height: 8),
        Opacity(
          opacity: enabled ? 1 : 0.5,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: enabled ? onTap : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F4),
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              child: Row(
                children: [
                  if (leadingImageUrl != null && leadingImageUrl!.isNotEmpty) ...[
                    AppNetworkImage(
                      url: leadingImageUrl,
                      width: 28,
                      height: 28,
                      fit: BoxFit.contain,
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Text(
                      hasValue ? value : hint,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.body.copyWith(
                        color: hasValue ? AppColors.text : AppColors.textMute,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.text),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
