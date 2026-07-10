import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/presentation/controllers/auth_controller.dart';
import '../data/cccd_qr.dart';
import '../data/kyc_api.dart';
import 'kyc_result_screens.dart';
import 'widgets/kyc_form_fields.dart';

/// "Xác thực thông tin" — reviews/edits the CCCD info (auto-filled from the QR
/// when present) and submits to `verify_agent`. Mirrors v1 `KycDocInfoPage`.
class KycDocInfoScreen extends ConsumerStatefulWidget {
  const KycDocInfoScreen({super.key, required this.front, required this.back});
  final File front;
  final File back;

  @override
  ConsumerState<KycDocInfoScreen> createState() => _KycDocInfoScreenState();
}

class _KycDocInfoScreenState extends ConsumerState<KycDocInfoScreen> {
  final _idNumber = TextEditingController();
  final _fullName = TextEditingController();
  final _dob = TextEditingController();
  final _address = TextEditingController();
  final _issueDate = TextEditingController();
  String _gender = 'Nam';

  Map<String, String>? _frontData;
  Map<String, String>? _backData;
  bool _frontHasQr = false;
  bool _backHasQr = false;
  KycDataSource _source = KycDataSource.none;

  bool _decoding = true;
  bool _locked = true;
  bool _legalAccepted = false;
  bool _submitting = false;
  String? _submitError;

  @override
  void initState() {
    super.initState();
    _decodeBoth();
  }

