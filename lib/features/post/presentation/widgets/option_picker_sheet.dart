import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Shows a bottom sheet listing [options] and returns the chosen index (or null
/// if dismissed). [selected] highlights the current value. Reused for property
/// type, house/balcony/land direction, legal-document type and furniture.
Future<int?> showOptionPicker(
  BuildContext context, {
  required String title,
  required List<String> options,
  String? selected,
}) {
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return ConstrainedBox(
        // Cap the sheet at 75% of the screen; with few options `min` keeps it
        // short, with many the list scrolls inside this bound.
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(ctx).size.height * 0.75,
        ),
        child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(child: Text(title, style: AppTypography.title)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 8),
                itemCount: options.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: AppColors.border),
                itemBuilder: (_, i) {
                  final isSel = options[i] == selected;
                  return ListTile(
                    title: Text(options[i],
                        style: AppTypography.body.copyWith(
                          color: isSel ? AppColors.primary : AppColors.text,
                          fontWeight:
                              isSel ? FontWeight.w600 : FontWeight.w400,
                        )),
                    trailing: isSel
                        ? const Icon(Icons.check, color: AppColors.primary)
                        : null,
                    onTap: () => Navigator.pop(ctx, i),
                  );
                },
              ),
            ),
          ],
        ),
        ),
      );
    },
  );
}
