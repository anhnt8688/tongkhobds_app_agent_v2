import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Labelled text input matching v1 `TitleDefaultTextField`: title `semibold15`,
/// grey fill (#F5F5F4), radius 12, no border by default → primary 2px on focus,
/// hint `semibold15` neutral-300, optional red required asterisk.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.textInputAction,
    this.enabled = true,
    this.required = false,
    this.titleColor = _neutral400,
    this.readOnly = false,
    this.onTap,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final bool enabled;
  final bool required;
  final Color titleColor;
  final bool readOnly;
  final VoidCallback? onTap;

  static const Color _neutral400 = Color(0xFFA8A29E);
  static const Color _neutral300 = Color(0xFFD6D3D1); // hint
  static const Color _fill = Color(0xFFF5F5F4); // neutral100
  static const double _radius = 12;

  OutlineInputBorder _border(Color color, double width) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
        borderSide: width == 0
            ? BorderSide.none
            : BorderSide(color: color, width: width),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: AppTextStyles.semibold(15, color: titleColor),
            children: required
                ? [
                    TextSpan(
                      text: ' *',
                      style: AppTextStyles.semibold(15, color: AppColors.danger),
                    ),
                  ]
                : null,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          textInputAction: textInputAction,
          enabled: enabled,
          readOnly: readOnly,
          onTap: onTap,
          cursorColor: AppColors.primary,
          style: AppTextStyles.semibold(15),
          decoration: InputDecoration(
            filled: true,
            fillColor: _fill,
            hintText: hint,
            hintStyle: AppTextStyles.semibold(15, color: _neutral300),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 18, color: AppColors.textMute)
                : null,
            suffixIcon: suffixIcon,
            border: _border(Colors.transparent, 0),
            enabledBorder: _border(Colors.transparent, 0),
            disabledBorder: _border(Colors.transparent, 0),
            focusedBorder: _border(AppColors.primary, 2),
            errorBorder: _border(AppColors.danger, 1.5),
            focusedErrorBorder: _border(AppColors.danger, 1.5),
          ),
        ),
      ],
    );
  }
}
