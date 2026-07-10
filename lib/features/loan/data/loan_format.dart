import 'package:intl/intl.dart';

/// Backend datetimes arrive as `yyyy-MM-dd HH:mm:ss` (sometimes ISO). Format for
/// the loan UI, tolerating junk (returns the raw string on parse failure).
String loanDate(String? raw, {bool withTime = false}) {
  if (raw == null || raw.trim().isEmpty) return '';
  final dt = DateTime.tryParse(raw.replaceFirst(' ', 'T'));
  if (dt == null) return raw;
  return DateFormat(withTime ? 'dd/MM/yyyy HH:mm' : 'dd/MM/yyyy').format(dt);
}
