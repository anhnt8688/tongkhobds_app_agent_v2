import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/widgets/app_network_image.dart';
import '../../../core/widgets/app_toast.dart';
import '../../realestate/presentation/widgets/detail/detail_map.dart';
import '../data/models/verification_models.dart';
import '../data/verification_providers.dart';
import 'widgets/verification_action_sheets.dart';
import 'widgets/verification_widgets.dart';

/// Article screen with a public tab + a verification tab, plus the
/// permission-gated action bar (mirrors v1 article page).
class VerificationArticleScreen extends ConsumerStatefulWidget {
  const VerificationArticleScreen({super.key, required this.item});
  final VerificationItem item;
  @override
  ConsumerState<VerificationArticleScreen> createState() =>
      _VerificationArticleScreenState();
}

class _VerificationArticleScreenState
    extends ConsumerState<VerificationArticleScreen> {
  int _tab = 0; // 0 = public, 1 = verification

  void _afterMutation() {
    ref.invalidate(verificationDetailProvider(widget.item.id));
    ref.read(verificationListControllerProvider.notifier).refresh();
  }

  Future<void> _confirm(
    VerificationSalesmanDetailResponse d,
    bool approver,
  ) async {
    final ok = await showVerificationConfirmSheet(
      context,
      detail: d,
      isApproverFlow: approver,
    );
    if (ok != true || !mounted) return;
    if (approver) {
      context.push(
        '/real-estate-verification/approve-success',
        extra: d.realEstate,
      );
    } else {
      AppToast.success(context, 'Xác nhận thành công');
      _afterMutation();
      context.go('/real-estate-verification');
    }
  }

  Future<void> _reject(VerificationSalesmanDetailResponse d) async {
    final ok = await showVerificationRejectSheet(context, detail: d);
    if (ok != true || !mounted) return;
    AppToast.success(context, 'Đã từ chối xác thực');
    _afterMutation();
    context.go('/real-estate-verification');
  }

  Future<void> _reverify(VerificationSalesmanDetailResponse d) async {
    final ok = await showVerificationReverifySheet(context, detail: d);
    if (ok != true || !mounted) return;
    AppToast.success(context, 'Đã gửi yêu cầu xác thực lại');
    _afterMutation();
    context.go('/real-estate-verification');
  }

  Future<void> _edit(VerificationSalesmanDetailResponse d) async {
    final changed = await context.push<bool>(
      '/real-estate-verification/form',
      extra: {'item': widget.item, 'detail': d},
    );
    if (changed == true) _afterMutation();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(verificationDetailProvider(widget.item.id));
    final detail = async.value;
    final accent = detail != null
        ? parseHexColor(detail.statusColor)
        : widget.item.accent;
    final statusText = detail?.statusName.trim().isNotEmpty == true
        ? detail!.statusName.trim()
        : widget.item.status;

    return VerificationScaffold(
      title: 'Chi tiết xác thực',
      action: VerificationStatusBadge(
        text: statusText,
        background: accent.withValues(alpha: 0.10),
        foreground: accent,
      ),
      bottomBar: detail == null
          ? null
          : (_tab == 0 ? null : _bottomBar(detail)),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _TabsBar(index: _tab, onChanged: (i) => setState(() => _tab = i)),
            Expanded(
              child: async.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: VColors.orange,
                  ),
                ),
                error: (_, __) => _ErrorBody(
                  onRetry: () => ref.invalidate(
                    verificationDetailProvider(widget.item.id),
                  ),
                ),
                data: (d) => _tab == 0 ? _publicTab(d) : _verificationTab(d),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────── public tab ─────────

  Widget _publicTab(VerificationSalesmanDetailResponse d) {
    final re = d.realEstate;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        _MetaHeader(d: d, item: widget.item),
        _Gallery(images: re.images, realEstateCode: re.realEstateCode),
        const SizedBox(height: 12),
        Text(
          re.title.isNotEmpty ? re.title : widget.item.title,
          style: vText(18, FontWeight.w600, VColors.n800, height: 1.3),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 14,
              color: VColors.n400,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                _address(d),
                style: vText(13, FontWeight.w400, VColors.n500),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          re.priceDisplay.isNotEmpty ? re.priceDisplay : widget.item.price,
          style: vText(20, FontWeight.w700, VColors.orange),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _stat(
              Icons.king_bed_outlined,
              re.bedrooms?.toString() ?? '-',
              'PN',
            ),
            _stat(
              Icons.bathtub_outlined,
              re.bathrooms?.toString() ?? '-',
              'WC',
            ),
            _stat(
              Icons.straighten,
              re.area != null ? '${re.area!.toStringAsFixed(0)}m²' : '-',
              'Diện tích',
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (re.descriptionHtml.trim().isNotEmpty)
          VerificationInfoCard(
            title: 'Mô tả chi tiết',
            icon: Icons.notes_rounded,
            child: HtmlWidget(re.descriptionHtml),
          ),
        if (re.legalDocumentFiles.isNotEmpty) ...[
          const SizedBox(height: 10),
          VerificationInfoCard(
            title: 'Tài liệu pháp lý',
            icon: Icons.folder_outlined,
            child: Column(
              children: [
                for (final f in re.legalDocumentFiles)
                  _FileRow(
                    title: (f['title'] ?? 'Tài liệu').toString(),
                    onOpen: () => _open((f['url'] ?? '').toString()),
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 10),
        VerificationInfoCard(
          title: 'Thông tin tóm tắt',
          icon: Icons.list_alt_rounded,
          child: Column(
            children: [
              _summary(
                'Mức giá',
                re.priceDisplay.isNotEmpty ? re.priceDisplay : '—',
              ),
              _summary(
                'Diện tích',
                re.area != null ? '${re.area!.toStringAsFixed(0)} m²' : '—',
              ),
              _summary(
                'Loại BĐS',
                re.propertyType.isNotEmpty ? re.propertyType : '—',
              ),
              _summary(
                'Pháp lý',
                re.legalDocument.isNotEmpty ? re.legalDocument : '—',
              ),
              _summary(
                'Nội thất',
                re.interior.isNotEmpty ? re.interior : 'Chưa có',
              ),
            ],
          ),
        ),
        if (re.lat != null && re.lng != null) ...[
          const SizedBox(height: 10),
          _MapCard(lat: re.lat!, lng: re.lng!),
        ],
      ],
    );
  }

  // ───────── verification tab ─────────

  Widget _verificationTab(VerificationSalesmanDetailResponse d) {
    final legal = d.legalInfo;
    final media = [...d.realEstate.images];
    final canEdit = d.permissions?.canEdit ?? false;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        _MetaHeader(d: d, item: widget.item),
        if ((d.verificationNotes ?? '').trim().isNotEmpty) ...[
          const SizedBox(height: 10),
          _Banner(
            bg: VColors.orangePale,
            border: VColors.orangeBorder,
            icon: Icons.warning_amber_rounded,
            text: 'TP yêu cầu sửa: ${d.verificationNotes!.trim()}',
          ),
        ],
        const SizedBox(height: 10),
        _Banner(
          bg: const Color(0xFFFFF3E8),
          border: const Color(0xFFFCD9B6),
          icon: Icons.visibility_off_outlined,
          text:
              'Chú ý dùng nội bộ\nThông tin trong tab này đang hiển thị cả trong bài đăng',
        ),
        const SizedBox(height: 10),
        const VerificationSectionTitle(title: 'Hình ảnh & video xác thực'),
        const SizedBox(height: 8),
        _MediaRow(
          images: media,
          onAdd: canEdit ? () => _edit(d) : null,
          onTapImage: (i) => _openGallery(media, i),
        ),
        const SizedBox(height: 10),
        VerificationInfoCard(
          title: 'Địa điểm',
          icon: Icons.place_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if ((d.googleMapsUrl ?? d.realEstate.googleMapLink)
                  .trim()
                  .isNotEmpty) ...[
                Text(
                  'Link Google Map',
                  style: vText(13, FontWeight.w400, VColors.n500),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () =>
                      _open(d.googleMapsUrl ?? d.realEstate.googleMapLink),
                  child: Text(
                    d.googleMapsUrl ?? d.realEstate.googleMapLink,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: vText(13, FontWeight.w600, VColors.orange),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              Text(
                _address(d),
                style: vText(13, FontWeight.w400, VColors.n700),
              ),
            ],
          ),
        ),
        if (d.realEstate.lat != null && d.realEstate.lng != null) ...[
          const SizedBox(height: 10),
          _MapCard(lat: d.realEstate.lat!, lng: d.realEstate.lng!),
        ],
        const SizedBox(height: 10),
        VerificationInfoCard(
          title: 'Thông tin giao dịch',
          icon: Icons.payments_outlined,
          child: Row(
            children: [
              Expanded(
                child: VerificationPairInfo(
                  label: 'Giá trị HĐ',
                  value: d.realEstateValue ?? widget.item.price,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: VerificationPairInfo(
                  label: 'Phí môi giới',
                  value: d.brokerageFeeValue ?? 'Chưa có',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        VerificationInfoCard(
          title: 'Người trên bìa đỏ',
          icon: Icons.badge_outlined,
          // v1 parity: the 3 chips are display-only (always "Bìa đỏ" active) and
          // the red-book fields are always shown.
          child: Column(
            children: [
              Row(
                children: const [
                  _LegalChip(
                    label: 'Bìa đỏ',
                    icon: Icons.description_outlined,
                    active: true,
                  ),
                  SizedBox(width: 8),
                  _LegalChip(
                    label: 'HĐ mua bán',
                    icon: Icons.receipt_long_outlined,
                    active: false,
                  ),
                  SizedBox(width: 8),
                  _LegalChip(
                    label: 'Khác',
                    icon: Icons.folder_outlined,
                    active: false,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: VerificationPairInfo(
                      label: 'GCCCN số',
                      value: legal.certificateNumber ?? 'Chưa có',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: VerificationPairInfo(
                      label: 'Quyển số',
                      value: legal.numberBook ?? 'Chưa có',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: VerificationPairInfo(
                      label: 'Cấp ngày',
                      value: legal.issuedDate ?? 'Chưa có',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: VerificationPairInfo(
                      label: 'Chủ nhà 1',
                      value:
                          legal.ownerNameFirst ??
                          d.ownerNameFirst ??
                          d.ownerName ??
                          'Chưa có',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: VerificationPairInfo(
                      label: 'CCCD',
                      value: legal.idCardFirst ?? d.idCardFirst ?? 'Chưa có',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        VerificationInfoCard(
          title: 'Lịch sử xác thực',
          icon: Icons.history_rounded,
          child: d.historys.isEmpty
              ? Text(
                  'Chưa có lịch sử xác thực',
                  style: vText(13, FontWeight.w400, VColors.n500),
                )
              : Column(
                  children: [
                    for (var i = 0; i < d.historys.length; i++) ...[
                      _HistoryRow(item: d.historys[i]),
                      if (i != d.historys.length - 1) const SizedBox(height: 8),
                    ],
                  ],
                ),
        ),
      ],
    );
  }

  // ───────── bottom action bar ─────────

  Widget? _bottomBar(VerificationSalesmanDetailResponse d) {
    final p = d.permissions;
    if (p == null) return null;
    final buttons = <Widget>[
      if (p.canEdit)
        _ActionButton(
          label: 'Sửa',
          icon: Icons.edit_outlined,
          fg: VColors.orange,
          border: const Color(0xFFFCD9B3),
          bg: Colors.white,
          onTap: () => _edit(d),
        ),
      if (p.canAgentReject)
        _ActionButton(
          label: 'Từ chối',
          icon: Icons.close_rounded,
          fg: VColors.red,
          border: const Color(0xFFFCA5A5),
          bg: Colors.white,
          onTap: () => _reject(d),
        ),
      if (p.canAgentConfirm)
        _ActionButton(
          label: 'Xác nhận',
          icon: Icons.check_rounded,
          fg: Colors.white,
          border: VColors.orange,
          bg: VColors.orange,
          onTap: () => _confirm(d, false),
        ),
      if (p.canApprove)
        _ActionButton(
          label: 'Duyệt',
          icon: Icons.check_rounded,
          fg: const Color(0xFF6366F1),
          border: const Color(0xFFA5B4FC),
          bg: Colors.white,
          onTap: () => _confirm(d, true),
        ),
      if (p.canRequestReverify)
        _ActionButton(
          label: 'Yêu cầu xác thực lại',
          icon: Icons.restart_alt_rounded,
          fg: const Color(0xFFD97706),
          border: const Color(0xFFF5D08A),
          bg: Colors.white,
          onTap: () => _reverify(d),
        ),
    ];
    if (buttons.isEmpty) return null;
    return SafeArea(
      top: false,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(
          children: [
            for (var i = 0; i < buttons.length; i++) ...[
              Expanded(child: buttons[i]),
              if (i != buttons.length - 1) const SizedBox(width: 8),
            ],
          ],
        ),
      ),
    );
  }

  /// Public tab bottom bar — only the "edit public article" action (v1 parity).
  Widget? _publicBottomBar(VerificationSalesmanDetailResponse d) {
    if (d.permissions?.canEdit != true) return null;
    return SafeArea(
      top: false,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: _ActionButton(
          label: 'Chỉnh sửa bài viết công khai',
          icon: Icons.edit_outlined,
          fg: Colors.white,
          border: VColors.orange,
          bg: VColors.orange,
          onTap: () => _edit(d),
        ),
      ),
    );
  }

  void _openGallery(List<String> images, int index) {
    if (images.isEmpty) return;
    showDialog<void>(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => _ImageViewer(images: images, initialIndex: index),
    );
  }

  // ───────── helpers ─────────

  Widget _stat(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: VColors.n50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: VColors.line),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: VColors.orange),
            const SizedBox(height: 4),
            Text(value, style: vText(14, FontWeight.w600, VColors.n800)),
            Text(label, style: vText(11, FontWeight.w400, VColors.n500)),
          ],
        ),
      ),
    );
  }

  Widget _summary(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: vText(13, FontWeight.w400, VColors.n500)),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: vText(13, FontWeight.w600, VColors.n800),
          ),
        ),
      ],
    ),
  );

  String _address(VerificationSalesmanDetailResponse d) {
    final parts = <String>[
      if ((d.address ?? '').trim().isNotEmpty) d.address!.trim(),
      if ((d.ward ?? '').trim().isNotEmpty) d.ward!.trim(),
      if ((d.district ?? '').trim().isNotEmpty) d.district!.trim(),
      if ((d.city ?? '').trim().isNotEmpty) d.city!.trim(),
    ];
    if (parts.isEmpty) {
      return d.realEstate.streetAddress.isNotEmpty
          ? d.realEstate.streetAddress
          : 'Chưa có địa chỉ';
    }
    return parts.join(', ');
  }

  Future<void> _open(String url) async {
    if (url.trim().isEmpty) return;
    final uri = Uri.tryParse(url.trim());
    if (uri == null) return;
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) AppToast.error(context, 'Không mở được liên kết');
    }
  }
}

// ───────────────────────── small widgets ─────────────────────────

class _TabsBar extends StatelessWidget {
  const _TabsBar({required this.index, required this.onChanged});
  final int index;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) {
    Widget tab(int i, String label) {
      final active = i == index;
      return Expanded(
        child: GestureDetector(
          onTap: () => onChanged(i),
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Text(
                label,
                style: vText(
                  15,
                  active ? FontWeight.w700 : FontWeight.w500,
                  active ? VColors.orange : VColors.n500,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 2,
                color: active ? VColors.orange : Colors.transparent,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      color: Colors.white,
      child: Row(children: [tab(0, 'Bài đăng'), tab(1, 'Thông tin xác thực')]),
    );
  }
}

class _Gallery extends StatefulWidget {
  const _Gallery({required this.images, this.realEstateCode = ''});
  final List<String> images;
  final String realEstateCode;
  @override
  State<_Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<_Gallery> {
  final _pc = PageController();
  int _i = 0;
  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: VColors.n100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.image_outlined, size: 40, color: VColors.n400),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 200,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pc,
              itemCount: widget.images.length,
              onPageChanged: (i) => setState(() => _i = i),
              itemBuilder: (_, i) => AppNetworkImage(
                url: verificationImageUrl(widget.images[i]),
                width: double.infinity,
                height: 200,
              ),
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${_i + 1}/${widget.images.length}',
                  style: vText(12, FontWeight.w600, Colors.white),
                ),
              ),
            ),
            if (widget.realEstateCode.trim().isNotEmpty)
              Positioned(
                left: 12,
                bottom: 12,
                child: GestureDetector(
                  onTap: () {
                    final code = widget.realEstateCode.trim();
                    Clipboard.setData(ClipboardData(text: code));
                    AppToast.success(context, 'Đã sao chép mã BĐS $code');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            widget.realEstateCode.trim(),
                            overflow: TextOverflow.ellipsis,
                            style: vText(13, FontWeight.w500, Colors.white),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.copy_outlined,
                          size: 13,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FileRow extends StatelessWidget {
  const _FileRow({required this.title, required this.onOpen});
  final String title;
  final VoidCallback onOpen;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFFFFEDD5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.insert_drive_file_outlined,
              size: 16,
              color: VColors.orange,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: vText(13, FontWeight.w600, VColors.n800),
            ),
          ),
          TextButton(
            onPressed: onOpen,
            child: Text(
              'Xem',
              style: vText(13, FontWeight.w600, VColors.orange),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shared header (above both tabs): Người đăng / Đầu chủ / Trưởng phòng cards
/// + "Đăng bởi" sub-line. Mirrors v1 _buildSharedHeader — each field falls back
/// to the list item when the detail response omits it, so đầu chủ / người phụ
/// trách stay visible.
class _MetaHeader extends StatelessWidget {
  const _MetaHeader({required this.d, required this.item});
  final VerificationSalesmanDetailResponse d;
  final VerificationItem item;

  @override
  Widget build(BuildContext context) {
    final salesman = d.salesman.name.trim().isNotEmpty
        ? d.salesman.name.trim()
        : item.salesmanName.trim();
    final assigned = (d.assignedToName?.trim().isNotEmpty ?? false)
        ? d.assignedToName!.trim()
        : item.assignedToName.trim();
    final manager = (d.agentSupport?.name.trim().isNotEmpty ?? false)
        ? d.agentSupport!.name.trim()
        : item.agentSupportName.trim();

    final cards = <Widget>[
      if (salesman.isNotEmpty)
        _card(Icons.edit_outlined, 'Người đăng', salesman, VColors.orange),
      if (assigned.isNotEmpty)
        _card(Icons.badge_outlined, 'Đầu chủ', assigned, VColors.orange),
      if (manager.isNotEmpty)
        _card(
          Icons.group_outlined,
          'Trưởng phòng',
          manager,
          const Color(0xFF3B82F6),
        ),
    ];
    if (cards.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (var i = 0; i < cards.length; i++) ...[
              Expanded(child: cards[i]),
              if (i != cards.length - 1) const SizedBox(width: 8),
            ],
          ],
        ),
        if (salesman.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.edit_outlined, size: 13, color: VColors.n400),
              const SizedBox(width: 6),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Đăng bởi ',
                        style: vText(13, FontWeight.w400, VColors.n400),
                      ),
                      TextSpan(
                        text: '$salesman · CTV',
                        style: vText(13, FontWeight.w600, VColors.n700),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _card(IconData icon, String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 9, color: color),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: vText(12, FontWeight.w400, color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: vText(13, FontWeight.w600, VColors.n800),
          ),
        ],
      ),
    );
  }
}

/// Boxed Google map preview (reuses the shared DetailMap widget).
class _MapCard extends StatelessWidget {
  const _MapCard({required this.lat, required this.lng});
  final double lat;
  final double lng;
  @override
  Widget build(BuildContext context) {
    return VerificationInfoCard(
      title: 'Vị trí trên bản đồ',
      icon: Icons.map_outlined,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: 170,
          child: DetailMap(lat: lat, lng: lng),
        ),
      ),
    );
  }
}

/// 3 thumbnail cells + an "Add" cell. Mirrors v1 _VerificationMediaRow.
class _MediaRow extends StatelessWidget {
  const _MediaRow({required this.images, required this.onTapImage, this.onAdd});
  final List<String> images;
  final ValueChanged<int> onTapImage;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    final items = images.where((e) => e.trim().isNotEmpty).take(3).toList();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < 3; i++) ...[
          Expanded(
            child: _MediaCell(
              imageUrl: i < items.length ? items[i] : null,
              label: '${i + 1}',
              onTap: i < items.length ? () => onTapImage(i) : null,
            ),
          ),
          if (i != 2) const SizedBox(width: 8),
        ],
        if (onAdd != null) ...[
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onAdd,
            child: Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: VColors.orange),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add, color: VColors.orange, size: 26),
                  const SizedBox(height: 4),
                  Text(
                    'Thêm',
                    style: vText(12, FontWeight.w600, VColors.orange),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _MediaCell extends StatelessWidget {
  const _MediaCell({required this.imageUrl, required this.label, this.onTap});
  final String? imageUrl;
  final String label;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final url = imageUrl == null ? null : verificationImageUrl(imageUrl!);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 84,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: VColors.n100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: VColors.line),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (url == null || url.isEmpty)
              const Icon(Icons.image_outlined, size: 20, color: VColors.n400)
            else
              AppNetworkImage(url: url, width: 120, height: 84),
            Positioned(
              left: 6,
              top: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.84),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  label,
                  style: vText(11, FontWeight.w600, VColors.n800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Full-screen swipeable image viewer.
class _ImageViewer extends StatefulWidget {
  const _ImageViewer({required this.images, required this.initialIndex});
  final List<String> images;
  final int initialIndex;
  @override
  State<_ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<_ImageViewer> {
  late final PageController _pc = PageController(
    initialPage: widget.initialIndex,
  );
  late int _i = widget.initialIndex;
  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pc,
            itemCount: widget.images.length,
            onPageChanged: (i) => setState(() => _i = i),
            itemBuilder: (_, i) => InteractiveViewer(
              child: Center(
                child: AppNetworkImage(
                  url: verificationImageUrl(widget.images[i]),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              child: const CircleAvatar(
                backgroundColor: Colors.black54,
                radius: 18,
                child: Icon(Icons.close_rounded, color: Colors.white, size: 20),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${_i + 1}/${widget.images.length}',
                  style: vText(13, FontWeight.w600, Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Display-only legal-type chip (v1 `_TriTabChip`): not tappable; the detail
/// view always shows the red-book layout with "Bìa đỏ" active.
class _LegalChip extends StatelessWidget {
  const _LegalChip({
    required this.label,
    required this.icon,
    required this.active,
  });
  final String label;
  final IconData icon;
  final bool active;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: active ? VColors.orangePale : VColors.n50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active ? VColors.orangeBorder : VColors.line,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: active ? VColors.orange : VColors.n500),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: vText(
                  13,
                  FontWeight.w600,
                  active ? VColors.orange : VColors.n500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    required this.bg,
    required this.border,
    required this.icon,
    required this.text,
  });
  final Color bg;
  final Color border;
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: VColors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: vText(
                13,
                FontWeight.w400,
                const Color(0xFF9A3412),
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.item});
  final VerificationHistoryItem item;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: VColors.n50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: VColors.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.history_rounded, size: 16, color: VColors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.description,
                  style: vText(13, FontWeight.w600, VColors.n800),
                ),
                if (item.userComment.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.userComment,
                    style: vText(12, FontWeight.w400, VColors.n500),
                  ),
                ],
                const SizedBox(height: 2),
                Text(
                  '${item.fullName} • ${item.timeStamp}',
                  style: vText(12, FontWeight.w400, VColors.n400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.fg,
    required this.border,
    required this.bg,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final Color fg;
  final Color border;
  final Color bg;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          backgroundColor: bg,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: border),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 15, color: fg),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: vText(12, FontWeight.w600, fg),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.onRetry});
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.error_outline_rounded, size: 40, color: VColors.n400),
        const SizedBox(height: 8),
        Text(
          'Không tải được chi tiết',
          style: vText(13, FontWeight.w400, VColors.n500),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: onRetry,
          child: Text(
            'Thử lại',
            style: vText(14, FontWeight.w600, VColors.orange),
          ),
        ),
      ],
    ),
  );
}
