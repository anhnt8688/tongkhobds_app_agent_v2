import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/thousands_input_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../data/models/filter_config.dart';
import '../../data/models/search_filter.dart';

/// Shared sheet chrome: title + scrollable body + sticky apply/clear footer.
class _SheetShell extends StatelessWidget {
  const _SheetShell({
    required this.title,
    required this.child,
    required this.onApply,
    this.onClear,
  });
  final String title;
  final Widget child;
  final VoidCallback onApply;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SheetHeader(title: title),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: child,
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  children: [
                    if (onClear != null) ...[
                      Expanded(
                        child: AppButton(
                          label: 'Đặt lại',
                          variant: AppButtonVariant.ghost,
                          onPressed: onClear,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: AppButton(label: 'Áp dụng', onPressed: onApply),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// v1 `SheetHeader`: 64h, centred semibold-22 title, close (X) on the right and
/// a divider below.
class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              const SizedBox(width: 44),
              Expanded(
                child: Center(
                  child: Text(title, style: AppTextStyles.semibold(22)),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.clear, color: AppColors.text),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
          ),
        ],
      ),
    );
  }
}

/// Single/multiple select filter (e.g. số phòng ngủ, loại BĐS).
class DynamicSelectSheet extends StatefulWidget {
  const DynamicSelectSheet({
    super.key,
    required this.option,
    required this.selected,
    required this.onApply,
  });

  final FilterOption option;
  final dynamic selected; // single value or List
  final ValueChanged<dynamic> onApply; // value or List or null (clear)

  @override
  State<DynamicSelectSheet> createState() => _DynamicSelectSheetState();
}

class _DynamicSelectSheetState extends State<DynamicSelectSheet> {
  late final bool _multi = widget.option.multiple;
  late Set<Object?> _picked = {
    if (widget.selected is List)
      ...(widget.selected as List)
    else if (widget.selected != null)
      widget.selected,
  };

  @override
  Widget build(BuildContext context) {
    return _SheetShell(
      title: widget.option.title,
      onClear: () {
        widget.onApply(null);
        Navigator.pop(context);
      },
      onApply: () {
        if (_picked.isEmpty) {
          widget.onApply(null);
        } else if (_multi) {
          widget.onApply(_picked.toList());
        } else {
          widget.onApply(_picked.first);
        }
        Navigator.pop(context);
      },
      child: Column(
        children: [
          for (final o in widget.option.options)
            _OptionTile(
              label: o.label,
              selected: _picked.contains(o.value),
              multi: _multi,
              onTap: () => setState(() {
                if (_multi) {
                  _picked.contains(o.value)
                      ? _picked.remove(o.value)
                      : _picked.add(o.value);
                } else {
                  _picked = {o.value};
                }
              }),
            ),
        ],
      ),
    );
  }
}

/// Range filter (giá / diện tích): preset ranges + custom min/max.
class DynamicRangeSheet extends StatefulWidget {
  const DynamicRangeSheet({
    super.key,
    required this.option,
    required this.selected,
    required this.onApply,
  });

  final FilterOption option;
  final String? selected; // "min-max"
  final ValueChanged<String?> onApply;

  @override
  State<DynamicRangeSheet> createState() => _DynamicRangeSheetState();
}

class _DynamicRangeSheetState extends State<DynamicRangeSheet> {
  String? _picked;
  final _min = TextEditingController();
  final _max = TextEditingController();

  @override
  void initState() {
    super.initState();
    _picked = widget.selected;
    final sel = widget.selected;
    if (sel != null && sel.contains('-') && !_isPreset(sel)) {
      final parts = sel.split('-');
      if (parts.isNotEmpty) _min.text = _grouped(parts[0]);
      if (parts.length > 1) _max.text = _grouped(parts[1]);
    }
  }

  bool _isPreset(String v) =>
      widget.option.options.any((o) => o.value?.toString() == v);

  /// Unit suffix shown in the custom inputs (Giá → VNĐ, Diện tích → m²).
  String get _unit => widget.option.key == 'price' ? 'VNĐ' : 'm²';

  /// Formats raw digits with thousands separators for display.
  String _grouped(String raw) {
    final n = digitsOf(raw);
    return n == 0
        ? ''
        : ThousandsInputFormatter()
              .formatEditUpdate(
                const TextEditingValue(),
                TextEditingValue(text: '$n'),
              )
              .text;
  }

  @override
  void dispose() {
    _min.dispose();
    _max.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SheetShell(
      title: widget.option.title,
      onClear: () {
        widget.onApply(null);
        Navigator.pop(context);
      },
      onApply: () {
        final mn = digitsOf(_min.text);
        final mx = digitsOf(_max.text);
        if (mn > 0 || mx > 0) {
          widget.onApply('$mn-${mx > 0 ? mx : 999999999999}');
        } else {
          widget.onApply(_picked);
        }
        Navigator.pop(context);
      },
      child: Column(
        children: [
          for (final o in widget.option.options)
            if (o.value?.toString() != 'all')
              _OptionTile(
                label: o.label,
                selected: _picked == o.value?.toString(),
                multi: false,
                onTap: () => setState(() {
                  _picked = o.value?.toString();
                  _min.clear();
                  _max.clear();
                }),
              ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _numField('Từ', _min)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('—'),
              ),
              Expanded(child: _numField('Đến', _max)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _numField(String hint, TextEditingController c) {
    return TextField(
      controller: c,
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsInputFormatter()],
      onChanged: (_) => setState(() => _picked = null),
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        suffixText: _unit,
        suffixStyle: AppTypography.caption.copyWith(color: AppColors.textMute),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
    );
  }
}

/// Sort options.
class SortSheet extends StatelessWidget {
  const SortSheet({super.key, required this.current, required this.onSelected});
  final PropertySort current;
  final ValueChanged<PropertySort> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Text('Sắp xếp', style: AppTypography.heading),
          const SizedBox(height: 8),
          for (final s in PropertySort.values)
            _OptionTile(
              label: s.label,
              selected: s == current,
              multi: false,
              onTap: () {
                onSelected(s);
                Navigator.pop(context);
              },
            ),
          SafeArea(top: false, child: const SizedBox(height: 8)),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.selected,
    required this.multi,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final bool multi;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.regular(
                  17,
                  color: selected ? AppColors.primary : AppColors.text,
                ),
              ),
            ),
            Icon(
              multi
                  ? (selected ? Icons.check_box : Icons.check_box_outline_blank)
                  : (selected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked),
              color: AppColors.primary,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
