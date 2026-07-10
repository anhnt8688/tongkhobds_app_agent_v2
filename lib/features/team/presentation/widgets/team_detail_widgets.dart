import 'package:flutter/material.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/money_format.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../data/team_api.dart';

// ── Status accent colors (match v1 team_member_detail_page) ───────────────────
const _statusGreen = Color(0xFF22C55E);
const _statusAmber = Color(0xFFE1A100);
const _statusRed = Color(0xFFF04444);

/// Parse a `#RRGGBB` / `RRGGBB` hex string to a [Color]; null if unparseable.
Color? hexColor(String? raw) {
  if (raw == null) return null;
  var h = raw.trim().replaceAll('#', '');
  if (h.isEmpty) return null;
  if (h.length == 6) h = 'FF$h';
  if (h.length != 8) return null;
  final v = int.tryParse(h, radix: 16);
  return v == null ? null : Color(v);
}

// ── Map field readers (loosely-typed Web2py payloads) ─────────────────────────

String readMapStr(Map d, List<String> keys) {
  for (final k in keys) {
    final v = d[k];
    if (v != null && v.toString().trim().isNotEmpty) return v.toString().trim();
  }
  return '';
}

num readMapNum(Map d, List<String> keys) {
  for (final k in keys) {
    final v = d[k];
    if (v is num) return v;
    final p = num.tryParse(v?.toString() ?? '');
    if (p != null) return p;
  }
  return 0;
}

String readNestedStr(Map d, List<String> parents, List<String> keys) {
  for (final p in parents) {
    final n = d[p];
    if (n is Map) {
      final v = readMapStr(n, keys);
      if (v.isNotEmpty) return v;
    }
  }
  return readMapStr(d, keys);
}

num readNestedNum(Map d, List<String> parents, List<String> keys) {
  final direct = readMapNum(d, keys);
  if (direct != 0) return direct;
  for (final p in parents) {
    final n = d[p];
    if (n is Map) {
      final v = readMapNum(n, keys);
      if (v != 0) return v;
    }
  }
  return 0;
}

/// `data['items']` may be a List or a single Map.
List<Map> extractItems(Object? data) {
  if (data is! Map) return const [];
  final raw = data['items'] ?? data['members'] ?? data['data'];
  if (raw is List) return raw.whereType<Map>().toList();
  if (raw is Map) return [raw];
  return const [];
}

// ── Shared small widgets ──────────────────────────────────────────────────────

Widget teamStatusPill(String text, Color color) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text.isEmpty ? '--' : text,
          style: AppTypography.caption
              .copyWith(color: color, fontWeight: FontWeight.w600)),
    );

Widget teamChip(String label,
        {required Color background, required Color foreground}) =>
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label,
          style: AppTypography.micro
              .copyWith(color: foreground, fontWeight: FontWeight.w600)),
    );

Widget teamSectionHeader(String title) =>
    Text(title, style: AppTypography.subtitle.copyWith(fontWeight: FontWeight.w700));

Widget teamEmptyCard(String text) => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(text,
          textAlign: TextAlign.center,
          style: AppTypography.body.copyWith(color: AppColors.textMute)),
    );

// ── Revenue card ──────────────────────────────────────────────────────────────

