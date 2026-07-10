import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/custom_screen.dart';
import '../../customers/data/customers_api.dart';
import '../../customers/data/models/customer.dart';
import '../../locations/locations_screen.dart';
import '../data/consultation_sell_api.dart';
import '../data/models/sell_lead.dart';

class SellLeadFormScreen extends ConsumerStatefulWidget {
  const SellLeadFormScreen({super.key});
  @override
  ConsumerState<SellLeadFormScreen> createState() => _SellLeadFormScreenState();
}

class _SellLeadFormScreenState extends ConsumerState<SellLeadFormScreen> {
  Customer? _customer;
  SellPropertyType? _propertyType;
  final _area = TextEditingController();
  final _price = TextEditingController();
  LocationSelection? _location;
  final _address = TextEditingController();
  final _bedrooms = TextEditingController();
  final _bathrooms = TextEditingController();
  final _floors = TextEditingController();
  String? _direction;
  String? _legal;
  final _note = TextEditingController();
  String _source = 'Tongkho';

  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    for (final c in [_area, _price, _address, _bedrooms, _bathrooms, _floors, _note]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (_customer == null) {
      setState(() => _error = 'Vui lòng chọn chủ nhà');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final payload = <String, dynamic>{
        'customer_id': _customer!.id,
        'transaction_type_id': 1,
        if (_propertyType != null) 'property_type_id': _propertyType!.id,
        if (_area.text.trim().isNotEmpty) 'area': num.tryParse(_area.text.trim()),
        if (_price.text.trim().isNotEmpty) 'price': num.tryParse(_price.text.trim()),
        if (_location != null) 'city_id': _location!.cityId,
        if (_location?.districtId != null) 'district_id': _location!.districtId,
        if (_location?.wardId != null) 'ward_id': _location!.wardId,
        if (_address.text.trim().isNotEmpty) 'address': _address.text.trim(),
        if (_bedrooms.text.trim().isNotEmpty)
          'bedrooms': int.tryParse(_bedrooms.text.trim()),
        if (_bathrooms.text.trim().isNotEmpty)
          'bathrooms': int.tryParse(_bathrooms.text.trim()),
        if (_floors.text.trim().isNotEmpty)
          'floors': int.tryParse(_floors.text.trim()),
        if (_direction != null) 'house_direction': _direction,
        if (_legal != null) 'legal_document': _legal,
        if (_note.text.trim().isNotEmpty) 'note': _note.text.trim(),
        'source': _source,
      };
      await ref.read(consultationSellApiProvider).create(payload);
      if (!mounted) return;
      AppToast.success(context, 'Tạo nhu cầu bán thành công');
      context.pop(true);
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } catch (_) {
      setState(() => _error = 'Không tạo được nhu cầu bán');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final types = ref.watch(sellPropertyTypesProvider).valueOrNull ?? const [];
    return CustomScreen(
      title: 'Tạo nhu cầu bán',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section('Chủ nhà'),
          _pickerTile(
            icon: Icons.person_outline,
            label: _customer == null
                ? 'Chọn chủ nhà *'
                : '${_customer!.name} · ${_customer!.phone}',
            empty: _customer == null,
            onTap: () async {
              final c = await showModalBottomSheet<Customer>(
                context: context,
                isScrollControlled: true,
                backgroundColor: AppColors.surface,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => const _CustomerPickerSheet(),
              );
              if (c != null) setState(() => _customer = c);
            },
          ),
          const SizedBox(height: 20),
          _section('Thông tin BĐS'),
          DropdownButtonFormField<SellPropertyType>(
            initialValue: _propertyType,
            isExpanded: true,
            decoration: _dec('Loại BĐS'),
            items: [
              for (final t in types)
                DropdownMenuItem(value: t, child: Text(t.name)),
            ],
            onChanged: (v) => setState(() => _propertyType = v),
          ),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
                child: AppTextField(
                    label: 'Diện tích (m²)',
                    controller: _area,
                    keyboardType: TextInputType.number)),
            const SizedBox(width: 12),
            Expanded(
                child: AppTextField(
                    label: 'Giá bán (VNĐ)',
                    controller: _price,
                    keyboardType: TextInputType.number)),
          ]),
          const SizedBox(height: 20),
          _section('Vị trí'),
          _pickerTile(
            icon: Icons.location_on_outlined,
            label: _location?.label ?? 'Chọn khu vực',
            empty: _location == null,
            onTap: () async {
              final sel = await showLocationPickerSheet(context);
              if (sel != null) setState(() => _location = sel);
            },
          ),
          const SizedBox(height: 12),
          AppTextField(label: 'Địa chỉ chi tiết', controller: _address),
          const SizedBox(height: 20),
          _section('Chi tiết'),
          Row(children: [
            Expanded(
                child: AppTextField(
                    label: 'Phòng ngủ',
                    controller: _bedrooms,
                    keyboardType: TextInputType.number)),
            const SizedBox(width: 12),
            Expanded(
                child: AppTextField(
                    label: 'Phòng tắm',
                    controller: _bathrooms,
                    keyboardType: TextInputType.number)),
            const SizedBox(width: 12),
            Expanded(
                child: AppTextField(
                    label: 'Số tầng',
                    controller: _floors,
                    keyboardType: TextInputType.number)),
          ]),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _direction,
            isExpanded: true,
            decoration: _dec('Hướng nhà'),
            items: [
              for (final d in kHouseDirections)
                DropdownMenuItem(value: d, child: Text(d)),
            ],
            onChanged: (v) => setState(() => _direction = v),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _legal,
            isExpanded: true,
            decoration: _dec('Pháp lý'),
            items: [
              for (final d in kLegalDocuments)
                DropdownMenuItem(value: d, child: Text(d)),
            ],
            onChanged: (v) => setState(() => _legal = v),
          ),
          const SizedBox(height: 20),
          _section('Khác'),
          DropdownButtonFormField<String>(
            initialValue: _source,
            isExpanded: true,
            decoration: _dec('Nguồn'),
            items: [
              for (final s in kSellSources)
                DropdownMenuItem(value: s, child: Text(s)),
            ],
            onChanged: (v) => setState(() => _source = v ?? 'Tongkho'),
          ),
          const SizedBox(height: 12),
          AppTextField(label: 'Ghi chú', controller: _note),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: AppColors.danger)),
          ],
          const SizedBox(height: 20),
          AppButton(
              label: 'Lưu nhu cầu bán', loading: _saving, onPressed: _save),
        ],
      ),
    );
  }

  InputDecoration _dec(String label) => InputDecoration(
        labelText: label,
        isDense: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
      );

  Widget _section(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(t, style: AppTypography.title),
      );

  Widget _pickerTile({
    required IconData icon,
    required String label,
    required bool empty,
    required VoidCallback onTap,
  }) =>
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.inputBorder),
          ),
          child: Row(children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.body.copyWith(
                      color: empty ? AppColors.textMute : AppColors.text)),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMute),
          ]),
        ),
      );
}

class _CustomerPickerSheet extends ConsumerWidget {
  const _CustomerPickerSheet();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(customersProvider);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(children: [
        const SizedBox(height: 12),
        Text('Chọn chủ nhà', style: AppTypography.heading),
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            onChanged: (v) =>
                ref.read(customerSearchProvider.notifier).state = v,
            decoration: InputDecoration(
              hintText: 'Tìm khách hàng...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
            ),
          ),
        ),
        Expanded(
          child: list.when(
            loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary)),
            error: (_, __) =>
                const Center(child: Text('Không tải được khách hàng')),
            data: (customers) => customers.isEmpty
                ? const Center(child: Text('Không có khách hàng'))
                : ListView.separated(
                    itemCount: customers.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final c = customers[i];
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: AppColors.primarySoft,
                          child: Icon(Icons.person_outline,
                              color: AppColors.primary),
                        ),
                        title: Text(c.name),
                        subtitle: Text(c.phone),
                        onTap: () => Navigator.pop(context, c),
                      );
                    },
                  ),
          ),
        ),
      ]),
    );
  }
}
