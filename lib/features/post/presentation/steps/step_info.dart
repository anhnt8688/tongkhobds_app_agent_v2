import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/thousands_input_formatter.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../locations/locations_screen.dart';
import '../../data/post_api.dart';
import '../ai_content_screen.dart';
import '../post_controller.dart';
import '../widgets/description_editor_screen.dart';
import '../widgets/dynamic_more_fields.dart';
import '../widgets/option_picker_sheet.dart';
import '../widgets/post_select_field.dart';
import '../widgets/price_suggestion_chips.dart';
import '../widgets/section_card.dart';

/// Step 1 — "Thông tin BĐS". Progressive-reveal form mirroring v1 step_one.
class StepInfo extends ConsumerStatefulWidget {
  const StepInfo({super.key});
  @override
  ConsumerState<StepInfo> createState() => _StepInfoState();
}

class _StepInfoState extends ConsumerState<StepInfo> {
  final _title = TextEditingController();
  final _addressDetail = TextEditingController();
  final _area = TextEditingController();
  final _price = TextEditingController();
  final _returnPrice = TextEditingController();
  List<PriceSuggestion> _suggestions = const [];

  static const _hintColor = Color(0xFFD6D3D1); // neutral300

  @override
  void dispose() {
    for (final c in [_title, _addressDetail, _area, _price, _returnPrice]) {
      c.dispose();
    }
    super.dispose();
  }

  PostController get _n => ref.read(postControllerProvider.notifier);

