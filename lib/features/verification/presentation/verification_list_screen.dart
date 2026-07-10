import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_network_image.dart';
import '../data/models/verification_models.dart';
import '../data/verification_providers.dart';
import 'widgets/assign_listing_manager_sheet.dart';
import 'widgets/assign_manager_sheet.dart';
import 'widgets/verification_filter_sheet.dart';
import 'widgets/verification_widgets.dart';

/// "Quản lý xác thực BĐS" — paginated, filterable list with status tabs.
class VerificationListScreen extends ConsumerWidget {
  const VerificationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(verificationListControllerProvider);
    final ctl = ref.read(verificationListControllerProvider.notifier);

    return VerificationScaffold(
      title: 'Xác thực BDS',
      titleWidget: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Xác thực BDS', style: vText(20, FontWeight.w700, VColors.n800)),
          const SizedBox(width: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: VColors.orangePale,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: VColors.orangeBorder),
            ),
            child: Text('${state.total}',
                style: vText(11, FontWeight.w600, VColors.orange)),
          ),
        ],
      ),
      action: VerificationTopAction(
        icon: Icons.tune_rounded,
        onTap: () => _openFilter(context),
      ),
      child: SafeArea(
        top: false,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: VerificationSearchBar(
                  initialValue: state.filters.searchText,
                  onChanged: ctl.setSearch,
                ),
              ),
              const SizedBox(height: 8),
              if (state.isLoadingFilters && state.statusFilters.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: SizedBox(
                      width: 26,
                      height: 26,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: VColors.orange)),
                )
              else
                _CategoryBar(
                  items: state.statusFilters,
                  selectedId: state.selectedStatusId,
                  onTap: ctl.selectStatus,
                ),
              const SizedBox(height: 8),
              Expanded(child: _buildBody(context, ref, state, ctl)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref,
      VerificationListState state, VerificationListController ctl) {
    if (state.isLoadingList && state.items.isEmpty) {
      return const Center(
          child: CircularProgressIndicator(strokeWidth: 2, color: VColors.orange));
    }
    if (state.items.isEmpty) {
      return _EmptyState(
        message: state.error == null ? 'Chưa có dữ liệu xác thực' : 'Không tải được dữ liệu',
        onRetry: ctl.retry,
      );
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (n.metrics.pixels >= n.metrics.maxScrollExtent - 180) ctl.loadMore();
        return false;
      },
      child: RefreshIndicator(
        color: VColors.orange,
        onRefresh: ctl.refresh,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
          itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            if (index >= state.items.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Center(
                    child: SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: VColors.orange))),
              );
            }
            final item = state.items[index];
            return _VerificationCard(
              item: item,
              onTap: () => context.push('/real-estate-verification/article',
                  extra: item),
              onAssignTap: item.assignedToName.isEmpty
                  ? () => _openAssignListingManager(context, ref, item)
                  : null,
              onAssignManagerTap: item.agentSupportName.isEmpty
                  ? () => _openAssignManager(context, ref, item)
                  : null,
            );
          },
        ),
      ),
    );
  }

  void _openFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const VerificationFilterSheet(),
    );
  }

  Future<void> _openAssignListingManager(
      BuildContext context, WidgetRef ref, VerificationItem item) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => AssignListingManagerSheet(item: item),
    );
    if (selected != null && selected.isNotEmpty) {
      ref
          .read(verificationListControllerProvider.notifier)
          .updateAssignedToName(item.id, selected);
    }
  }

  Future<void> _openAssignManager(
      BuildContext context, WidgetRef ref, VerificationItem item) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => AssignManagerSheet(item: item),
    );
    if (selected != null && selected.isNotEmpty) {
      ref
          .read(verificationListControllerProvider.notifier)
          .updateAgentSupportName(item.id, selected);
    }
  }
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar(
      {required this.items, required this.selectedId, required this.onTap});
  final List<VerificationStatusFilter> items;
  final int selectedId;
  final ValueChanged<VerificationStatusFilter> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: VColors.line, width: 0.8)),
        boxShadow: [
          BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: SizedBox(
        height: 34,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const BouncingScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final it = items[i];
            final active = it.id == selectedId;
            return GestureDetector(
              onTap: () => onTap(it),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(it.name,
                        style: vText(15, FontWeight.w600,
                            active ? VColors.orange : const Color(0xFF757575))),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 18,
                    height: 2,
                    decoration: BoxDecoration(
                      color: active ? VColors.orange : Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded, size: 36, color: VColors.n400),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style: vText(13, FontWeight.w400, VColors.n500)),
            const SizedBox(height: 10),
            TextButton(
              onPressed: onRetry,
              child: Text('Thử lại',
                  style: vText(14, FontWeight.w600, VColors.orange)),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerificationCard extends StatelessWidget {
  const _VerificationCard({
    required this.item,
    required this.onTap,
    this.onAssignTap,
    this.onAssignManagerTap,
  });
  final VerificationItem item;
  final VoidCallback onTap;
  final VoidCallback? onAssignTap;
  final VoidCallback? onAssignManagerTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: VColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Thumb(imageUrl: item.imageUrl),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: vText(16, FontWeight.w600, VColors.n800,
                              height: 1.25)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 12, color: VColors.n400),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(item.location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: vText(15, FontWeight.w400, VColors.n500)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(item.price,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: vText(17, FontWeight.w700, VColors.orange)),
                          ),
                          const SizedBox(width: 8),
                          VerificationStatusBadge(
                            text: item.status,
                            background: item.accent.withValues(alpha: 0.10),
                            foreground: item.accent,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _MiniChip(
                    color: item.accent,
                    icon: Icons.person_outline_rounded,
                    title: 'Người đăng',
                    value: item.salesmanName.isNotEmpty
                        ? item.salesmanName
                        : (item.owner.isNotEmpty ? item.owner : 'Chưa có'),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: GestureDetector(
                    onTap: onAssignTap,
                    child: _MiniChip(
                      color: item.accent,
                      icon: Icons.home_outlined,
                      title: 'Đầu chủ',
                      value: item.assignedToName.isNotEmpty
                          ? item.assignedToName
                          : 'Gán đầu chủ',
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: GestureDetector(
                    onTap: onAssignManagerTap,
                    child: _MiniChip(
                      color: item.accent,
                      icon: Icons.verified_outlined,
                      title: 'Trưởng phòng',
                      value: item.agentSupportName.isNotEmpty
                          ? item.agentSupportName
                          : 'Gán trưởng phòng',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.edit_outlined, size: 12, color: VColors.n400),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Yêu cầu xác thực bởi ${item.salesmanName.isNotEmpty ? item.salesmanName : item.owner}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: vText(12, FontWeight.w400, VColors.n500),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.schedule_outlined, size: 12, color: VColors.n400),
                    const SizedBox(width: 3),
                    Text(item.date, style: vText(12, FontWeight.w400, VColors.n500)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.imageUrl});
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    final url = verificationImageUrl(imageUrl);
    return Container(
      width: 84,
      height: 82,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: VColors.line),
      ),
      child: (url == null || url.isEmpty)
          ? Container(
              color: VColors.n100,
              child: const Icon(Icons.apartment_rounded,
                  color: VColors.n400, size: 20))
          : AppNetworkImage(url: url, width: 84, height: 82),
    );
  }
}

class _MiniChip extends StatelessWidget {
  const _MiniChip(
      {required this.color,
      required this.icon,
      required this.title,
      required this.value});
  final Color color;
  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 10, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: vText(12, FontWeight.w400, color)),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: vText(13, FontWeight.w600, VColors.n800)),
        ],
      ),
    );
  }
}
