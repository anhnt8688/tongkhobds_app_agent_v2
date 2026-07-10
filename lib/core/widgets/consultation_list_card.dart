import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/app_colors.dart';

/// Formats a backend timestamp ("2026-06-25T09:09:16" / "yyyy-MM-dd HH:mm:ss")
/// as "dd/MM/yyyy HH:mm"; returns the raw string if it can't be parsed.
String _formatCreatedAt(String raw) {
  final dt = DateTime.tryParse(raw.trim().replaceFirst(' ', 'T'));
  return dt == null ? raw : DateFormat('dd/MM/yyyy HH:mm').format(dt);
}

/// A single tag entry for the card (name + optional hex color).
typedef CardTag = ({String label, String? color});

/// List card for the "Nhu cầu mua" / "Nhu cầu bán" lists, reproducing the v1
/// demand-card look: code + name (+ role badge) and a status pill on top, phone,
/// two info boxes (budget/price · area), a blue location line, a secondary
/// office/owner line, a tag row, and the created date bottom-right.
class ConsultationListCard extends StatelessWidget {
  const ConsultationListCard({
    super.key,
    required this.code,
    required this.name,
    this.roleBadge,
    required this.statusBadge,
    this.phone,
    required this.box1Title,
    required this.box1Value,
    required this.box2Title,
    required this.box2Value,
    this.location,
    this.secondaryIcon = Icons.apartment_outlined,
    this.secondaryText,
    this.tags = const [],
    this.createdAt,
    required this.onTap,
    this.onLongPress,
  });

  final String code;
  final String name;
  final String? roleBadge;
  final Widget statusBadge;
  final String? phone;
  final String box1Title;
  final String box1Value;
  final String box2Title;
  final String box2Value;
  final String? location;
  final IconData secondaryIcon;
  final String? secondaryText;
  final List<CardTag> tags;
  final String? createdAt;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  static const _border = Color(0xFFE7EAF0);
  static const _code = Color(0xFF8B93A7);
  static const _grey = Color(0xFF667085);
  static const _blue = Color(0xFF1D9BF0);
  static const _faint = Color(0xFF98A2B3);

  TextStyle _t(double size, FontWeight w, Color c) => TextStyle(
      fontFamily: 'SF Pro Text',
      fontSize: size,
      fontWeight: w,
      color: c,
      letterSpacing: -0.3);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        if (code.isNotEmpty)
                          Text(code, style: _t(15, FontWeight.w400, _code)),
                        Text(name, style: _t(17, FontWeight.w700, AppColors.text)),
                        if ((roleBadge ?? '').isNotEmpty)
                          _miniBadge(roleBadge!, const Color(0xFFF2F4F8),
                              const Color(0xFF6B7280)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  statusBadge,
                ],
              ),
              if ((phone ?? '').isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(phone!, style: _t(14, FontWeight.w400, _grey)),
              ],
              const SizedBox(height: 14),
              Row(children: [
                Expanded(child: _infoBox(box1Title, box1Value)),
                const SizedBox(width: 10),
                Expanded(child: _infoBox(box2Title, box2Value)),
              ]),
              if ((location ?? '').isNotEmpty) ...[
                const SizedBox(height: 14),
                _line(Icons.location_on_outlined, _blue, location!, _blue,
                    maxLines: 2),
              ],
              if ((secondaryText ?? '').isNotEmpty) ...[
                const SizedBox(height: 10),
                _line(secondaryIcon, _grey, secondaryText!, _grey),
              ],
              if (tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _fillPill(tags.last.label, _parse(tags.last.color)),
                    if (tags.length > 1) _morePill(tags.length - 1),
                  ],
                ),
              ],
              if ((createdAt ?? '').isNotEmpty) ...[
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(_formatCreatedAt(createdAt!),
                      style: _t(12, FontWeight.w400, _faint)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _miniBadge(String label, Color bg, Color fg) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
            color: bg, borderRadius: BorderRadius.circular(999)),
        child: Text(label, style: _t(11, FontWeight.w600, fg)),
      );

  Widget _infoBox(String title, String value) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: _t(12, FontWeight.w400, _faint)),
            const SizedBox(height: 4),
            Text(value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _t(15, FontWeight.w700, AppColors.text)),
          ],
        ),
      );

  Widget _line(IconData icon, Color iconColor, String text, Color textColor,
      {int maxLines = 1}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 6),
        Expanded(
          child: Text(text,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              style: _t(14, FontWeight.w400, textColor)),
        ),
      ],
    );
  }

  Widget _fillPill(String label, Color bg) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
        child: Text(label, style: _t(13, FontWeight.w600, _fg(bg))),
      );

  Widget _morePill(int n) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: const Color(0xFFF0F2F6),
            borderRadius: BorderRadius.circular(999)),
        child: Text('+$n thẻ', style: _t(13, FontWeight.w600, _grey)),
      );

  /// Dark text on light tag backgrounds, white otherwise (v1 luminance rule).
  Color _fg(Color bg) =>
      bg.computeLuminance() > 0.58 ? const Color(0xFF1F2937) : Colors.white;

  Color _parse(String? hex) {
    final cleaned = (hex ?? '').replaceAll('#', '').trim();
    if (cleaned.length == 6) {
      final v = int.tryParse('FF$cleaned', radix: 16);
      if (v != null) return Color(v);
    }
    return AppColors.primary;
  }
}
