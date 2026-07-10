import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// v1-style "Ký tên" modal: an orange-bordered 3:2 signature canvas with a
/// placeholder, plus "Ký lại" / "Áp dụng" actions. "Áp dụng" stays disabled
/// until a stroke is drawn. Pops the captured PNG bytes, or null if cancelled.
class SignaturePadDialog extends StatefulWidget {
  const SignaturePadDialog({super.key});

  /// Opens the dialog and returns the signature PNG bytes (null if cancelled).
  static Future<Uint8List?> show(BuildContext context) {
    return showDialog<Uint8List>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const SignaturePadDialog(),
    );
  }

  @override
  State<SignaturePadDialog> createState() => _SignaturePadDialogState();
}

class _SignaturePadDialogState extends State<SignaturePadDialog> {
  late final SignatureController _ctrl = SignatureController(
    penColor: Colors.black87,
    penStrokeWidth: 2.6,
    exportBackgroundColor: Colors.transparent,
  )..addListener(_onStroke);

  bool _hasStroke = false;

  void _onStroke() {
    final filled = _ctrl.isNotEmpty;
    if (filled != _hasStroke) setState(() => _hasStroke = filled);
  }

  @override
  void dispose() {
    _ctrl.removeListener(_onStroke);
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _apply() async {
    final png = await _ctrl.toPngBytes();
    if (!mounted) return;
    Navigator.of(context).pop<Uint8List>(
      (png != null && png.isNotEmpty) ? png : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Spacer(),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary, width: 1.2),
              ),
              padding: const EdgeInsets.all(8),
              child: AspectRatio(
                aspectRatio: 3 / 2,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Signature(
                      controller: _ctrl,
                      backgroundColor: Colors.transparent,
                    ),
                    if (!_hasStroke)
                      Center(
                        child: Text(
                          'Vui lòng vẽ chữ ký vào đây',
                          style: AppTextStyles.regular(14,
                              color: const Color(0xFF9CA3AF)),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _ctrl.clear();
                      setState(() => _hasStroke = false);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE6E6E6)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Ký lại',
                        style: AppTextStyles.semibold(15, color: AppColors.text)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _hasStroke ? _apply : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _hasStroke
                          ? AppColors.primary
                          : AppColors.primarySoft,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Áp dụng',
                        style: AppTextStyles.semibold(15, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
