import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// Display data shared by the work-action dialogs (contact card, BĐS card,
/// owner state, post link). Both nhu-cầu-mua and nhu-cầu-bán populate this.
class WorkDialogContext {
  const WorkDialogContext({
    this.contactName,
    this.contactPhone,
    this.contactRole = 'Khách hàng',
    this.bdsCode,
    this.bdsTitle,
    this.bdsSubtitle,
    this.postLink,
    this.entityBadge,
    this.hasOwner = false,
    this.ownerName,
  });

  final String? contactName;
  final String? contactPhone;
  final String contactRole;
  final String? bdsCode;
  final String? bdsTitle;
  final String? bdsSubtitle;
  final String? postLink;
  final String? entityBadge;
  final bool hasOwner;
  final String? ownerName;
}

// ---- Enum option lists `(value, label)` ----

const kCallResults = <(String, String)>[
  ('connected', 'Đã kết nối'),
  ('no_answer', 'Không nghe máy'),
  ('busy', 'Máy bận'),
  ('rejected', 'Từ chối'),
];

const kSendChannels = <(String, String, IconData)>[
  ('zalo', 'Zalo', Icons.chat_bubble_outline),
  ('messenger', 'Messenger', Icons.facebook_outlined),
  ('app_tongkho', 'App Tổng Kho', Icons.smartphone_outlined),
];

const kDepositTypes = <(String, String)>[
  ('thien_chi', 'Cọc thiện chí'),
  ('coc_chet', 'Cọc chính thức'),
];

/// Quick deposit amounts `(VND, label)`.
const kQuickDeposits = <(int, String)>[
  (5000000, '5tr'),
  (10000000, '10tr'),
  (20000000, '20tr'),
  (50000000, '50tr'),
  (100000000, '100tr'),
  (200000000, '200tr'),
  (500000000, '500tr'),
  (1000000000, '1 tỷ'),
];

/// Card scaffold for a work dialog: header (icon · title · badge · close),
/// scrollable body, and a footer with a cancel + primary action.
class WorkDialogScaffold extends StatelessWidget {
  const WorkDialogScaffold({
    super.key,
    required this.icon,
    required this.title,
    required this.children,
    required this.primaryLabel,
    required this.onPrimary,
    this.primaryIcon,
    this.badge,
    this.cancelLabel = 'Đóng',
    this.primaryColor = AppColors.primary,
  });

  final IconData icon;
  final String title;
  final String? badge;
  final List<Widget> children;
  final String primaryLabel;
  final IconData? primaryIcon;
  final VoidCallback? onPrimary; // null = disabled
  final String cancelLabel;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: 520, maxHeight: MediaQuery.of(context).size.height * 0.85),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 8, 12),
              child: Row(
                children: [
                  Icon(icon, color: AppColors.primary, size: 22),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(title,
                        style: AppTypography.title, overflow: TextOverflow.ellipsis),
                  ),
                  if (badge != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.bg,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusPill),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(badge!,
                          style: AppTypography.micro
                              .copyWith(color: AppColors.textSecondary)),
                    ),
                  ],
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    color: AppColors.textMute,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
            // Body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                ),
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
            // Footer
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(cancelLabel,
                        style: TextStyle(color: AppColors.textSecondary)),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: primaryColor,
                      disabledBackgroundColor: primaryColor.withValues(alpha: 0.4),
                    ),
                    onPressed: onPrimary,
                    icon: Icon(primaryIcon ?? Icons.check, size: 18),
                    label: Text(primaryLabel),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---- Small shared building blocks ----

/// Grey info card with an uppercase [label] and arbitrary [child].
Widget workCard({String? label, required Widget child}) => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            Text(label.toUpperCase(),
                style: AppTypography.micro.copyWith(
                    color: AppColors.textMute, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
          ],
          child,
        ],
      ),
    );

/// A field label with an optional required asterisk.
Widget workFieldLabel(String text, {bool required = false}) => Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 4),
      child: RichText(
        text: TextSpan(
          text: text,
          style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary, fontWeight: FontWeight.w600),
          children: required
              ? const [TextSpan(text: ' *', style: TextStyle(color: AppColors.danger))]
              : null,
        ),
      ),
    );

/// Contact card: role + name + phone, with optional copy/call actions.
Widget workContactCard({
  String? role,
  String? name,
  String? phone,
  VoidCallback? onCopy,
  VoidCallback? onCall,
}) =>
    workCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(name ?? '—',
                          style: AppTypography.body
                              .copyWith(fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis),
                    ),
                    if (role != null) ...[
                      const SizedBox(width: 6),
                      Text('· $role',
                          style: AppTypography.caption
                              .copyWith(color: AppColors.textMute)),
                    ],
                  ],
                ),
                if (phone != null && phone.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(phone,
                      style: AppTypography.title
                          .copyWith(fontWeight: FontWeight.w700)),
                ],
              ],
            ),
          ),
          if (onCopy != null)
            IconButton(
              icon: const Icon(Icons.copy_outlined, size: 18),
              color: AppColors.textSecondary,
              onPressed: onCopy,
            ),
          if (onCall != null)
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: AppColors.success),
              onPressed: onCall,
              icon: const Icon(Icons.call, size: 16),
              label: const Text('Gọi'),
            ),
        ],
      ),
    );

/// BĐS card: orange code + title + optional subtitle (address).
Widget workBdsCard({String? code, String? title, String? subtitle}) => workCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (code != null && code.isNotEmpty)
            Text(code,
                style: AppTypography.caption.copyWith(
                    color: AppColors.primary, fontWeight: FontWeight.w700)),
          if (title != null && title.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(title, style: AppTypography.body),
          ],
          if (subtitle != null && subtitle.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(subtitle,
                style: AppTypography.caption
                    .copyWith(color: AppColors.textMute)),
          ],
        ],
      ),
    );

/// Outlined text field used across the dialogs.
Widget workTextField(
  TextEditingController controller, {
  required String hint,
  int maxLines = 1,
  int? maxLength,
  TextInputType? keyboardType,
  ValueChanged<String>? onChanged,
  bool autofocus = false,
}) =>
    TextField(
      controller: controller,
      autofocus: autofocus,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: AppTypography.body,
      decoration: InputDecoration(
        hintText: hint,
        counterText: maxLength == null ? '' : null,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
