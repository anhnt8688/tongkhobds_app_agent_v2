import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/theme/app_colors.dart';
import '../data/kyc_image_crop.dart';

/// Crops the captured frame to the viewfinder rect, lets the user confirm or
/// retake. Mirrors v1 `CaptureReviewPage`.
///
/// Pops with the cropped [File] on confirm (when [onConfirm] is null), or pops
/// with `null` on retake.
class KycCaptureReviewScreen extends StatefulWidget {
  const KycCaptureReviewScreen({
    super.key,
    required this.imageFile,
    required this.title,
    required this.cropRectPct,
    this.onConfirm,
  });

  final File imageFile;
  final String title;
  final Rect cropRectPct;
  final Future<void> Function(BuildContext context, File file)? onConfirm;

  @override
  State<KycCaptureReviewScreen> createState() => _KycCaptureReviewScreenState();
}

class _KycCaptureReviewScreenState extends State<KycCaptureReviewScreen> {
  bool _confirming = false;
  String? _error;
  late final Future<File?> _cropFuture;

  /// Fast GPU-cropped preview (decode-downscale + drawImageRect via the engine),
  /// shown almost instantly. The slower file crop runs in parallel for QR +
  /// upload only.
  ui.Image? _preview;

  @override
  void initState() {
    super.initState();
    _cropFuture = _startCrop();
    _buildPreview();
  }

  @override
  void dispose() {
    _preview?.dispose();
    super.dispose();
  }

  /// Crops the captured frame to the viewfinder rect with the engine (no JPEG
  /// re-encode) just for display — orders of magnitude faster than the `image`
  /// package path used for the saved file.
  Future<void> _buildPreview() async {
    try {
      final bytes = await widget.imageFile.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes, targetWidth: 1080);
      final full = (await codec.getNextFrame()).image;
      final r = widget.cropRectPct;
      final sw = (r.width * full.width).clamp(1.0, full.width.toDouble());
      final sh = (r.height * full.height).clamp(1.0, full.height.toDouble());
      final src = Rect.fromLTWH(r.left * full.width, r.top * full.height, sw, sh);
      final dst = Rect.fromLTWH(0, 0, sw, sh);
      final recorder = ui.PictureRecorder();
      ui.Canvas(recorder).drawImageRect(full, src, dst, ui.Paint());
      final out =
          await recorder.endRecording().toImage(sw.round(), sh.round());
      full.dispose();
      if (!mounted) {
        out.dispose();
        return;
      }
      setState(() => _preview = out);
    } catch (_) {
      // Leave _preview null; the build falls back to the original frame.
    }
  }

  Future<File?> _startCrop() async {
    try {
      final dir = await getTemporaryDirectory();
      final outPath = p.join(dir.path,
          'kyc_crop_${DateTime.now().millisecondsSinceEpoch}.jpg');
      final r = widget.cropRectPct;
      final path = await compute(
        cropByPercentEntry,
        CropArgs(
          inPath: widget.imageFile.path,
          outPath: outPath,
          left: r.left,
          top: r.top,
          width: r.width,
          height: r.height,
        ),
      );
      // The crop is only used for QR decode + upload, not for display, so no
      // setState is needed — the original frame stays on screen.
      return File(path);
    } catch (e) {
      if (mounted) setState(() => _error = 'Không thể xử lý ảnh: $e');
      return null;
    }
  }

  Future<void> _confirm() async {
    if (_confirming) return;
    setState(() => _confirming = true);
    try {
      // Wait for the background crop (used for QR + upload, not display).
      final file = await _cropFuture;
      if (file == null || !mounted) return;
      if (widget.onConfirm != null) {
        await widget.onConfirm!(context, file);
      } else if (mounted) {
        Navigator.pop<File>(context, file);
      }
    } finally {
      if (mounted) setState(() => _confirming = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final disabled = _confirming || _error != null;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Chụp ảnh'),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Text(widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: _error != null
                    ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(_error!,
                            style: const TextStyle(color: Colors.redAccent)),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        // Show the engine-cropped preview as soon as it's ready;
                        // until then show the original frame so nothing blocks.
                        child: _preview != null
                            ? RawImage(image: _preview, fit: BoxFit.contain)
                            : Image.file(widget.imageFile,
                                fit: BoxFit.contain, cacheWidth: 1080),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed:
                          _confirming ? null : () => Navigator.pop<File?>(context, null),
                      child: const Text('Chụp lại'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: disabled ? null : _confirm,
                      child: _confirming
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Text('Xác nhận'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