  @override
  Widget build(BuildContext context) {
    final d = ref.watch(postControllerProvider);
    // Warm the property-type list for the picker once an address is chosen.
    if (d.hasLocation) ref.watch(propertyTypesProvider(d.transactionType));
    final infoFilled =
        d.propertyTypeId != null && d.area != null && d.price != null;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _demand(d),
        const SizedBox(height: 21),
        _address(d),
        if (d.hasLocation) ...[
          const SizedBox(height: 21),
          _mainInfo(d),
        ],
        if (infoFilled) ...[
          const SizedBox(height: 21),
          SectionCard(
            title: 'Mô tả thêm',
            collapsible: true,
            child: const DynamicMoreFields(),
          ),
          const SizedBox(height: 21),
          _content(d),
        ],
      ],
    );
  }

  // --- Nhu cầu ---
  Widget _demand(PostDraft d) {
    Widget chip(int t, IconData icon, String label) {
      final sel = d.transactionType == t;
      return Expanded(
        child: GestureDetector(
          onTap: () => _n.setDemand(t),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: sel ? AppColors.primary : AppColors.bg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(children: [
              FaIcon(icon,
                  size: 20, color: sel ? AppColors.bg : AppColors.text),
              const SizedBox(height: 4),
              Text(label,
                  style: AppTextStyles.semibold(13,
                      color: sel ? AppColors.bg : AppColors.text)),
            ]),
          ),
        ),
      );
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Nhu cầu', style: AppTextStyles.semibold(15)),
      const SizedBox(height: 8),
      Row(children: [
        chip(1, FontAwesomeIcons.tag, 'Bán BĐS'),
        const SizedBox(width: 8),
        chip(2, FontAwesomeIcons.key, 'Cho thuê'),
      ]),
    ]);
  }

  // --- Địa chỉ ---
  Widget _address(PostDraft d) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      PostSelectField(
        label: 'Địa chỉ',
        required: true,
        value: d.locationLabel,
        hint: 'Chọn địa chỉ',
        onTap: () async {
          final sel = await showLocationPickerSheet(context);
          if (sel != null) _n.setLocation(sel);
        },
      ),
      const SizedBox(height: 12),
      AppTextField(
        label: 'Địa chỉ chi tiết',
        controller: _addressDetail,
        titleColor: AppColors.text,
        hint: 'Nhập địa chỉ chi tiết',
        onChanged: (v) => _n.update((x) => x.copyWith(addressDetail: v)),
      ),
    ]);
  }

  // --- Mô tả chính ---
  Widget _mainInfo(PostDraft d) {
    final isSell = d.transactionType == 1;
    return SectionCard(
      title: 'Mô tả chính',
      collapsible: true,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        PostSelectField(
          label: 'Loại BĐS',
          required: true,
          value: d.propertyTypeName,
          hint: 'Chọn loại BĐS',
          onTap: () => _pickType(d.transactionType, d.propertyTypeName),
        ),
        if (d.propertyTypeId != null) ...[
          const SizedBox(height: 14),
          _numberField('Diện tích', _area, 'm²', required: true,
              onChanged: (v) => _n.update((x) => digitsOf(v) > 0
                  ? x.copyWith(area: digitsOf(v).toDouble())
                  : x.copyWith(clearArea: true))),
        ],
        if (d.area != null) ...[
          const SizedBox(height: 14),
          _numberField('Giá báo khách hàng', _price, 'VNĐ', required: true,
              onChanged: (v) {
            _n.update((x) => digitsOf(v) > 0
                ? x.copyWith(price: digitsOf(v).toDouble())
                : x.copyWith(clearPrice: true));
            setState(
                () => _suggestions = suggestPrices(digitsOf(v), isSell: isSell));
            _n.fetchCommission();
          }),
          PriceSuggestionChips(
            suggestions: _suggestions,
            onPick: (amount) {
              final f = ThousandsInputFormatter()
                  .formatEditUpdate(const TextEditingValue(),
                      TextEditingValue(text: '$amount'))
                  .text;
              _price.text = f;
              _n.update((x) => x.copyWith(price: amount.toDouble()));
              setState(() => _suggestions = const []);
              _n.fetchCommission();
            },
          ),
        ],
        if (d.price != null) ...[
          const SizedBox(height: 14),
          _numberField('Giá thu về', _returnPrice, 'VNĐ',
              onChanged: (v) => _n.update((x) => digitsOf(v) > 0
                  ? x.copyWith(returnPrice: digitsOf(v).toDouble())
                  : x.copyWith(clearReturnPrice: true))),
          if (d.returnPrice != null &&
              d.price != null &&
              d.returnPrice! > d.price!)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text('Giá thu về không được lớn hơn giá báo khách hàng',
                  style:
                      AppTextStyles.regular(13, color: const Color(0xFFFF3B30))),
            ),
        ],
      ]),
    );
  }

  // --- Nội dung tin đăng ---
  Widget _content(PostDraft d) {
    return SectionCard(
      title: 'Nội dung tin đăng',
      collapsible: true,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: Text('Tạo nội dung tự động', style: AppTextStyles.semibold(15)),
          ),
          _AiButton(onTap: _openAiContent),
        ]),
        const SizedBox(height: 16),
        AppTextField(
          label: 'Tiêu đề',
          controller: _title,
          required: true,
          titleColor: AppColors.text,
          hint: 'VD: Bán nhà riêng 50m², 2 phòng ngủ',
          onChanged: (v) => _n.update((x) => x.copyWith(title: v)),
        ),
        const SizedBox(height: 12),
        Text.rich(TextSpan(text: 'Mô tả', style: AppTextStyles.semibold(15),
            children: [
              TextSpan(
                  text: ' *',
                  style: AppTextStyles.semibold(15, color: AppColors.danger)),
            ])),
        const SizedBox(height: 8),
        InkWell(
          onTap: _editDescription,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: Text(
                  d.description.isEmpty
                      ? 'Nhấn để mở trình chỉnh sửa toàn màn hình'
                      : d.description,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.regular(15,
                      color: d.description.isEmpty
                          ? AppColors.neutral400
                          : AppColors.textSecondary),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.open_in_full_rounded,
                  size: 18, color: AppColors.neutral400),
            ]),
          ),
        ),
      ]),
    );
  }

  /// Opens the dedicated "Tạo nội dung tự động" page (v1 parity). On return the
  /// page has committed the description/title into the draft, so sync the title
  /// field controller to reflect any AI-suggested title.
  Future<void> _openAiContent() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AiContentScreen()),
    );
    if (!mounted) return;
    final t = ref.read(postControllerProvider).title;
    if (t != _title.text) _title.text = t;
  }

  Future<void> _editDescription() async {
    final res = await Navigator.of(context).push<DescriptionResult>(
      MaterialPageRoute(
        builder: (_) => DescriptionEditorScreen(
            initialPlain: ref.read(postControllerProvider).description),
      ),
    );
    if (res != null) {
      _n.update((x) => x.copyWith(description: res.plain, htmlContent: res.html));
    }
  }

  Future<void> _pickType(int transactionType, String current) async {
    final types =
        ref.read(propertyTypesProvider(transactionType)).value ?? const [];
    if (types.isEmpty) return;
    final i = await showOptionPicker(context,
        title: 'Loại BĐS',
        options: types.map((t) => t.name).toList(),
        selected: current);
    if (i != null) {
      _n.selectPropertyType(types[i].id, types[i].name);
    }
  }

  /// v1 `TitleDefaultTextField` number variant: `semibold(15)` title, neutral100
  /// fill, thousands grouping, unit suffix.
  Widget _numberField(
    String label,
    TextEditingController c,
    String unit, {
    required ValueChanged<String> onChanged,
    bool required = false,
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text.rich(TextSpan(text: label, style: AppTextStyles.semibold(15),
          children: required
              ? [
                  TextSpan(
                      text: ' *',
                      style:
                          AppTextStyles.semibold(15, color: AppColors.danger)),
                ]
              : null)),
      const SizedBox(height: 8),
      TextField(
        controller: c,
        keyboardType: TextInputType.number,
        inputFormatters: [ThousandsInputFormatter()],
        onChanged: onChanged,
        cursorColor: AppColors.primary,
        style: AppTextStyles.semibold(15),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.neutral100,
          hintText: 'Nhập mức giá',
          hintStyle: AppTextStyles.semibold(15, color: _hintColor),
          suffixText: unit,
          suffixStyle: AppTextStyles.semibold(15, color: AppColors.text),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          border: _fieldBorder(Colors.transparent, 0),
          enabledBorder: _fieldBorder(Colors.transparent, 0),
          focusedBorder: _fieldBorder(AppColors.primary, 2),
        ),
      ),
    ]);
  }

  OutlineInputBorder _fieldBorder(Color color, double width) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            width == 0 ? BorderSide.none : BorderSide(color: color, width: width),
      );
}

/// v1 gradient pill "Tạo tự động" button ([#FF5858→#F09819] + `ic_ai.png`).
class _AiButton extends StatelessWidget {
  const _AiButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: const LinearGradient(
            colors: [Color(0xFFFF5858), Color(0xFFF09819)],
          ),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text('Tạo tự động',
              style: AppTextStyles.semibold(15, color: Colors.white)),
          const SizedBox(width: 8),
          Image.asset('assets/images/ic_ai.png', width: 20, height: 20),
        ]),
      ),
    );
  }
}
