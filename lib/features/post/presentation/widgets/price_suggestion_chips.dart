import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

const int _million = 1000000;
const int _billion = 1000000000;
const int _maxSell = 1000 * _billion;
const int _maxRent = 100 * _million;

/// A suggested price (raw amount + human label like "2 tỷ").
class PriceSuggestion {
  const PriceSuggestion(this.amount, this.label);
  final int amount;
  final String label;
}

String _label(int amount) {
  String trim(double v) => v == v.floorToDouble()
      ? v.toInt().toString()
      : v.toStringAsFixed(1).replaceAll(RegExp(r'\.?0$'), '');
  if (amount >= _billion) return '${trim(amount / _billion)} tỷ';
  if (amount >= _million) return '${trim(amount / _million)} triệu';
  return NumberFormat.decimalPattern('vi_VN').format(amount);
}

int _ceil(int n, int step) {
  final r = n % step;
  return r == 0 ? n : n + step - r;
}

/// Price suggestions for the typed [raw] number (mirrors v1 `handlePriceInput`).
/// Small numbers are treated as a multiplier; larger ones are rounded up.
List<PriceSuggestion> suggestPrices(int raw, {required bool isSell}) {
  if (raw <= 0) return const [];
  final cap = isSell ? _maxSell : _maxRent;
  final factor = raw < 100000;
  final List<int> candidates;
  if (factor) {
    candidates = isSell
        ? [raw * 10 * _million, raw * 100 * _million, raw * _billion, raw * 10 * _billion]
        : [raw * 100000, raw * _million, raw * 10 * _million];
  } else {
    candidates = isSell
        ? [_ceil(raw, 10 * _million), _ceil(raw, 100 * _million), _ceil(raw, _billion), _ceil(raw, 10 * _billion)]
        : [_ceil(raw, 100000), _ceil(raw, _million), _ceil(raw, 10 * _million)];
  }
  final seen = <int>{};
  final out = <PriceSuggestion>[];
  for (final c in candidates) {
    if (c > cap || !seen.add(c)) continue;
    out.add(PriceSuggestion(c, _label(c)));
  }
  return out;
}

/// Horizontal wrap of tappable price suggestions.
class PriceSuggestionChips extends StatelessWidget {
  const PriceSuggestionChips({
    super.key,
    required this.suggestions,
    required this.onPick,
  });

  final List<PriceSuggestion> suggestions;
  final ValueChanged<int> onPick;

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final s in suggestions)
            GestureDetector(
              onTap: () => onPick(s.amount),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(s.label,
                    style: AppTypography.caption
                        .copyWith(fontWeight: FontWeight.w600)),
              ),
            ),
        ],
      ),
    );
  }
}
