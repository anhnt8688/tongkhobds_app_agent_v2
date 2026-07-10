import '../../../../core/config/app_config.dart';

/// A "đăng bán" post template for a listing (`get_news_by_real_estate.json` →
/// `data.posts[]`). Mirrors v1 `RealEstateNewsPostModel`.
class SellNewsPost {
  const SellNewsPost({
    required this.postId,
    required this.menuName,
    required this.content,
    required this.images,
  });

  final String postId;
  final String menuName;

  /// HTML content of the post (edited in place before sharing).
  final String content;
  final List<String> images;

  factory SellNewsPost.fromJson(Map json) => SellNewsPost(
        postId: (json['post_id'] ?? '').toString(),
        menuName: (json['menu_name'] ?? '').toString(),
        content: (json['content'] ?? '').toString(),
        images: (json['images'] as List? ?? const [])
            .map((e) => e.toString())
            .where((e) => e.trim().isNotEmpty)
            .toList(),
      );

  SellNewsPost copyWith({String? content, List<String>? images}) =>
      SellNewsPost(
        postId: postId,
        menuName: menuName,
        content: content ?? this.content,
        images: images ?? this.images,
      );

  /// Resolves post images to absolute URLs, falling back to [fallback] (the
  /// listing gallery) when the post has none. De-duplicated.
  List<String> resolvedImages(List<String> fallback) {
    final source = images.isEmpty ? fallback : images;
    return source
        .map(_resolveUrl)
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();
  }

  static String _resolveUrl(String raw) {
    final v = raw.trim();
    if (v.isEmpty) return '';
    if (v.startsWith('/http')) return v.substring(1);
    if (v.startsWith('http')) return v;
    return AppConfig.imageUrl(v) ?? '';
  }
}
