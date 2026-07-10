import '../../../../core/utils/json_parse.dart';

/// A team member row (`api_team_members` / `api_sub_members` /
/// `api_member_subordinates`). v1 `_TeamMemberItem` + member-card fields.
class TeamMemberItem {
  const TeamMemberItem({
    required this.salesmanId,
    required this.name,
    this.phone,
    this.image,
    this.memberCode,
    this.titleName = '--',
    this.childrenCount = 0,
    this.totalTeamMembers = 0,
    this.revenue = 0,
    this.deals = 0,
    this.totalBds = 0,
    this.statusText,
    this.statusColor,
    this.children = const [],
    this.referrals = const [],
  });

  final int salesmanId;
  final String name;
  final String? phone;
  final String? image;
  final String? memberCode;
  final String titleName;
  final int childrenCount;
  final int totalTeamMembers;
  final double revenue;
  final int deals;
  final int totalBds;

  /// Growth / status badge text (`status_text` → `growth_label` …).
  final String? statusText;

  /// Optional badge color hint (`status_color` / `color_code`).
  final String? statusColor;

  /// Nested children when a sub-members response embeds the hierarchy.
  final List<TeamMemberItem> children;
  final List<TeamMemberItem> referrals;

  bool get hasChildren => childrenCount > 0 || totalTeamMembers > 0;

  static List<TeamMemberItem> _kids(Object? v) =>
      v is List ? v.whereType<Map>().map(TeamMemberItem.fromJson).toList() : const [];

  factory TeamMemberItem.fromJson(Map d) => TeamMemberItem(
        salesmanId: asInt(d['salesman_id'] ?? d['id'] ?? d['member_id']),
        name: (d['name'] ?? '--').toString(),
        phone: (d['phone'] ?? d['mobile'] ?? d['phone_number'])?.toString(),
        image: (d['image'] ?? d['avatar'])?.toString(),
        memberCode: (d['member_code'] ??
                d['name_code'] ??
                d['agent_code'] ??
                d['code'])
            ?.toString(),
        titleName: (d['title_name'] ?? d['title_code'] ?? '--').toString(),
        childrenCount: asInt(d['children_count'] ??
            d['direct_subordinates'] ??
            d['subordinates_count']),
        totalTeamMembers:
            asInt(d['total_team_members'] ?? d['total_descendants']),
        revenue:
            asDoubleOrNull(d['total_revenue'] ?? d['personal_revenue']) ?? 0,
        deals: asInt(d['total_deals'] ?? d['personal_deals']),
        totalBds: asInt(d['total_bds'] ?? d['total_listings']),
        statusText: (d['status_text'] ??
                d['status_name'] ??
                d['growth_label'] ??
                d['title_change_label'])
            ?.toString(),
        statusColor: (d['status_color'] ?? d['color_code'])?.toString(),
        children: _kids(d['children']),
        referrals: _kids(d['referrals']),
      );
}
