import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../realestate/data/realestate_api.dart';
import '../../../verification/data/models/verification_models.dart';
import '../../../verification/data/verification_api.dart';
import '../../data/models/sell_lead.dart';

/// CÔNG VIỆC card: tin đăng / xác thực BĐS / HĐ trích thưởng — one row per
/// item (each a top-level sibling object in `get_consultation_sell`, not
/// nested inside one another). Done items show their status + "Xem chi
/// tiết"; not-done items show a gated "Tạo" button. Single section — no
/// more splitting into a separate "đã triển khai" block.
class SellRealEstatesSection extends ConsumerWidget {
  const SellRealEstatesSection({
    super.key,
    required this.leadId,
    required this.hasListingManager,
    required this.realEstate,
    required this.verification,
    required this.contract,
  });
  final int leadId;
  final bool hasListingManager;
  final SellRealEstateRef? realEstate;
  final SellVerificationRef? verification;
  final SellContractRef? contract;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final done = [realEstate != null, verification != null, contract != null]
        .where((e) => e)
        .length;
    void warn(String msg) => AppToast.warning(context, msg);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('CÔNG VIỆC',
              style: AppTypography.micro.copyWith(
                  color: AppColors.textMute, fontWeight: FontWeight.w700)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
            ),
            child: Text('$done/3',
                style: AppTypography.micro.copyWith(
                    color: AppColors.primary, fontWeight: FontWeight.w700)),
          ),
        ]),
        if (done == 3) ...[
          const SizedBox(height: 10),
          _completionBanner(),
        ],
        const SizedBox(height: 10),
        _RealEstateCard(
          item: realEstate,
          // Push the standalone wizard (the '/post' tab can't be pushed and
          // switching tabs breaks its back button), carrying the lead id so
          // the new listing gets linked back to it on submit.
          onCreate: () => context.push('/post-create', extra: leadId),
        ),
        const SizedBox(height: 10),
        _VerificationCard(
          item: verification,
          onOpen: () => _openVerification(context, ref, verification!),
          onCreate: () {
            if (!hasListingManager) {
              warn('Cần gán đầu chủ trước khi tạo xác thực');
              return;
            }
            if (realEstate == null) {
              warn('Cần tạo tin đăng trước khi tạo xác thực');
              return;
            }
            _createVerification(context, ref, realEstate!);
          },
        ),
        const SizedBox(height: 10),
        _ContractCard(
          item: contract,
          onCreate: () {
            if ((verification?.verificationName ?? '').isEmpty) {
              warn('Cần tạo xác thực trước khi tạo HĐ');
              return;
            }
            context.push('/contracts');
          },
        ),
      ]),
    );
  }

  Widget _completionBanner() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: const Color(0xFFFDE68A)),
        ),
        child: Row(children: [
          const Icon(Icons.check_circle_outline,
              size: 16, color: Color(0xFF92400E)),
          const SizedBox(width: 8),
          Expanded(
            child: Text('Hoàn thành cả 3 → lead tự đóng',
                style: AppTypography.caption
                    .copyWith(color: const Color(0xFF92400E), fontWeight: FontWeight.w600)),
          ),
        ]),
      );

  /// Builds a minimal display-only `VerificationItem` (id = salesman id, the
  /// same field `fetchVerificationDetail`/the article screen's own
  /// `verificationDetailProvider` key on — verified against the working
  /// "Yêu cầu xác thực" flow in realestate detail_footer.dart) and confirms
  /// the record still resolves before navigating.
  Future<void> _openVerification(
      BuildContext context, WidgetRef ref, SellVerificationRef v) async {
    try {
      await ref
          .read(verificationApiProvider)
          .fetchVerificationDetail(v.realEstateSalesmanId);
      if (!context.mounted) return;
      context.push('/real-estate-verification/article',
          extra: VerificationItem(
            id: v.realEstateSalesmanId,
            title: v.realEstateTitle ?? '',
            location: '',
            price: '',
            area: '',
            status: v.verificationName ?? '',
            date: '',
            imageUrl: '',
            accent: AppColors.primary,
            cardToneA: AppColors.primarySoft,
            cardToneB: AppColors.surface,
            salesmanId: v.realEstateSalesmanId,
            salesmanName: '',
            agentSupportName: '',
            assignedToName: '',
            owner: '',
            company: '',
          ));
    } catch (_) {
      if (context.mounted) {
        AppToast.error(context, 'Không tải được thông tin xác thực');
      }
    }
  }

  /// Opens the create-verification form for the linked tin đăng. The form needs
  /// the property's `real_estate_salesman_id` (not the real_estate_id), so fetch
  /// the property detail first, then its verification detail — mirroring the
  /// working "Yêu cầu xác thực" flow in realestate detail_footer.dart.
  Future<void> _createVerification(
      BuildContext context, WidgetRef ref, SellRealEstateRef re) async {
    try {
      final prop =
          await ref.read(realEstateApiProvider).detail(id: re.id, owned: true);
      final salesmanId = prop.realEstateSalesmanId;
      if (salesmanId == null) {
        if (context.mounted) {
          AppToast.warning(context, 'Tin chưa sẵn sàng để xác thực');
        }
        return;
      }
      final vDetail =
          await ref.read(verificationApiProvider).fetchVerificationDetail(salesmanId);
      if (!context.mounted) return;
      final item = VerificationItem(
        id: salesmanId,
        title: prop.title,
        location: prop.address,
        price: prop.priceText,
        area: prop.areaDisplay,
        status: prop.statusName ?? '',
        date: prop.timeAgo ?? '',
        imageUrl: prop.gallery.isNotEmpty ? prop.gallery.first : '',
        accent: AppColors.primary,
        cardToneA: AppColors.primarySoft,
        cardToneB: AppColors.surface,
        salesmanId: salesmanId,
        salesmanName: prop.seller?.name ?? '',
        agentSupportName: '',
        assignedToName: '',
        owner: prop.seller?.name ?? '',
        company: '',
      );
      context.push('/real-estate-verification/form',
          extra: {'item': item, 'detail': vDetail});
    } catch (_) {
      if (context.mounted) {
        AppToast.error(context, 'Không tải được thông tin xác thực');
      }
    }
  }
}

