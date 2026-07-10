import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/widgets/app_network_image.dart';
import '../../../core/widgets/app_toast.dart';
import '../data/models/verification_models.dart';
import '../data/verification_api.dart';
import 'widgets/verification_widgets.dart';

/// Edit / submit the verification info (mirrors v1 form page). Pops `true`
/// when the submission succeeds.
class VerificationFormScreen extends ConsumerStatefulWidget {
  const VerificationFormScreen({
    super.key,
    required this.item,
    required this.detail,
  });
  final VerificationItem item;
  final VerificationSalesmanDetailResponse? detail;

  @override
  ConsumerState<VerificationFormScreen> createState() =>
      _VerificationFormScreenState();
}

class _VerificationFormScreenState
    extends ConsumerState<VerificationFormScreen> {
  final _picker = ImagePicker();

  LegalDocType _type = LegalDocType.redBook;
  String _brokerageUnit = '%'; // '%' or 'VND'
  String _taxBearer = 'buyer';
  bool _showOwner2 = false;
  bool _submitting = false;

  // location (ids resolved when picked; names seeded from detail)
  String _cityName = '', _districtName = '', _wardName = '';
  String _cityId = '', _districtId = '', _wardId = '';
  String _citySlug = '';

  final _ownerName = TextEditingController(); // chủ nhà (owner_name)
  final _ownerPhone = TextEditingController(); // SĐT chủ nhà (owner_phone)
  final _googleMap = TextEditingController();
  final _address = TextEditingController();
  final _contractValue = TextEditingController();
  final _brokerValue = TextEditingController();
  final _certificate = TextEditingController();
  final _book = TextEditingController();
  final _issuedDate = TextEditingController();
  final _owner1Name = TextEditingController();
  final _owner1Id = TextEditingController();
  final _owner2Name = TextEditingController();
  final _owner2Id = TextEditingController();
  final _contractNumber = TextEditingController();
  final _contractSignDate = TextEditingController();
  final _buyerName = TextEditingController(); // HĐ mua bán: bên mua
  final _sellerName = TextEditingController(); // HĐ mua bán: bên bán
  final _company = TextEditingController();
  final _otherNotes = TextEditingController();

  // media
  final _verificationImages = <XFile>[];
  final _verificationVideos = <XFile>[];
  final _otherLegalFiles = <PlatformFile>[];
  // existing (already-uploaded) media seeded from the detail for display
  final _existingImages = <String>[];
  final _existingVideos = <String>[];
  XFile? _redFront, _redBack;
  int? _redFrontId, _redBackId;
  String? _redFrontUrl, _redBackUrl;

  // baseline for sync-request detection (v1: contract value / area changed)
  String _initialContractText = '';

  @override
  void initState() {
    super.initState();
    _seed();
  }

  void _seed() {
    final d = widget.detail;
    if (d == null) return;
    // legal type from existing data
    final legal = d.legalInfo;
    if ((legal.contractNumber ?? legal.contractSignedDate ?? legal.buyerCompany) != null) {
      _type = LegalDocType.contract;
    } else if ((legal.certificateNumber ?? legal.numberBook ?? legal.issuedDate) != null) {
      _type = LegalDocType.redBook;
    } else {
      _type = LegalDocType.other;
    }
    // Họ tên / SĐT chủ nhà: để trống cho người dùng tự nhập, không prefill.
    _cityName = d.city ?? '';
    _districtName = d.district ?? '';
    _wardName = d.ward ?? '';
    _googleMap.text = d.googleMapsUrl ?? '';
    _address.text = d.address ?? d.realEstate.streetAddress;
    _contractValue.text = _digits(d.realEstateValue ?? d.realEstate.priceDisplay);
    _initialContractText = _contractValue.text;
    _brokerageUnit = (d.brokerageFeeUnit == 'money') ? 'VND' : '%';
    _brokerValue.text = _digits(d.brokerageFeeValue ?? '');
    _taxBearer = d.taxBearer ?? 'buyer';
    _certificate.text = legal.certificateNumber ?? '';
    _book.text = legal.numberBook ?? '';
    _issuedDate.text = _uiDate(legal.issuedDate);
    _owner1Name.text = legal.ownerNameFirst ?? d.ownerNameFirst ?? d.ownerName ?? '';
    _owner1Id.text = legal.idCardFirst ?? d.idCardFirst ?? '';
    _owner2Name.text = legal.ownerNameSecond ?? d.ownerNameSecond ?? '';
    _owner2Id.text = legal.idCardSecond ?? d.idCardSecond ?? '';
    _showOwner2 = _owner2Name.text.isNotEmpty || _owner2Id.text.isNotEmpty;
    _contractNumber.text = legal.contractNumber ?? '';
    _contractSignDate.text = _uiDate(legal.contractSignedDate);
    // HĐ mua bán parties (kept distinct from the red-book owner controllers).
    _buyerName.text = legal.ownerNameFirst ?? d.ownerNameFirst ?? d.ownerName ?? '';
    _sellerName.text = legal.sellerName ?? legal.ownerNameSecond ?? '';
    _company.text = legal.buyerCompany ?? '';
    _otherNotes.text = d.verificationNotes ?? '';
    if (legal.redBookPhotos.isNotEmpty) {
      _redFrontId = legal.redBookPhotos[0].id;
      _redFrontUrl = legal.redBookPhotos[0].url;
      if (legal.redBookPhotos.length > 1) {
        _redBackId = legal.redBookPhotos[1].id;
        _redBackUrl = legal.redBookPhotos[1].url;
      }
    }
    // Show already-uploaded verification media (matches the detail tab).
    _existingImages.addAll(d.realEstate.images.where((e) => e.trim().isNotEmpty));
    _existingVideos.addAll(d.realEstate.videos.where((e) => e.trim().isNotEmpty));
  }

  String _digits(String v) => v.replaceAll(RegExp(r'[^0-9]'), '');

  /// Normalize an API date (`yyyy-MM-dd`) to the UI's `dd/MM/yyyy`. Leaves any
  /// other format untouched (already `dd/MM/yyyy`, empty, etc.).
  String _uiDate(String? raw) {
    final v = raw?.trim() ?? '';
    final m = RegExp(r'^(\d{4})-(\d{2})-(\d{2})').firstMatch(v);
    if (m == null) return v;
    return '${m.group(3)}/${m.group(2)}/${m.group(1)}';
  }

  @override
  void dispose() {
    for (final c in [
      _ownerName, _ownerPhone,
      _googleMap, _address, _contractValue, _brokerValue, _certificate, _book,
      _issuedDate, _owner1Name, _owner1Id, _owner2Name, _owner2Id,
      _contractNumber, _contractSignDate, _buyerName, _sellerName,
      _company, _otherNotes,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  // ── media pickers ──

  Future<void> _pickVerificationImages() async {
    final files = await _picker.pickMultiImage();
    if (files.isNotEmpty) setState(() => _verificationImages.addAll(files));
  }

  /// Choice sheet: image or video (mirrors v1 _pickVerificationMedia).
  Future<void> _pickVerificationMedia() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            const VSheetHandle(),
            ListTile(
              leading: const Icon(Icons.image_outlined, color: VColors.orange),
              title: Text('Chọn ảnh', style: vText(15, FontWeight.w500, VColors.n800)),
              onTap: () => Navigator.pop(context, 'image'),
            ),
            ListTile(
              leading: const Icon(Icons.videocam_outlined, color: VColors.orange),
              title: Text('Chọn video', style: vText(15, FontWeight.w500, VColors.n800)),
              onTap: () => Navigator.pop(context, 'video'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (choice == 'image') {
      await _pickVerificationImages();
    } else if (choice == 'video') {
      await _pickVerificationVideo();
    }
  }

  Future<void> _pickVerificationVideo() async {
    final file = await _picker.pickVideo(source: ImageSource.gallery);
    if (file == null) return;
    final size = await File(file.path).length();
    if (size > 100 * 1024 * 1024) {
      if (mounted) {
        AppToast.error(context, 'Video vượt quá 100MB, vui lòng chọn file nhỏ hơn');
      }
      return;
    }
    setState(() => _verificationVideos.add(file));
  }

  /// File picker for the "Khác" legal tab (PDF / DOC / images).
  Future<void> _pickOtherLegalFiles() async {
    final result =
        await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.any);
    if (result == null || result.files.isEmpty) return;
    setState(() {
      _otherLegalFiles
          .addAll(result.files.where((e) => e.path != null && e.path!.isNotEmpty));
    });
  }

  Future<void> _pickRedBook({required bool front}) async {
    final f = await _picker.pickImage(source: ImageSource.gallery);
    if (f == null) return;
    setState(() {
      if (front) {
        _redFront = f;
      } else {
        _redBack = f;
      }
    });
  }

  Future<void> _pickDate(TextEditingController c) async {
    final now = DateTime.now();
    DateTime? init;
    final parts = c.text.split('/');
    if (parts.length == 3) {
      init = DateTime.tryParse(
          '${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}');
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: init ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      String two(int v) => v.toString().padLeft(2, '0');
      c.text = '${two(picked.day)}/${two(picked.month)}/${picked.year}';
      setState(() {});
    }
  }

  String? _toApiDate(String ui) {
    final parts = ui.split('/');
    if (parts.length != 3) return null;
    return '${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}';
  }

  // ── upload + submit ──

  Future<int?> _upload(File file) async {
    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path,
          filename: file.path.split('/').last),
      'action_type': 'real_estate_verify',
      'real_estate_id': widget.detail?.realEstate.id ?? widget.item.id,
    });
    return ref.read(verificationApiProvider).uploadFile(form);
  }

  Future<void> _submit() async {
    final contractValue = int.tryParse(_digits(_contractValue.text)) ?? 0;
    if (contractValue <= 0) {
      AppToast.warning(context, 'Vui lòng nhập giá trị hợp đồng');
      return;
    }
    if (_type == LegalDocType.redBook) {
      if (_certificate.text.trim().isEmpty) {
        AppToast.warning(context, 'Vui lòng nhập GCN số');
        return;
      }
      if (_owner1Name.text.trim().isEmpty || _owner1Id.text.trim().isEmpty) {
        AppToast.warning(context, 'Vui lòng nhập thông tin chủ nhà 1');
        return;
      }
    } else if (_type == LegalDocType.contract) {
      if (_contractNumber.text.trim().isEmpty || _contractSignDate.text.trim().isEmpty) {
        AppToast.warning(context, 'Vui lòng nhập thông tin hợp đồng');
        return;
      }
    }

    // Sync-request prompt when the contract value changed (v1 parity).
    var syncRequested = false;
    if (_contractValue.text.trim() != _initialContractText.trim()) {
      syncRequested = await _showSyncRequestDialog();
      if (!mounted) return;
    }

    setState(() => _submitting = true);
    try {
      final imageIds = <int>[];
      for (final x in _verificationImages) {
        final id = await _upload(File(x.path));
        if (id != null) imageIds.add(id);
      }
      for (final v in _verificationVideos) {
        final id = await _upload(File(v.path));
        if (id != null) imageIds.add(id);
      }
      for (final f in _otherLegalFiles) {
        if (f.path == null) continue;
        final id = await _upload(File(f.path!));
        if (id != null) imageIds.add(id);
      }
      int? redFront = _redFrontId;
      int? redBack = _redBackId;
      if (_redFront != null) redFront = await _upload(File(_redFront!.path));
      if (_redBack != null) redBack = await _upload(File(_redBack!.path));

      final d = widget.detail;
      final body = <String, dynamic>{
        'id': d?.id ?? widget.item.id,
        'real_estate_id': d?.realEstate.id ?? widget.item.id,
        if (d?.saleOffMemberId != null) 'sale_off_member_id': d!.saleOffMemberId,
        'contract_type': _type.apiValue,
        if (_cityId.isNotEmpty) 'city_id': _cityId,
        if (_districtId.isNotEmpty) 'district_id': _districtId,
        if (_wardId.isNotEmpty) 'ward_id': _wardId,
        'google_maps_url':
            _googleMap.text.trim().isEmpty ? null : _googleMap.text.trim(),
        'address': _address.text.trim(),
        'owner_name': _ownerName.text.trim(),
        'owner_phone': _ownerPhone.text.trim(),
        'owner_name_first': _type == LegalDocType.contract
            ? _buyerName.text.trim()
            : _owner1Name.text.trim(),
        'owner1_id_card': _owner1Id.text.trim(),
        'owner_name_second': _showOwner2 ? _owner2Name.text.trim() : null,
        'owner2_id_card': _showOwner2 ? _owner2Id.text.trim() : null,
        'id_card_first': _owner1Id.text.trim(),
        'id_card_second': _owner2Id.text.trim(),
        'real_estate_value': contractValue,
        'brokerage_fee_value': double.tryParse(_digits(_brokerValue.text)) ?? 0,
        'brokerage_fee_unit': _brokerageUnit == 'VND' ? 'money' : 'percent',
        'tax_bearer': _taxBearer,
        'tax_rate_percent': 0.0,
        'certificate_number': _certificate.text.trim(),
        'number_book': _book.text.trim(),
        'issued_date': _toApiDate(_issuedDate.text.trim()),
        'red_book_photos': [if (redFront != null) redFront, if (redBack != null) redBack],
        'deposit_percent': d?.depositPercent ?? 100,
        'completion_payout_percent': d?.completionPayoutPercent ?? 0,
        'verification_notes': _otherNotes.text.trim(),
        'contract_media_ids': <int>[],
        'contract_number': _contractNumber.text.trim(),
        'seller_name': _type == LegalDocType.contract
            ? _sellerName.text.trim()
            : _owner1Id.text.trim(),
        'buyer_company': _company.text.trim(),
        'contract_signed_date': _toApiDate(_contractSignDate.text.trim()),
        'verification_media_ids': imageIds,
        'cover_media_ids': <int>[],
      };

      final res = await ref.read(verificationApiProvider).verifyRealEstate(body);
      if (!mounted) return;
      if (res.success) {
        AppToast.success(
            context,
            syncRequested
                ? 'Yêu cầu đồng bộ thông tin thành công'
                : 'Xác thực thông tin thành công');
        context.pop(true);
      } else {
        AppToast.error(context,
            res.message.isNotEmpty ? res.message : 'Không thể xác thực');
        setState(() => _submitting = false);
      }
    } catch (_) {
      if (mounted) {
        AppToast.error(context, 'Không thể xác thực, vui lòng thử lại');
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return VerificationScaffold(
      title: 'Bổ sung thông tin xác thực',
      titleWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Bổ sung thông tin xác thực',
              style: vText(16, FontWeight.w600, VColors.n800)),
          Text('BĐS: ${widget.item.title}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: vText(11, FontWeight.w400, VColors.n500)),
        ],
      ),
      bottomBar: _bottomBar(),
      child: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _Banner(
                'Mọi thông tin bạn nhập trong xác thực không xuất hiện trên bài đăng công khai'),
            const SizedBox(height: 12),
            // owner contact (chủ nhà)
            VerificationInfoCard(
              title: 'Thông tin chủ nhà',
              icon: Icons.person_outline,
              child: Column(
                children: [
                  _field('Họ và tên chủ nhà', _ownerName),
                  const SizedBox(height: 10),
                  _field('Số điện thoại chủ nhà', _ownerPhone,
                      keyboardType: TextInputType.phone),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // verification media
            VerificationInfoCard(
              title: 'Hình ảnh & video xác thực',
              icon: Icons.photo_library_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tải lên tối đa 3 ảnh - 1 video (≤ 100MB)',
                      style: vText(12, FontWeight.w400, VColors.n500)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final url in _existingImages)
                        _existingThumb(url, isVideo: false),
                      for (final url in _existingVideos)
                        _existingThumb(url, isVideo: true),
                      for (final x in _verificationImages)
                        _thumb(File(x.path),
                            onRemove: () =>
                                setState(() => _verificationImages.remove(x))),
                      for (final v in _verificationVideos)
                        _videoThumb(v.path,
                            onRemove: () =>
                                setState(() => _verificationVideos.remove(v))),
                      _addThumb(_pickVerificationMedia),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // location
            VerificationInfoCard(
              title: 'Địa điểm',
              icon: Icons.place_outlined,
              child: Column(
                children: [
                  _field('Link Google Map', _googleMap, hint: 'https://...'),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: _readonlyField('Tỉnh', _cityName,
                              onTap: _pickCity)),
                      const SizedBox(width: 8),
                      Expanded(
                          child: _readonlyField('Quận/Huyện', _districtName,
                              onTap: _pickDistrict)),
                      const SizedBox(width: 8),
                      Expanded(
                          child: _readonlyField('Phường/Xã', _wardName,
                              onTap: _pickWard)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _field('Địa chỉ cụ thể', _address, maxLines: 2),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // transaction
            VerificationInfoCard(
              title: 'Thông tin giao dịch',
              icon: Icons.payments_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _field('Giá trị hợp đồng *', _contractValue,
                      digitsOnly: true, suffix: 'VND'),
                  const SizedBox(height: 10),
                  Text('Phí môi giới',
                      style: vText(13, FontWeight.w600, VColors.n700)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(child: _unitToggle('%')),
                      const SizedBox(width: 8),
                      Expanded(child: _unitToggle('VND')),
                      const SizedBox(width: 8),
                      Expanded(
                          flex: 2,
                          child: _field('', _brokerValue, digitsOnly: true)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // legal
            VerificationInfoCard(
              title: 'Người trên bìa đỏ',
              icon: Icons.badge_outlined,
              trailing: const VSmallOrangeBadge(text: '2 chủ'),
              child: Column(
                children: [
                  Row(
                    children: [
                      _typeTab(LegalDocType.redBook, 'Bìa đỏ', Icons.shield_outlined),
                      const SizedBox(width: 8),
                      _typeTab(LegalDocType.contract, 'HĐ mua bán', Icons.description_outlined),
                      const SizedBox(width: 8),
                      _typeTab(LegalDocType.other, 'Khác', Icons.folder_outlined),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_type == LegalDocType.redBook) ..._redBookFields(),
                  if (_type == LegalDocType.contract) ..._contractFields(),
                  if (_type == LegalDocType.other) ..._otherFields(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── legal field groups ──

  List<Widget> _redBookFields() => [
        _fieldLabel('Ảnh bìa đỏ *', ' (mặt trước & mặt sau)'),
        const SizedBox(height: 8),
        Row(
          children: [
            _redPhoto('Mặt trước', _redFront, _redFrontUrl,
                () => _pickRedBook(front: true)),
            const SizedBox(width: 10),
            _redPhoto('Mặt sau', _redBack, _redBackUrl,
                () => _pickRedBook(front: false)),
          ],
        ),
        const SizedBox(height: 12),
        _sectionHeader('Thông tin bìa đỏ'),
        const SizedBox(height: 10),
        _field('GCN số *', _certificate),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _field('Quyển số', _book)),
            const SizedBox(width: 10),
            Expanded(
                child: _readonlyField('Cấp ngày', _issuedDate.text,
                    onTap: () => _pickDate(_issuedDate),
                    icon: Icons.calendar_today_outlined)),
          ],
        ),
        const SizedBox(height: 12),
        _sectionHeader('Người đứng tên bìa đỏ'),
        const SizedBox(height: 10),
        _ownerBox('Chủ nhà 1', _owner1Name, _owner1Id),
        const SizedBox(height: 10),
        if (_showOwner2)
          _ownerBox('Chủ nhà 2', _owner2Name, _owner2Id, onRemove: () {
            setState(() {
              _showOwner2 = false;
              _owner2Name.clear();
              _owner2Id.clear();
            });
          })
        else
          OutlinedButton.icon(
            onPressed: () => setState(() => _showOwner2 = true),
            icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
            label: const Text('Thêm chủ nhà 2'),
            style: OutlinedButton.styleFrom(
              foregroundColor: VColors.orange,
              side: const BorderSide(color: VColors.orange),
              minimumSize: const Size.fromHeight(44),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
      ];

  List<Widget> _contractFields() => [
        _sectionHeader('Hợp đồng mua bán'),
        const SizedBox(height: 10),
        _field('Số hợp đồng *', _contractNumber),
        const SizedBox(height: 10),
        _readonlyField('Ngày ký *', _contractSignDate.text,
            onTap: () => _pickDate(_contractSignDate),
            icon: Icons.calendar_today_outlined),
        const SizedBox(height: 10),
        _field('Giấy chứng nhận số *', _certificate),
        const SizedBox(height: 10),
        _field('Bên mua *', _buyerName),
        const SizedBox(height: 10),
        _field('Bên bán *', _sellerName),
        const SizedBox(height: 10),
        _field('Tên công ty', _company, maxLines: 2),
      ];

  List<Widget> _otherFields() => [
        Text('Tải lên PDF, DOC, ảnh giấy tờ pháp lý khác',
            style: vText(12, FontWeight.w400, VColors.n500)),
        const SizedBox(height: 8),
        for (final f in _otherLegalFiles)
          _fileRow(f, onRemove: () => setState(() => _otherLegalFiles.remove(f))),
        OutlinedButton.icon(
          onPressed: _pickOtherLegalFiles,
          icon: const Icon(Icons.upload_file_outlined, size: 18),
          label: const Text('Tải lên tệp'),
          style: OutlinedButton.styleFrom(
            foregroundColor: VColors.orange,
            side: const BorderSide(color: VColors.orange),
            minimumSize: const Size.fromHeight(44),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 10),
        _field('Thông tin khác', _otherNotes, maxLines: 3),
      ];

  // ── small builders ──

  Widget _field(String label, TextEditingController c,
      {bool digitsOnly = false,
      String? suffix,
      String? hint,
      TextInputType? keyboardType,
      int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(label, style: vText(13, FontWeight.w600, VColors.n700)),
          const SizedBox(height: 6),
        ],
        TextField(
          controller: c,
          maxLines: maxLines,
          keyboardType: keyboardType ??
              (digitsOnly ? TextInputType.number : TextInputType.text),
          inputFormatters:
              digitsOnly ? [FilteringTextInputFormatter.digitsOnly] : null,
          style: vText(14, FontWeight.w500, VColors.n800),
          decoration: InputDecoration(
            hintText: hint,
            suffixText: suffix,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: VColors.line)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: VColors.line)),
          ),
        ),
      ],
    );
  }

  Widget _readonlyField(String label, String value,
      {required VoidCallback onTap, IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: vText(13, FontWeight.w600, VColors.n700)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: VColors.line),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(value.isEmpty ? 'Chọn' : value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: vText(14, FontWeight.w500,
                          value.isEmpty ? VColors.n400 : VColors.n800)),
                ),
                Icon(icon ?? Icons.keyboard_arrow_down_rounded,
                    size: 18, color: VColors.n400),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _unitToggle(String unit) {
    final active = _brokerageUnit == unit;
    return GestureDetector(
      onTap: () => setState(() => _brokerageUnit = unit),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? VColors.orange : VColors.n50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: active ? VColors.orange : VColors.line),
        ),
        child: Text(unit,
            style: vText(13, FontWeight.w600, active ? Colors.white : VColors.n500)),
      ),
    );
  }

  Widget _typeTab(LegalDocType t, String label, IconData icon) {
    final active = _type == t;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _type = t),
        child: Column(
          children: [
            Icon(icon, size: 20, color: active ? VColors.orange : VColors.n400),
            const SizedBox(height: 4),
            Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: vText(12, FontWeight.w600,
                    active ? VColors.orange : VColors.n400)),
            const SizedBox(height: 4),
            Container(
              height: 3,
              decoration: BoxDecoration(
                color: active ? VColors.orange : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ownerBox(String title, TextEditingController name,
      TextEditingController id, {VoidCallback? onRemove}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: VColors.n50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: VColors.n100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(title,
                      style: vText(15, FontWeight.w600, VColors.n800))),
              if (onRemove != null)
                GestureDetector(
                  onTap: onRemove,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.delete_outline_rounded,
                          size: 18, color: VColors.red),
                      const SizedBox(width: 2),
                      Text('Xóa',
                          style: vText(13, FontWeight.w600, VColors.red)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          _field('Họ tên *', name),
          const SizedBox(height: 10),
          _field('CCCD/CMND *', id, digitsOnly: true),
        ],
      ),
    );
  }

  /// Bold field label with an optional lighter suffix (e.g. "Ảnh bìa đỏ *").
  Widget _fieldLabel(String text, [String suffix = '']) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(text: text, style: vText(13, FontWeight.w600, VColors.n700)),
        if (suffix.isNotEmpty)
          TextSpan(text: suffix, style: vText(13, FontWeight.w400, VColors.n400)),
      ]),
    );
  }

  /// Orange accent-bar section header (matches v1 sub-section style).
  Widget _sectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: VColors.orange,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(width: 8),
        Text(title, style: vText(14, FontWeight.w600, VColors.n800)),
      ],
    );
  }

  /// Read-only thumbnail for an already-uploaded image/video (network URL).
  Widget _existingThumb(String url, {required bool isVideo}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 74,
        height: 74,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AppNetworkImage(url: verificationImageUrl(url)),
            if (isVideo)
              Container(
                color: Colors.black26,
                child: const Center(
                  child: Icon(Icons.play_circle_fill_rounded,
                      color: Colors.white, size: 28),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _thumb(File file, {required VoidCallback onRemove}) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(file, width: 74, height: 74, fit: BoxFit.cover),
        ),
        Positioned(
          right: 2,
          top: 2,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.black54, shape: BoxShape.circle),
              child: const Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _videoThumb(String path, {required VoidCallback onRemove}) {
    return Stack(
      children: [
        Container(
          width: 74,
          height: 74,
          decoration: BoxDecoration(
            color: VColors.n800,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Icon(Icons.play_circle_fill_rounded,
                color: Colors.white, size: 28),
          ),
        ),
        Positioned(
          right: 2,
          top: 2,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.black54, shape: BoxShape.circle),
              child: const Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _fileRow(PlatformFile f, {required VoidCallback onRemove}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: VColors.n50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: VColors.line),
      ),
      child: Row(
        children: [
          const Icon(Icons.insert_drive_file_outlined,
              size: 18, color: VColors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: Text(f.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: vText(13, FontWeight.w500, VColors.n800)),
          ),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close_rounded, size: 16, color: VColors.n400),
          ),
        ],
      ),
    );
  }

  Widget _addThumb(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 74,
        height: 74,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: VColors.orange),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, size: 22, color: VColors.orange),
            Text('Thêm', style: vText(11, FontWeight.w600, VColors.orange)),
          ],
        ),
      ),
    );
  }

  Widget _redPhoto(String label, XFile? local, String? url, VoidCallback onTap) {
    Widget content;
    if (local != null) {
      content = Image.file(File(local.path), fit: BoxFit.cover);
    } else if (url != null && url.isNotEmpty) {
      content = AppNetworkImage(url: verificationImageUrl(url));
    } else {
      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add_a_photo_outlined, color: VColors.orange),
          const SizedBox(height: 4),
          Text(label, style: vText(11, FontWeight.w600, VColors.orange)),
        ],
      );
    }
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 96,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: VColors.orangeBorder),
          ),
          child: Center(child: content),
        ),
      ),
    );
  }

  Widget _bottomBar() {
    return SafeArea(
      top: false,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _submitting ? null : () => context.pop(),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  side: const BorderSide(color: VColors.n300),
                  foregroundColor: VColors.n700,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Hủy'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: _submitting ? null : _submit,
                icon: _submitting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white)))
                    : const Icon(Icons.send_rounded, size: 18),
                label: Text(_submitting ? 'Đang gửi...' : 'Gửi xác thực'),
                style: FilledButton.styleFrom(
                  backgroundColor: VColors.orange,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Asks whether to record a sync request to the public article when the
  /// contract value changed. Returns true if the user confirms (v1 parity:
  /// only changes the success toast, the flag is not sent in the payload).
  Future<bool> _showSyncRequestDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Đồng bộ thông tin',
            style: vText(18, FontWeight.w700, VColors.n800)),
        content: Text(
          'Giá trị đã thay đổi. Bạn có muốn ghi nhận yêu cầu đồng bộ sang bài viết công khai không?',
          style: vText(14, FontWeight.w400, VColors.n600, height: 1.45),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(46),
                    side: const BorderSide(color: VColors.n300),
                    foregroundColor: VColors.n700,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Đóng'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  style: FilledButton.styleFrom(
                    backgroundColor: VColors.orange,
                    minimumSize: const Size.fromHeight(46),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Xác nhận'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // ── location picker (city → district → ward) ──

  /// City list uses `{city, city_id, slug}` keys; district/ward lists use
  /// `{name, id}` (the backend's two location endpoints differ).
  Future<void> _pickCity() async {
    final cities = await ref.read(verificationApiProvider).fetchCities(limit: 63);
    if (!mounted) return;
    final city = await _pickFromList('Chọn Tỉnh/Thành', cities, nameKey: 'city');
    if (city == null) return;
    setState(() {
      _cityName = (city['city'] ?? '').toString();
      _cityId = (city['city_id'] ?? '').toString();
      _citySlug = (city['slug'] ?? '').toString();
      _districtName = '';
      _districtId = '';
      _wardName = '';
      _wardId = '';
    });
  }

  Future<void> _pickDistrict() async {
    if (_cityId.isEmpty) {
      AppToast.warning(context, 'Vui lòng chọn Tỉnh/Thành trước');
      return;
    }
    final districts = await ref.read(verificationApiProvider).fetchLocations(
        id: _cityId, layer: 1, grant: 1, nSlug: _citySlug);
    if (!mounted) return;
    final district = await _pickFromList('Chọn Quận/Huyện', districts);
    if (district == null) return;
    setState(() {
      _districtName = (district['name'] ?? '').toString();
      _districtId = (district['id'] ?? '').toString();
      _wardName = '';
      _wardId = '';
    });
  }

  Future<void> _pickWard() async {
    if (_districtId.isEmpty) {
      AppToast.warning(context, 'Vui lòng chọn Quận/Huyện trước');
      return;
    }
    final wards = await ref
        .read(verificationApiProvider)
        .fetchLocations(id: _districtId, layer: 2, grant: 1);
    if (!mounted) return;
    final ward = await _pickFromList('Chọn Phường/Xã', wards);
    if (ward == null) return;
    setState(() {
      _wardName = (ward['name'] ?? '').toString();
      _wardId = (ward['id'] ?? '').toString();
    });
  }

  Future<Map?> _pickFromList(String title, List<Map> items,
      {String nameKey = 'name'}) {
    return showModalBottomSheet<Map>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (_, scroll) => Column(
          children: [
            const SizedBox(height: 10),
            const Center(child: VSheetHandle()),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(title, style: vText(18, FontWeight.w700, VColors.n800)),
            ),
            Expanded(
              child: ListView.builder(
                controller: scroll,
                itemCount: items.length,
                itemBuilder: (_, i) => ListTile(
                  title: Text(
                      (items[i][nameKey] ?? items[i]['name'] ?? '').toString(),
                      style: vText(14, FontWeight.w500, VColors.n800)),
                  onTap: () => Navigator.pop(context, items[i]),
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
  const _Banner(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: VColors.orangePale,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: VColors.orangeBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, size: 18, color: VColors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: vText(12, FontWeight.w400, const Color(0xFF9A3412))),
          ),
        ],
      ),
    );
  }
}