  @override
  void dispose() {
    for (final c in [_idNumber, _fullName, _dob, _address, _issueDate]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _decodeBoth() async {
    // mobile_scanner.analyzeImage uses the native GoogleMLKit barcode engine.
    // On veryHigh (~1080p) images this is fast; the timeout is a safety net so
    // the form never stays stuck loading (falls back to manual entry).
    final scanner = MobileScannerController();
    Future<Map<String, String>?> decode(File f) async {
      try {
        final res = await scanner
            .analyzeImage(f.path)
            .timeout(const Duration(seconds: 8), onTimeout: () => null);
        final raw = (res != null && res.barcodes.isNotEmpty)
            ? res.barcodes.first.rawValue?.trim()
            : null;
        if (raw != null && raw.isNotEmpty) return CccdQr.parse(raw);
      } catch (_) {}
      return null;
    }

    final front = await decode(widget.front);
    final back = await decode(widget.back);
    try {
      await scanner.dispose();
    } catch (_) {}

    _frontData = front;
    _backData = back;
    _frontHasQr = front != null;
    _backHasQr = back != null;
    _source = _backHasQr
        ? KycDataSource.back
        : _frontHasQr
            ? KycDataSource.front
            : KycDataSource.none;
    _applySource();
    if (mounted) setState(() => _decoding = false);
  }

  void _applySource() {
    final data = switch (_source) {
      KycDataSource.front => _frontData,
      KycDataSource.back => _backData,
      KycDataSource.none => null,
    };
    _idNumber.text = data?['id_number'] ?? '';
    _fullName.text = data?['full_name'] ?? '';
    _dob.text = _fmtDdMmYyyy(data?['dob'] ?? '');
    final g = (data?['gender'] ?? '').trim();
    _gender = g.toLowerCase().startsWith('nữ') ? 'Nữ' : 'Nam';
    _address.text = data?['permanent_address'] ?? '';
    _issueDate.text = _fmtDdMmYyyy(data?['issue_date'] ?? '');
    _locked = _source != KycDataSource.none;
    if (mounted) setState(() {});
  }

  Future<void> _pickDate(TextEditingController ctl) async {
    final now = DateTime.now();
    DateTime? initial;
    if (_isDdMmYyyy(ctl.text.trim())) {
      final p = ctl.text.trim().split('/');
      initial = DateTime(int.parse(p[2]), int.parse(p[1]), int.parse(p[0]));
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime(now.year - 20),
      firstDate: DateTime(1940),
      lastDate: DateTime(now.year + 1),
      helpText: 'Chọn ngày',
    );
    if (picked != null) {
      ctl.text =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      setState(() => _submitError = null);
    }
  }

  Future<void> _submit() async {
    final id = _idNumber.text.trim();
    final name = _fullName.text.trim();
    final dobDisplay = _dob.text.trim();
    final address = _address.text.trim();
    final issueDisplay = _issueDate.text.trim();
    final sex = _gender.toLowerCase().startsWith('nữ') ? 0 : 1;

    if (!RegExp(r'^[0-9]{12}$').hasMatch(id)) {
      setState(() => _submitError = 'Số CCCD phải gồm đúng 12 chữ số.');
      return;
    }
    if (name.isEmpty) {
      setState(() => _submitError = 'Vui lòng nhập Họ và tên.');
      return;
    }
    if (dobDisplay.isEmpty) {
      setState(() => _submitError = 'Vui lòng chọn Ngày sinh.');
      return;
    }
    if (address.isEmpty) {
      setState(() => _submitError = 'Vui lòng nhập Địa chỉ.');
      return;
    }
    if (issueDisplay.isEmpty) {
      setState(() => _submitError = 'Vui lòng chọn Ngày cấp.');
      return;
    }
    if (!_legalAccepted) {
      setState(() => _submitError =
          'Vui lòng xác nhận sử dụng thông tin được xác thực làm thông tin pháp lý cho tài khoản.');
      return;
    }

    final dobIso = _toIso(dobDisplay);
    final issueIso = _toIso(issueDisplay);
    final iso = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!iso.hasMatch(dobIso)) {
      setState(() => _submitError = 'Ngày sinh không hợp lệ. Vui lòng chọn lại.');
      return;
    }
    if (!iso.hasMatch(issueIso)) {
      setState(() => _submitError = 'Ngày cấp không hợp lệ. Vui lòng chọn lại.');
      return;
    }

    setState(() {
      _submitting = true;
      _submitError = null;
    });
    try {
      final data = await ref.read(kycApiProvider).verifyAgent(
            idCard: id,
            name: name,
            birthday: dobIso,
            sex: sex,
            address: address,
            idDay: issueIso,
            front: widget.front,
            back: widget.back,
            blockEdit: _frontHasQr || _backHasQr,
          );
      await ref.read(authControllerProvider.notifier).refreshProfile();
      if (!mounted) return;

      final avatar = data?['image']?.toString();
      final summary = <String, String>{
        'full_name': name,
        'id_number': id,
        'dob': dobDisplay,
        'gender': sex == 0 ? 'Nữ' : 'Nam',
        'issue_date': issueDisplay,
        'address': address,
      };
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => KycVerifiedSummaryScreen(
              info: summary, avatarUrl: avatar, showSuccessBanner: true),
        ),
      );
    } on ApiException catch (e) {
      final processing = e.message.toLowerCase().contains('đang được xử lý');
      if (processing) {
        await ref.read(authControllerProvider.notifier).refreshProfile();
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const KycWaitingReviewScreen()),
        );
        return;
      }
      if (mounted) setState(() => _submitError = e.message);
    } catch (_) {
      if (mounted) {
        setState(() => _submitError = 'Xác thực thất bại, vui lòng kiểm tra lại.');
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Xác thực thông tin')),
      body: _decoding
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    Expanded(
                        child: KycImageThumb(
                            file: widget.front,
                            caption: 'Mặt trước',
                            hasQr: _frontHasQr)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: KycImageThumb(
                            file: widget.back,
                            caption: 'Mặt sau',
                            hasQr: _backHasQr)),
                  ],
                ),
                const SizedBox(height: 12),
                if (_frontHasQr && _backHasQr) ...[
                  KycSourceSelector(
                    current: _source,
                    onChanged: (s) {
                      _source = s;
                      _applySource();
                    },
                  ),
                  const SizedBox(height: 8),
                ],
                KycFieldBlock(
                    label: 'Số CCCD *',
                    controller: _idNumber,
                    readOnly: _locked,
                    keyboardType: TextInputType.number),
                KycFieldBlock(
                    label: 'Họ và tên *',
                    controller: _fullName,
                    readOnly: _locked),
                KycDateFieldBlock(
                    label: 'Ngày sinh *',
                    controller: _dob,
                    readOnly: _locked,
                    onPick: () => _pickDate(_dob)),
                KycGenderDropdownBlock(
                    label: 'Giới tính *',
                    value: _gender,
                    onChanged: _locked
                        ? null
                        : (v) => setState(() => _gender = v ?? 'Nam')),
                KycFieldBlock(
                    label: 'Địa chỉ *',
                    controller: _address,
                    readOnly: _locked,
                    maxLines: 3),
                KycDateFieldBlock(
                    label: 'Ngày cấp *',
                    controller: _issueDate,
                    readOnly: _locked,
                    onPick: () => _pickDate(_issueDate)),
                if (_submitError != null && _submitError!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(_submitError!, style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 8),
                CheckboxListTile(
                  value: _legalAccepted,
                  onChanged: _submitting
                      ? null
                      : (v) => setState(() => _legalAccepted = v ?? false),
                  activeColor: AppColors.primary,
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Xác nhận sử dụng thông tin được xác thực làm thông tin pháp lý cho tài khoản.',
                    style: TextStyle(fontSize: 13, height: 1.35),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _submitting
                          ? null
                          : () => Navigator.of(context).popUntil((r) => r.isFirst),
                      style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary),
                      child: const Text('Hủy'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size(160, 44),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: (!_legalAccepted || _submitting) ? null : _submit,
                      child: _submitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Text('Lưu & xác nhận'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
    );
  }

  // ── Date helpers (CCCD QR gives ddMMyyyy / yyyy-MM-dd / dd/MM/yyyy) ──────────

  bool _isDdMmYyyy(String v) => RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(v);

  String _fmtDdMmYyyy(String raw) {
    if (raw.isEmpty) return '';
    if (_isDdMmYyyy(raw)) return raw;
    final isoM = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(raw);
    if (isoM != null) {
      return '${isoM.group(3)}/${isoM.group(2)}/${isoM.group(1)}';
    }
    final d = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (d.length == 8) {
      // CCCD QR uses ddMMyyyy.
      return '${d.substring(0, 2)}/${d.substring(2, 4)}/${d.substring(4, 8)}';
    }
    return raw;
  }

  String _toIso(String raw) {
    final t = raw.trim();
    final isoM = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(t);
    if (isoM != null) return t;
    final slashM = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$').firstMatch(t);
    if (slashM != null) {
      return '${slashM.group(3)}-${slashM.group(2)}-${slashM.group(1)}';
    }
    final d = t.replaceAll(RegExp(r'[^0-9]'), '');
    if (d.length == 8) {
      return '${d.substring(4, 8)}-${d.substring(2, 4)}-${d.substring(0, 2)}';
    }
    return t;
  }
}