Widget _cardBox({required Widget child}) => Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: child,
    );

Widget _iconBox(IconData icon, Color color) => Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Icon(icon, size: 18, color: color),
    );

Widget _pill(String label, String? hex, {Color fallback = AppColors.primary}) {
  final c = AppColors.fromHex(hex, fallback: fallback);
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: c,
      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
    ),
    child: Text(label,
        style: AppTypography.micro
            .copyWith(color: AppColors.text, fontWeight: FontWeight.w600)),
  );
}

Widget _detailButton(String label, Color color, VoidCallback onTap) =>
    SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
        ),
        child: Text(label,
            style: AppTypography.caption
                .copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
    );

Widget _createButton(String label, String action, VoidCallback onTap) => Row(
      children: [
        Expanded(
            child: Text(label,
                style:
                    AppTypography.caption.copyWith(color: AppColors.textMute))),
        OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.text,
            side: const BorderSide(color: AppColors.inputBorder),
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.lock_outline, size: 13),
            const SizedBox(width: 4),
            Text(action),
          ]),
        ),
      ],
    );

String _price(double? p) {
  if (p == null) return '';
  if (p >= 1e9) {
    final b = p / 1e9;
    return '${b == b.roundToDouble() ? b.toInt() : b.toStringAsFixed(1)} tỷ';
  }
  if (p >= 1e6) return '${(p / 1e6).toStringAsFixed(0)} triệu';
  return p.toStringAsFixed(0);
}

String _area(num? a) => a == null ? '' : '${a == a.roundToDouble() ? a.toInt() : a} m²';

