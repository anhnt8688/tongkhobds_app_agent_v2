import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_toast.dart';
import '../../data/models/verification_models.dart';
import '../../data/verification_api.dart';
import 'verification_widgets.dart';

/// Approve / confirm sheet. Returns true on success.
Future<bool?> showVerificationConfirmSheet(
  BuildContext context, {
  required VerificationSalesmanDetailResponse detail,
  required bool isApproverFlow,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) =>
        _ConfirmSheet(detail: detail, isApproverFlow: isApproverFlow),
  );
}

/// Reject sheet (status 3). Returns true on success.
Future<bool?> showVerificationRejectSheet(
  BuildContext context, {
  required VerificationSalesmanDetailResponse detail,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ReasonSheet(
      detail: detail,
      mode: _ReasonMode.reject,
    ),
  );
}

/// Re-verify request sheet (status 5 + reset). Returns true on success.
Future<bool?> showVerificationReverifySheet(
  BuildContext context, {
  required VerificationSalesmanDetailResponse detail,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ReasonSheet(
      detail: detail,
      mode: _ReasonMode.reverify,
    ),
  );
}

// ───────────────────────── confirm / approve ─────────────────────────

class _ConfirmSheet extends ConsumerStatefulWidget {
  const _ConfirmSheet({required this.detail, required this.isApproverFlow});
  final VerificationSalesmanDetailResponse detail;
  final bool isApproverFlow;
  @override
  ConsumerState<_ConfirmSheet> createState() => _ConfirmSheetState();
}

class _ConfirmSheetState extends ConsumerState<_ConfirmSheet> {
  bool _checked = false;
  bool _submitting = false;

