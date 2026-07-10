import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/custom_screen.dart';
import '../../customers/data/customers_api.dart';
import '../../customers/data/models/customer.dart';
import '../../realestate/data/models/property.dart';
import '../../realestate/data/models/search_filter.dart';
import '../../realestate/data/realestate_api.dart';
import '../../realestate/presentation/widgets/property_card.dart';
import '../data/appointments_api.dart';
import 'widgets/success_dialog.dart';

/// Create or edit an appointment. Pass a [Property] via `extra` to pre-select
/// the BĐS (from the property detail "Đặt lịch hẹn"), or an [Appointment] to
/// edit an existing one. Mirrors the v1 MakeAnAppointmentPage.
class MakeAppointmentScreen extends ConsumerStatefulWidget {
  const MakeAppointmentScreen({super.key, this.property, this.editing});

  final Property? property;
  final Appointment? editing;

  @override
  ConsumerState<MakeAppointmentScreen> createState() =>
      _MakeAppointmentScreenState();
}

class _MakeAppointmentScreenState extends ConsumerState<MakeAppointmentScreen> {
  Customer? _customer;
  Property? _property;
  String _date = ''; // dd/MM/yyyy
  String _time = ''; // HH:mm
  bool _saving = false;

  bool get _isEdit => widget.editing != null;
  bool get _propertyLocked => widget.property != null || _isEdit;

  @override
  void initState() {
    super.initState();
    _property = widget.property;
    final e = widget.editing;
    if (e != null) {
      _date = e.dateText;
      _time = e.timeText;
    }
  }

