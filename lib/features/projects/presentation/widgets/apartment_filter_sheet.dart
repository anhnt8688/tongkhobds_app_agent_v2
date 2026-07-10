import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import 'apartment_filter.dart';

/// v1 `DynamicCheckboxFilterSheet` port: a header (title + close + divider), a
/// scrollable multi-select list (label + checkbox), then "Đặt lại" / "Áp dụng".
/// Returns the chosen values, or null if dismissed. Empty list = cleared.
Future<List<String>?> showApartmentFilterSheet(
  BuildContext context, {
  required ApartmentFilterDef def,
  required List<String> selected,
}) {
  return showModalBottomSheet<List<String>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => _Sheet(def: def, initial: selected),
  );
}

class _Sheet extends StatefulWidget {
  const _Sheet({required this.def, required this.initial});
  final ApartmentFilterDef def;
  final List<String> initial;

  @override
  State<_Sheet> createState() => _SheetState();
}

class _SheetState extends State<_Sheet> {
  late final Set<String> _sel = {...widget.initial};

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _header(context),
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: widget.def.options.length,
                itemBuilder: (_, i) {
                  final o = widget.def.options[i];
                  final on = _sel.contains(o.value);
                  return InkWell(
                    onTap: () => setState(
                        () => on ? _sel.remove(o.value) : _sel.add(o.value)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text(o.label,
                                  style: AppTextStyles.regular(17))),
                          Icon(
                            on
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            size: 24,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            child: Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Đặt lại',
                    variant: AppButtonVariant.ghost,
                    onPressed: () => Navigator.pop(context, <String>[]),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppButton(
                    label: 'Áp dụng',
                    onPressed: () => Navigator.pop(context, _sel.toList()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) => SizedBox(
        height: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const SizedBox(width: 44),
                Expanded(
                  child: Center(
                    child: Text(widget.def.title,
                        style: AppTextStyles.semibold(22)),
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
