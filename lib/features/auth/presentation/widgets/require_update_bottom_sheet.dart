import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/auth_validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../locations/locations_screen.dart';
import '../../../profile/data/profile_api.dart';
import '../controllers/auth_controller.dart';

/// "Thông tin Agent" sheet opened from the require-update dialog's "Tiếp tục"
/// (v1 `RequireUpdateBottomSheet`). Collects the missing agent profile fields —
/// address, address detail, email, birthday — then updates the profile so the
/// account is granted Agent rights. Pops `true` on success.
class RequireUpdateBottomSheet extends ConsumerStatefulWidget {
  const RequireUpdateBottomSheet({super.key});

  @override
  ConsumerState<RequireUpdateBottomSheet> createState() =>
      _RequireUpdateBottomSheetState();
}

class _RequireUpdateBottomSheetState
    extends ConsumerState<RequireUpdateBottomSheet> {
  final _detail = TextEditingController();
  final _email = TextEditingController();
  LocationSelection? _address;
  DateTime? _birthday;
  bool _twoLevel = false;
  bool _submitting = false;

  @override
  void dispose() {
    _detail.dispose();
    _email.dispose();
    super.dispose();
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  bool get _emailValid {
    final v = _email.text.trim();
    return v.isEmpty || isValidEmail(v);
  }

  bool get _valid =>
      _address != null && _detail.text.trim().isNotEmpty && _emailValid;

  /// Selected area label; drops the district when the two-level option is on.
  String _addressLabel() {
    final a = _address;
    if (a == null) return '';
    return <String>[
      if ((a.wardName ?? '').trim().isNotEmpty) a.wardName!,
      if (!_twoLevel && (a.districtName ?? '').trim().isNotEmpty) a.districtName!,
      if (a.cityName.trim().isNotEmpty) a.cityName,
    ].join(', ');
  }

  Future<void> _pickAddress() async {
    final sel = await showLocationPickerSheet(context);
    if (sel != null) setState(() => _address = sel);
  }

  Future<void> _pickBirthday() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthday ?? DateTime(now.year - 20, now.month, now.day),
      firstDate: DateTime(1950),
      lastDate: now,
    );
    if (picked != null) setState(() => _birthday = picked);
  }

  Future<void> _submit() async {
    if (!_valid || _submitting) return;
    setState(() => _submitting = true);
    try {
      final u = ref.read(currentUserProvider);
      final detail = _detail.text.trim();
      final fullAddress = [detail, _addressLabel()]
          .where((e) => e.trim().isNotEmpty)
          .join(', ');
      final bday = _birthday == null
          ? null
          : '${_birthday!.year}-${_two(_birthday!.month)}-${_two(_birthday!.day)}';
      final email = _email.text.trim();
      await ref.read(profileApiProvider).updateProfile(
            fullName: u?.fullName ?? '',
            phone: u?.phone ?? '',
            email: email.isNotEmpty ? email : null,
            address: fullAddress.isNotEmpty ? fullAddress : null,
            birthday: bday,
            cityId: _address?.cityId,
            districtId: _twoLevel ? null : _address?.districtId,
            wardId: _address?.wardId,
          );
      await ref.read(authControllerProvider.notifier).refreshProfile();
      if (!mounted) return;
      AppToast.success(context, 'Cập nhật thông tin tài khoản thành công');
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (mounted) AppToast.error(context, e.message);
    } catch (_) {
      if (mounted) AppToast.error(context, 'Cập nhật thất bại, thử lại');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.74,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.fromLTRB(
                20, 12, 20, 24 + MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('Thông tin Agent',
                          style: AppTypography.heading
                              .copyWith(color: AppColors.text)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close,
                          color: AppColors.textSecondary),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const Divider(height: 1, color: AppColors.border),
                const SizedBox(height: 12),
                Text(
                  'Vui lòng bổ sung thông tin để tiếp tục đăng nhập với quyền Agent',
                  style: AppTypography.subtitle
                      .copyWith(color: AppColors.textMute, height: 1.4),
                ),
                const SizedBox(height: 16),
                _addressHeader(),
                const SizedBox(height: 6),
                _PickerField(
                  hint: 'Chọn địa chỉ',
                  value: _addressLabel(),
                  onTap: _pickAddress,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Địa chỉ chi tiết *',
                  controller: _detail,
                  hint: 'Nhập địa chỉ chi tiết',
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Email',
                  controller: _email,
                  hint: 'Nhập địa chỉ email',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) => setState(() {}),
                ),
                if (!_emailValid)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text('Email không đúng định dạng',
                        style: AppTypography.caption
                            .copyWith(color: AppColors.danger)),
                  ),
                const SizedBox(height: 16),
                Text('Ngày sinh',
                    style:
                        AppTypography.subtitle.copyWith(color: AppColors.text)),
                const SizedBox(height: 6),
                _PickerField(
                  hint: 'Chọn ngày sinh',
                  value: _birthday == null
                      ? ''
                      : '${_two(_birthday!.day)}/${_two(_birthday!.month)}/${_birthday!.year}',
                  onTap: _pickBirthday,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: 'Quay lại',
                        variant: AppButtonVariant.ghost,
                        onPressed:
                            _submitting ? null : () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        label: 'Xác nhận',
                        loading: _submitting,
                        onPressed: _valid ? _submit : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// "Địa chỉ *" label with the optional two-level (drop-district) checkbox.
  Widget _addressHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            text: 'Địa chỉ',
            style: AppTypography.subtitle.copyWith(color: AppColors.text),
            children: const [
              TextSpan(text: ' *', style: TextStyle(color: AppColors.danger)),
            ],
          ),
        ),
        Row(
          children: [
            Text('Chọn địa chỉ mới (2 cấp)',
                style: AppTypography.caption
                    .copyWith(color: AppColors.textSecondary)),
            Checkbox(
              value: _twoLevel,
              activeColor: AppColors.primary,
              visualDensity: VisualDensity.compact,
              onChanged: (v) => setState(() => _twoLevel = v ?? false),
            ),
          ],
        ),
      ],
    );
  }
}

/// Read-only tappable field (address / birthday picker) with a chevron.
class _PickerField extends StatelessWidget {
  const _PickerField({required this.hint, required this.value, required this.onTap});
  final String hint;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final filled = value.trim().isNotEmpty;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                filled ? value : hint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.body.copyWith(
                    color: filled ? AppColors.text : AppColors.textMute),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded,
                color: AppColors.textMute),
          ],
        ),
      ),
    );
  }
}
