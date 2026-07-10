import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/auth_validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/custom_screen.dart';
import '../data/customers_api.dart';
import '../data/models/customer.dart';

/// add = tạo mới, edit = chỉnh sửa, detail = xem (read-only). Mirrors v1
/// `CustomerType` driving the shared `AddCustomerPage`.
enum CustomerFormMode { add, edit, detail }

/// Customer create / edit / detail page (v1 `AddCustomerPage`):
/// Họ tên (bắt buộc) + SĐT (bắt buộc) + Email + Địa chỉ; save only when changed.
/// Avatar shown in detail view only (no avatar editing on add/edit).
class CustomerFormScreen extends ConsumerStatefulWidget {
  const CustomerFormScreen({super.key, required this.mode, this.customer});

  final CustomerFormMode mode;
  final Customer? customer;

  @override
  ConsumerState<CustomerFormScreen> createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends ConsumerState<CustomerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _email;
  late final TextEditingController _address;
  bool _saving = false;
  String? _error;

  bool get _readOnly => widget.mode == CustomerFormMode.detail;

  @override
  void initState() {
    super.initState();
    final c = widget.customer;
    _name = TextEditingController(text: c?.name ?? '');
    _phone = TextEditingController(text: c?.phone ?? '');
    _email = TextEditingController(text: c?.email ?? '');
    _address = TextEditingController(text: c?.address ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _address.dispose();
    super.dispose();
  }

  String get _title {
    switch (widget.mode) {
      case CustomerFormMode.add:
        return 'Thêm khách hàng';
      case CustomerFormMode.edit:
        return 'Chỉnh sửa khách hàng';
      case CustomerFormMode.detail:
        return 'Chi tiết khách hàng';
    }
  }

  /// v1 `hasChanges`: add → any field filled; edit → any field differs.
  bool get _hasChanges {
    final c = widget.customer;
    if (c == null) {
      return _name.text.trim().isNotEmpty ||
          _phone.text.trim().isNotEmpty ||
          _email.text.trim().isNotEmpty ||
          _address.text.trim().isNotEmpty;
    }
    return _name.text.trim() != (c.name) ||
        _phone.text.trim() != (c.phone) ||
        _email.text.trim() != (c.email ?? '') ||
        _address.text.trim() != (c.address ?? '');
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_hasChanges) {
      AppToast.info(context, 'Chưa có thay đổi nào');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    final api = ref.read(customersApiProvider);
    try {
      if (widget.mode == CustomerFormMode.edit && widget.customer != null) {
        await api.update(
          id: widget.customer!.id,
          name: _name.text.trim(),
          phone: _phone.text.trim(),
          email: _email.text.trim(),
          address: _address.text.trim(),
        );
      } else {
        await api.add(
          name: _name.text.trim(),
          phone: _phone.text.trim(),
          email: _email.text.trim(),
          address: _address.text.trim(),
        );
      }
      if (!context.mounted) return;
      AppToast.success(context, 'Lưu khách hàng thành công');
      context.pop(true);
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } catch (_) {
      setState(() => _error = 'Không lưu được khách hàng');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: _title,
      actions: [
        if (_readOnly)
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Chỉnh sửa',
            onPressed: () async {
              final ok = await context.push<bool>('/customers/edit',
                  extra: widget.customer);
              if (ok == true && mounted) context.pop(true);
            },
          ),
      ],
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_readOnly) ...[
                  _avatar(),
                  const SizedBox(height: 20),
                ],
                AppTextField(
                  label: 'Họ và tên',
                  controller: _name,
                  enabled: !_readOnly,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Nhập họ tên' : null,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'Số điện thoại',
                  controller: _phone,
                  enabled: !_readOnly,
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    final s = v?.trim() ?? '';
                    if (s.isEmpty) return 'Nhập số điện thoại';
                    if (!isValidVietnamPhone(s)) return 'Số điện thoại không hợp lệ';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'Email',
                  controller: _email,
                  enabled: !_readOnly,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    final s = v?.trim() ?? '';
                    if (s.isNotEmpty && !isValidEmail(s)) {
                      return 'Email không hợp lệ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'Địa chỉ',
                  controller: _address,
                  enabled: !_readOnly,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!,
                      style: AppTypography.subtitle
                          .copyWith(color: AppColors.danger)),
                ],
                if (!_readOnly) ...[
                  const SizedBox(height: 24),
                  AppButton(
                    label: 'Lưu khách hàng',
                    loading: _saving,
                    onPressed: _save,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Display-only avatar (detail view). Add/edit forms omit it entirely.
  Widget _avatar() {
    return const CircleAvatar(
      radius: 44,
      backgroundColor: AppColors.primarySoft,
      child: Icon(Icons.person, size: 44, color: AppColors.primary),
    );
  }
}
