import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/tags_api.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_toast.dart';
import 'async_view.dart';

/// Bottom-sheet tag picker. Loads the tag groups for [categoryCode], lets the
/// user toggle tags (pre-selected from [selectedIds]), then assigns the full
/// set to the entity (replace semantics). Returns the new selected ids on
/// success, or `null` if cancelled.
Future<List<int>?> showTagPickerSheet(
  BuildContext context, {
  required TagEntity entity,
  required int entityId,
  required List<int> selectedIds,
  String? categoryCode,
}) {
  return showModalBottomSheet<List<int>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _TagPicker(
      entity: entity,
      entityId: entityId,
      selectedIds: selectedIds,
      categoryCode: categoryCode ?? entity.defaultCategory,
    ),
  );
}

class _TagPicker extends ConsumerStatefulWidget {
  const _TagPicker({
    required this.entity,
    required this.entityId,
    required this.selectedIds,
    required this.categoryCode,
  });
  final TagEntity entity;
  final int entityId;
  final List<int> selectedIds;
  final String categoryCode;

  @override
  ConsumerState<_TagPicker> createState() => _TagPickerState();
}

class _TagPickerState extends ConsumerState<_TagPicker> {
  late final Set<int> _selected = {...widget.selectedIds};
  bool _saving = false;

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref.read(tagsApiProvider).assignTags(
            entity: widget.entity,
            entityId: widget.entityId,
            tagIds: _selected.toList(),
          );
      if (mounted) Navigator.pop(context, _selected.toList());
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        AppToast.error(context, 'Không lưu được thẻ');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final groups = ref.watch(tagGroupsProvider(widget.categoryCode));
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Text('Quản lý thẻ', style: AppTypography.title),
            const SizedBox(height: 8),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: AsyncView(
                  value: groups,
                  data: (list) => list.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(24),
                          child: Text('Không có thẻ'),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final g in list) ...[
                              Padding(
                                padding: const EdgeInsets.only(top: 8, bottom: 4),
                                child: Text(g.name,
                                    style: AppTypography.caption.copyWith(
                                        color: AppColors.textSecondary)),
                              ),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  for (final t in g.items)
                                    _chip(t.id, t.name, t.color)
                                ],
                              ),
                            ],
                          ],
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style:
                      FilledButton.styleFrom(backgroundColor: AppColors.primary),
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Text('Lưu thẻ'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(int id, String name, String? hex) {
    final on = _selected.contains(id);
    final color = AppColors.fromHex(hex, fallback: AppColors.primary);
    return GestureDetector(
      onTap: () => setState(
          () => on ? _selected.remove(id) : _selected.add(id)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: on ? color.withValues(alpha: 0.14) : AppColors.bg,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          border: Border.all(color: on ? color : AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (on) ...[
              Icon(Icons.check, size: 14, color: color),
              const SizedBox(width: 4),
            ],
            Text(name,
                style: AppTypography.caption.copyWith(
                    color: on ? color : AppColors.text,
                    fontWeight: on ? FontWeight.w600 : FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
