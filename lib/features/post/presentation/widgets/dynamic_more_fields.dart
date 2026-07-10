import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/house_direction.dart';
import '../../data/models/option_item.dart';
import '../../data/post_api.dart';
import '../post_controller.dart';
import 'counter_field.dart';
import 'option_picker_sheet.dart';
import 'post_select_field.dart';

/// Renders the dynamic "Mô tả thêm" fields (`fields_array`) for the selected
/// property type. Each field's `type` chooses the widget (parity with v1
/// `step_one.item()`).
class DynamicMoreFields extends ConsumerStatefulWidget {
  const DynamicMoreFields({super.key});

  @override
  ConsumerState<DynamicMoreFields> createState() => _DynamicMoreFieldsState();
}

class _DynamicMoreFieldsState extends ConsumerState<DynamicMoreFields> {
  final _controllers = <String, TextEditingController>{};

  static const _units = {
    'frontage': 'm',
    'road_width': 'm',
    'ceiling_height': 'm',
    'door_size': 'm',
    'access_door_size': 'm',
    'management_fee': 'đ',
    'residential_agricultural_ratio': '%',
    'building_density': '%',
    'construction_area': 'm²',
    'campus_area': 'm²',
  };

  TextEditingController _ctrl(String type) =>
      _controllers.putIfAbsent(type, () => TextEditingController());

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(postControllerProvider);
    final notifier = ref.read(postControllerProvider.notifier);
    // Warm option lists for the field types present.
    final types = draft.fields.map((f) => f.type).toSet();
    if (types.contains('legal_document_type')) {
      ref.watch(legalDocumentsProvider);
    }
    if (types.contains('interior')) ref.watch(furnitureProvider);
    if (draft.loadingFields) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }
    final widgets = <Widget>[];
    for (final f in draft.fields) {
      final w = _field(context, f.type, f.title, draft, notifier);
      if (w != null) widgets.add(w);
    }
    if (widgets.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < widgets.length; i++) ...[
          if (i > 0) const SizedBox(height: 14),
          widgets[i],
        ],
      ],
    );
  }

  Widget? _field(BuildContext context, String type, String title,
      PostDraft d, PostController n) {
    switch (type) {
      case 'bedrooms':
        return CounterField(
            label: title.isEmpty ? 'Phòng ngủ' : title,
            value: d.bedrooms,
            onChanged: (v) => n.update((x) => x.copyWith(bedrooms: v)));
      case 'bathrooms':
        return CounterField(
            label: title.isEmpty ? 'Phòng vệ sinh' : title,
            value: d.bathrooms,
            onChanged: (v) => n.update((x) => x.copyWith(bathrooms: v)));
      case 'floors':
        return CounterField(
            label: title.isEmpty ? 'Số tầng' : title,
            value: d.floors,
            onChanged: (v) => n.update((x) => x.copyWith(floors: v)));
      case 'num_of_floors':
        return CounterField(
            label: title.isEmpty ? 'Số tầng' : title,
            value: d.numOfFloors,
            onChanged: (v) => n.update((x) => x.copyWith(numOfFloors: v)));
      case 'floor_block':
        return CounterField(
            label: title.isEmpty ? 'Block' : title,
            value: d.floorBlock,
            onChanged: (v) => n.update((x) => x.copyWith(floorBlock: v)));
      case 'house_direction':
        return _directionField(context, 'Chọn hướng nhà', d.houseDirection,
            (v) => n.update((x) => x.copyWith(houseDirection: v)));
      case 'balcony_direction':
        return _directionField(context, 'Chọn hướng ban công',
            d.balconyDirection, (v) => n.update((x) => x.copyWith(balconyDirection: v)));
      case 'land_direction':
        return _directionField(context, 'Chọn hướng đất', d.landDirection,
            (v) => n.update((x) => x.copyWith(landDirection: v)));
      case 'legal_document_type':
        return _optionField(context, title.isEmpty ? 'Giấy tờ pháp lý' : title,
            d.legalDocumentType, legalDocumentsProvider,
            (v) => n.update((x) => x.copyWith(legalDocumentType: v)));
      case 'interior':
        return _optionField(context, title.isEmpty ? 'Nội thất' : title,
            d.furnitureName, furnitureProvider,
            (v) => n.update((x) => x.copyWith(furnitureName: v)));
      case 'frontage':
      case 'road_width':
      case 'management_fee':
      case 'zone_of_project':
      case 'residential_agricultural_ratio':
      case 'building_density':
      case 'construction_area':
      case 'campus_area':
      case 'ceiling_height':
      case 'door_size':
      case 'access_door_size':
      case 'business_type':
        return _textField(type, title, n);
      default:
        return null;
    }
  }

  Widget _directionField(BuildContext context, String label, String value,
      ValueChanged<String> onPick) {
    final labels = HouseDirection.values.map((e) => e.label).toList();
    return PostSelectField(
      label: label,
      value: value,
      hint: label,
      onTap: () async {
        final i = await showOptionPicker(context,
            title: label, options: labels, selected: value);
        if (i != null) onPick(labels[i]);
      },
    );
  }

  Widget _optionField(BuildContext context, String label, String value,
      ProviderListenable<AsyncValue<List<OptionItem>>> provider,
      ValueChanged<String> onPick) {
    return PostSelectField(
      label: label,
      value: value,
      hint: 'Chọn ${label.toLowerCase()}',
      onTap: () async {
        // valueOrNull (not value) — value rethrows when the option load errored,
        // which would crash the tap handler.
        final items = ref.read(provider).valueOrNull ?? const <OptionItem>[];
        final names = items.map((e) => e.name).toList();
        if (names.isEmpty) return;
        final i = await showOptionPicker(context,
            title: label, options: names, selected: value);
        if (i != null) onPick(names[i]);
      },
    );
  }

  Widget _textField(String type, String title, PostController n) {
    final unit = _units[type] ?? '';
    final isText = type == 'business_type';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.isEmpty ? type : title, style: AppTextStyles.semibold(15)),
        const SizedBox(height: 8),
        TextField(
          controller: _ctrl(type),
          keyboardType: isText ? TextInputType.text : TextInputType.number,
          onChanged: (v) => n.setExtraField(type, v),
          cursorColor: AppColors.primary,
          style: AppTextStyles.semibold(15),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.neutral100,
            hintText: 'Nhập ${title.toLowerCase()}',
            hintStyle:
                AppTextStyles.semibold(15, color: const Color(0xFFD6D3D1)),
            suffixText: unit.isEmpty ? null : unit,
            suffixStyle: AppTextStyles.semibold(15, color: AppColors.text),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 2)),
          ),
        ),
      ],
    );
  }
}
