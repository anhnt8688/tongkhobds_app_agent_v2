import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../../core/network/dio_client.dart';
import '../../core/utils/json_parse.dart';

/// One utility tool (e.g. "Tính lãi suất"). `type` feeds the form/calc API.
class UtilityItem {
  const UtilityItem({required this.title, required this.type});
  final String title;
  final String type;
  factory UtilityItem.fromJson(Map j) => UtilityItem(
        title: asString(j['name'] ?? j['title']),
        type: asString(j['description'] ?? j['type'] ?? j['code']),
      );
}

class UtilityOption {
  const UtilityOption({required this.label, required this.value});
  final String label;
  final String value;
  factory UtilityOption.fromJson(Map j) => UtilityOption(
        label: asString(j['label'] ?? j['name'] ?? j['text']),
        value: asString(j['value'] ?? j['id']),
      );
}

class UtilityField {
  const UtilityField({
    required this.name,
    required this.label,
    required this.type,
    required this.required,
    required this.options,
    this.hint,
    this.unit,
  });
  final String name;
  final String label;
  final String type; // text | number | select | radio
  final bool required;
  final List<UtilityOption> options;
  final String? hint;
  final String? unit;

  factory UtilityField.fromJson(Map j) => UtilityField(
        name: asString(j['name'] ?? j['key']),
        label: asString(j['label'] ?? j['title']),
        type: asString(j['type'], fallback: 'text'),
        required: j['required'] == true || j['required'] == 1,
        hint: (j['placeholder'] ?? j['hint'])?.toString(),
        unit: (j['unit'] ?? j['suffix'])?.toString(),
        options: (j['options'] is List)
            ? (j['options'] as List)
                .whereType<Map>()
                .map(UtilityOption.fromJson)
                .toList()
            : const [],
      );
}

class UtilityForm {
  const UtilityForm({required this.title, required this.fields});
  final String title;
  final List<UtilityField> fields;
  factory UtilityForm.fromJson(Map j) => UtilityForm(
        title: asString(j['title'] ?? j['name']),
        fields: (j['fields'] is List)
            ? (j['fields'] as List)
                .whereType<Map>()
                .map(UtilityField.fromJson)
                .toList()
            : const [],
      );
}

class UtilitiesApi {
  UtilitiesApi(this._dio);
  final Dio _dio;

  List _list(dynamic data) {
    if (data is List) return data;
    if (data is Map) {
      for (final k in ['data', 'result', 'items']) {
        if (data[k] is List) return data[k] as List;
      }
    }
    return const [];
  }

  Map _map(dynamic data) {
    if (data is Map) {
      if (data['data'] is Map) return data['data'] as Map;
      return data;
    }
    return const {};
  }

  Future<List<UtilityItem>> fetchTools() async {
    final res = await _dio.get(
        '${AppConfig.customer}/news_by_folder.json',
        queryParameters: {'folder': 'tien-ich-agent'});
    return _list(res.data).whereType<Map>().map(UtilityItem.fromJson).toList();
  }

  Future<UtilityForm> fetchForm(String type) async {
    final res = await _dio.get('${AppConfig.public}/get_form_config.json',
        queryParameters: {'type': type});
    return UtilityForm.fromJson(_map(res.data));
  }

  /// Returns the result HTML.
  Future<String> calculate(Map<String, dynamic> data) async {
    final res = await _dio.post('${AppConfig.public}/calculate.json', data: data);
    final m = _map(res.data);
    return asString(m['html'] ?? m['content'] ?? m['result']);
  }
}

final utilitiesApiProvider =
    Provider<UtilitiesApi>((ref) => UtilitiesApi(ref.watch(dioProvider)));

final utilityToolsProvider =
    FutureProvider.autoDispose<List<UtilityItem>>((ref) {
  return ref.watch(utilitiesApiProvider).fetchTools();
});

final utilityFormProvider =
    FutureProvider.autoDispose.family<UtilityForm, String>((ref, type) {
  return ref.watch(utilitiesApiProvider).fetchForm(type);
});