  Future<void> _submit() async {
    setState(() => _submitting = true);
    final res = await ref.read(verificationApiProvider).updateVerificationSalesman(
          realEstateSalesmanId: widget.detail.id,
          verificationStatus: 1,
        );
    if (!mounted) return;
    if (res.success) {
      Navigator.pop(context, true);
    } else {
      AppToast.error(context, res.message.isNotEmpty
          ? res.message
          : (widget.isApproverFlow ? 'Duyệt xác thực thất bại' : 'Xác nhận thất bại'));
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.detail;
    final approve = widget.isApproverFlow;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return DraggableScrollableSheet(
      initialChildSize: 0.78,
      maxChildSize: 0.92,
      minChildSize: 0.55,
      expand: false,
      builder: (context, scroll) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: ListView(
          controller: scroll,
          padding: EdgeInsets.fromLTRB(16, 10, 16, 16 + bottomInset),
          children: [
            const Center(
              child: SizedBox(width: 54, child: Center(child: VSheetHandle())),
            ),
            const SizedBox(height: 14),
            Center(
              child: Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                    color: Color(0xFFFFEDD5), shape: BoxShape.circle),
                child: const Icon(Icons.verified_outlined,
                    color: VColors.orange, size: 42),
              ),
            ),
            const SizedBox(height: 18),
            Text(approve ? 'Duyệt thông tin BĐS' : 'Xác nhận thông tin BĐS',
                textAlign: TextAlign.center,
                style: vText(20, FontWeight.w700, VColors.n800)),
            const SizedBox(height: 8),
            Text(
              approve
                  ? 'Sau khi duyệt, tin đăng sẽ được xuất bản trên Web & App Tổng kho BDS.'
                  : 'Sau khi xác nhận, yêu cầu sẽ chuyển sang bước duyệt.',
              textAlign: TextAlign.center,
              style: vText(14, FontWeight.w400, VColors.n500, height: 1.3),
            ),
            const SizedBox(height: 18),
            _InfoCard(d: d),
            const SizedBox(height: 14),
            InkWell(
              onTap: () => setState(() => _checked = !_checked),
              borderRadius: BorderRadius.circular(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _checked ? VColors.orange : Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: _checked ? VColors.orange : VColors.n300),
                    ),
                    child: _checked
                        ? const Icon(Icons.check_rounded,
                            size: 16, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Tôi đã đọc nội dung bài viết công khai và các thông tin xác thực',
                      style: vText(14, FontWeight.w400, VColors.n700, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _submitting ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      side: const BorderSide(color: VColors.n300),
                      foregroundColor: VColors.n700,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Hủy'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: (!_checked || _submitting) ? null : _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: VColors.orange,
                      disabledBackgroundColor: VColors.n300,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: _submitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white)))
                        : Text(approve ? 'Duyệt' : 'Xác nhận'),
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

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.d});
  final VerificationSalesmanDetailResponse d;
  @override
  Widget build(BuildContext context) {
    final rows = <List<String>>[
      ['Mã BĐS', '#${d.realEstate.realEstateCode.isNotEmpty ? d.realEstate.realEstateCode : d.realEstate.id}'],
      ['BĐS', d.realEstate.title.isNotEmpty ? d.realEstate.title : 'Chưa có'],
      ['Địa chỉ', d.address ?? (d.realEstate.streetAddress.isNotEmpty ? d.realEstate.streetAddress : 'Chưa có')],
      ['Giá', d.realEstateValue ?? (d.realEstate.priceDisplay.isNotEmpty ? d.realEstate.priceDisplay : 'Chưa có')],
      ['Chủ nhà', d.ownerName ?? d.ownerNameFirst ?? d.legalInfo.ownerNameFirst ?? 'Chưa có'],
      ['Người đăng tin', d.salesman.name],
      ['Trưởng phòng', d.agentSupport?.name ?? 'Chưa có'],
      ['Pháp lý', d.legalInfo.certificateNumber ?? d.legalInfo.numberBook ?? 'Chưa có'],
    ];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: VColors.n50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: VColors.line),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: 110,
                    child: Text(rows[i][0],
                        style: vText(13, FontWeight.w400, VColors.n500))),
                Expanded(
                  child: Text(rows[i][1],
                      textAlign: TextAlign.right,
                      style: vText(
                          13,
                          FontWeight.w600,
                          (rows[i][0] == 'Mã BĐS' || rows[i][0] == 'Giá')
                              ? VColors.orange
                              : VColors.n800)),
                ),
              ],
            ),
            if (i != rows.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

// ───────────────────────── reject / reverify ─────────────────────────

enum _ReasonMode { reject, reverify }

class _ReasonSheet extends ConsumerStatefulWidget {
  const _ReasonSheet({required this.detail, required this.mode});
  final VerificationSalesmanDetailResponse detail;
  final _ReasonMode mode;
  @override
  ConsumerState<_ReasonSheet> createState() => _ReasonSheetState();
}

class _ReasonSheetState extends ConsumerState<_ReasonSheet> {
  final _reason = TextEditingController();
  bool _submitting = false;

  static const _reasonCategories = ['Pháp lý', 'Chủ nhà', 'BĐS', 'Giao dịch'];
  final _selectedTags = <String>{};

  bool get _isReject => widget.mode == _ReasonMode.reject;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final typed = _reason.text.trim();
    if (typed.isEmpty) {
      AppToast.warning(context,
          _isReject ? 'Vui lòng nhập lý do từ chối' : 'Vui lòng nhập lý do xác thực lại');
      return;
    }
    final reason = (_isReject && _selectedTags.isNotEmpty)
        ? 'Mục cần sửa: ${_selectedTags.join(', ')}. $typed'
        : typed;
    setState(() => _submitting = true);
    final api = ref.read(verificationApiProvider);
    final res = _isReject
        ? await api.updateVerificationSalesman(
            realEstateSalesmanId: widget.detail.id,
            verificationStatus: 3,
            reason: reason)
        : await api.reverifyVerificationSalesman(
            realEstateSalesmanId: widget.detail.id, reason: reason);
    if (!mounted) return;
    if (res.success) {
      Navigator.pop(context, true);
    } else {
      AppToast.error(context, res.message.isNotEmpty
          ? res.message
          : (_isReject ? 'Từ chối thất bại' : 'Xác thực lại thất bại'));
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.detail;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final color = _isReject ? VColors.red : VColors.orange;
    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      maxChildSize: 0.92,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scroll) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: ListView(
          controller: scroll,
          padding: EdgeInsets.fromLTRB(16, 10, 16, 16 + bottomInset),
          children: [
            const Center(child: VSheetHandle()),
            const SizedBox(height: 14),
            Center(
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                    color: _isReject ? const Color(0xFFFEE2E2) : const Color(0xFFFFEDD5),
                    shape: BoxShape.circle),
                child: Icon(
                    _isReject ? Icons.close_rounded : Icons.restart_alt_rounded,
                    color: color,
                    size: 42),
              ),
            ),
            const SizedBox(height: 18),
            Text(_isReject ? 'Từ chối xác thực' : 'Xác thực lại thông tin BĐS',
                textAlign: TextAlign.center,
                style: vText(20, FontWeight.w700, VColors.n800)),
            const SizedBox(height: 8),
            Text(
              _isReject
                  ? 'Vui lòng nhập lý do để CTV biết hướng chỉnh sửa'
                  : 'Vui lòng nhập lý do để yêu cầu CTV cập nhật lại thông tin',
              textAlign: TextAlign.center,
              style: vText(14, FontWeight.w400, VColors.n500, height: 1.3),
            ),
            const SizedBox(height: 16),
            _MiniInfoCard(d: d),
            if (_isReject) ...[
              const SizedBox(height: 16),
              Text('Mục cần sửa', style: vText(14, FontWeight.w600, VColors.n700)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tag in _reasonCategories)
                    _RejectReasonChip(
                      label: tag,
                      active: _selectedTags.contains(tag),
                      onTap: () => setState(() => _selectedTags.contains(tag)
                          ? _selectedTags.remove(tag)
                          : _selectedTags.add(tag)),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            Text(_isReject ? 'Lý do từ chối *' : 'Lý do *',
                style: vText(14, FontWeight.w600, VColors.n700)),
            const SizedBox(height: 8),
            TextField(
              controller: _reason,
              maxLines: 5,
              style: vText(14, FontWeight.w400, VColors.n800),
              decoration: InputDecoration(
                hintText: _isReject
                    ? 'Nhập lý do từ chối...'
                    : 'Nhập lý do yêu cầu xác thực lại...',
                hintStyle: vText(14, FontWeight.w400, VColors.n400),
                contentPadding: const EdgeInsets.all(14),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFFCA5A5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: color),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _submitting ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      side: const BorderSide(color: VColors.n300),
                      foregroundColor: VColors.n700,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Hủy'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _submitting ? null : _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: _isReject ? VColors.redDark : VColors.orange,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: _submitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white)))
                        : Text(_isReject ? 'Từ chối' : 'Xác thực lại'),
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

class _RejectReasonChip extends StatelessWidget {
  const _RejectReasonChip(
      {required this.label, required this.active, required this.onTap});
  final String label;
  final bool active;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFFEE2E2) : VColors.n50,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
              color: active ? const Color(0xFFFCA5A5) : VColors.line),
        ),
        child: Text(label,
            style: vText(13, FontWeight.w600,
                active ? VColors.redDark : VColors.n600)),
      ),
    );
  }
}

class _MiniInfoCard extends StatelessWidget {
  const _MiniInfoCard({required this.d});
  final VerificationSalesmanDetailResponse d;
  @override
  Widget build(BuildContext context) {
    final rows = <List<String>>[
      ['Mã BĐS', '#${d.realEstate.realEstateCode.isNotEmpty ? d.realEstate.realEstateCode : d.realEstate.id}'],
      ['BĐS', d.realEstate.title.isNotEmpty ? d.realEstate.title : 'Chưa có'],
      ['Người đăng tin', d.salesman.name],
    ];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: VColors.n50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: VColors.line),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            Row(
              children: [
                SizedBox(
                    width: 110,
                    child: Text(rows[i][0],
                        style: vText(13, FontWeight.w400, VColors.n500))),
                Expanded(
                  child: Text(rows[i][1],
                      textAlign: TextAlign.right,
                      style: vText(13, FontWeight.w600,
                          rows[i][0] == 'Mã BĐS' ? VColors.orange : VColors.n800)),
                ),
              ],
            ),
            if (i != rows.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
