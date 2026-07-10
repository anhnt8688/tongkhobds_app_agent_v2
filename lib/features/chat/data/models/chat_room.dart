import '../../../../core/utils/json_parse.dart';

/// A conversation in the inbox (v1 ChatWithAdminModel, from `get_list_message`).
class ChatRoom {
  const ChatRoom({
    this.name,
    this.roomId,
    this.messageTime,
    this.messageRefresh,
    this.username,
    this.messageContent,
    this.image,
    this.app,
    this.botId,
    this.projectId,
    this.countMiss = 0,
    this.seen = false,
  });

  final String? name;
  final String? roomId;
  final String? messageTime;
  final String? messageRefresh;
  final String? username;
  final String? messageContent;
  final String? image;
  final String? app;
  final String? botId;
  final Object? projectId; // backend sends int or string
  final int countMiss;
  final bool seen;

  int get projectIdInt => asInt(projectId);

  factory ChatRoom.fromJson(Map d) => ChatRoom(
        name: d['name']?.toString(),
        roomId: d['room_id']?.toString(),
        messageTime: d['message_time']?.toString(),
        messageRefresh: d['message_refresh']?.toString(),
        username: d['username']?.toString(),
        messageContent: d['message_content']?.toString(),
        image: d['image']?.toString(),
        app: d['app']?.toString(),
        botId: d['id_bot']?.toString(),
        projectId: d['project_id'],
        countMiss: asInt(d['count_miss']),
        seen: d['seen'] == true || d['seen'] == 1 || d['seen'] == '1',
      );

  ChatRoom copyWith({String? messageContent, String? messageTime, int? countMiss}) =>
      ChatRoom(
        name: name,
        roomId: roomId,
        messageTime: messageTime ?? this.messageTime,
        messageRefresh: messageRefresh,
        username: username,
        messageContent: messageContent ?? this.messageContent,
        image: image,
        app: app,
        botId: botId,
        projectId: projectId,
        countMiss: countMiss ?? this.countMiss,
        seen: seen,
      );
}
