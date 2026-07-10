import '../../../../core/config/app_config.dart';
import '../../../../core/utils/json_parse.dart';

/// One work/activity entry on a consultation timeline (`activities_consultation`).
class ActivityWork {
  const ActivityWork({
    required this.workId,
    this.name,
    this.subtype,
    this.description,
    this.status,
    this.resultLabel,
    this.resultColor,
    this.startedAt,
    this.createdAt,
    this.meetingPlace,
    this.sendChannel,
    this.depositAmount,
    this.reasonLabel,
    this.commentCount = 0,
    this.createdByName,
  });

  final int workId;
  final String? name;
  final String? subtype; // call_owner/send_customer/appointment/deposit/...
  final String? description;
  final String? status;
  final String? resultLabel;
  final String? resultColor;
  final String? startedAt;
  final String? createdAt;
  final String? meetingPlace;
  final String? sendChannel;
  final double? depositAmount;
  final String? reasonLabel;
  final int commentCount;
  final String? createdByName;

  factory ActivityWork.fromJson(Map d) {
    final by = d['created_by'];
    return ActivityWork(
      workId: asInt(d['work_id'] ?? d['id']),
      name: (d['work_name'] ?? d['name'])?.toString(),
      subtype: (d['work_subtype'] ?? d['work_type'])?.toString(),
      description: d['description']?.toString(),
      status: d['status']?.toString(),
      resultLabel: d['result_label']?.toString(),
      resultColor: d['result_color']?.toString(),
      startedAt: d['started_at']?.toString(),
      createdAt: (d['created_at'] ?? d['created_on'])?.toString(),
      meetingPlace: d['meeting_place']?.toString(),
      sendChannel: d['send_channel']?.toString(),
      depositAmount: asDoubleOrNull(d['amount_deposit'] ?? d['deposit_amount']),
      reasonLabel: d['reason_label']?.toString(),
      commentCount: asInt(d['comment_count']),
      createdByName: by is Map ? by['name']?.toString() : by?.toString(),
    );
  }
}

/// An internal note (`salesman_comments`).
class DemandComment {
  const DemandComment({
    required this.id,
    this.content,
    this.type,
    this.createdByName,
    this.createdAt,
  });
  final int id;
  final String? content;
  final String? type;
  final String? createdByName;
  final String? createdAt;

  factory DemandComment.fromJson(Map d) => DemandComment(
    id: asInt(d['id']),
    content: d['content']?.toString(),
    type: d['comment_type']?.toString(),
    createdByName: (d['created_by_name'] ?? d['created_by'])?.toString(),
    createdAt: (d['created_at'] ?? d['created_on'])?.toString(),
  );
}

/// A tag assign/remove entry (`get_entity_tag_history.json`).
class DemandTagLog {
  const DemandTagLog({
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

  /// "Thêm thẻ" for assign, "Gỡ thẻ" for remove.
  String get actionLabel => action == 'remove' ? 'Gỡ thẻ' : 'Thêm thẻ';

  factory DemandTagLog.fromJson(Map d) {
    // `get_entity_tag_history.json`: the actor's display name is `name`,
    // `user_name` is the phone/login. The tag itself lives in `tag_info`.
    final tagInfo = d['tag_info'] is Map ? d['tag_info'] as Map : const {};
    return DemandTagLog(
      id: asInt(d['id']),
      tagName: (d['tag_name'] ?? tagInfo['name'])?.toString(),
      tagColor: (d['tag_color'] ?? tagInfo['color'] ?? d['color'])?.toString(),
      action: d['action']?.toString(),
      userName:
          (d['full_name'] ??
                  d['user_full_name'] ??
                  d['name'] ??
                  d['created_by_name'] ??
                  d['user_name'] ??
                  d['username'])
              ?.toString(),
      createdAt: (d['time_text'] ?? d['created_at'] ?? d['created_on'])
          ?.toString(),
    );
  }
}

/// A property the consultation is "working on" (`get_consultation_interests_all`).
class ConsultationInterest {
  const ConsultationInterest({
    required this.id,
    this.realEstateId,
    this.code,
    this.title,
    this.address,
    this.price,
    this.area,
    this.image,
    this.slug,
    this.agentName,
    this.agentPhone,
    this.isOriginal = false,
    this.status,
  });

  final int id;
  final int? realEstateId;
  final String? code;
  final String? title;
  final String? address;
  final double? price;
  final num? area;
  final String? image;
  final String? slug;
  final String? agentName;
  final String? agentPhone;
  final bool isOriginal;
  final String? status;

  /// Public share link for the BĐS (`webBase/bds/{slug}` or ID fallback).
  String? get shareLink {
    final s = (slug ?? '').isNotEmpty ? slug : realEstateId?.toString();
    if (s == null || s.isEmpty) return null;
    return '${AppConfig.webBase}/bds/$s';
  }

  factory ConsultationInterest.fromJson(Map d) {
    final re = d['real_estate'];
    final reMap = re is Map ? re : const {};
    final agent =
        d['listing_manager'] ??
        d['agent'] ??
        d['salesman'] ??
        d['salesman_info'] ??
        d['owner'] ??
        reMap['verified_by_agent_info'] ??
        reMap['salesman_info'];

    // Sometimes the agent name comes directly as a string or in other fields.
    final rawAgentName =
        (agent is Map ? (agent['name'] ?? agent['full_name']) : agent) ??
        d['salesman_name'] ??
        d['owner_name'];
    final rawAgentPhone =
        (agent is Map ? agent['phone'] : null) ?? d['owner_phone'];

    return ConsultationInterest(
      id: asInt(d['id']),
      realEstateId: asIntOrNull(d['real_estate_id'] ?? reMap['id']),
      code: (d['real_estate_code'] ?? reMap['code'])?.toString(),
      title: reMap['title']?.toString(),
      slug: (reMap['slug'] ?? d['slug'])?.toString(),
      address: reMap['address']?.toString(),
      price: asDoubleOrNull(reMap['price']),
      area: asDoubleOrNull(reMap['area']),
      image: AppConfig.imageUrl(reMap['main_image']?.toString()),
      agentName: rawAgentName?.toString(),
      agentPhone: rawAgentPhone?.toString(),
      isOriginal: d['is_original_property'] == true,
      status: d['status']?.toString(),
    );
  }
}

/// Interest section stats.
class InterestStats {
  const InterestStats({
    this.totalBds = 0,
    this.totalOwners = 0,
    this.totalAppointments = 0,
    this.processingDays = 0,
  });
  final int totalBds;
  final int totalOwners;
  final int totalAppointments;
  final int processingDays;

  factory InterestStats.fromJson(Map d) => InterestStats(
    totalBds: asInt(d['total_bds']),
    totalOwners: asInt(d['total_owners']),
    totalAppointments: asInt(d['total_appointments']),
    processingDays: asInt(d['processing_days']),
  );
}

/// Interests payload = items + stats.
class InterestsResult {
  const InterestsResult({
    this.items = const [],
    this.stats = const InterestStats(),
  });
  final List<ConsultationInterest> items;
  final InterestStats stats;
}

/// A "not suitable" reason option (`get_not_suitable_reasons`).
class NotSuitableReason {
  const NotSuitableReason({
    required this.code,
    required this.label,
    this.noteRequired = false,
  });
  final String code;
  final String label;
  final bool noteRequired;

  factory NotSuitableReason.fromJson(Map d) => NotSuitableReason(
    code: (d['code'] ?? '').toString(),
    label: (d['label'] ?? d['name'] ?? '').toString(),
    noteRequired: d['is_note_required'] == true,
  );
}
