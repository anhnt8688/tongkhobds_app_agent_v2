import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/tags_api.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/custom_screen.dart';
import '../../../core/widgets/tag_picker_sheet.dart';
import '../../work_actions/work_dialogs.dart';
import '../data/demands_api.dart';
import '../data/models/consultation_activity.dart';
import '../data/models/demand.dart';
import 'widgets/demand_bds_expanded.dart';
import 'widgets/demand_customer_activity_tab.dart';
import 'widgets/demand_detail_cards.dart';
import 'widgets/demand_interest_tile.dart';
import 'widgets/demand_notes_tab.dart';
import 'widgets/demand_tag_history_tab.dart';

/// "Chi tiết nhu cầu mua". Customer info (card + thẻ + mong muốn + nhân sự) sits
/// in a scrollable section above a pinned TabBar; the tabs hold BĐS quan tâm,
/// Khách hàng (hoạt động + log công việc + ghi chú) and Lịch sử gán thẻ.
class DemandDetailScreen extends ConsumerWidget {
  const DemandDetailScreen({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(demandDetailProvider(id));
    final d = detail.valueOrNull;

    return CustomScreen(
      title: 'Chi tiết nhu cầu mua',
      backgroundColor: AppColors.bg,
      actions: [
        if ((d?.customerPhone ?? '').isNotEmpty)
          IconButton(
            icon: const Icon(Icons.call, color: AppColors.primary),
            onPressed: () => launchUrl(Uri.parse('tel:${d!.customerPhone}')),
          ),
        if (d != null && !d.isClosed)
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'close') _close(context, ref);
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'close', child: Text('Đóng nhu cầu')),
            ],
          ),
      ],
      child: AsyncView<DemandDetail>(
        value: detail,
        onRetry: () => ref.invalidate(demandDetailProvider(id)),
        data: (d) => _Body(id: id, detail: d, onManageTags: () => _manageTags(context, ref, d), onAddNote: () => _addNote(context, ref, d.code)),
      ),
    );
  }

  Future<void> _manageTags(
      BuildContext context, WidgetRef ref, DemandDetail d) async {
    final res = await showTagPickerSheet(
      context,
      entity: TagEntity.consultation,
      entityId: id,
      selectedIds: d.tags.map((t) => t.id).toList(),
    );
    if (res == null) return;
    ref.invalidate(demandDetailProvider(id));
    ref.invalidate(demandTagHistoryProvider(id));
    if (context.mounted) AppToast.success(context, 'Đã cập nhật thẻ');
  }

  Future<void> _addNote(
      BuildContext context, WidgetRef ref, String? code) async {
    final text = await showNoteDialog(context,
        ctx: WorkDialogContext(entityBadge: code ?? 'nhu cầu #$id'));
    if (text == null || text.isEmpty) return;
    try {
      await ref.read(demandsApiProvider).addComment(id, text);
      ref.invalidate(demandCommentsProvider(id));
      if (context.mounted) AppToast.success(context, 'Đã thêm ghi chú');
    } on ApiException catch (e) {
      if (context.mounted) AppToast.error(context, e.message);
    } catch (_) {
      if (context.mounted) AppToast.error(context, 'Không thêm được ghi chú');
    }
  }

  Future<void> _close(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Đóng nhu cầu'),
        content: const Text('Đánh dấu nhu cầu này là đã kết thúc?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Huỷ')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Đóng nhu cầu'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(demandsApiProvider).close(id);
      ref.invalidate(demandDetailProvider(id));
      if (context.mounted) AppToast.success(context, 'Đã đóng nhu cầu');
    } on ApiException catch (e) {
      if (context.mounted) AppToast.error(context, e.message);
    } catch (_) {
      if (context.mounted) AppToast.error(context, 'Có lỗi xảy ra');
    }
  }
}

// ───────── Body: customer header section + pinned tabs ─────────
class _Body extends ConsumerWidget {
  const _Body({
    required this.id,
    required this.detail,
    required this.onManageTags,
    required this.onAddNote,
  });

  final int id;
  final DemandDetail detail;
  final VoidCallback onManageTags;
  final VoidCallback onAddNote;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count =
        ref.watch(demandInterestsProvider(id)).valueOrNull?.items.length;

