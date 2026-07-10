import '../../../../core/config/app_config.dart';
import '../../../../core/utils/json_parse.dart';

/// A promotional banner from `news_by_folder.json?folder=thumbnail-agnet`.
class HomeBanner {
  const HomeBanner({
    required this.image,
    this.title,
    this.link,
    this.description,
    this.newsId,
  });

  final String image;
  final String? title;
  final String? link;

  /// Raw `description` (v1). Banners encode a `project/{id}` target here.
  final String? description;

  /// News/event id (v1 `NewModel.id`) — used to open the item's detail.
  final int? newsId;

  /// The `{id}` from a `project/{id}` description (v1 `extractProjectId`).
  String? get projectId {
    final d = description ?? '';
    if (!d.contains('project/')) return null;
    final parts = d.split('/');
    return parts.length == 2 ? parts[1] : null;
  }

  factory HomeBanner.fromJson(Map data) {
    final raw =
        (data['avatar'] ?? data['image'] ?? data['url'] ?? data['banner'] ?? '')
            .toString();
    return HomeBanner(
      image: AppConfig.imageUrl(raw) ?? '',
      title: (data['name'] ?? data['title'])?.toString(),
      link: (data['link'] ?? data['url'])?.toString(),
      description: data['description']?.toString(),
      newsId: asIntOrNull(data['id']),
    );
  }
}
