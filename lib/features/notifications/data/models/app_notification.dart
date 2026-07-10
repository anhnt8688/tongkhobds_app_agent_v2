import '../../../../core/config/app_config.dart';
import '../../../../core/utils/json_parse.dart';

/// Mirrors v1 NotificationModel (an item from `list_tmessage.json`).
class AppNotification {
  const AppNotification({
    this.id,
    this.title = '',
    this.content = '',
    this.tablename,
    this.tableId,
    this.createdOn,
    this.isRead = false,
    this.link,
    this.tmessageType,
    this.image,
  });

  final int? id;
  final String title;
  final String content;
  final String? tablename;
  final int? tableId;
  final DateTime? createdOn;
  final bool isRead;
  final String? link;
  final int? tmessageType;
  final String? image;

  // Compatibility getters used elsewhere (e.g. the home "việc cần làm" card).
  bool get read => isRead;
  String get message => content;

  factory AppNotification.fromJson(Map data) => AppNotification(
        id: asIntOrNull(data['id']),
        title: asString(data['title']),
        content: asString(data['content'] ?? data['message'] ?? data['body']),
        tablename: data['tablename']?.toString(),
        tableId: asIntOrNull(data['table_id']),
        createdOn: (data['created_on'] ?? data['created_at']) != null
            ? DateTime.tryParse(
                (data['created_on'] ?? data['created_at']).toString())
            : null,
        isRead: data['is_read'] == true ||
            data['is_read'] == 1 ||
            data['read'] == true ||
            data['read'] == 1,
        link: data['link']?.toString(),
        tmessageType: asIntOrNull(data['tmessage_type']),
        image: AppConfig.imageUrl(data['image']?.toString()),
      );
}
