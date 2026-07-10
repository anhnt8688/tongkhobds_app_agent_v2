import 'package:flutter/material.dart';

/// Design tokens (colors) from mobile_app_v2.pen design system.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFFF26F21);
  static const Color primarySoft = Color(0xFFFFEDD5);
  static const Color primaryDark = Color(0xFFD85F12);

  static const Color success = Color(0xFF12B76A);
  static const Color warning = Color(0xFFF79009);
  static const Color danger = Color(0xFFEF4444);
  static const Color info = Color(0xFF2E90FA);

  static const Color bg = Color(0xFFFAFAF9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE7E5E4);
  static const Color inputBorder = Color(0xFFD6D3D1);

  static const Color text = Color(0xFF292524);
  static const Color textSecondary = Color(0xFF57534E);
  static const Color textMute = Color(0xFF78716C);

  // v1 neutral scale (used across auth for exact parity).
  static const Color neutral100 = Color(0xFFF5F5F4);
  static const Color neutral200 = Color(0xFFE7E5E4);
  static const Color neutral300 = Color(0xFFD6D3D1);
  static const Color neutral400 = Color(0xFFA8A29E);
  static const Color neutral500 = Color(0xFF78716C);

  // Soft status backgrounds + foregrounds (status pills).
  static const Color amberBg = Color(0xFFFEF3C7);
  static const Color amberFg = Color(0xFF92400E);
  static const Color blueBg = Color(0xFFDBEAFE);
  static const Color blueFg = Color(0xFF1E40AF);
  static const Color greenBg = Color(0xFFD1FAE5);
  static const Color greenFg = Color(0xFF0D7C4D);
  static const Color redBg = Color(0xFFFEE2E2);
  static const Color redFg = Color(0xFF991B1B);

  /// Listing price accent (v1 parity: status/label badges colour).
  static const Color price = Color(0xFFF58229);

  /// Parses a backend hex string ("#RRGGBB" / "RRGGBB" / "AARRGGBB") into a
  /// [Color]. Used for server-driven status badge colours on listing cards.
  static Color fromHex(String? hex, {Color fallback = Colors.transparent}) {
    if (hex == null || hex.trim().isEmpty) return fallback;
    try {
      final buffer = StringBuffer();
      final cleaned = hex.replaceAll('#', '');
      if (cleaned.length == 6 || cleaned.length == 7) buffer.write('ff');
      buffer.write(cleaned);
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return fallback;
    }
  }
}
