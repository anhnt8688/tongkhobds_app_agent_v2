import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../core/widgets/app_toast.dart';
import '../data/referral_api.dart';

const _orange = Color(0xFFE48745);

/// Camera QR scanner that mirrors v1: corner frame, "Tải ảnh lên" (scan from a
/// gallery image), and a referrer-info confirm sheet. Pops `true` when a
/// referral was successfully added.
class ScanQrScreen extends ConsumerStatefulWidget {
  const ScanQrScreen({super.key});
  @override
  ConsumerState<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends ConsumerState<ScanQrScreen> {
  final _scanner = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );
  final _picker = ImagePicker();

  bool _leaving = false;
  bool _sheetOpen = false;
  bool _scanLocked = false;
  bool _busyPick = false;

  @override
  void dispose() {
    _leaving = true;
    _scanner.dispose();
    super.dispose();
  }

  /// v1 logic (scan_qr_page._extractNameCode): take the last path segment, then
  /// the trailing digit run. Returns null (→ "QR không hợp lệ") if none.
  String? _extractNameCode(String raw) {
    final s = raw.trim();
    if (s.isEmpty) return null;
    final uri = Uri.tryParse(s);
    final lastSeg = (uri != null && uri.pathSegments.isNotEmpty)
        ? uri.pathSegments.last
        : s.split('/').last;
    final m = RegExp(r'(\d+)$').firstMatch(lastSeg);
    return m?.group(1);
  }

