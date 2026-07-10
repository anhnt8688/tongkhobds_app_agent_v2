import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';

/// Which CCCD face's QR data populates the form.
enum KycDataSource { none, front, back }

/// Labeled text field used across the KYC doc-info form. Read-only fields
/// (data pulled from a trusted QR) render with a muted fill.
class KycFieldBlock extends StatelessWidget {
  const KycFieldBlock({
    super.key,
    required this.label,
    required this.controller,
    required this.readOnly,
    this.maxLines = 1,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final bool readOnly;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            readOnly: readOnly,
            maxLines: maxLines,
            keyboardType: keyboardType,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            decoration: _decoration(readOnly),
          ),
        ],
      ),
    );
  }
}

/// Read-only date field with a calendar picker trigger.
class KycDateFieldBlock extends StatelessWidget {
  const KycDateFieldBlock({
    super.key,
    required this.label,
    required this.controller,
    required this.readOnly,
    required this.onPick,
  });

  final String label;
  final TextEditingController controller;
  final bool readOnly;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            readOnly: true,
            onTap: readOnly ? null : onPick,
            decoration: _decoration(readOnly).copyWith(
              hintText: 'dd/MM/yyyy',
              suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

/// Nam / Nữ dropdown. A null [onChanged] renders it disabled (read-only).
class KycGenderDropdownBlock extends StatelessWidget {
  const KycGenderDropdownBlock({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String value;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            // Keyed by value so a programmatic change (QR source switch) re-seeds
            // the field's initial value on rebuild.
            key: ValueKey(value),
            initialValue: (value == 'Nữ') ? 'Nữ' : 'Nam',
            onChanged: onChanged,
            decoration: _decoration(onChanged == null),
            items: const [
              DropdownMenuItem(value: 'Nam', child: Text('Nam')),
              DropdownMenuItem(value: 'Nữ', child: Text('Nữ')),
            ],
          ),
        ],
      ),
    );
  }
}

/// CCCD face thumbnail with a "Có QR" / "Không QR" badge.
class KycImageThumb extends StatelessWidget {
  const KycImageThumb(
      {super.key, required this.file, required this.caption, required this.hasQr});
  final File file;
  final String caption;
  final bool hasQr;

  @override
  Widget build(BuildContext context) {
    final badgeColor =
        hasQr ? const Color(0xFF16A34A) : const Color(0xFF9CA3AF);
    return Column(
      children: [
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 16 / 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(file, fit: BoxFit.cover),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(999)),
                child: Text(hasQr ? 'Có QR' : 'Không QR',
                    style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(caption,
            style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}

/// Choose which face's QR data fills the form (only when both have a QR).
class KycSourceSelector extends StatelessWidget {
  const KycSourceSelector(
      {super.key, required this.current, required this.onChanged});
  final KycDataSource current;
  final ValueChanged<KycDataSource> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ChoiceChip(
          label: const Text('Dùng dữ liệu Mặt trước'),
          selected: current == KycDataSource.front,
          onSelected: (_) => onChanged(KycDataSource.front),
        ),
        ChoiceChip(
          label: const Text('Dùng dữ liệu Mặt sau'),
          selected: current == KycDataSource.back,
          onSelected: (_) => onChanged(KycDataSource.back),
        ),
      ],
    );
  }
}

InputDecoration _decoration(bool readOnly) => InputDecoration(
      isDense: true,
      filled: true,
      fillColor: readOnly ? const Color(0xFFF5F5F4) : Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );

/// Digits-only formatter for the CCCD number field.
final kDigitsOnly = FilteringTextInputFormatter.digitsOnly;