  bool get _valid {
    if (_date.isEmpty || _time.isEmpty) return false;
    if (_isEdit) return true;
    return _customer != null && _property != null;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _date =
          '${_two(picked.day)}/${_two(picked.month)}/${picked.year}');
    }
  }

  /// v1-style time picker: an orange-headed dialog with two Cupertino wheels
  /// (hours 0–23, minutes 0–59) and Huỷ / Xong actions.
  Future<void> _pickTime() async {
    final now = TimeOfDay.now();
    int hour = now.hour;
    int minute = now.minute;
    final hourCtrl = FixedExtentScrollController(initialItem: hour);
    final minuteCtrl = FixedExtentScrollController(initialItem: minute);

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          height: 350,
          width: double.maxFinite,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(
                  color: AppColors.price,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Center(
                  child: Text('Chọn giờ',
                      style: AppTextStyles.bold(16, color: Colors.white)),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: hourCtrl,
                        itemExtent: 40,
                        useMagnifier: true,
                        diameterRatio: 1.1,
                        onSelectedItemChanged: (v) => hour = v,
                        children: List.generate(
                          24,
                          (i) => Center(
                              child: Text(_two(i),
                                  style: AppTextStyles.semibold(18))),
                        ),
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: minuteCtrl,
                        itemExtent: 40,
                        useMagnifier: true,
                        diameterRatio: 1.1,
                        onSelectedItemChanged: (v) => minute = v,
                        children: List.generate(
                          60,
                          (i) => Center(
                              child: Text(_two(i),
                                  style: AppTextStyles.semibold(18))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text('Huỷ',
                            style: AppTextStyles.semibold(15,
                                color: AppColors.text)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() => _time = '${_two(hour)}:${_two(minute)}');
                          Navigator.of(ctx).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.price,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text('Xong',
                            style: AppTextStyles.semibold(15,
                                color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _two(int v) => v.toString().padLeft(2, '0');

  Future<void> _submit() async {
    if (!_valid) return;
    setState(() => _saving = true);
    try {
      final api = ref.read(appointmentsApiProvider);
      final AppointmentResult res;
      if (_isEdit) {
        res = await api.update(
          appointmentId: widget.editing!.id,
          date: _date,
          time: _time,
          status: widget.editing!.status,
        );
      } else {
        res = await api.create(
          tableId: _property!.id,
          customerId: _customer!.id,
          date: _date,
          time: _time,
        );
      }
      if (!res.success) {
        if (mounted) AppToast.error(context, res.message ?? 'Có lỗi xảy ra');
        return;
      }
      if (!mounted) return;
      await SuccessDialog.show(
        context,
        title: _isEdit
            ? 'Chỉnh sửa lịch hẹn thành công'
            : 'Đặt lịch hẹn thành công',
        onConfirm: () => Navigator.pop(context, true),
      );
    } on ApiException catch (e) {
      if (mounted) AppToast.error(context, e.message);
    } catch (_) {
      if (mounted) AppToast.error(context, 'Có lỗi xảy ra');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.editing;
    final propTitle = _property?.title ?? e?.propertyTitle ?? '';
    final propAddr = _property?.address ?? e?.propertyAddress ?? '';
    final custName = _customer?.name ?? e?.customerName ?? '';
    final custPhone = _customer?.phone ?? e?.customerPhone ?? '';

    return CustomScreen(
      title: _isEdit ? 'Chỉnh sửa lịch hẹn' : 'Đặt lịch hẹn',
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Customer
                _Section(
                  title: 'Thông tin khách hàng',
                  action: _isEdit
                      ? null
                      : _IconBtn(
                          icon: _customer == null ? Icons.add : Icons.edit,
                          onTap: _pickCustomer,
                        ),
                  child: custName.isEmpty
                      ? const _Empty('Chưa chọn khách hàng')
                      : Column(
                          children: [
                            _kv('Tên khách hàng', custName),
                            _kv('Số điện thoại', custPhone),
                          ],
                        ),
                ),
                const SizedBox(height: 16),
                // Property
                _Section(
                  title: 'Thông tin BĐS',
                  action: _propertyLocked
                      ? null
                      : _IconBtn(
                          icon: _property == null ? Icons.add : Icons.edit,
                          onTap: _pickProperty,
                        ),
                  child: propTitle.isEmpty
                      ? const _Empty('Chưa chọn bất động sản')
                      : Column(
                          children: [
                            _kv('Tên BĐS', propTitle),
                            if (propAddr.isNotEmpty) _kv('Địa chỉ', propAddr),
                          ],
                        ),
                ),
                const SizedBox(height: 16),
                // Date & time (v1 has no section title on this card)
                _Section(
                  child: Column(
                    children: [
                      _PickerField(
                        label: 'Ngày hẹn',
                        value: _date,
                        hint: 'Chọn ngày hẹn',
                        onTap: _pickDate,
                      ),
                      const SizedBox(height: 12),
                      _PickerField(
                        label: 'Thời gian',
                        value: _time,
                        hint: 'Chọn thời gian',
                        onTap: _pickTime,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: AppButton(
                label: _isEdit ? 'Chỉnh sửa lịch hẹn' : 'Đặt lịch hẹn',
                loading: _saving,
                onPressed: _valid && !_saving ? _submit : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickCustomer() async {
    final picked = await showModalBottomSheet<Customer>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _CustomerPickerSheet(),
    );
    if (picked != null) setState(() => _customer = picked);
  }

  Future<void> _pickProperty() async {
    final picked = await showModalBottomSheet<Property>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _PropertyPickerSheet(),
    );
    if (picked != null) setState(() => _property = picked);
  }

  Widget _kv(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(label,
                style: AppTextStyles.regular(15, color: AppColors.neutral400)),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 4,
            child: Text(value,
                textAlign: TextAlign.end,
                style: AppTextStyles.semibold(15)),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({this.title, required this.child, this.action});
  final String? title;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              children: [
                Container(
                  width: 8,
                  height: 16,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(child: Text(title!, style: AppTextStyles.semibold(20))),
                if (action != null) action!,
              ],
            ),
            const SizedBox(height: 16),
          ],
          child,
        ],
      ),
    );
  }
}

/// v1 uses a bare Material icon (edit/add) in neutral400, not a filled button.
class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Icon(icon, size: 22, color: AppColors.neutral400),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.centerLeft,
        child: Text(text,
            style: AppTextStyles.regular(15, color: AppColors.textMute)),
      );
}

class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.label,
    required this.value,
    required this.hint,
    required this.onTap,
  });
  final String label;
  final String value;
  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.semibold(15)),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value.isEmpty ? hint : value,
                    style: AppTextStyles.regular(
                      15,
                      color:
                          value.isEmpty ? AppColors.neutral400 : AppColors.text,
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down_outlined,
                    color: AppColors.neutral400),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Bottom sheet to pick a customer from the agent's customer list.
class _CustomerPickerSheet extends ConsumerStatefulWidget {
  const _CustomerPickerSheet();
  @override
  ConsumerState<_CustomerPickerSheet> createState() =>
      _CustomerPickerSheetState();
}

class _CustomerPickerSheetState extends ConsumerState<_CustomerPickerSheet> {
  @override
  Widget build(BuildContext context) {
    final list = ref.watch(customersProvider);
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Text('Chọn khách hàng', style: AppTextStyles.semibold(17)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: (v) =>
                    ref.read(customerSearchProvider.notifier).state = v,
                decoration: InputDecoration(
                  hintText: 'Tìm khách hàng...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                ),
              ),
            ),
            Expanded(
              child: list.when(
                loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary)),
                error: (_, __) =>
                    const Center(child: Text('Không tải được khách hàng')),
                data: (customers) {
                  if (customers.isEmpty) {
                    return const Center(child: Text('Không có khách hàng'));
                  }
                  return ListView.separated(
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

/// Bottom sheet to search & pick a property.
class _PropertyPickerSheet extends ConsumerStatefulWidget {
  const _PropertyPickerSheet();
  @override
  ConsumerState<_PropertyPickerSheet> createState() =>
      _PropertyPickerSheetState();
}

class _PropertyPickerSheetState extends ConsumerState<_PropertyPickerSheet> {
  String _query = '';
  List<Property> _results = const [];
  bool _loading = false;

  Future<void> _search() async {
    setState(() => _loading = true);
    try {
      final res = await ref
          .read(realEstateApiProvider)
          .search(SearchFilter(keyword: _query), page: 1, limit: 20);
      if (mounted) setState(() => _results = res.items);
    } catch (_) {
      if (mounted) setState(() => _results = const []);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _search();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Text('Chọn bất động sản', style: AppTextStyles.semibold(17)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                textInputAction: TextInputAction.search,
                onChanged: (v) => _query = v,
                onSubmitted: (_) => _search(),
                decoration: InputDecoration(
                  hintText: 'Tìm theo tên / mã / khu vực...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: _search,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(
                      child:
                          CircularProgressIndicator(color: AppColors.primary))
                  : _results.isEmpty
                      ? const Center(child: Text('Không tìm thấy BĐS'))
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                          itemCount: _results.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (_, i) {
                            final p = _results[i];
                            return PropertyCard(
                              property: p,
                              onTap: () => Navigator.pop(context, p),
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