  Future<void> _handleQrRaw(String raw) async {
    if (_leaving || _sheetOpen) return;
    final nameCode = _extractNameCode(raw);
    if (nameCode == null) {
      _scanLocked = true;
      AppToast.warning(context, 'QR không hợp lệ');
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) _scanLocked = false;
      });
      return;
    }

    _sheetOpen = true;
    try {
      await _scanner.stop();
    } catch (_) {}

    if (!mounted) return;
    final added = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      barrierColor: Colors.black54,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      clipBehavior: Clip.antiAlias,
      builder: (_) => _ReferrerInfoSheet(nameCode: nameCode),
    );

    if (added == true) {
      if (mounted) Navigator.pop(context, true);
      return;
    }
    // Cancelled → resume scanning.
    _sheetOpen = false;
    try {
      await _scanner.start();
    } catch (_) {}
  }

  Future<void> _pickImageAndScan() async {
    if (_busyPick) return;
    _busyPick = true;
    try {
      final file = await _picker.pickImage(source: ImageSource.gallery);
      if (file == null) return;
      final result = await _scanner.analyzeImage(file.path);
      final code = result?.barcodes
          .map((b) => b.rawValue)
          .firstWhere((v) => v != null && v.trim().isNotEmpty,
              orElse: () => null);
      if (code != null && code.trim().isNotEmpty) {
        await _handleQrRaw(code.trim());
      } else if (mounted) {
        AppToast.warning(context, 'Không tìm thấy mã QR trong ảnh');
      }
    } catch (_) {
      if (mounted) AppToast.error(context, 'Không thể quét ảnh');
    } finally {
      _busyPick = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final box = (size.width * 0.78).clamp(240.0, 320.0);
    final topPadding = 12 + MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            MobileScanner(
              controller: _scanner,
              fit: BoxFit.cover,
              onDetect: (capture) {
                if (_leaving || _scanLocked || _sheetOpen || !mounted) return;
                final val = capture.barcodes.isEmpty
                    ? null
                    : capture.barcodes.first.rawValue;
                if (val != null && val.trim().isNotEmpty) {
                  _handleQrRaw(val.trim());
                }
              },
              errorBuilder: (context, error) => Center(
                child: Text(
                  'Không mở được camera:\n${error.errorDetails?.message ?? error.errorCode.name}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(height: topPadding),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          _leaving = true;
                          final nav = Navigator.of(context);
                          try {
                            await _scanner.stop();
                          } catch (_) {}
                          if (mounted) nav.pop();
                        },
                        borderRadius: BorderRadius.circular(999),
                        child: const SizedBox(
                          width: 44,
                          height: 44,
                          child: Icon(Icons.arrow_back_ios_new,
                              color: Colors.white, size: 18),
                        ),
                      ),
                      const Spacer(),
                      Text('Quét mã QR',
                          style: AppTypography.title.copyWith(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700)),
                      const Spacer(),
                      const SizedBox(width: 44),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Center(
                    child: Text('Di chuyển camera đến mã QR để quét',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: box,
                          height: box,
                          child: Stack(
                            children: [
                              _CornerBox(size: box, color: _orange),
                              IgnorePointer(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                        color:
                                            Colors.white.withValues(alpha: 0.08)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: _pickImageAndScan,
                          borderRadius: BorderRadius.circular(14),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.image_outlined,
                                    color: Colors.white, size: 24),
                                SizedBox(width: 10),
                                Text('Tải ảnh lên',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.flash_on, color: Colors.white),
                      onPressed: () => _scanner.toggleTorch(),
                    ),
                    const SizedBox(width: 24),
                    IconButton(
                      icon: const Icon(Icons.cameraswitch, color: Colors.white),
                      onPressed: () => _scanner.switchCamera(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet that looks up the referrer by name_code and confirms adding it.
/// Pops `true` on a successful add.
class _ReferrerInfoSheet extends ConsumerStatefulWidget {
  const _ReferrerInfoSheet({required this.nameCode});
  final String nameCode;
  @override
  ConsumerState<_ReferrerInfoSheet> createState() => _ReferrerInfoSheetState();
}

class _ReferrerInfoSheetState extends ConsumerState<_ReferrerInfoSheet> {
  late Future<RefPerson?> _future;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _future = ref.read(referralApiProvider).lookupByNameCode(widget.nameCode);
  }

  Future<void> _confirm() async {
    setState(() => _busy = true);
    try {
      // v1 sends only name_code to salesman_process_referral_code.json.
      final api = ref.read(referralApiProvider);
      final res = await api.processReferral(widget.nameCode);
      if (!mounted) return;
      if (res.success) {
        AppToast.success(context, 'Thêm người giới thiệu thành công');
        Navigator.pop(context, true);
      } else {
        AppToast.error(context, res.message);
        setState(() => _busy = false);
      }
    } catch (_) {
      if (!mounted) return;
      AppToast.error(context, 'Không thể thêm người giới thiệu');
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.of(context).size.height * 0.34;
    return SafeArea(
      top: false,
      child: SizedBox(
        height: maxH,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFE6E6E6),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  const SizedBox(width: 40),
                  Expanded(
                    child: Center(
                      child: Text('Thông tin người giới thiệu',
                          style: AppTypography.title.copyWith(fontSize: 18)),
                    ),
                  ),
                  InkWell(
                    onTap: _busy ? null : () => Navigator.pop(context, false),
                    borderRadius: BorderRadius.circular(999),
                    child: const SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(Icons.close, size: 22)),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            Expanded(
              child: FutureBuilder<RefPerson?>(
                future: _future,
                builder: (context, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return const Center(
                        child: CircularProgressIndicator(color: _orange));
                  }
                  final p = snap.data;
                  if (p == null) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Không tìm thấy người giới thiệu'),
                          const SizedBox(height: 10),
                          OutlinedButton(
                            onPressed: () => setState(() {
                              _future = ref
                                  .read(referralApiProvider)
                                  .lookupByNameCode(widget.nameCode);
                            }),
                            child: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: _InfoCard(person: p),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: FutureBuilder<RefPerson?>(
                future: _future,
                builder: (context, snap) {
                  final p = snap.data;
                  return Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFF1F3F5),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed:
                                _busy ? null : () => Navigator.pop(context, false),
                            child: const Text('Hủy',
                                style: TextStyle(
                                    color: Color(0xFF222222),
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: _orange,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: (_busy || p == null)
                                ? null
                                : () => _confirm(),
                            child: _busy
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                            Colors.white)),
                                  )
                                : const Text('Xác nhận',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.person});
  final RefPerson person;

  @override
  Widget build(BuildContext context) {
    const mute = Color(0xFF8A8A8A);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 64,
              height: 64,
              child: (person.avatar ?? '').trim().isNotEmpty
                  ? AppNetworkImage(url: person.avatar, width: 64, height: 64)
                  : Container(
                      color: const Color(0xFFF2F2F2),
                      child: const Icon(Icons.person, color: Color(0xFFBDBDBD)),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(person.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.body.copyWith(
                        fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.badge_outlined, size: 16, color: mute),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(person.roles ?? 'Agent',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: mute)),
                  ),
                ]),
                const SizedBox(height: 6),
                Row(children: [
                  const Icon(Icons.phone_outlined, size: 16, color: mute),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(person.phone ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: mute)),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Four L-shaped corner marks framing the scan area (v1 _CornerBox).
class _CornerBox extends StatelessWidget {
  const _CornerBox({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    Widget corner(bool left, bool top) => Positioned(
          left: left ? 0 : null,
          right: left ? null : 0,
          top: top ? 0 : null,
          bottom: top ? null : 0,
          child: SizedBox(
            width: 22,
            height: 22,
            child: CustomPaint(
              painter: _CornerPainter(color: color, left: left, top: top),
            ),
          ),
        );
    return SizedBox(
      width: size,
      height: size,
      child: Stack(children: [
        corner(true, true),
        corner(false, true),
        corner(true, false),
        corner(false, false),
      ]),
    );
  }
}

class _CornerPainter extends CustomPainter {
  _CornerPainter({required this.color, required this.left, required this.top});
  final Color color;
  final bool left;
  final bool top;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;
    final path = Path();
    if (left && top) {
      path.moveTo(0, size.height);
      path.lineTo(0, 0);
      path.lineTo(size.width, 0);
    } else if (!left && top) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    } else if (left && !top) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    }
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
