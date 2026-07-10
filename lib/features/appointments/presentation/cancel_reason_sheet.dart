import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';

/// Bottom sheet to pick a cancellation reason (preset list + free text),
/// mirroring the v1 `RasonCancelSheet`. Returns the chosen reason via [onSend].
class CancelReasonSheet extends StatefulWidget {
  const CancelReasonSheet({super.key, required this.onSend});

  final ValueChanged<String> onSend;

  static const presets = <String>[
    'Khách không xuất hiện',
    'Khách hủy không muốn xem',
  ];

  @override
  State<CancelReasonSheet> createState() => _CancelReasonSheetState();
}

class _CancelReasonSheetState extends State<CancelReasonSheet> {
  final _other = TextEditingController();
  String _selected = '';

  @override
  void dispose() {
    _other.dispose();
    super.dispose();
  }

  bool get _enabled => _selected.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Center(
              child: Text('Chọn lý do huỷ', style: AppTextStyles.semibold(17)),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final r in CancelReasonSheet.presets)
                    _Option(
                      label: r,
                      selected: _selected == r,
                      onTap: () => setState(() {
                        _selected = r;
                        _other.clear();
                      }),
                    ),
                  const SizedBox(height: 16),
                  Text('Lý do khác', style: AppTextStyles.regular(17)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _other,
                    maxLines: 3,
                    onChanged: (v) => setState(() => _selected = v),
                    decoration: InputDecoration(
                      hintText: 'Nhập lý do khác',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                20, 12, 20, 16 + MediaQuery.of(context).padding.bottom),
            child: AppButton(
              label: 'Gửi',
              onPressed: _enabled
                  ? () {
                      Navigator.pop(context);
                      widget.onSend(_selected.trim());
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option(
      {required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primarySoft : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
              color: selected ? AppColors.primary : AppColors.border),
        ),
        child: Row(
          children: [
            Expanded(child: Text(label, style: AppTextStyles.regular(15))),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? AppColors.primary : AppColors.textMute,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
