import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../../core/network/dio_client.dart';
import '../../core/utils/json_parse.dart';

/// A legal/policy archive item.
class LegalItem {
  const LegalItem({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.summary,
    required this.createdOn,
    this.htmlContent,
  });
  final int id;
  final String name;
  final String? thumbnail;
  final String summary;
  final String createdOn;
  final String? htmlContent;

  factory LegalItem.fromJson(Map j) => LegalItem(
        id: asInt(j['id']),
        name: asString(j['name'] ?? j['title']),
        thumbnail: AppConfig.imageUrl(
            (j['thumbnail'] ?? j['image'] ?? j['avatar'])?.toString()),
        summary: asString(j['description'] ?? j['summary'] ?? j['short_description']),
        createdOn: asString(j['created_on'] ?? j['created_at']),
        htmlContent:
            (j['htmlcontent'] ?? j['html_content'] ?? j['content'])?.toString(),
      );
}

class LegalApi {
  LegalApi(this._dio);
  final Dio _dio;

  List _list(dynamic data) {
    if (data is List) return data;
    if (data is Map) {
      for (final k in ['data', 'result', 'items', 'archives']) {
        if (data[k] is List) return data[k] as List;
      }
    }
    return const [];
  }

  Map _map(dynamic data) {
    if (data is Map) {
      if (data['result'] is Map) return data['result'] as Map;
      if (data['data'] is Map) return data['data'] as Map;
      return data;
    }
    return const {};
  }

  Future<List<LegalItem>> search({String keyword = ''}) async {
    final res = await _dio.get('${AppConfig.agent}/archives_by_folder.json',
        queryParameters: {if (keyword.isNotEmpty) 'key': keyword});
    return _list(res.data).whereType<Map>().map(LegalItem.fromJson).toList();
  }

  Future<LegalItem> detail(int id) async {
    final res = await _dio
        .get('${AppConfig.agent}/archive_by_id.json', queryParameters: {'id': id});
    return LegalItem.fromJson(_map(res.data));
  }
}

final legalApiProvider =
    Provider<LegalApi>((ref) => LegalApi(ref.watch(dioProvider)));

final legalSearchProvider =
    FutureProvider.autoDispose.family<List<LegalItem>, String>((ref, keyword) {
  return ref.watch(legalApiProvider).search(keyword: keyword);
});

final legalDetailProvider =
    FutureProvider.autoDispose.family<LegalItem, int>((ref, id) {
  return ref.watch(legalApiProvider).detail(id);
});
