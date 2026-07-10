import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../notifications/data/notifications_api.dart';
import '../home_nav.dart';

/// The 4-shortcut menu bar under the banner (v1 `menuView`): a shadowed card
/// with BĐS của tôi · Khách hàng · Vay vốn · Thông báo. The notification
/// shortcut carries an unread-count badge like v1's `MenuItem`.
class HomeMenuBar extends ConsumerWidget {
  const HomeMenuBar({super.key});

  static const _items = <({String label, String icon, String route})>[
    (label: 'BĐS của tôi', icon: 'my_warehouse_icon', route: '/my-listings'),
    (label: 'Khách hàng', icon: 'customer_icon', route: '/customers'),
    (label: 'Vay vốn', icon: 'capital_icon', route: '/loan'),
    (label: 'Thông báo', icon: 'home_notification_icon', route: '/notifications'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(notificationsProvider).maybeWhen(
          data: (list) => list.where((n) => !n.read).length,
          orElse: () => 0,
        );
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.10),
            offset: const Offset(0, 2),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        children: [
          for (final it in _items)
            Expanded(
              child: InkWell(
                onTap: () => navTo(context, it.route),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: [
                      _Icon(
                        asset: it.icon,
                        badge: it.route == '/notifications' ? unread : 0,
                      ),
                      const SizedBox(height: 8),
                      Text(it.label,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.medium(12)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon({required this.asset, this.badge = 0});
  final String asset;
  final int badge;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Image.asset('assets/images/$asset.png', width: 40, height: 40),
        if (badge > 0)
          Positioned(
            right: -1,
            top: -6,
            child: Container(
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
              decoration: const BoxDecoration(
                color: AppColors.danger,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  badge > 99 ? '99+' : '$badge',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.medium(9, color: Colors.white),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
