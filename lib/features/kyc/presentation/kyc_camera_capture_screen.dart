import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'kyc_capture_review_screen.dart';
import 'kyc_doc_info_screen.dart';
import 'widgets/kyc_camera_overlay.dart';

/// Live camera capture of one CCCD face. Used for both the front (`isBack:
/// false`) and back (`isBack: true`). Mirrors v1 camera_capture_front/back:
/// frame the card in the ID-1 viewfinder, capture, crop in the review screen,
/// then advance — front → back, back → doc-info form.
class KycCameraCaptureScreen extends StatefulWidget {
  const KycCameraCaptureScreen({super.key, this.isBack = false, this.frontImage});

  final bool isBack;

  /// The confirmed front image, required when [isBack] is true.
  final File? frontImage;

  @override
  State<KycCameraCaptureScreen> createState() => _KycCameraCaptureScreenState();
}

class _KycCameraCaptureScreenState extends State<KycCameraCaptureScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  bool _initing = true;
  bool _busy = false;
  bool _initInFlight = false;
  String? _err;
  PreviewGeometry? _geometry;

  /// Which face is being captured. Mutable so front → back reuses the same
  /// camera controller (a fresh screen + re-init races the device's single
  /// camera slot and hangs `initialize()` → stuck spinner).
  late bool _isBack;
  File? _frontImage;

  @override
  void initState() {
    super.initState();
    _isBack = widget.isBack;
    _frontImage = widget.frontImage;
    WidgetsBinding.instance.addObserver(this);
    _safeInit();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      final c = _controller;
      _controller = null;
      c?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (_controller == null && mounted) {
        setState(() => _initing = true);
        _safeInit();
      }
    }
  }

  Future<void> _safeInit() async {
    if (_initInFlight) return;
    _initInFlight = true;
    try {
      await Future.delayed(const Duration(milliseconds: 80));
      await _initCamera();
    } catch (e) {
      if (mounted) {
        setState(() {
          _err = 'Không mở được camera: $e';
          _initing = false;
        });
      }
    } finally {
      _initInFlight = false;
    }
  }

  Future<void> _initCamera() async {
    if (_controller != null && _controller!.value.isInitialized) {
      if (mounted) setState(() => _initing = false);
      return;
    }
    final cams = await availableCameras();
    if (cams.isEmpty) {
      if (!mounted) return;
      setState(() {
        _err = 'Không tìm thấy camera trên thiết bị';
        _initing = false;
      });
      return;
    }
    final backIdx =
        cams.indexWhere((c) => c.lensDirection == CameraLensDirection.back);
    final cam = backIdx >= 0 ? cams[backIdx] : cams.first;

    // veryHigh (~1080p) keeps CCCD text + QR readable while keeping the JPEG
    // small enough that crop + QR decode stay fast on real Android devices.
    // ResolutionPreset.max produced 12MP+ files that made cropping/QR hang.
    final c = CameraController(
      cam,
      ResolutionPreset.veryHigh,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    await c.initialize();
    await c.lockCaptureOrientation(DeviceOrientation.portraitUp);
    try {
      await c.setFlashMode(FlashMode.off);
      await c.setFocusMode(FocusMode.auto);
      await c.setExposureMode(ExposureMode.auto);
      await c.setZoomLevel(1.0);
    } catch (_) {}

    if (!mounted) {
      await c.dispose();
      return;
    }
    setState(() {
      _controller = c;
      _initing = false;
      _err = null;
    });
  }

  Future<void> _onTapFocus(TapDownDetails d, BoxConstraints cons) async {
    final c = _controller;
    if (c == null) return;
    try {
      await c.setFocusPoint(
          Offset(d.localPosition.dx / cons.maxWidth, d.localPosition.dy / cons.maxHeight));
      await c.setExposurePoint(
          Offset(d.localPosition.dx / cons.maxWidth, d.localPosition.dy / cons.maxHeight));
    } catch (_) {}
  }

  Future<void> _take() async {
    if (_busy) return;
    final c = _controller;
    final geom = _geometry;
    if (c == null || !c.value.isInitialized || geom == null) return;

    setState(() => _busy = true);
    try {
      // Capture immediately — no focus/exposure lock ceremony or delay — so the
      // shot lands fast; the review screen shows it instantly and crops in the
      // background. Continuous autofocus keeps the framed card sharp enough.
      final shot = await c.takePicture();
      final cropRect = geom.toCropPct();
      if (!mounted) return;
      setState(() => _busy = false);

      if (_isBack) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => KycCaptureReviewScreen(
              imageFile: File(shot.path),
              title: 'Ảnh mặt sau',
              cropRectPct: cropRect,
              onConfirm: (ctx, file) async {
                Navigator.pushReplacement(
                  ctx,
                  MaterialPageRoute(
                    builder: (_) => KycDocInfoScreen(
                      front: _frontImage!,
                      back: file,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      } else {
        final cropped = await Navigator.push<File?>(
          context,
          MaterialPageRoute(
            builder: (_) => KycCaptureReviewScreen(
              imageFile: File(shot.path),
              title: 'Ảnh mặt trước',
              cropRectPct: cropRect,
            ),
          ),
        );
        // Reuse the live camera: flip to the back side in place instead of
        // pushing a new screen that would re-init the camera and hang.
        if (cropped != null && mounted) {
          setState(() {
            _frontImage = cropped;
            _isBack = true;
          });
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Chụp ảnh thất bại: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(_isBack ? 'Chụp mặt SAU' : 'Chụp mặt TRƯỚC'),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _initing
          ? const Center(child: CircularProgressIndicator())
          : _err != null
              ? _ErrorView(
                  message: _err!,
                  onRetry: () {
                    setState(() {
                      _initing = true;
                      _err = null;
                    });
                    _safeInit();
                  },
                )
              : KycCameraPreview(
                  controller: _controller!,
                  tip: _isBack
                      ? 'Đặt mặt SAU CCCD (có QR) vào khung chữ nhật nằm ngang (chuẩn ID-1)'
                      : 'Đặt mặt TRƯỚC CCCD vào khung chữ nhật nằm ngang (chuẩn ID-1)',
                  onShutter: _busy ? () {} : _take,
                  onTapFocus:
                      (d, cons) => _busy ? Future.value() : _onTapFocus(d, cons),
                  onGeometry: (g) => _geometry = g,
                ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('Thử lại')),
          ],
        ),
      ),
    );
  }
}
