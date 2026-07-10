import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Spec enum option lists for the `work_consultation` actions
/// (Nhu cầu mua — Data Model & API Contract). Each entry is `(value, label)`:
/// `value` is the API enum sent to the backend, `label` is the Vietnamese UI text.

/// `call_owner.call_result`.
const kCallResults = <(String, String)>[
  ('connected', 'Đã kết nối'),
  ('no_answer', 'Không nghe máy'),
  ('busy', 'Máy bận'),
  ('rejected', 'Từ chối nghe'),
];

/// `send_customer.send_channel`.
const kSendChannels = <(String, String)>[
  ('zalo', 'Zalo'),
  ('messenger', 'Messenger'),
  ('app_tongkho', 'App Tổng Kho'),
];

/// `deposit.deposit_type`.
const kDepositTypes = <(String, String)>[
  ('thien_chi', 'Cọc thiện chí'),
  ('coc_chet', 'Cọc chết'),
];

/// Bottom-sheet single-choice picker → returns the selected enum `value`.
Future<String?> pickWorkOption(
  BuildContext context,
  String title,
  List<(String, String)> options,
) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: AppColors.surface,
    builder: (_) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Text(title, style: AppTypography.title),
          const SizedBox(height: 8),
          for (final o in options)
            ListTile(
              title: Text(o.$2),
              onTap: () => Navigator.pop(context, o.$1),
            ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}

/// Simple text-input dialog. Returns the trimmed text, or `null` if cancelled
/// (an empty submit returns `''`, which callers treat per-field).
Future<String?> askWorkText(
  BuildContext context,
  String title,
  String hint, {
  bool number = false,
}) {
  final ctrl = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: ctrl,
        autofocus: true,
        maxLines: number ? 1 : 4,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx), child: const Text('Huỷ')),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
          onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
          child: const Text('Xong'),
        ),
      ],
    ),
  );
}

/// Note dialog: required `content` + visibility toggle (`internal` vs public).
Future<({String content, bool internal})?> askNoteContent(
    BuildContext context) {
  final ctrl = TextEditingController();
  var internal = false;
  return showDialog<({String content, bool internal})>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: const Text('Ghi chú'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ctrl,
              autofocus: true,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Nhập nội dung',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
              ),
            ),
            const SizedBox(height: 4),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              activeThumbColor: AppColors.primary,
              title: Text('Chỉ nội bộ',
                  style: AppTypography.caption
                      .copyWith(color: AppColors.textSecondary)),
              value: internal,
              onChanged: (v) => setState(() => internal = v),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Huỷ')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => Navigator.pop(
                ctx, (content: ctrl.text.trim(), internal: internal)),
            child: const Text('Xong'),
          ),
        ],
      ),
    ),
  );
}

/// Optional `location` + `note` for an appointment (after the date/time is
/// picked). Returns `null` if cancelled; either field may be empty.
Future<({String location, String note})?> askAppointmentDetails(
    BuildContext context) {
  final locCtrl = TextEditingController();
  final noteCtrl = TextEditingController();
  return showDialog<({String location, String note})>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Chi tiết lịch hẹn'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: locCtrl,
            decoration: InputDecoration(
              labelText: 'Địa điểm (tuỳ chọn)',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: noteCtrl,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Ghi chú (tuỳ chọn)',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx), child: const Text('Huỷ')),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
          onPressed: () => Navigator.pop(
              ctx, (location: locCtrl.text.trim(), note: noteCtrl.text.trim())),
          child: const Text('Xong'),
        ),
      ],
    ),
  );
}
