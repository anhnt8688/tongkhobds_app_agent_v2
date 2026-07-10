import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_toast.dart';
import '../controllers/auth_controller.dart';

class _DomainOption extends StatelessWidget {
  const _DomainOption(
      {required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: selected ? AppColors.primary : AppColors.textMute,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(label, style: AppTypography.body)),
          ],
        ),
      ),
    );
  }
}

/// Hidden domain switcher (v1 parity): pick a preset or enter a custom backend
/// domain. Saving persists it, rebuilds the HTTP client and logs out so the
/// next login hits the chosen environment.
class DomainPickerSheet extends ConsumerStatefulWidget {
  const DomainPickerSheet({super.key});
  @override
  ConsumerState<DomainPickerSheet> createState() => _DomainPickerSheetState();
}

class _DomainPickerSheetState extends ConsumerState<DomainPickerSheet> {
  late String _selected = AppConfig.baseUrl;
  final _custom = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _custom.dispose();
    super.dispose();
  }

  String _normalize(String input) {
    var s = input.trim();
    if (s.isEmpty) return s;
    if (!s.startsWith('http://') && !s.startsWith('https://')) {
      s = 'https://$s';
    }
    if (s.endsWith('/')) s = s.substring(0, s.length - 1);
    return s;
  }

  bool _valid(String url) {
    final uri = Uri.tryParse(url);
    return uri != null &&
        (uri.isScheme('http') || uri.isScheme('https')) &&
        uri.host.isNotEmpty;
  }

  Future<void> _save() async {
    final custom = _normalize(_custom.text);
    final domain = custom.isNotEmpty ? custom : _selected;
    if (!_valid(domain)) {
      AppToast.error(context, 'Domain không hợp lệ');
      return;
    }
    setState(() => _saving = true);
    final ts = ref.read(tokenStorageProvider);
    await ts.saveDomain(domain);
    AppConfig.setBaseUrl(domain);
    // Rebuild the Dio client (and all API clients) against the new domain.
    ref.read(domainProvider.notifier).state = domain;
    // Drop the old-environment session → router returns to login.
    await ref.read(authControllerProvider.notifier).logout();
    if (!mounted) return;
    Navigator.pop(context);
    AppToast.success(context, 'Đã đổi domain. Vui lòng đăng nhập lại.');
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(99)),
            ),
          ),
          const SizedBox(height: 16),
          Text('Chọn domain', style: AppTypography.title),
          const SizedBox(height: 4),
          Text('Hiện tại: ${AppConfig.baseUrl}',
              style:
                  AppTypography.caption.copyWith(color: AppColors.textMute)),
          const SizedBox(height: 12),
          for (final d in AppConfig.domains)
            _DomainOption(
              label: d,
              selected: _custom.text.trim().isEmpty && _selected == d,
              onTap: () => setState(() {
                _selected = d;
                _custom.clear();
              }),
            ),
          const SizedBox(height: 8),
          TextField(
            controller: _custom,
            onChanged: (_) => setState(() {}),
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              labelText: 'Domain tuỳ chọn',
              hintText: 'https://...',
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: _saving ? null : _save,
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              child: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white)))
                  : const Text('Lưu & đăng nhập lại'),
            ),
          ),
        ],
      ),
    );
  }
}
