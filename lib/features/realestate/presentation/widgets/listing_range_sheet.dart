import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/realestate_api.dart';

/// Min/max range picker with presets — used for price ("Chọn mức giá") and area
/// ("Chọn diện tích"). Parity with v1 `PriceFilterProduct` / `AreaRangeSheet`:
/// emits a "min-max" (or "min" / "0-max") string, or "" on reset.
class ListingRangeSheet extends StatefulWidget {
  const ListingRangeSheet({
    super.key,
    required this.title,
    required this.minTitle,
    required this.maxTitle,
    required this.suffix,
    required this.values,
    required this.initialRange,
    required this.onApply,
  });

  final String title;
  final String minTitle;
  final String maxTitle;
  final String suffix;
  final List<FilterValue> values;
  final String initialRange; // "min-max"
  final ValueChanged<String> onApply;

  @override
  State<ListingRangeSheet> createState() => _ListingRangeSheetState();
}

class _ListingRangeSheetState extends State<ListingRangeSheet> {
  final _min = TextEditingController();
  final _max = TextEditingController();

  @override
  void initState() {
    super.initState();
    final parts = widget.initialRange.split('-');
    if (parts.length == 2) {
      if ((int.tryParse(parts[0]) ?? 0) > 0) _min.text = parts[0];
      if ((int.tryParse(parts[1]) ?? 0) > 0) _max.text = parts[1];
    }
  }

  @override
  void dispose() {
    _min.dispose();
    _max.dispose();
    super.dispose();
  }

  String _formattedRange() {
    final min = int.tryParse(_min.text.trim());
    final max = int.tryParse(_max.text.trim());
    if (min != null && max != null) return '$min-$max';
    if (min != null) return '$min';
    if (max != null) return '0-$max';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 100),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(widget.title,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w700)),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  _inputs(),
                  const SizedBox(height: 8),
                  for (final v in widget.values) _preset(v),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _footer(),
          const SizedBox(height: 27),
        ],
      ),
    );
  }

  Widget _inputs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: _field(_min, widget.minTitle, 'Từ')),
          const SizedBox(width: 16),
          Expanded(child: _field(_max, widget.maxTitle, 'Đến')),
        ],
      ),
    );
  }

  Widget _field(TextEditingController c, String title, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        TextField(
          controller: c,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            suffixText: widget.suffix,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  Widget _preset(FilterValue v) {
    final selected = (v.id?.toString() ?? '') == _formattedRange();
    return InkWell(
      onTap: () {
        final parts = (v.id?.toString() ?? '').split('-');
        setState(() {
          _min.text = (parts.isNotEmpty && (int.tryParse(parts[0]) ?? 0) > 0)
              ? parts[0]
              : '';
          _max.text = (parts.length > 1 && (int.tryParse(parts[1]) ?? 0) > 0)
              ? parts[1]
              : '';
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
                child: Text(v.name,
                    style: TextStyle(
                        fontSize: 16,
                        color:
                            selected ? AppColors.primary : AppColors.text))),
            if (selected)
              const Icon(Icons.check, size: 20, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _footer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onApply('');
              },
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
              onPressed: () {
                Navigator.pop(context);
                widget.onApply(_formattedRange());
              },
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
}
