import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/json_parse.dart';
import 'models/form_field_spec.dart';
import 'models/option_item.dart';

/// A selectable property type (id + label).
class PropertyType {
  const PropertyType(this.id, this.name);
  final int id;
  final String name;
}

/// Default commission range returned by the backend for given params
/// (`get_commission_default.json` → `data`).
class CommissionDefault {
  const CommissionDefault({
    this.min,
    this.max,
    this.editable = true,
    this.title = '',
    this.description = '',
  });
  final double? min;
  final double? max;
  final bool editable;
  final String title;
  final String description;
}

/// AI-generated description: raw HTML markup + the generated/suggested title.
class AiDescription {
  const AiDescription({required this.html, required this.title});
  final String html;
  final String title;

  /// Plain-text projection of [html] for the description input (tags stripped,
  /// common entities decoded, whitespace collapsed).
  String get plainText {
    var s = html
        .replaceAll(RegExp(r'<\s*br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</\s*(p|div|li|h[1-6])\s*>', caseSensitive: false),
            '\n')
        .replaceAll(RegExp(r'<[^>]+>'), '');
    s = s
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");
    return s
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .join('\n');
  }
}

class PostApi {
  PostApi(this._dio);

  final Dio _dio;

  /// Common Vietnamese real-estate types used as a fallback when the backend
  /// filter config does not return a usable list.
  static const _fallbackTypes = [
    PropertyType(1, 'Căn hộ/Chung cư'),
    PropertyType(2, 'Nhà phố'),
    PropertyType(3, 'Đất nền'),
    PropertyType(4, 'Biệt thự'),
    PropertyType(5, 'Văn phòng'),
    PropertyType(6, 'Kho/Xưởng'),
    PropertyType(7, 'Shophouse'),
  ];

  /// Real property types — `GET /api_customer/get_property_types.json?type=<t>`
  /// → `data[] { id, title, vietnamese, icon }` (matches v1 app). [type] is the
  /// transaction type (1 = bán, 2 = cho thuê).
  Future<List<PropertyType>> propertyTypes({int type = 1}) async {
    try {
      final res = await _dio.get(
        '${AppConfig.customer}/get_property_types.json',
        queryParameters: {'type': type},
      );
      final list = _findTypeList(res.data);
      if (list.isNotEmpty) return list;
    } catch (_) {
      // fall through to fallback
    }
    return _fallbackTypes;
  }

  /// Dynamic "Mô tả thêm" fields for a property type —
  /// `GET /api_customer/get_property_type_fields?property_type_id=<id>`
  /// → `data.fields_array[] { title, type }`.
  Future<List<FormFieldSpec>> propertyTypeFields(int propertyTypeId) async {
    final res = await _dio.get(
      '${AppConfig.customer}/get_property_type_fields',
      queryParameters: {'property_type_id': propertyTypeId},
    );
    // EnvelopeInterceptor already unwraps `{status,message,data}` → the inner
    // `data` object `{id, title, fields_array}`, so read `fields_array` straight
    // off it. Fall back to a nested `data` only if the envelope was bypassed.
    final data = res.data;
    Object? arr;
    if (data is Map) {
      arr = data['fields_array'];
      if (arr == null && data['data'] is Map) {
        arr = (data['data'] as Map)['fields_array'];
      }
    }
    if (arr is! List) return const [];
    return arr.whereType<Map>().map(FormFieldSpec.fromJson).toList();
  }

  /// Legal-document options — `GET /api/get_legal_documents.json`
  /// → (after envelope unwrap) `{documents:[{id,name}]}`. (v1 `fetchProject`;
  /// v1's `apiCommon` resolves to `/api`, not `/api_common`.)
  Future<List<OptionItem>> legalDocuments() => _optionList(
      '${AppConfig.public}/get_legal_documents.json', 'documents');

  /// Furniture (nội thất) options — `GET /api/get_furniture.json`
  /// → (after envelope unwrap) `{furniture:[{id,name}]}`. (v1 `furniture`.)
  Future<List<OptionItem>> furniture() =>
      _optionList('${AppConfig.public}/get_furniture.json', 'furniture');