class TeamRevenueCard extends StatelessWidget {
  const TeamRevenueCard({super.key, required this.revenue});
  final num revenue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.monetization_on_outlined,
                size: 17, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Doanh số',
                    style: AppTypography.caption
                        .copyWith(color: AppColors.textMute)),
                const SizedBox(height: 2),
                Text(formatMoney(revenue.toDouble()),
                    style: AppTypography.heading
                        .copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Summary tab cards (Giao dịch / Nguồn hàng / Thành viên) ────────────────────

class TeamSummaryTabs extends StatelessWidget {
  const TeamSummaryTabs({
    super.key,
    required this.activeIndex,
    required this.onChanged,
    required this.transactionCount,
    required this.inventoryCount,
    required this.memberCount,
  });

  final int activeIndex;
  final ValueChanged<int> onChanged;
  final int transactionCount;
  final int inventoryCount;
  final int memberCount;

  @override
  Widget build(BuildContext context) {
    final tabs = <({String title, String value})>[
      (title: 'Giao dịch', value: '$transactionCount'),
      (title: 'Nguồn hàng', value: '$inventoryCount'),
      (title: 'Thành viên', value: '$memberCount'),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 16) / 3;
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(tabs.length, (i) {
            final selected = activeIndex == i;
            return SizedBox(
              width: itemWidth,
              child: Material(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => onChanged(i),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary.withValues(alpha: 0.08)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : AppColors.border),
                    ),
                    child: Column(
                      children: [
                        Text(tabs[i].title,
                            textAlign: TextAlign.center,
                            style: AppTypography.micro.copyWith(
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.textMute)),
                        const SizedBox(height: 4),
                        Text(tabs[i].value,
                            style: AppTypography.heading.copyWith(
                                fontWeight: FontWeight.w700,
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.text)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

// ── Transaction card ──────────────────────────────────────────────────────────

Widget teamTransactionCard(Map item) {
  final code =
      readMapStr(item, ['transaction_code', 'code', 'transactionCode']);
  final reCode = readNestedStr(item, ['real_estate', 'product'],
      ['real_estate_code', 'code', 'member_code']);
  final client = readNestedStr(item, ['real_estate', 'product'],
      ['customer_name', 'buyer_name', 'seller_name', 'name']);
  final price = readNestedNum(item, ['real_estate'], ['price', 'amount']);
  final status = readMapStr(item, ['status_text', 'status_name', 'status']);
  final statusColor = _transactionStatusColor(item, status);

  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(code.isEmpty ? '--' : code,
                  style: AppTypography.subtitle
                      .copyWith(fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 8),
            teamStatusPill(status, statusColor),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          reCode.isEmpty
              ? (client.isEmpty ? '--' : client)
              : 'Mã BĐS: $reCode ${client.isNotEmpty ? client : ''}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 6),
        Text('Số tiền: ${formatMoney(price.toDouble())}',
            style:
                AppTypography.caption.copyWith(color: AppColors.textSecondary)),
      ],
    ),
  );
}

Color _transactionStatusColor(Map item, String status) {
  final hex = hexColor(readNestedStr(item, ['status_info'], ['color_code']));
  if (hex != null) return hex;
  final s = status.toLowerCase();
  if (s.contains('thành công') || s.contains('success')) {
    return const Color(0xFF58B368);
  }
  if (s.contains('khởi tạo') || s.contains('init')) return AppColors.primary;
  return AppColors.textSecondary;
}

// ── Inventory card ────────────────────────────────────────────────────────────

Widget teamInventoryCard(Map item) {
  final title = readMapStr(item, ['title', 'name', 'project_name']);
  final address =
      readMapStr(item, ['street_address', 'address', 'city', 'province_name']);
  final price = _inventoryPriceText(item);
  final area = _inventoryAreaText(item);
  final thumb = _inventoryThumbnail(item);
  final status = _inventoryStatusText(item);
  final statusColor = _inventoryStatusColor(item, status);

  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    width: double.infinity,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AppNetworkImage(
            url: AppConfig.imageUrl(thumb),
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
                  children: [
                    if (status.isNotEmpty) ...[
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: teamStatusPill(status, statusColor),
                      ),
                      const WidgetSpan(child: SizedBox(width: 6)),
                    ],
                    TextSpan(text: title.isEmpty ? '--' : title),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (price.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(price,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.subtitle.copyWith(
                        color: AppColors.primary, fontWeight: FontWeight.w700)),
              ],
              if (address.isNotEmpty) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 15, color: AppColors.textMute),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.caption
                              .copyWith(color: AppColors.textMute)),
                    ),
                  ],
                ),
              ],
              if (area.isNotEmpty) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.straighten,
                        size: 15, color: AppColors.textMute),
                    const SizedBox(width: 4),
                    Text(area,
                        style: AppTypography.caption
                            .copyWith(color: AppColors.textMute)),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

String _inventoryAreaText(Map item) {
  final raw = readMapNum(item, ['area', 'area_display', 'area_text']);
  if (raw <= 0) return '';
  final v = raw.toDouble();
  final t = v % 1 == 0 ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
  return '$t m²';
}

String _inventoryPriceText(Map item) {
  final t = readMapStr(item, ['price_description', 'price_display']);
  if (t.isNotEmpty) return t;
  final raw = readMapNum(item, ['price', 'amount']);
  if (raw <= 0) return '';
  return '${formatMoneyWithUnit(raw.toDouble())} đồng';
}

String _inventoryThumbnail(Map item) {
  final direct = readMapStr(
      item, ['thumbnail', 'main_image', 'mainImage', 'image', 'avatar']);
  if (direct.isNotEmpty) return direct;
  return readNestedStr(
      item, ['real_estate'], ['thumbnail', 'main_image', 'mainImage', 'image']);
}

String _inventoryStatusText(Map item) {
  final direct = readMapStr(item,
      ['status_text', 'status_name', 'status_label', 'status_title', 'status']);
  if (direct.isNotEmpty) return direct;
  return readNestedStr(item, ['status_info'],
      ['status_text', 'status_name', 'status_label', 'title', 'name']);
}

Color _inventoryStatusColor(Map item, String status) {
  final hex = hexColor(readMapStr(item, ['status_color', 'color_code'])) ??
      hexColor(readNestedStr(item, ['status_info'], ['status_color', 'color_code']));
  if (hex != null) return hex;
  final s = status.toLowerCase();
  if (s.contains('đã xác thực') ||
      s.contains('đã xác nhận') ||
      s.contains('verified') ||
      s.contains('thành công') ||
      s.contains('success')) {
    return _statusGreen;
  }
  if (s.contains('chờ xác thực') ||
      s.contains('chờ duyệt') ||
      s.contains('pending') ||
      s.contains('khởi tạo') ||
      s.contains('init')) {
    return _statusAmber;
  }
  return AppColors.textMute;
}

// ── Member card (renders from TeamMemberItem) ─────────────────────────────────

Widget teamMemberCard(TeamMemberItem m, {required VoidCallback? onTap}) {
  final statusText = m.statusText?.trim() ?? '';
  final statusColor = _memberStatusColor(m, statusText);

  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    child: Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: AppColors.primarySoft,
                    child: Text(
                      m.name.isEmpty
                          ? '?'
                          : m.name.characters.first.toUpperCase(),
                      style: AppTypography.caption
                          .copyWith(color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(m.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.body
                            .copyWith(fontWeight: FontWeight.w600)),
                  ),
                  if (statusText.isNotEmpty)
                    teamStatusPill(statusText, statusColor),
                ],
              ),
              const SizedBox(height: 4),
              Text(m.titleName,
                  style:
                      AppTypography.caption.copyWith(color: AppColors.textMute)),
              const SizedBox(height: 6),
              Text(
                'BDS: ${m.totalBds} | Giao dịch: ${m.deals} | Doanh số: ${formatMoney(m.revenue)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.caption
                    .copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Color _memberStatusColor(TeamMemberItem m, String statusText) {
  final hex = hexColor(m.statusColor);
  if (hex != null) return hex;
  if (statusText.contains('-')) return _statusRed;
  if (statusText.contains('+')) return _statusGreen;
  return AppColors.primary;
}
