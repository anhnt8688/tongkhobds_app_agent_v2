import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Formats a numeric text field with thousands separators (e.g. 1000000 →
/// "1,000,000") as the user types. Non-digits are stripped. Use [digitsOf] to
/// recover the raw number from a formatted string.
class ThousandsInputFormatter extends TextInputFormatter {
  ThousandsInputFormatter() : _fmt = NumberFormat.decimalPattern('en_US');

  final NumberFormat _fmt;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      return const TextEditingValue(text: '');
    }
    final n = int.tryParse(digits);
    if (n == null) return oldValue;
    final formatted = _fmt.format(n);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Raw digits of a formatted thousands string, as an int (0 if empty).
int digitsOf(String formatted) =>
    int.tryParse(formatted.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
