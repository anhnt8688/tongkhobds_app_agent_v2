// Auth field validators, ported from v1 for parity.

/// Vietnamese mobile number: starts with `0` or `+84`, valid telco prefix,
/// 10 digits total (or +84 + 9 digits).
bool isValidVietnamPhone(String value) => RegExp(
      r'^(0|\+84)(3[2-9]|5[6|8|9]|7[0|6-9]|8[1-9]|9[0-9])[0-9]{7}$',
    ).hasMatch(value.trim());

/// 6–15 chars, at least one letter and one digit, no whitespace.
bool isValidPassword(String value) =>
    RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[^\s]{6,15}$').hasMatch(value);

/// Basic email shape check (local@domain.tld).
bool isValidEmail(String value) =>
    RegExp(r'^[\w.\-+]+@([\w\-]+\.)+[\w\-]{2,}$').hasMatch(value.trim());
