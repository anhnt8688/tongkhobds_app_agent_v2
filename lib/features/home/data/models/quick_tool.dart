import '../../../../core/config/app_config.dart';

/// A home "Công cụ nhanh" item from `news_by_folder.json?folder=19` (v1).
/// The backend drives both the icon (`avatar`) and the destination
/// (`description`, e.g. `/legal_lookup` or `/webview?url=...`).
class QuickTool {
  const QuickTool({
    required this.name,
    required this.icon,
    required this.description,
  });

  final String name;
  final String icon; // resolved absolute URL
  final String description; // routing path

  factory QuickTool.fromJson(Map data) {
    final raw = (data['avatar'] ?? data['image'] ?? '').toString();
    return QuickTool(
      name: (data['name'] ?? '').toString(),
      icon: AppConfig.imageUrl(raw) ?? '',
      description: (data['description'] ?? '').toString(),
    );
  }
}