    return DefaultTabController(
      length: 4,
      child: NestedScrollView(
        headerSliverBuilder: (ctx, _) => [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DemandCustomerCard(detail: detail, onManage: onManageTags),
                  const SizedBox(height: 14),
                  const DemandSectionLabel('Nhu cầu mong muốn'),
                  DemandNeedCard(detail: detail),
                  const SizedBox(height: 14),
                  DemandPersonnelCard(detail: detail),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textMute,
              labelStyle:
                  AppTypography.caption.copyWith(fontWeight: FontWeight.w700),
              tabs: [
                Tab(text: count == null ? 'BĐS' : 'BĐS ($count)'),
                const Tab(text: 'Khách hàng'),
                const Tab(text: 'Ghi chú nội bộ'),
                const Tab(text: 'Lịch sử gán thẻ'),
              ],
            )),
          ),
        ],
        body: TabBarView(
          children: [
            _BdsTab(
              consultationId: id,
              customerName: detail.customerName,
              customerPhone: detail.customerPhone,
            ),
            DemandCustomerActivityTab(
              consultationId: id,
              customerName: detail.customerName,
              customerPhone: detail.customerPhone,
            ),
            DemandNotesTab(consultationId: id, onAddNote: onAddNote),
            DemandTagHistoryTab(consultationId: id),
          ],
        ),
      ),
    );
  }
}

/// Pinned-header delegate hosting the [TabBar] with a solid background.
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  _TabBarDelegate(this.tabBar);
  final TabBar tabBar;

  @override
  double get minExtent => 48;
  @override
  double get maxExtent => 48;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) {
    return Container(
      color: AppColors.bg,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate old) => old.tabBar != tabBar;
}

// ───────── Tab 1: BĐS quan tâm (single-expand accordion) ─────────
class _BdsTab extends ConsumerStatefulWidget {
  const _BdsTab({
    required this.consultationId,
    this.customerName,
    this.customerPhone,
  });
  final int consultationId;
  final String? customerName;
  final String? customerPhone;

  @override
  ConsumerState<_BdsTab> createState() => _BdsTabState();
}

class _BdsTabState extends ConsumerState<_BdsTab> {
  // Single-expand accordion: id of the BĐS whose work panel is open.
  int? _expandedId;

  @override
  Widget build(BuildContext context) {
    final interests = ref.watch(demandInterestsProvider(widget.consultationId));
    return interests.when(
      loading: () => const Center(
          child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(color: AppColors.primary))),
      error: (_, __) => Center(
          child: Text('Không tải được BĐS',
              style: AppTypography.caption.copyWith(color: AppColors.textMute))),
      data: (res) => ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 28),
        children: [
          _statsRow(res.stats),
          const SizedBox(height: 12),
          if (res.items.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                border: Border.all(color: AppColors.border),
              ),
              child: Center(
                child: Text('Chưa có BĐS quan tâm',
                    style: AppTypography.caption
                        .copyWith(color: AppColors.textMute)),
              ),
            )
          else
            for (final item in res.items)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    DemandInterestTile(
                      item: item,
                      expanded: _expandedId == item.id,
                      onTap: () => setState(() => _expandedId =
                          _expandedId == item.id ? null : item.id),
                    ),
                    if (_expandedId == item.id)
                      DemandBdsExpanded(
                        interest: item,
                        consultationId: widget.consultationId,
                        customerName: widget.customerName,
                        customerPhone: widget.customerPhone,
                      ),
                  ],
                ),
              ),
        ],
      ),
    );
  }

  Widget _statsRow(InterestStats s) {
    Widget cell(String label, int value) => Expanded(
          child: Column(children: [
            Text('$value',
                style: AppTypography.title.copyWith(color: AppColors.text)),
            const SizedBox(height: 2),
            Text(label,
                style: AppTypography.micro.copyWith(color: AppColors.textMute)),
          ]),
        );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(children: [
        cell('BĐS khớp', s.totalBds),
        cell('Tư vấn', s.totalOwners),
        cell('Xem', s.totalAppointments),
        cell('Ngày', s.processingDays),
      ]),
    );
  }
}
