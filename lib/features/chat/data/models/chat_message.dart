import '../../../../core/utils/json_parse.dart';

/// RocketChat user embedded on a message (v1 ChatUserModel).
class ChatUser {
  const ChatUser({this.id, this.username, this.name});
  final String? id;
  final String? username;
  final String? name;

  factory ChatUser.fromJson(Map d) => ChatUser(
        id: d['_id']?.toString(),
        username: d['username']?.toString(),
        name: d['name']?.toString(),
      );
}

/// A file/image/video attachment on a message (v1 FileModel).
class ChatAttachment {
  const ChatAttachment({
    this.title,
    this.titleLink,
    this.imageType,
    this.videoType,
    this.size,
    this.description,
  });

  final String? title;
  final String? titleLink;
  final String? imageType;
  final String? videoType;
  final int? size;
  final String? description;

  bool get isImage => imageType != null;
  bool get isVideo => videoType != null;

  factory ChatAttachment.fromJson(Map d) => ChatAttachment(
        title: d['title']?.toString(),
        titleLink: d['title_link']?.toString(),
        imageType: d['image_type']?.toString(),
        videoType: d['video_type']?.toString(),
        size: asIntOrNull(d['size']),
        description: d['description']?.toString(),
      );
}

/// A RocketChat message (v1 ChatModel). `ts` is an ISO string (realtime frames
/// arrive as `{$date: millis}` and are normalised before parsing).
class ChatMessage {
  const ChatMessage({
    this.id,
    this.rid,
    this.msg,
    this.ts,
    this.user,
    this.updatedAt,
    this.attachments = const [],
  });

  final String? id;
  final String? rid;
  final String? msg;
  final String? ts;
  final ChatUser? user;
  final String? updatedAt;
  final List<ChatAttachment> attachments;

  factory ChatMessage.fromJson(Map d) => ChatMessage(
        id: d['_id']?.toString(),
        rid: d['rid']?.toString(),
        msg: d['msg']?.toString(),
        ts: _normalizeTs(d['ts']),
        user: d['u'] is Map ? ChatUser.fromJson(d['u'] as Map) : null,
        updatedAt: _normalizeTs(d['_updatedAt']),
        attachments: d['attachments'] is List
            ? (d['attachments'] as List)
                .whereType<Map>()
                .map(ChatAttachment.fromJson)
                .toList()
            : const [],
      );

  /// RocketChat timestamps come as an ISO string (REST) or `{$date: millis}`
  /// (DDP realtime) — normalise both to an ISO string.
  static String? _normalizeTs(Object? v) {
    if (v == null) return null;
    if (v is Map && v[r'$date'] is int) {
      return DateTime.fromMillisecondsSinceEpoch(v[r'$date'] as int)
          .toIso8601String();
    }
    return v.toString();
  }
}
