import '../../../../core/utils/json_parse.dart';

/// Agent award / rank (`get_award_detail_by_user.json`).
class AwardDetail {
  const AwardDetail({
    required this.id,
    this.name,
    this.description,
    this.code,
    this.htmlContent,
  });
  final int id;
  final String? name;
  final String? description;
  final String? code;
  final String? htmlContent;

  bool get hasAward => (name ?? '').trim().isNotEmpty;

  factory AwardDetail.fromJson(Map d) => AwardDetail(
        id: asInt(d['id']),
        name: d['name']?.toString(),
        description: d['description']?.toString(),
        code: d['code']?.toString(),
        htmlContent: (d['html_content'] ?? d['htmlcontent'])?.toString(),
      );
}
