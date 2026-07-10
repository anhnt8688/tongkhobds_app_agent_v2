import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/custom_screen.dart';
import '../../customers/data/models/customer.dart';
import '../../locations/locations_screen.dart';
import '../../post/data/post_api.dart';
import '../data/demands_api.dart';
import 'widgets/customer_picker_sheet.dart';
import 'widgets/demand_create_widgets.dart';

/// "Tạo nhu cầu" — capture a customer's BĐS buy/rent demand. Layout mirrors the
/// web agent platform: customer search, BĐS criteria, up to 3 interest areas,
/// and extra preferences (directions, legal, notes).
class DemandCreateScreen extends ConsumerStatefulWidget {
  const DemandCreateScreen({super.key});

  @override
  ConsumerState<DemandCreateScreen> createState() => _DemandCreateScreenState();
}

class _DemandCreateScreenState extends ConsumerState<DemandCreateScreen> {
  static const _maxAreas = 3;
  static const _directions = [
    'Đông', 'Tây', 'Nam', 'Bắc', 'Đông Nam', 'Tây Nam', 'Đông Bắc', 'Tây Bắc'
  ];
  static const _legalOptions = ['Sổ hồng', 'Sổ đỏ', 'Giấy tờ đầy đủ'];

  Customer? _customer;

  int _transaction = 0; // 0 = Mua bds, 1 = Thuê bds
  int? _propertyTypeId;

  final _minPrice = TextEditingController();
  final _maxPrice = TextEditingController();
  final _minArea = TextEditingController();
  final _maxArea = TextEditingController();
  final _minBed = TextEditingController();
  final _maxBed = TextEditingController();

  final List<LocationSelection> _areas = [];
  bool _twoLevel = false;