  Future<List<OptionItem>> _optionList(String url, String key) async {
    final res = await _dio.get(url);
    // EnvelopeInterceptor already unwraps `{status,message,data}` → `res.data`
    // is the inner object `{<key>:[...]}`. Read the list straight off it; only
    // fall back to a nested `data` if the envelope was bypassed.
    final data = res.data;
    Object? list;
    if (data is Map) {
      list = data[key];
      if (list == null && data['data'] is Map) {
        list = (data['data'] as Map)[key];
      }
    }
    if (list is! List) return const [];
    return list.whereType<Map>().map(OptionItem.fromJson).toList();
  }

  List<PropertyType> _findTypeList(Object? data) {
    Object? node = data;
    if (node is Map) {
      node = node['data'] ?? node['property_types'] ?? node['property_type'];
    }
    if (node is List) {
      final out = <PropertyType>[];
      for (final e in node) {
        if (e is Map) {
          final id = asIntOrNull(e['id']);
          final name =
              (e['vietnamese'] ?? e['title'] ?? e['name'])?.toString();
          if (id != null && name != null && name.isNotEmpty) {
            out.add(PropertyType(id, name));
          }
        }
      }
      return out;
    }
    return const [];
  }

  /// AI-generates a listing description (v1 `createContentAi` logic, 1:1):
  /// success → `data.data` (HTML) + `data.title`; while the async pipeline is
  /// "đang được xử lý" → poll up to 6× with a 3s gap; any other failure → throw
  /// the server's [ApiException] so the UI shows its message.
  ///
  /// `rawEnvelope: true` keeps the full `{status,message,data}` so the success
  /// branch can read `data.data`. The backend still rejects `status == 0` at the
  /// interceptor (→ DioException/ApiException), so the "processing" state is
  /// detected from that error's message, mirroring v1's `isProcessing` branch.
  Future<AiDescription> generateDescription(Map<String, dynamic> info) async {
    const maxAttempts = 6;
    const processingHint = 'đang được xử lý';
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      final isLast = attempt == maxAttempts - 1;
      try {
        final res = await _dio.post(
          '${AppConfig.public}/generate_real_estate_sample.json',
          data: info,
          // AI generation is slow (LLM) and can exceed the global 30s receive
          // timeout, which would fail every time — give it a longer window.
          options: Options(
            extra: const {'rawEnvelope': true},
            receiveTimeout: const Duration(seconds: 90),
            sendTimeout: const Duration(seconds: 90),
          ),
        );
        // Raw shape: `{status, message, data:{data:"<html>", title}}` (v1).
        final root = res.data;
        _logGenerate(attempt, root);
        if (root is Map) {
          final payload = root['data'];
          if (payload is Map) {
            final html = (payload['data'] ?? '').toString();
            if (html.trim().isNotEmpty) {
              return AiDescription(
                html: html,
                title: (payload['title'] ?? '').toString(),
              );
            }
          }
          // status 1 but no html: treat a "đang được xử lý" message as still
          // processing → poll; otherwise give up (nothing produced).
          final message = (root['message'] ?? '').toString().toLowerCase();
          if (!message.contains(processingHint) || isLast) {
            return const AiDescription(html: '', title: '');
          }
        } else if (root is String && root.trim().isNotEmpty) {
          return AiDescription(html: root, title: '');
        }
      } on DioException catch (e) {
        // The interceptor turns `status == 0` into an ApiException. v1 retries
        // while it reports "đang được xử lý"; any other error is surfaced.
        final apiError = e.error is ApiException ? e.error as ApiException : null;
        if (kDebugMode) {
          debugPrint('🤖 [generate] attempt ${attempt + 1} ERROR '
              '(${apiError?.statusCode ?? e.response?.statusCode ?? '-'}): '
              '${apiError?.message ?? e.message} | raw=${e.response?.data}');
        }
        final message = (apiError?.message ?? '').toLowerCase();
        if (!message.contains(processingHint) || isLast) {
          throw apiError ?? e;
        }
      }
      await Future.delayed(const Duration(seconds: 3));
    }
    return const AiDescription(html: '', title: '');
  }

  /// Pretty-prints the raw AI-generate response (debug builds only).
  void _logGenerate(int attempt, Object? root) {
    if (!kDebugMode) return;
    String body;
    try {
      body = const JsonEncoder.withIndent('  ').convert(root);
    } catch (_) {
      body = root.toString();
    }
    if (body.length > 2000) body = '${body.substring(0, 2000)}…';
    debugPrint('🤖 [generate] attempt ${attempt + 1} response:\n$body');
  }

  Future<CommissionDefault> commissionDefault({
    int? cityId,
    int? districtId,
    int? wardId,
    double? area,
    double? price,
    int? propertyType,
  }) async {
    final res = await _dio.get(
      '${AppConfig.agent}/get_commission_default.json',
      queryParameters: {
        if (cityId != null) 'city_id': cityId,
        if (districtId != null) 'district_id': districtId,
        if (wardId != null) 'ward_id': wardId,
        if (area != null) 'area': area.toInt(),
        if (price != null) 'price': price.toInt(),
        if (propertyType != null) 'property_type': propertyType,
      },
    );
    final root = res.data is Map ? res.data as Map : {};
    // The payload may be wrapped in `data` (v1 shape) or flat.
    final data = root['data'] is Map ? root['data'] as Map : root;
    return CommissionDefault(
      min: asDoubleOrNull(data['minCommission'] ?? data['min_commission']),
      max: asDoubleOrNull(data['maxCommission'] ?? data['max_commission']),
      editable: data['updateCommission'] != false,
      title: asString(data['title']),
      description: asString(data['description']),
    );
  }

  /// Uploads a single file (image / video / document), returning its URL.
  Future<String?> uploadFile(String path) async {
    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(path),
    });
    final res = await _dio.post(
      '${AppConfig.customer}/upload_file.json',
      data: form,
    );
    return _extractUrl(res.data);
  }

  /// Back-compat alias for [uploadFile].
  Future<String?> uploadImage(String path) => uploadFile(path);

  String? _extractUrl(Object? data) {
    if (data is String && data.isNotEmpty) return data;
    if (data is Map) {
      final d = data['data'] ?? data['url'];
      if (d is String && d.isNotEmpty) return d;
      if (d is Map) return (d['url'] ?? d['link'])?.toString();
      if (d is List && d.isNotEmpty) return d.first.toString();
    }
    if (data is List && data.isNotEmpty) return data.first.toString();
    return null;
  }

  /// Submits the new listing. Backend expects an array-wrapped object.
  ///
  /// Reads the raw envelope: the created id (`product_id`/`real_estate_id`) and
  /// `real_estate_salesman_id` can sit either at the envelope root OR nested in
  /// `data` (this Web2py backend is inconsistent — same quirk as the
  /// permissions-sibling-to-data case), so probe both.
  Future<({int id, int? salesmanId})> save(Map<String, dynamic> listing) async {
    final res = await _dio.post(
      '${AppConfig.agent}/save_real_estate.json',
      data: [listing],
      options: Options(extra: {'rawEnvelope': true}),
    );
    final root = res.data is Map ? res.data as Map : const {};
    final inner = root['data'] is Map ? root['data'] as Map : const {};

    int? pick(String key) => asIntOrNull(root[key] ?? inner[key]);
    final id = pick('product_id') ?? pick('real_estate_id') ?? pick('id') ?? 0;
    final salesmanId = pick('real_estate_salesman_id');
    return (id: id, salesmanId: salesmanId);
  }
}

final postApiProvider = Provider<PostApi>((ref) => PostApi(ref.watch(dioProvider)));

/// Property types for the given transaction type (1 = bán, 2 = cho thuê).
final propertyTypesProvider =
    FutureProvider.autoDispose.family<List<PropertyType>, int>((ref, type) {
  return ref.watch(postApiProvider).propertyTypes(type: type);
});

/// Dynamic "Mô tả thêm" fields for the selected property type.
final propertyTypeFieldsProvider =
    FutureProvider.autoDispose.family<List<FormFieldSpec>, int>((ref, id) {
  return ref.watch(postApiProvider).propertyTypeFields(id);
});

final legalDocumentsProvider =
    FutureProvider.autoDispose<List<OptionItem>>((ref) {
  return ref.watch(postApiProvider).legalDocuments();
});

final furnitureProvider = FutureProvider.autoDispose<List<OptionItem>>((ref) {
  return ref.watch(postApiProvider).furniture();
});
