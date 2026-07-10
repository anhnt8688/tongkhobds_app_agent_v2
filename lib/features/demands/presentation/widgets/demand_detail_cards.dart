import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/demand.dart';
import '../demands_screen.dart' show demandStatusBadge, demandTagChip;

/// Uppercase muted section label (e.g. "NHU CẦU MONG MUỐN").
class DemandSectionLabel extends StatelessWidget {
  const DemandSectionLabel(this.text, {super.key, this.trailing});
  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
      child: Row(
        children: [
          Text(text.toUpperCase(),
              style: AppTypography.micro.copyWith(
                  color: AppColors.textMute,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4)),
          if (trailing != null) ...[const Spacer(), trailing!],
        ],
      ),
    );
  }
}

Widget _card({required Widget child}) => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );

/// Initials from a full name (up to 2 letters).
String demandInitials(String? name) {
  final parts = (name ?? '').trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty);
  if (parts.isEmpty) return '?';
  final letters = parts.map((p) => p[0].toUpperCase()).toList();
  return letters.length == 1 ? letters.first : '${letters[letters.length - 2]}${letters.last}';
}

/// Customer summary card — avatar, name + KH tag, phone, status, tags row.
class DemandCustomerCard extends StatelessWidget {
  const DemandCustomerCard({super.key, required this.detail, this.onManage});
  final DemandDetail detail;
  final VoidCallback? onManage;

  @override
  Widget build(BuildContext context) {
    final d = detail;
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.primarySoft,
                  shape: BoxShape.circle,
                ),
                child: Text(demandInitials(d.customerName),
                    style: AppTypography.subtitle.copyWith(
                        color: AppColors.primary, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Flexible(
                        child: Text(d.customerName ?? 'Khách hàng',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.subtitle
                                .copyWith(fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: Text('KH',
                            style: AppTypography.micro.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700)),
                      ),
                    ]),
                    if ((d.customerPhone ?? '').isNotEmpty)
                      Text(d.customerPhone!,
                          style: AppTypography.caption
                              .copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              demandStatusBadge(
                  d.statusLabel, d.statusName?.color, d.statusEnum?.tone),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: AppColors.border),
          ),
          Row(
            children: [
              Text('THẺ GẮN',
                  style: AppTypography.micro.copyWith(
                      color: AppColors.textMute, fontWeight: FontWeight.w700)),
              const Spacer(),
              if (onManage != null)
                GestureDetector(
                  onTap: onManage,
                  child: Text('Quản lý',
                      style: AppTypography.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (d.tags.isEmpty)
            Text('Chưa gắn thẻ nào',
                style: AppTypography.caption.copyWith(color: AppColors.textMute))
          else
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [for (final t in d.tags) demandTagChip(t)],
            ),
        ],
      ),
    );
  }
}

/// "Nhân sự liên quan" card — người phụ trách + văn phòng.
class DemandPersonnelCard extends StatelessWidget {
  const DemandPersonnelCard({super.key, required this.detail});
  final DemandDetail detail;

  @override
  Widget build(BuildContext context) {
    final d = detail;
    final people = <(IconData, String, String)>[
      if ((d.supportName ?? '').isNotEmpty)
        (Icons.support_agent_outlined, 'Phụ trách', d.supportName!),
      if ((d.officeName ?? '').isNotEmpty)
        (Icons.apartment_outlined, 'Văn phòng', d.officeName!),
    ];
    if (people.isEmpty) return const SizedBox.shrink();
    return _card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('NHÂN SỰ LIÊN QUAN',
            style: AppTypography.micro.copyWith(
                color: AppColors.textMute, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        for (final p in people)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(children: [
              Icon(p.$1, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text('${p.$2}: ',
                  style:
                      AppTypography.caption.copyWith(color: AppColors.textMute)),
              Expanded(
                child: Text(p.$3,
                    style: AppTypography.body
                        .copyWith(fontWeight: FontWeight.w600)),
              ),
            ]),
          ),
      ]),
    );
  }
}

/// "Nhu cầu mong muốn" card — transaction pill, budget/area mini-cards,
/// location + extra preference pills.
class DemandNeedCard extends StatelessWidget {
  const DemandNeedCard({super.key, required this.detail});
  final DemandDetail detail;

  @override
  Widget build(BuildContext context) {
    final r = detail.requirements;
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _softPill(
            icon: Icons.account_balance_outlined,
            label: r?.transactionType ?? 'Mua bán',
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _miniCard(
                    'Ngân sách', budgetRangeText(r?.budgetMin, r?.budgetMax)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child:
                    _miniCard('Diện tích', areaRangeText(r?.areaMin, r?.areaMax)),
              ),
            ],
          ),
          if (detail.locationNames.isNotEmpty) ...[
            const SizedBox(height: 12),
            _softPill(
                icon: Icons.location_on_outlined,
                label: detail.locationNames.join(', ')),
          ],
          if (detail.directions.isNotEmpty || detail.legal.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final s in [...detail.directions, ...detail.legal])
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.bg,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(s,
                        style: AppTypography.micro
                            .copyWith(color: AppColors.textSecondary)),
                  ),
              ],
            ),
          ],
          if ((detail.special ?? '').isNotEmpty ||
              (detail.note ?? '').isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              [detail.special, detail.note]
                  .where((e) => (e ?? '').trim().isNotEmpty)
                  .join(' · '),
              style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }

  Widget _softPill({required IconData icon, required String label}) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primarySoft,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 8),
            Flexible(
              child: Text(label,
                  style: AppTypography.subtitle.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      );

  Widget _miniCard(String label, String value) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: AppTypography.micro.copyWith(color: AppColors.textMute)),
            const SizedBox(height: 4),
            Text(value,
                style:
                    AppTypography.body.copyWith(fontWeight: FontWeight.w700)),
          ],
        ),
      );
}