  final Set<String> _dirSel = {};
  final Set<String> _legalSel = {};
  final _special = TextEditingController();
  final _note = TextEditingController();

  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    for (final c in [
      _minPrice, _maxPrice, _minArea, _maxArea, _minBed, _maxBed, _special, _note
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  /// Area label honouring the "2 cấp" toggle (drop district → Tỉnh, Xã only).
  String _areaLabel(LocationSelection s) {
    final parts = <String>[
      if (s.wardName != null && s.wardName!.trim().isNotEmpty) s.wardName!,
      if (!_twoLevel && s.districtName != null && s.districtName!.trim().isNotEmpty)
        s.districtName!,
      if (s.cityName.trim().isNotEmpty) s.cityName,
    ];
    return parts.join(', ');
  }

  Future<void> _pickCustomer() async {
    final picked = await showModalBottomSheet<Customer>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const CustomerPickerSheet(),
    );
    if (picked != null) setState(() => _customer = picked);
  }

  Future<void> _addArea() async {
    if (_areas.length >= _maxAreas) return;
    final sel = await showLocationPickerSheet(context);
    if (sel != null) setState(() => _areas.add(sel));
  }

  Future<void> _save() async {
    if (_customer == null) {
      setState(() => _error = 'Vui lòng chọn khách hàng');
      return;
    }
    if (_propertyTypeId == null) {
      setState(() => _error = 'Vui lòng chọn loại bất động sản');
      return;
    }
    if (_areas.isEmpty) {
      setState(() => _error = 'Vui lòng chọn ít nhất một khu vực quan tâm');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });

    final cities = <String>{};
    final districts = <String>{};
    final wards = <String>{};
    for (final a in _areas) {
      cities.add(a.cityId);
      if (!_twoLevel && a.districtId != null) districts.add(a.districtId!);
      if (a.wardId != null) wards.add(a.wardId!);
    }

    int? num(TextEditingController c) =>
        c.text.trim().isEmpty ? null : int.tryParse(c.text.trim());

    try {
      final payload = <String, dynamic>{
        'customer_info': {'customer_id': _customer!.id},
        'property_requirements': {
          'property_type': _propertyTypeId,
          'transaction_type': _transaction == 0 ? 1 : 2,
          if (num(_minPrice) != null) 'budget_min': num(_minPrice),
          if (num(_maxPrice) != null) 'budget_max': num(_maxPrice),
          if (num(_minArea) != null) 'area_min': num(_minArea),
          if (num(_maxArea) != null) 'area_max': num(_maxArea),
          if (num(_minBed) != null) 'bedrooms_min': num(_minBed),
          if (num(_maxBed) != null) 'bedrooms_max': num(_maxBed),
        },
        'location_preferences': {
          'interested_cities': cities.toList(),
          if (districts.isNotEmpty) 'interested_districts': districts.toList(),
          if (wards.isNotEmpty) 'interested_wards': wards.toList(),
        },
        'preferences': {
          if (_dirSel.isNotEmpty) 'preferred_directions': _dirSel.toList(),
          if (_legalSel.isNotEmpty) 'legal': _legalSel.toList(),
          if (_special.text.trim().isNotEmpty)
            'special_requirements': _special.text.trim(),
          if (_note.text.trim().isNotEmpty) 'note': _note.text.trim(),
        },
      };
      await ref.read(demandsApiProvider).create(payload);
      if (!mounted) return;
      AppToast.success(context, 'Tạo nhu cầu thành công');
      context.pop(true);
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } catch (_) {
      setState(() => _error = 'Không tạo được nhu cầu');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'Tạo nhu cầu',
      backgroundColor: AppColors.bg,
      bottomNavigationBar: _bottomBar(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Ghi nhận nhu cầu tìm BĐS của khách hàng',
              style: AppTypography.caption),
          const SizedBox(height: 16),
          _customerSection(),
          _criteriaSection(),
          _areaSection(),
          _preferenceSection(),
          if (_error != null) ...[
            Text(_error!, style: const TextStyle(color: AppColors.danger)),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  // --- Sections -------------------------------------------------------------

  Widget _customerSection() => DemandSectionCard(
        title: 'Khách hàng',
        children: [
          const FieldLabel('Tìm khách hàng', required: true),
          InkWell(
            onTap: _pickCustomer,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: Row(children: [
                const Icon(Icons.person_search_outlined,
                    size: 18, color: AppColors.textMute),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _customer == null
                        ? 'Tìm theo tên hoặc số điện thoại'
                        : '${_customer!.name} · ${_customer!.phone}',
                    style: AppTypography.body.copyWith(
                        color: _customer == null
                            ? AppColors.textMute
                            : AppColors.text),
                  ),
                ),
                const Icon(Icons.unfold_more, size: 18, color: AppColors.textMute),
              ]),
            ),
          ),
        ],
      );

  Widget _criteriaSection() {
    final typesAsync = ref.watch(propertyTypesProvider(_transaction == 0 ? 1 : 2));
    final types = typesAsync.valueOrNull ?? const <PropertyType>[];
    final value = types.any((t) => t.id == _propertyTypeId) ? _propertyTypeId : null;

    return DemandSectionCard(
      title: 'Tiêu chí BĐS',
      children: [
        const FieldLabel('Loại giao dịch'),
        DemandSegmented(
          options: const ['Mua bds', 'Thuê bds'],
          selectedIndex: _transaction,
          onChanged: (i) => setState(() {
            _transaction = i;
            _propertyTypeId = null; // types differ per transaction
          }),
        ),
        const SizedBox(height: 14),
        const FieldLabel('Loại bất động sản', required: true),
        DropdownButtonFormField<int>(
          initialValue: value,
          isExpanded: true,
          hint: Text('Chọn loại bất động sản...',
              style: AppTypography.body.copyWith(color: AppColors.textMute)),
          items: [
            for (final t in types)
              DropdownMenuItem(value: t.id, child: Text(t.name)),
          ],
          onChanged: (v) => setState(() => _propertyTypeId = v),
        ),
        const SizedBox(height: 14),
        _rangeRow('Ngân sách từ', 'Ngân sách đến', _minPrice, _maxPrice,
            'Từ (VNĐ)', 'Đến (VNĐ)'),
        const SizedBox(height: 14),
        _rangeRow('Diện tích từ (m²)', 'Diện tích đến (m²)', _minArea, _maxArea,
            'Từ', 'Đến',
            suffix: 'm²'),
        const SizedBox(height: 14),
        _rangeRow('Phòng ngủ từ', 'Phòng ngủ đến', _minBed, _maxBed, 'Từ', 'Đến',
            suffix: 'PN'),
      ],
    );
  }

