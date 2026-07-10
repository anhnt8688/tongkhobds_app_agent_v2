import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../utils/json_parse.dart';
import 'dio_client.dart';

/// A selectable tag option inside a [TagGroup].
class TagOption {
  const TagOption({required this.id, required this.name, this.color});
  final int id;
  final String name;
  final String? color; // hex, optional

  factory TagOption.fromJson(Map d) => TagOption(
        id: asInt(d['id'] ?? d['tag_id']),
        name: (d['name'] ?? d['tag_name'] ?? '').toString(),
        color: (d['color'] ?? d['tag_color'])?.toString(),
      );
}

/// A group of tags from `list_tags.json`
/// (`{group_id, group_name, selection_type, tags:[...]}`).
class TagGroup {
  const TagGroup({
    required this.id,
    required this.name,
    this.single = false,
    this.items = const [],
  });
  final int id;
  final String name;
  final bool single; // selection_type == 'single'
  final List<TagOption> items;

  factory TagGroup.fromJson(Map d) => TagGroup(
        id: asInt(d['group_id'] ?? d['id']),
        name: (d['group_name'] ?? d['name'] ?? '').toString(),
        single: (d['selection_type']?.toString() ?? 'multiple') == 'single',
        items: ((d['tags'] ?? d['items']) is List
                ? (d['tags'] ?? d['items']) as List
                : const [])
            .whereType<Map>()
            .map(TagOption.fromJson)
            .where((t) => t.name.isNotEmpty)
            .toList(),
      );
}

/// Entity types accepted by the generic tag endpoint.
enum TagEntity {
  consultation('consultation', 'DEMAND'),
  consultationSell('consultation_sell', 'SALE-DEMAND');

  const TagEntity(this.type, this.defaultCategory);
  final String type;
  final String defaultCategory;
}

/// Generic tag client. Reuses v1's Flutter-native `/api_agent/list_tags`:
/// GET returns the tag groups; POST assigns tags to an entity with replace
/// semantics (send the full desired `tag_ids[]`, not a delta).
class TagsApi {
  TagsApi(this._dio);
  final Dio _dio;
  String get _a => AppConfig.agent;

  List _listOf(Object? data) {
    if (data is List) return data;
    if (data is Map) {
      for (final k in ['data', 'items', 'groups']) {
        if (data[k] is List) return data[k] as List;
      }
    }
    return const [];
  }

  Future<List<TagGroup>> listTags({String categoryCode = 'DEMAND'}) async {
    final res = await _dio.get('$_a/list_tags.json',
        queryParameters: {'category_code': categoryCode});
    return _listOf(res.data)
        .whereType<Map>()
        .map(TagGroup.fromJson)
        .where((g) => g.items.isNotEmpty)
        .toList();
  }

  /// Replace the full set of tags on an entity. Pass every tag id that should
  /// remain assigned.
  Future<void> assignTags({
    required TagEntity entity,
    required int entityId,
    required List<int> tagIds,
  }) async {
    await _dio.post('$_a/list_tags.json', data: {
      'entity_type': entity.type,
      'entity_id': entityId,
      'tag_ids': tagIds,
    });
  }
}

final tagsApiProvider = Provider<TagsApi>((ref) => TagsApi(ref.watch(dioProvider)));

/// Tag groups for a category (default the consultation/"DEMAND" set).
final tagGroupsProvider =
    FutureProvider.autoDispose.family<List<TagGroup>, String>((ref, category) {
  return ref.watch(tagsApiProvider).listTags(categoryCode: category);
});
