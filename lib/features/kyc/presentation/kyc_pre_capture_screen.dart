import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/theme/app_colors.dart';
import 'kyc_camera_capture_screen.dart';

/// "Cập nhật thông tin định danh" — KYC intro/instructions, mirrors v1
/// `KycPreCapturePage`. Requests camera permission then starts the capture flow.
/// This is the `/kyc` entry point.
class KycPreCaptureScreen extends StatefulWidget {
  const KycPreCaptureScreen({super.key});

  @override
  State<KycPreCaptureScreen> createState() => _KycPreCaptureScreenState();
}

class _KycPreCaptureScreenState extends State<KycPreCaptureScreen> {
  String _docType = 'CCCD';
  static const _docLabels = {
    'CCCD': 'Căn Cước Công Dân',
    'PASSPORT': 'Hộ chiếu',
  };
  bool _cameraGranted = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.camera.status;
    if (!mounted) return;
    setState(() => _cameraGranted = status.isGranted);
  }

  Future<void> _requestPermission() async {
    final status = await Permission.camera.request();
    if (!mounted) return;
    if (status.isPermanentlyDenied) await openAppSettings();
    setState(() => _cameraGranted = status.isGranted);
  }

  Future<void> _start() async {
    final ok = await Permission.camera.request().isGranted;
    if (!ok || !mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const KycCameraCaptureScreen()),
    );
  }

  Future<void> _openDocTypeSheet() async {
    final res = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 48,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Center(
                    child: Text('Loại giấy tờ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                  Positioned(
                    right: 0,
                    child: IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close, size: 22)),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            const SizedBox(height: 4),
            for (final e in _docLabels.entries)
              _SheetRadioRow(
                label: e.value,
                selected: _docType == e.key,
                onTap: () => Navigator.pop(ctx, e.key),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (res != null && res != _docType) setState(() => _docType = res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cập nhật thông tin định danh')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          if (!_cameraGranted)
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt_outlined,
                          color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                          'Ứng dụng cần quyền camera để chụp ảnh giấy tờ xác thực.'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                        onPressed: _requestPermission,
                        child: const Text('Cấp quyền')),
                  ],
                ),
              ),
            ),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Xác thực thông tin tài khoản',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  const Text(
                      'Quý khách cần xác thực thông tin tài khoản để nâng cao độ bảo mật.'),
                  const SizedBox(height: 16),
                  Text.rich(
                    TextSpan(children: [
                      const TextSpan(text: 'Loại giấy tờ'),
                      TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red.shade600)),
                    ]),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: _openDocTypeSheet,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Expanded(child: Text(_docLabels[_docType]!)),
                          const Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  for (final t in const [
                    'Sử dụng giấy tờ tùy thân bản gốc và còn hiệu lực',
                    'Không để ánh sáng lóa vào giấy tờ khi chụp',
                    'Không chụp giấy tờ bị mất góc, quăn mép, bị mờ',
                    'Không để ngón tay đè vào giấy tờ khi chụp',
                  ])
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle,
                              color: Colors.green, size: 18),
                          const SizedBox(width: 8),
                          Expanded(child: Text(t)),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      Expanded(child: _BadTipCard(caption: 'Không chụp quá mờ')),
                      SizedBox(width: 12),
                      Expanded(child: _BadTipCard(caption: 'Không chụp mất góc')),
                      SizedBox(width: 12),
                      Expanded(
                          child: _BadTipCard(caption: 'Không chụp bị che khuất')),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size.fromHeight(52),
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: _cameraGranted ? _start : _requestPermission,
            child: Text(_cameraGranted ? 'Bắt đầu xác thực' : 'Cấp quyền camera'),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'Bằng việc tiếp tục, bạn đồng ý với Thỏa thuận sử dụng và Chính sách bảo mật.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetRadioRow extends StatelessWidget {
  const _SheetRadioRow(
      {required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
                child: Text(label, style: const TextStyle(fontSize: 16))),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                    color: selected ? AppColors.primary : Colors.black26,
                    width: selected ? 3 : 2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BadTipCard extends StatelessWidget {
  const _BadTipCard({required this.caption});
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 10,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child:
                const Center(child: Icon(Icons.credit_card, size: 32, color: Colors.grey)),
          ),
        ),
        const SizedBox(height: 6),
        Text(caption,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Color(0xFFE11D48),
                fontSize: 12,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}
