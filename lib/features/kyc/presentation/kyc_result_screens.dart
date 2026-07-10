import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_network_image.dart';
import 'kyc_pre_capture_screen.dart';

/// "Hoàn tất xác thực" — shown when the backend accepts the submission but the
/// account is still pending manual review. Mirrors v1 `KycWaitingReviewPage`.
class KycWaitingReviewScreen extends StatelessWidget {
  const KycWaitingReviewScreen({super.key});

  void _exit(BuildContext context) =>
      Navigator.of(context).popUntil((r) => r.isFirst);

  void _retry(BuildContext context) {
    Navigator.of(context).popUntil((r) => r.isFirst);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const KycPreCaptureScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.primarySoft,
                    child: Icon(Icons.hourglass_top_rounded,
                        size: 64, color: AppColors.primary),
                  ),
                  SizedBox(height: 20),
                  Text('Hoàn tất xác thực',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                          height: 1.25)),
                  SizedBox(height: 8),
                  Text(
                    'Hệ thống sẽ tiến hành xét duyệt thông tin xác thực của bạn',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14, height: 1.45, color: Color(0xFF7E8299)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () => _retry(context),
                  style: FilledButton.styleFrom(
                    elevation: 0,
                    minimumSize: const Size.fromHeight(54),
                    backgroundColor: const Color(0xFFF3F4F6),
                    foregroundColor: const Color(0xFF111827),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Xác thực lại'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () => _exit(context),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Đã hiểu',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// "Thông tin định danh" — verified summary card. Mirrors v1
/// `KycVerifiedSummaryPage`.
class KycVerifiedSummaryScreen extends StatefulWidget {
  const KycVerifiedSummaryScreen({
    super.key,
    required this.info,
    this.avatarUrl,
    this.showSuccessBanner = true,
  });

  final Map<String, String> info;
  final String? avatarUrl;
  final bool showSuccessBanner;

  @override
  State<KycVerifiedSummaryScreen> createState() =>
      _KycVerifiedSummaryScreenState();
}

class _KycVerifiedSummaryScreenState extends State<KycVerifiedSummaryScreen> {
  bool _showBanner = false;

  @override
  void initState() {
    super.initState();
    _showBanner = widget.showSuccessBanner;
    if (_showBanner) {
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) setState(() => _showBanner = false);
      });
    }
  }

  String _v(String k) =>
      (widget.info[k]?.trim().isNotEmpty == true) ? widget.info[k]!.trim() : '—';

  String _maskId(String? id) {
    final s = (id ?? '').trim();
    if (s.length <= 3) return s;
    return '*****${s.substring(s.length - 3)}';
  }

  void _finish() => Navigator.of(context).popUntil((r) => r.isFirst);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _finish();
      },
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          title: const Text('Thông tin định danh'),
          leading: IconButton(
              onPressed: _finish, icon: const Icon(Icons.arrow_back)),
        ),
        body: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
              children: [
                _profileCard(),
                const SizedBox(height: 16),
                _sectionCard('Thông tin cá nhân', [
                  _kv('Họ và tên', _v('full_name')),
                  _kv('Giới tính', _v('gender')),
                  _kv('Ngày sinh', _v('dob')),
                ]),
                const SizedBox(height: 16),
                _sectionCard('Thông tin định danh', [
                  _kv('Số CCCD', _maskId(widget.info['id_number'])),
                  _kv('Ngày cấp', _v('issue_date')),
                  _kv('Địa chỉ', _v('address')),
                ]),
              ],
            ),
            if (_showBanner)
              Positioned(
                top: 14,
                left: 16,
                right: 16,
                child: Material(
                  color: Colors.black,
                  elevation: 3,
                  borderRadius: BorderRadius.circular(12),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Color(0xFF22C55E)),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text('Định danh thành công',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _finish,
                child: const Text('Hoàn tất',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileCard() {
    final url = widget.avatarUrl;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipOval(
                  child: (url == null || url.isEmpty)
                      ? const CircleAvatar(
                          radius: 32,
                          backgroundColor: Color(0xFFE5E7EB),
                          child: Icon(Icons.person, size: 32, color: Colors.white))
                      : AppNetworkImage(
                          url: url, width: 64, height: 64, fit: BoxFit.cover),
                ),
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.verified,
                        size: 16, color: Color(0xFF22C55E)),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_v('full_name').toUpperCase(),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(_v('id_number'),
                      style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard(String title, List<Widget> rows) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            for (var i = 0; i < rows.length; i++) ...[
              rows[i],
              if (i != rows.length - 1) const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }

  Widget _kv(String k, String v) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(k, style: const TextStyle(color: Colors.black54))),
          const SizedBox(width: 12),
          Expanded(
            child: Text(v,
                textAlign: TextAlign.right,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      );
}
