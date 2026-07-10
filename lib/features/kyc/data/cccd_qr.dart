/// Parser for the QR code printed on a Vietnamese CCCD (căn cước công dân).
///
/// The QR payload is a pipe-delimited string:
/// `id_number|old_id|full_name|dob|gender|permanent_address|issue_date|...`
class CccdQr {
  static Map<String, String> parse(String raw) {
    final p = raw.split('|').map((e) => e.trim()).toList();
    String at(int i) => (i >= 0 && i < p.length) ? p[i] : '';

    return {
      'id_number': at(0),
      'full_name': at(2),
      'dob': at(3),
      'gender': at(4),
      'permanent_address': at(5),
      'issue_date': at(6),
      'issue_place': at(7),
      'email': '',
    };
  }
}
