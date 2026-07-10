import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/config/app_config.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/share_util.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/custom_screen.dart';
import '../data/referral_api.dart';
import 'scan_qr_screen.dart';

/// "Giới thiệu" — 2 tabs (my QR / referrers), mirroring v1 SharePage.
class ReferralScreen extends ConsumerStatefulWidget {
  const ReferralScreen({super.key});

  @override
  ConsumerState<ReferralScreen> createState() => _ReferralScreenState();
}

const _orange = Color(0xFFE48745);

class _ReferralScreenState extends ConsumerState<ReferralScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'Giới thiệu',
      backgroundColor: const Color(0xFFF6F6F6),
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tab,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(color: _orange, width: 2),
                insets: EdgeInsets.symmetric(horizontal: 20),
              ),
              labelColor: _orange,
              unselectedLabelColor: const Color(0xFF222222),
              labelStyle:
                  AppTypography.body.copyWith(fontWeight: FontWeight.w600),
              unselectedLabelStyle: AppTypography.body,
              dividerColor: const Color(0xFFEDEDED),
              dividerHeight: 1,
              tabs: const [
                Tab(text: 'Mã QR của tôi'),
                Tab(text: 'Người giới thiệu'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: const [_MyQrTab(), _ReferrerTab()],
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── Tab 1: my QR ─────────────────────────

class _MyQrTab extends ConsumerWidget {
  const _MyQrTab();

  Future<void> _copy(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) AppToast.success(context, 'Sao chép thành công');
  }

  Future<void> _share(BuildContext context, MyReferral m) async {
    final link = (m.linkInvited ?? '').isNotEmpty ? m.linkInvited! : AppConfig.webBase;
    await Share.share(link, sharePositionOrigin: shareOrigin(context));
  }

  Future<void> _saveToGallery(BuildContext context, String base64Str) async {
    try {
      var raw = base64Str;
      if (raw.contains(',')) raw = raw.split(',').last;
      if (raw.trim().isEmpty) {
        if (context.mounted) AppToast.error(context, 'Không có ảnh để lưu');
        return;
      }
      final Uint8List bytes = base64Decode(raw);
      final dir = await getTemporaryDirectory();
      final path =
          '${dir.path}/qr_${DateTime.now().millisecondsSinceEpoch}.png';
      await File(path).writeAsBytes(bytes);
      await Gal.putImage(path);
      if (context.mounted) {
        AppToast.success(context, 'Ảnh đã lưu vào thư viện');
      }
    } catch (e) {
      if (context.mounted) AppToast.error(context, 'Lỗi lưu ảnh');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final my = ref.watch(myReferralProvider);
    return my.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(color: _orange)),
      error: (_, __) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Không tải được thông tin',
                  style: AppTypography.body
                      .copyWith(color: const Color(0xFF7A7A7A))),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => ref.invalidate(myReferralProvider),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      ),
      data: (m) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
        child: Column(
          children: [
            _ProfileQrCard(my: m),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _CircleAction(
                  icon: Icons.download_rounded,
                  label: 'Lưu hình',
                  onTap: () => _saveToGallery(
                      context, m.qrCodeIcon ?? m.qrCode ?? ''),
                ),
                const SizedBox(width: 36),
                _CircleAction(
                  icon: Icons.copy_rounded,
                  label: 'Sao chép',
                  onTap: () => _copy(context, m.linkInvited ?? ''),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _showInvited(context),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.groups_outlined,
                        color: Color(0xFFB0B0B0), size: 22),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mời thành công',
                            style: AppTypography.body
                                .copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text('${m.countInvited} người',
                            style: AppTypography.caption
                                .copyWith(color: const Color(0xFF888888))),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right,
                        color: Color(0xFFB0B0B0), size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: _orange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => _share(context, m),
                child: Text('Chia sẻ',
                    style: AppTypography.body.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInvited(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      barrierColor: Colors.black54,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      clipBehavior: Clip.antiAlias,
      builder: (_) => const _InvitedSheet(),
    );
  }
}

class _ProfileQrCard extends StatelessWidget {
  const _ProfileQrCard({required this.my});
  final MyReferral my;

  Uint8List? _decode(String raw) {
    try {
      var s = raw;
      if (s.contains(',')) s = s.split(',').last;
      if (s.trim().isEmpty) return null;
      return base64Decode(s);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final qrBytes = _decode(my.qrCode ?? '');
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 44),
          padding: const EdgeInsets.fromLTRB(16, 52, 16, 18),
          width: double.infinity,
          decoration: BoxDecoration(
            color: _orange,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                my.name ?? '',
                textAlign: TextAlign.center,
                style: AppTypography.title.copyWith(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text(
                'ID: ${my.nameCode ?? ''}',
                style: AppTypography.body.copyWith(
                    color: Colors.white.withValues(alpha: 0.9), fontSize: 16),
              ),
              const SizedBox(height: 14),
              LayoutBuilder(
                builder: (context, c) {
                  final box = (c.maxWidth * 0.65).clamp(200.0, 250.0);
                  return Container(
                    width: box,
                    height: box,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: qrBytes == null
                        ? const Center(child: Text('QR không hợp lệ'))
                        : Image.memory(qrBytes, fit: BoxFit.contain),
                  );
                },
              ),
            ],
          ),
        ),
        Container(
          width: 88,
          height: 88,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            border: Border.fromBorderSide(
                BorderSide(color: Colors.white, width: 4)),
            color: Colors.white,
          ),
          child: ClipOval(
            child: (my.avatar ?? '').trim().isNotEmpty
                ? AppNetworkImage(url: my.avatar, width: 88, height: 88)
                : Container(
                    color: const Color(0xFFF2F2F2),
                    child: const Icon(Icons.person,
                        size: 44, color: Color(0xFFBDBDBD)),
                  ),
          ),
        ),
      ],
    );
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction(
      {required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF8A8A8A)),
          ),
        ),
        const SizedBox(height: 8),
        Text(label,
            style: AppTypography.caption
                .copyWith(color: const Color(0xFF7A7A7A))),
      ],
    );
  }
}

