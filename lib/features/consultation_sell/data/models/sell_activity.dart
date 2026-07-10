import '../../../../core/utils/json_parse.dart';

/// A work/activity on a sell lead (`get_activities_consultation_sell`).
class SellWork {
  const SellWork({
    required this.workId,
    this.name,
    this.type,
    this.status,
    this.startedAt,
    this.createdAt,
    this.meetingPlace,
    this.depositAmount,
    this.commentCount = 0,
  });
  final int workId;
  final String? name;
  final String? type; // appointment / deposit / note / call
  final String? status;
  final String? startedAt;
  final String? createdAt;
  final String? meetingPlace;
  final double? depositAmount;
  final int commentCount;

  factory SellWork.fromJson(Map d) => SellWork(
        workId: asInt(d['work_id'] ?? d['id']),
        name: (d['work_name'] ?? d['name'])?.toString(),
        type: (d['work_type'] ?? d['work_subtype'])?.toString(),
        status: d['status']?.toString(),
        startedAt: d['started_at']?.toString(),
        createdAt: (d['created_at'] ?? d['created_on'])?.toString(),
        meetingPlace: d['meeting_place']?.toString(),
        depositAmount: asDoubleOrNull(d['amount_deposit'] ?? d['deposit_amount']),
        commentCount: asInt(d['comment_count']),
      );
}

/// A comment on a sell lead (`consultation_sell_get_comments`).
class SellComment {
  const SellComment(
      {required this.id, this.content, this.createdByName, this.createdAt});
  final int id;
  final String? content;
  final String? createdByName;
  final String? createdAt;

  factory SellComment.fromJson(Map d) => SellComment(
        id: asInt(d['id']),
        content: (d['content_comment'] ?? d['content'])?.toString(),
        createdByName: (d['created_by_name'] ??
                (d['user'] is Map ? d['user']['name'] : d['created_by']))
            ?.toString(),
        createdAt: (d['created_at'] ?? d['created_on'])?.toString(),
      );
}

/// A tag-assignment log entry (`get_entity_tag_history.json`).
class SellTagLog {
  const SellTagLog({
    required this.id,
    this.tagName,
    this.tagColor,
    this.action,
    this.userName,
    this.createdAt,
  });
  final int id;
  final String? tagName;
  final String? tagColor;
  final String? action; // assign / remove
  final String? userName;
  final String? createdAt;

  /// "Thêm tag" for assign, "Gỡ tag" for remove.
  String get actionLabel => action == 'remove' ? 'Gỡ tag' : 'Thêm tag';

  factory SellTagLog.fromJson(Map d) {
    // `get_entity_tag_history.json`: the actor's display name is `name`,
    // `user_name` is the phone/login. The tag itself lives in `tag_info`.
    final tagInfo = d['tag_info'] is Map ? d['tag_info'] as Map : const {};
    return SellTagLog(
      id: asInt(d['id']),
      tagName: (d['tag_name'] ?? tagInfo['name'])?.toString(),
      tagColor: (d['tag_color'] ?? tagInfo['color'] ?? d['color'])?.toString(),
      action: d['action']?.toString(),
      userName: (d['full_name'] ??
              d['name'] ??
              d['created_by_name'] ??
              d['user_name'])
          ?.toString(),
      createdAt:
          (d['time_text'] ?? d['created_at'] ?? d['created_on'])?.toString(),
    );
  }
}

/// A potential duplicate (`check_duplicate_consultation_sell`).
class SellDuplicate {
  const SellDuplicate({required this.id, this.code, this.customerName});
  final int id;
  final String? code;
  final String? customerName;
  factory SellDuplicate.fromJson(Map d) => SellDuplicate(
        id: asInt(d['id']),
        code: (d['demand_code'] ?? d['code'])?.toString(),
        customerName: d['customer_name']?.toString(),
      );
}
