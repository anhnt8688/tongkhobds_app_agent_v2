import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/realestate_api.dart';

/// Bottom-sheet filter pickers for "BĐS của tôi" (parity with v1's source /
/// property / room / direction / sort sheets). Each `show*` resolves through an
/// `onSelected` callback: called with the chosen value on "Áp dụng", or with a
/// cleared value on "Đặt lại".

Future<void> _present(BuildContext context, Widget child) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => child,
  );
}

Widget _sheet(String title, List<Widget> children) {
  return Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [_header(title), ...children, const SizedBox(height: 27)],
    ),
  );
}

Widget _header(String title) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(title,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

Widget _footer({required VoidCallback onReset, required VoidCallback onApply}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
    child: Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onReset,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.text,
              side: const BorderSide(color: AppColors.inputBorder),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Đặt lại'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: FilledButton(
            onPressed: onApply,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Áp dụng'),
          ),
        ),
      ],
    ),
  );
}

Widget _option(String label, bool selected, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: TextStyle(
                    fontSize: 16,
                    color: selected ? AppColors.primary : AppColors.text)),
          ),
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            size: 22,
            color: selected ? AppColors.primary : AppColors.inputBorder,
          ),
        ],
      ),
    ),
  );
}

/// Single-select list (source / house direction / balcony direction).
Future<void> showSingleSelectSheet(
  BuildContext context, {
  required String title,
  required List<FilterValue> values,
  required FilterValue? selected,
  required ValueChanged<FilterValue?> onSelected,
}) {
  FilterValue? current = selected;
  return _present(
    context,
    StatefulBuilder(
      builder: (ctx, setState) => _sheet(title, [
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (final v in values)
                  _option(v.name, v == current, () => setState(() => current = v)),
              ],
            ),
          ),
        ),
        _footer(
          onReset: () {
            Navigator.pop(ctx);
            onSelected(null);
          },
          onApply: () {
            Navigator.pop(ctx);
            onSelected(current);
          },
        ),
      ]),
    ),
  );
}

/// Multi-select with a "Chọn tất cả" head row (property types).
Future<void> showMultiSelectSheet(
  BuildContext context, {
  required String title,
  required List<FilterValue> values,
  required List<FilterValue> selected,
  required ValueChanged<List<FilterValue>> onSelected,
}) {
  final current = List<FilterValue>.from(selected);
  bool isAll() => values.isNotEmpty && current.length == values.length;
  return _present(
    context,
    StatefulBuilder(
      builder: (ctx, setState) => _sheet(title, [
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _option('Chọn tất cả', isAll(), () {
                  setState(() {
                    if (isAll()) {
                      current.clear();
                    } else {
                      current
                        ..clear()
                        ..addAll(values);
                    }
                  });
                }),
                for (final v in values)
                  _option(v.name, current.contains(v), () {
                    setState(() {
                      current.contains(v) ? current.remove(v) : current.add(v);
                    });
                  }),
              ],
            ),
          ),
        ),
        _footer(
          onReset: () {
            Navigator.pop(ctx);
            onSelected(const []);
          },
          onApply: () {
            Navigator.pop(ctx);
            onSelected(current);
          },
        ),
      ]),
    ),
  );
}

/// Bedroom count chips (single-select).
Future<void> showBedroomSheet(
  BuildContext context, {
  required List<FilterValue> values,
  required FilterValue? selected,
  required ValueChanged<FilterValue?> onSelected,
}) {
  FilterValue? current = selected;
  return _present(
    context,
    StatefulBuilder(
      builder: (ctx, setState) => _sheet('Số phòng ngủ', [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final v in values)
                GestureDetector(
                  onTap: () => setState(() => current = v),
                  child: Container(
                    width: 44,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: v == current ? AppColors.primary : Colors.white,
                      border: v == current
                          ? null
                          : Border.all(width: 2, color: AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${v.id}${(int.tryParse('${v.id}') ?? 0) >= 5 ? '+' : ''}',
                      style: TextStyle(
                        fontSize: 16,
                        color: v == current ? Colors.white : AppColors.text,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        _footer(
          onReset: () {
            Navigator.pop(ctx);
            onSelected(null);
          },
          onApply: () {
            Navigator.pop(ctx);
            onSelected(current);
          },
        ),
      ]),
    ),
  );
}

/// Sort picker — tap-to-apply (no footer), matches v1 `SortBottomSheetProduct`.
Future<void> showSortSheet(
  BuildContext context, {
  required List<FilterValue> values,
  required FilterValue? selected,
  required ValueChanged<FilterValue> onSelected,
}) {
  return _present(
    context,
    _sheet('Sắp xếp theo', [
      for (final v in values)
        _option(v.name, v == selected, () {
          Navigator.pop(context);
          onSelected(v);
        }),
    ]),
  );
}