// ───────────────────────── Tab 2: referrers ─────────────────────────

class _ReferrerTab extends ConsumerWidget {
  const _ReferrerTab();

  Future<void> _scan(BuildContext context, WidgetRef ref) async {
    final ok = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const ScanQrScreen()),
    );
    if (ok == true) ref.invalidate(referrersProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final referrers = ref.watch(referrersProvider);
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: referrers.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: _orange)),
        error: (_, __) => _empty(context, ref),
        data: (list) => list.isEmpty
            ? _empty(context, ref)
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _PersonCard(
                  person: list[i],
                  secondaryIcon: Icons.badge_outlined,
                  secondaryText: list[i].roles ?? 'Agent',
                ),
              ),
      ),
    );
  }

  Widget _empty(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                color: Color(0xFFF2F2F2),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.person_outline,
                      size: 58, color: Color(0xFFC9C9C9)),
                  Positioned(
                    right: 26,
                    bottom: 28,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE0E0E0),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit,
                          size: 14, color: Color(0xFF9E9E9E)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Chưa có người giới thiệu nào',
              textAlign: TextAlign.center,
              style: AppTypography.body
                  .copyWith(color: const Color(0xFF7A7A7A), fontSize: 16),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 46,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: _orange,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                ),
                onPressed: () => _scan(context, ref),
                child: Text('Thêm người giới thiệu',
                    style: AppTypography.body.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── shared card ─────────────────────────

/// White elevated card with avatar + name + two icon rows.
/// Used by the referrer list and the invited bottom sheet.
class _PersonCard extends StatelessWidget {
  const _PersonCard({
    required this.person,
    required this.secondaryIcon,
    required this.secondaryText,
  });
  final RefPerson person;
  final IconData secondaryIcon;
  final String secondaryText;

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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                        fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                _iconRow(secondaryIcon, secondaryText, mute),
                const SizedBox(height: 6),
                _iconRow(Icons.phone_outlined, person.phone ?? '', mute),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconRow(IconData icon, String text, Color color) => Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.caption.copyWith(color: color)),
          ),
        ],
      );
}

// ───────────────────────── invited bottom sheet ─────────────────────────

class _InvitedSheet extends ConsumerWidget {
  const _InvitedSheet();

  String _date(String? raw) {
    final s = (raw ?? '').toString();
    final m = RegExp(r'(\d{2}/\d{2}/\d{4})').firstMatch(s);
    return m?.group(1) ?? s;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invited = ref.watch(invitedListProvider);
    final maxH = MediaQuery.of(context).size.height * 0.7;
    return SafeArea(
      top: false,
      bottom: false,
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
                      child: Text('Mời thành công',
                          style: AppTypography.title.copyWith(fontSize: 18)),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
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
              child: invited.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator(color: _orange)),
                error: (_, __) => _emptyInvited(),
                data: (list) => list.isEmpty
                    ? _emptyInvited()
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        itemCount: list.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (_, i) => _PersonCard(
                          person: list[i],
                          secondaryIcon: Icons.calendar_today_outlined,
                          secondaryText:
                              'Tham gia ngày ${_date(list[i].createdOn)}',
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: SizedBox(
                height: 52,
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: _orange,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text('Đã hiểu',
                      style: AppTypography.body.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyInvited() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_off_outlined,
                size: 86, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text('Chưa có người được mời thành công',
                style: AppTypography.body
                    .copyWith(color: const Color(0xFF7A7A7A))),
          ],
        ),
      );
}