  Widget _areaSection() => DemandSectionCard(
        title: 'Khu vực quan tâm',
        required: true,
        trailing: Text('(${_areas.length}/$_maxAreas)',
            style: AppTypography.caption.copyWith(color: AppColors.textMute)),
        children: [
          _twoLevelToggle(),
          const SizedBox(height: 12),
          if (_areas.isEmpty)
            Text('Chưa chọn khu vực nào',
                style: AppTypography.caption.copyWith(color: AppColors.textMute))
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var i = 0; i < _areas.length; i++)
                  _areaChip(_areaLabel(_areas[i]), () {
                    setState(() => _areas.removeAt(i));
                  }),
              ],
            ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _areas.length >= _maxAreas ? null : _addArea,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Chọn địa điểm'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          ),
        ],
      );

  Widget _preferenceSection() => DemandSectionCard(
        title: 'Ưu tiên khác',
        children: [
          const FieldLabel('Hướng nhà'),
          DemandSelectChips(
            options: _directions,
            selected: _dirSel,
            onToggle: (d) => setState(() =>
                _dirSel.contains(d) ? _dirSel.remove(d) : _dirSel.add(d)),
          ),
          const SizedBox(height: 14),
          const FieldLabel('Pháp lý'),
          DemandSelectChips(
            options: _legalOptions,
            selected: _legalSel,
            onToggle: (l) => setState(() =>
                _legalSel.contains(l) ? _legalSel.remove(l) : _legalSel.add(l)),
          ),
          const SizedBox(height: 14),
          const FieldLabel('Yêu cầu đặc biệt'),
          TextFormField(
            controller: _special,
            style: AppTypography.body,
            decoration: const InputDecoration(hintText: 'View, tầng, nội thất...'),
          ),
          const SizedBox(height: 14),
          const FieldLabel('Ghi chú'),
          TextFormField(
            controller: _note,
            style: AppTypography.body,
            maxLines: 4,
            maxLength: 500,
            decoration:
                const InputDecoration(hintText: 'Thông tin bổ sung cho agent...'),
          ),
        ],
      );

  // --- Small builders -------------------------------------------------------

  Widget _twoLevelToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text('Địa chỉ mới (2 cấp)',
                      style: AppTypography.subtitle
                          .copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(width: 4),
                  const Icon(Icons.info_outline,
                      size: 14, color: AppColors.textMute),
                ]),
                const SizedBox(height: 2),
                Text('Bỏ cấp Huyện, chỉ chọn Tỉnh → Xã',
                    style: AppTypography.micro
                        .copyWith(color: AppColors.textMute)),
              ],
            ),
          ),
          Switch(
            value: _twoLevel,
            activeThumbColor: AppColors.primary,
            onChanged: (v) => setState(() => _twoLevel = v),
          ),
        ],
      ),
    );
  }

  Widget _rangeRow(String l1, String l2, TextEditingController c1,
      TextEditingController c2, String h1, String h2,
      {String? suffix}) {
    Widget field(TextEditingController c, String hint) => TextFormField(
          controller: c,
          keyboardType: TextInputType.number,
          style: AppTypography.body,
          decoration: InputDecoration(
            hintText: hint,
            suffixText: suffix,
            suffixStyle:
                AppTypography.caption.copyWith(color: AppColors.textMute),
          ),
        );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [FieldLabel(l1), field(c1, h1)],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [FieldLabel(l2), field(c2, h2)],
          ),
        ),
      ],
    );
  }

  Widget _areaChip(String label, VoidCallback onRemove) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 6, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(label,
                style: AppTypography.caption.copyWith(
                    color: AppColors.primary, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 16, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _bottomBar() {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _saving ? null : () => context.pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                side: const BorderSide(color: AppColors.inputBorder),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
              ),
              child: const Text('Hủy'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: AppButton(
                label: 'Tạo nhu cầu', loading: _saving, onPressed: _save),
          ),
        ],
      ),
    );
  }
}
