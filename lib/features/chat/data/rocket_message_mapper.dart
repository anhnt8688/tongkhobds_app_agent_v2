import 'package:flutter_chat_core/flutter_chat_core.dart';

import '../../../core/config/app_config.dart';
import 'models/chat_message.dart';
import 'models/rocket_auth.dart';

/// Converts a RocketChat [ChatMessage] into a flutter_chat_ui [Message].
/// Media links are signed with `rc_uid`/`rc_token` query params so the default
/// image/file/video builders can load protected uploads without custom headers.
class RocketMessageMapper {
  const RocketMessageMapper(this.auth);
  final RocketAuth? auth;

  Message toUi(ChatMessage m) {
    final id = m.id ?? _fallbackId();
    final authorId = m.user?.id ?? 'system';
    final createdAt = _parseTs(m.ts);

    if (authorId == 'system') {
      return Message.system(id: id, authorId: authorId, createdAt: createdAt, text: m.msg ?? '');
    }

    for (final a in m.attachments) {
      final url = _signed(a.titleLink);
      if (url == null) continue;
      if (a.isImage) {
        return Message.image(id: id, authorId: authorId, createdAt: createdAt, source: url, text: m.msg);
      }
      if (a.isVideo) {
        return Message.video(id: id, authorId: authorId, createdAt: createdAt, source: url, text: m.msg, name: a.title);
      }
      return Message.file(
          id: id, authorId: authorId, createdAt: createdAt, source: url, name: a.title ?? 'file', size: a.size);
    }

    return Message.text(id: id, authorId: authorId, createdAt: createdAt, text: m.msg ?? '');
  }

  /// Absolute, token-signed URL for a Rocket upload path (`/file-upload/...`).
  String? _signed(String? link) {
    if (link == null || link.isEmpty) return null;
    final base = link.startsWith('http') ? link : '${AppConfig.rocketHost}$link';
    final uid = auth?.userId ?? '';
    final token = auth?.token ?? '';
    if (uid.isEmpty || token.isEmpty) return base;
    final sep = base.contains('?') ? '&' : '?';
    return '$base${sep}rc_uid=$uid&rc_token=$token';
  }

  static DateTime? _parseTs(String? ts) => tryTs(ts);

  /// Parses a RocketChat ISO timestamp to [DateTime] (null-safe).
  static DateTime? tryTs(String? ts) =>
      ts == null ? null : DateTime.tryParse(ts);

  static String _fallbackId() =>
      DateTime.now().microsecondsSinceEpoch.toString();
}
