import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/custom_screen.dart';
import '../data/consultation_sell_api.dart';
import '../data/models/sell_lead.dart';
import 'widgets/sell_activity_sections.dart';
import 'widgets/sell_customer_cards.dart';
import 'widgets/sell_detail_actions.dart';
import 'widgets/sell_detail_sections.dart';
import 'widgets/sell_real_estate_section.dart';

/// "Chi tiết nhu cầu bán" — single-scroll layout: header, thông tin BĐS, đầu
/// chủ, thẻ gắn, công việc (tin đăng/xác thực/HĐ — done state or gated
/// create button per item), hoạt động, ghi chú nội bộ, lịch sử gán thẻ. Work
/// actions live in the "..." sheet.
class SellLeadDetailScreen extends ConsumerWidget {
  const SellLeadDetailScreen({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(sellDetailProvider(id));
    final perms = ref.watch(sellPermissionsProvider).valueOrNull ??
        const SellPermissions();
    final actions = SellDetailActions(ref, id);
    final d = detail.valueOrNull;

    return CustomScreen(
      title: '',
      backgroundColor: AppColors.bg,
      titleWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text((d?.code ?? '').isNotEmpty ? 'Lead ${d!.code}' : 'Chi tiết',
              style: AppTypography.title
                  .copyWith(color: Colors.white)),
          if ((d?.customerName ?? '').isNotEmpty)
            Text(d!.customerName!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.caption
                    .copyWith(color: Colors.white70)),
        ],
      ),
      action: (d != null && !d.isClosed && perms.close)
          ? Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton.icon(
                onPressed: () => actions.close(context),
                icon: const Icon(Icons.lock_outline,
                    size: 16, color: Colors.white),
                label: Text('Đóng nhu cầu',
                    style: AppTypography.caption.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            )
          : null,
      child: AsyncView<SellLeadDetail>(
        value: detail,
        onRetry: () => ref.invalidate(sellDetailProvider(id)),
        data: (d) => ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 28),
          children: [
            SellHeaderCard(detail: d),
            const SizedBox(height: 12),
            SellBdsInfoCard(detail: d),
            const SizedBox(height: 12),
            SellOwnerCard(
                detail: d,
                onEdit: perms.assignListing
                    ? () => actions.assignManager(context)
                    : null),
            const SizedBox(height: 12),
            SellTagsCard(
                tags: d.tags,
                onManage: perms.addTag
                    ? () => actions.manageTags(context, d)
                    : null),
            const SizedBox(height: 12),
            SellRealEstatesSection(
              leadId: d.id,
              hasListingManager: d.hasListingManager,
              realEstate: d.realEstateRef,
              verification: d.verificationRef,
              contract: d.contractRef,
            ),
            const SizedBox(height: 12),
            SellActivitySection(
              sellId: id,
              onCall: () => actions.call(context, d),
              onNote: () => actions.note(context, d),
              onAppointment: () => actions.appointment(context, d),
            ),
            const SizedBox(height: 12),
            SellNotesSection(
                sellId: id, onAdd: () => actions.addComment(context)),
            const SizedBox(height: 12),
            SellTagHistorySection(sellId: id),
          ],
        ),
      ),
    );
  }

}
