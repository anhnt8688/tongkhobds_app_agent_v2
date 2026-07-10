import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_toast.dart';
import '../../core/widgets/async_view.dart';
import '../../core/widgets/custom_screen.dart';
import 'utilities_api.dart';

/// "Tiện ích" — dynamic calculator tools (lãi suất, chi phí làm nhà, xem tuổi,
/// phong thủy…) driven by the backend form config + calculate endpoints.
class UtilitiesScreen extends ConsumerStatefulWidget {
  const UtilitiesScreen({super.key});
  @override
  ConsumerState<UtilitiesScreen> createState() => _UtilitiesScreenState();
}

class _UtilitiesScreenState extends ConsumerState<UtilitiesScreen> {
  UtilityItem? _selected;

  @override
  Widget build(BuildContext context) {
    final tools = ref.watch(utilityToolsProvider);
    return CustomScreen(
      title: 'Tiện ích',
      backgroundColor: AppColors.bg,
      child: AsyncView<List<UtilityItem>>(
        value: tools,
        onRetry: () => ref.invalidate(utilityToolsProvider),
        data: (list) {
          if (list.isEmpty) {
            return const Center(child: Text('Chưa có tiện ích'));
          }
          _selected ??= list.first;
          return Column(
            children: [
              SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final t = list[i];
                    final active = t.type == _selected?.type;
                    return GestureDetector(
                      onTap: () => setState(() => _selected = t),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: active ? AppColors.primary : AppColors.surface,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                              color: active
                                  ? AppColors.primary
                                  : AppColors.border),
                        ),
                        child: Text(t.title,
                            style: AppTypography.caption.copyWith(
                                color: active
                                    ? Colors.white
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.w600)),
                      ),
                    );
                  },
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: _selected == null
                    ? const SizedBox.shrink()
                    : _ToolForm(key: ValueKey(_selected!.type), tool: _selected!),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ToolForm extends ConsumerStatefulWidget {
  const _ToolForm({super.key, required this.tool});
  final UtilityItem tool;
  @override
  ConsumerState<_ToolForm> createState() => _ToolFormState();
}

class _ToolFormState extends ConsumerState<_ToolForm> {
  final _text = <String, TextEditingController>{};
  final _select = <String, String>{};
  bool _calculating = false;
  String? _result;

  @override
  void dispose() {
    for (final c in _text.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _calculate(UtilityForm form) async {
    final data = <String, dynamic>{'type': widget.tool.type};
    for (final f in form.fields) {
      if (f.type == 'select' || f.type == 'radio') {
        final v = _select[f.name];
        if (f.required && (v == null || v.isEmpty)) {
          AppToast.warning(context, 'Vui lòng chọn ${f.label}');
          return;
        }
        if (v != null && v.isNotEmpty) data[f.name] = v;
      } else {
        final v = _text[f.name]?.text.trim() ?? '';
        if (f.required && v.isEmpty) {
          AppToast.warning(context, 'Vui lòng nhập ${f.label}');
          return;
        }
        if (v.isNotEmpty) data[f.name] = v;
      }
    }
    setState(() => _calculating = true);
    try {
      final html = await ref.read(utilitiesApiProvider).calculate(data);
      setState(() => _result = html);
    } catch (_) {
      if (mounted) AppToast.error(context, 'Tính toán thất bại');
    } finally {
      if (mounted) setState(() => _calculating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formAsync = ref.watch(utilityFormProvider(widget.tool.type));
    return AsyncView<UtilityForm>(
      value: formAsync,
      onRetry: () => ref.invalidate(utilityFormProvider(widget.tool.type)),
      data: (form) {
        for (final f in form.fields) {
          if (f.type != 'select' && f.type != 'radio') {
            _text.putIfAbsent(f.name, () => TextEditingController());
          }
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final f in form.fields) ...[
              _field(f),
              const SizedBox(height: 14),
            ],
            SizedBox(
              height: 50,
              child: FilledButton(
                onPressed: _calculating ? null : () => _calculate(form),
                style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                child: _calculating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white)))
                    : const Text('Tính'),
              ),
            ),
            if (_result != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(color: AppColors.border),
                ),
                child: HtmlWidget(_result!),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _field(UtilityField f) {
    final label = Text.rich(TextSpan(children: [
      TextSpan(
          text: f.label,
          style: AppTypography.caption
              .copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
      if (f.required)
        const TextSpan(text: ' *', style: TextStyle(color: AppColors.danger)),
    ]));
    if (f.type == 'select' || f.type == 'radio') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label,
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: _select[f.name],
            isExpanded: true,
            hint: Text(f.hint ?? 'Chọn'),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surface,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
            ),
            items: [
              for (final o in f.options)
                DropdownMenuItem(value: o.value, child: Text(o.label)),
            ],
            onChanged: (v) => setState(() => _select[f.name] = v ?? ''),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label,
        const SizedBox(height: 6),
        TextField(
          controller: _text[f.name],
          keyboardType:
              f.type == 'number' ? TextInputType.number : TextInputType.text,
          inputFormatters: f.type == 'number'
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,
          decoration: InputDecoration(
            hintText: f.hint,
            suffixText: f.unit,
            filled: true,
            fillColor: AppColors.surface,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
          ),
        ),
      ],
    );
  }
}
