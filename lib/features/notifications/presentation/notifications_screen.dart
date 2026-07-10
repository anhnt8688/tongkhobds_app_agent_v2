import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../core/widgets/custom_screen.dart';
import '../data/models/app_notification.dart';
import '../data/notifications_api.dart';

/// "Thông báo" tab, rebuilt to match v1 `notification_page`: gradient
/// `CustomScreen` shell, two tabs (Giao dịch / Hệ thống) with inline unread
/// counters, a mark-all-read app-bar action, unread-tinted rows, and a
/// per-item actions sheet (xoá / ngưng nhận). Root tab → no back button.
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});
  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 2, vsync: this)
    ..addListener(() {
      if (!_tab.indexIsChanging) {
        ref.read(notificationsControllerProvider.notifier).setTab(_tab.index);
      }
    });

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationsControllerProvider);
    final ctl = ref.read(notificationsControllerProvider.notifier);
    final hasUnread = state.items.any((e) => !e.isRead);

    return CustomScreen(
      title: 'Thông báo',
      isBack: false,
      action: hasUnread ? _markAllButton(ctl) : null,
      child: Column(
        children: [
          TabBar(
            controller: _tab,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: AppColors.primary,
            indicatorWeight: 2,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.text,
            labelStyle: AppTextStyles.semibold(15),
            unselectedLabelStyle: AppTextStyles.semibold(15),
            labelPadding: const EdgeInsets.all(16),
            dividerColor: AppColors.neutral200,
            dividerHeight: 0.5,
            tabs: [
              Tab(
                  text: 'Giao dịch'
                      '${state.countOrder > 0 ? ' (${state.countOrder})' : ''}'),
              Tab(
                  text: 'Hệ thống'
                      '${state.countPromotion > 0 ? ' (${state.countPromotion})' : ''}'),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(child: _body(state, ctl)),
        ],
      ),
    );
  }

  Widget _markAllButton(NotificationsController ctl) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: GestureDetector(
          onTap: ctl.markAllRead,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAF9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: FaIcon(FontAwesomeIcons.solidCircleCheck,
                  size: 16, color: AppColors.text),
            ),
          ),
        ),
      );

  Widget _body(NotificationsState state, NotificationsController ctl) {
    if (state.loading && state.items.isEmpty) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (state.items.isEmpty) return _empty();
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: ctl.refresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (n.metrics.pixels >= n.metrics.maxScrollExtent - 200) {
            ctl.loadMore();
          }
          return false;
        },
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: state.items.length + (state.loadingMore ? 1 : 0),
          itemBuilder: (context, i) {
            if (i >= state.items.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                    child: SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.primary))),
              );
            }
            return _item(state.items[i], ctl);
          },
        ),
      ),
    );
  }

  /// v1 `NoDataView`: centred illustration + "Không có dữ liệu".
  Widget _empty() {
    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.22),
        Center(
          child: Column(
            children: [
              Image.asset('assets/images/img_no_data.png',
                  width: 150, height: 120),
              const SizedBox(height: 4),
              Text('Không có dữ liệu', style: AppTextStyles.regular(15)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _item(AppNotification n, NotificationsController ctl) {
    return GestureDetector(
      onTap: () => ctl.markRead(n),
      child: Container(
        color: n.isRead
            ? Colors.transparent
            : AppColors.primary.withValues(alpha: 0.2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              child: SizedBox(
                width: 48,
                height: 48,
                child: (n.image ?? '').isNotEmpty
                    ? AppNetworkImage(url: n.image, width: 48, height: 48)
                    : Container(
                        color: AppColors.neutral300,
                        child: const Icon(Icons.notifications_active,
                            color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(n.title.isEmpty ? 'Thông báo' : n.title,
                      style: AppTextStyles.semibold(15)),
                  if (n.content.isNotEmpty)
                    Text(n.content,
                        style: AppTextStyles.regular(13,
                            color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Text(_time(n.createdOn),
                      style: AppTextStyles.regular(13,
                          color: AppColors.neutral400)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => _showActions(n, ctl),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFFFAFAF9),
                ),
                child: const Icon(Icons.more_horiz_outlined,
                    size: 18, color: AppColors.text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showActions(AppNotification n, NotificationsController ctl) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFFAFAF9),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 24),
            _sheetRow(
              icon: Icons.delete_outline,
              label: 'Xoá thông báo',
              onTap: () {
                Navigator.pop(ctx);
                ctl.remove(n);
              },
            ),
            const Divider(height: 0.5, thickness: 0.5),
            _sheetRow(
              icon: Icons.notifications_off_outlined,
              label: 'Ngưng nhận thông báo từ bài viết này',
              onTap: () {
                Navigator.pop(ctx);
                ctl.denied(n);
              },
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  /// v1 action-sheet row: icon + regular-17 label, padding v18 h16.
  Widget _sheetRow({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, size: 22, color: AppColors.text),
            const SizedBox(width: 8),
            Expanded(child: Text(label, style: AppTextStyles.regular(17))),
          ],
        ),
      ),
    );
  }

  String _time(DateTime? dt) {
    if (dt == null) return '';
    return DateFormat('dd/MM/yyyy HH:mm').format(dt);
  }
}
