import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../data/models/sell_lead.dart';

/// Initials from a full name (up to 2 letters).
String _initials(String? name) {
  final parts =
      (name ?? '').trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty);
  if (parts.isEmpty) return '?';
  final letters = parts.map((p) => p[0].toUpperCase()).toList();
  return letters.length == 1
      ? letters.first
      : '${letters[letters.length - 2]}${letters.last}';
}

Widget _card({required Widget child, EdgeInsets? padding}) => Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );

Widget _label(String text) => Text(text.toUpperCase(),
    style: AppTypography.micro.copyWith(
        color: AppColors.textMute,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4));

/// Header card: avatar, name + status badge, phone + time.
/// (Gọi ngay/Zalo removed — tester feedback: don't expose direct contact
/// actions for the chủ nhà here.)
class SellHeaderCard extends StatelessWidget {
  const SellHeaderCard({super.key, required this.detail});
  final SellLeadDetail detail;

  @override
  Widget build(BuildContext context) {
    final d = detail;
    return _card(
      child: Row(children: [
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: AppColors.primarySoft, shape: BoxShape.circle),
          child: Text(_initials(d.customerName),
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
                    child: Text(d.customerName ?? 'Chủ nhà',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.subtitle
                            .copyWith(fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 8),
                  StatusPill(
                      label: d.statusLabel,
                      tone: d.statusEnum?.tone ?? StatusTone.neutral),
                ]),
                const SizedBox(height: 2),
                Text(
                    [d.customerPhone, d.createdOn]
                        .where((e) => (e ?? '').isNotEmpty)
                        .join('  ·  '),
                    style: AppTypography.caption
                        .copyWith(color: AppColors.textMute)),
              ]),
        ),
      ]),
    );
  }
}

/// THÔNG TIN BĐS card: property type · area · price, location + source tag.
class SellBdsInfoCard extends StatelessWidget {
  const SellBdsInfoCard({super.key, required this.detail});
  final SellLeadDetail detail;

  @override
  Widget build(BuildContext context) {
    final d = detail;
    return _card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _label('Thông tin BĐS'),
        const SizedBox(height: 12),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              flex: 2,
              child: _kv('Loại bất động sản', d.propertyTypeName ?? '—')),
          Expanded(child: _kv('Diện tích', _area(d.area))),
          Expanded(child: _kv('Giá bán', _price(d.price))),
        ]),
        if (d.fullAddress.isNotEmpty) ...[
          const SizedBox(height: 12),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.location_on_outlined,
                size: 18, color: Color(0xFF1D9BF0)),
            const SizedBox(width: 6),
            Expanded(
              child: Text(d.fullAddress,
                  style: AppTypography.body
                      .copyWith(color: const Color(0xFF1D9BF0))),
            ),
          ]),
        ],
        if ((d.source ?? '').isNotEmpty) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.warehouse_outlined,
                  size: 13, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(d.source!,
                  style: AppTypography.micro.copyWith(
                      color: AppColors.primary, fontWeight: FontWeight.w600)),
            ]),
          ),
        ],
      ]),
    );
  }

  Widget _kv(String k, String v) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(k,
              style: AppTypography.micro.copyWith(color: AppColors.textMute)),
          const SizedBox(height: 4),
          Text(v,
              style: AppTypography.body.copyWith(fontWeight: FontWeight.w700)),
        ],
      );

  String _price(double? p) {
    if (p == null) return 'Thỏa thuận';
    if (p >= 1e9) {
      final b = p / 1e9;
      return '${b == b.roundToDouble() ? b.toInt() : b.toStringAsFixed(1)} tỷ';
    }
    if (p >= 1e6) return '${(p / 1e6).toStringAsFixed(0)} triệu';
    return p.toStringAsFixed(0);
  }

  String _area(num? a) =>
      a == null ? '—' : '${a == a.roundToDouble() ? a.toInt() : a} m²';
}

/// ĐẦU CHỦ card: assigned listing manager (avatar + name + phone + edit), or a
/// "Chưa giao" empty state with an assign button.
class SellOwnerCard extends StatelessWidget {
  const SellOwnerCard({super.key, required this.detail, required this.onEdit});
  final SellLeadDetail detail;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final m = detail.listingManager;
    final assigned = (m?.name ?? '').trim().isNotEmpty;
    return _card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _label('Đầu chủ'),
        const SizedBox(height: 10),
        if (!assigned)
          Row(children: [
            const Icon(Icons.person_off_outlined,
                size: 20, color: AppColors.textMute),
            const SizedBox(width: 10),
            Expanded(
              child: Text('Chưa giao đầu chủ',
                  style: AppTypography.body.copyWith(color: AppColors.textMute)),
            ),
            FilledButton(
              onPressed: onEdit,
              style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  visualDensity: VisualDensity.compact),
              child: const Text('Gán'),
            ),
          ])
        else
          Row(children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: AppColors.primary, shape: BoxShape.circle),
              child: Text(_initials(m!.name),
                  style: AppTypography.caption.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m.name!,
                        style: AppTypography.body
                            .copyWith(fontWeight: FontWeight.w700)),
                    if ((m.phone ?? '').isNotEmpty)
                      Text(m.phone!,
                          style: AppTypography.caption
                              .copyWith(color: AppColors.textMute)),
                  ]),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined,
                  size: 18, color: AppColors.textMute),
              onPressed: onEdit,
            ),
          ]),
      ]),
    );
  }
}