class _RealEstateCard extends StatelessWidget {
  const _RealEstateCard({required this.item, required this.onCreate});
  final SellRealEstateRef? item;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final r = item;
    return _cardBox(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          _iconBox(Icons.campaign_outlined, AppColors.info),
          const SizedBox(width: 10),
          Expanded(
            child: Text('Tin đăng',
                style: AppTypography.body
                    .copyWith(color: AppColors.info, fontWeight: FontWeight.w700)),
          ),
        ]),
        const SizedBox(height: 8),
        if (r == null)
          _createButton('Chưa có tin đăng nào', 'Tạo tin', onCreate)
        else ...[
          Text(r.title ?? r.code ?? 'BĐS #${r.id}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(
              [r.priceDescription ?? _price(r.price), r.code]
                  .where((e) => (e ?? '').isNotEmpty)
                  .join('  ·  '),
              style: AppTypography.caption.copyWith(color: AppColors.textMute)),
          if (_area(r.area).isNotEmpty)
            Text(_area(r.area),
                style: AppTypography.caption.copyWith(color: AppColors.textMute)),
          const SizedBox(height: 10),
          _detailButton('Xem chi tiết tin đăng', AppColors.info,
              () => context.push('/property/${r.id}')),
        ],
      ]),
    );
  }
}

class _VerificationCard extends StatelessWidget {
  const _VerificationCard(
      {required this.item, required this.onOpen, required this.onCreate});
  final SellVerificationRef? item;
  final VoidCallback onOpen;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final v = item;
    return _cardBox(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          _iconBox(Icons.verified_outlined, AppColors.success),
          const SizedBox(width: 10),
          Expanded(
            child: Row(children: [
              Flexible(
                child: Text('Xác thực BĐS',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.body.copyWith(
                        color: AppColors.success, fontWeight: FontWeight.w700)),
              ),
              if ((v?.verificationTypeName ?? '').isNotEmpty)
                Text(' – ${v!.verificationTypeName}',
                    style: AppTypography.body.copyWith(
                        color: AppColors.success, fontWeight: FontWeight.w700)),
              if (v?.isApproved == true) ...[
                const SizedBox(width: 4),
                const Icon(Icons.check_circle, size: 16, color: AppColors.success),
              ],
            ]),
          ),
        ]),
        const SizedBox(height: 8),
        if (v == null)
          _createButton('Chưa có xác thực nào', 'Tạo XT', onCreate)
        else ...[
          Text(
              [
                v.realEstateTitle,
                if ((v.realEstateCode ?? '').isNotEmpty) 'Mã BĐS: ${v.realEstateCode}',
              ].where((e) => (e ?? '').isNotEmpty).join(' - '),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.caption.copyWith(color: AppColors.textMute)),
          if ((v.verificationName ?? '').isNotEmpty) ...[
            const SizedBox(height: 8),
            _pill(v.verificationName!, v.verificationColor,
                fallback: AppColors.success),
          ],
          const SizedBox(height: 10),
          _detailButton('Xem chi tiết xác thực', AppColors.success, onOpen),
        ],
      ]),
    );
  }
}

class _ContractCard extends StatelessWidget {
  const _ContractCard({required this.item, required this.onCreate});
  final SellContractRef? item;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final c = item;
    return _cardBox(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          _iconBox(Icons.description_outlined, AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
                'Hợp đồng${(c?.contractTypeName ?? '').isNotEmpty ? ' – ${c!.contractTypeName}' : ''}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.body
                    .copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
          ),
        ]),
        const SizedBox(height: 8),
        if (c == null)
          _createButton('Chưa có hợp đồng nào', 'Tạo HĐ', onCreate)
        else ...[
          if ((c.officeName ?? '').isNotEmpty)
            Text(c.officeName!,
                style: AppTypography.caption.copyWith(color: AppColors.textMute)),
          if ((c.statusName ?? '').isNotEmpty) ...[
            const SizedBox(height: 8),
            _pill(c.statusName!, c.statusColor, fallback: AppColors.warning),
          ],
          const SizedBox(height: 10),
          _detailButton('Xem chi tiết HĐ trích thưởng', AppColors.primary,
              () => context.push('/contract/${c.id}')),
        ],
      ]),
    );
  }
}
