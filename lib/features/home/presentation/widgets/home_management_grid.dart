import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../home_nav.dart';

/// "Quản lý": a static 4-per-row grid of agent management shortcuts, relocated
/// from the Profile tab. Mirrors the [HomeQuickTools] visual (soft square icon
/// tile + label) but with local FontAwesome icons and fixed in-app routes.
class HomeManagementGrid extends StatelessWidget {
  const HomeManagementGrid({super.key});

  static const _items = <({String label, IconData icon, String route})>[
    (label: 'BĐS của tôi', icon: FontAwesomeIcons.warehouse, route: '/my-listings'),
    (label: 'Khách hàng', icon: FontAwesomeIcons.userTie, route: '/customers'),
    (label: 'Nhu cầu mua', icon: FontAwesomeIcons.magnifyingGlassDollar, route: '/demands'),
    (label: 'Nhu cầu bán', icon: FontAwesomeIcons.tags, route: '/nhu-cau-ban'),
    (label: 'Quản lý hợp đồng', icon: FontAwesomeIcons.fileContract, route: '/contracts'),
    (label: 'Đội nhóm', icon: FontAwesomeIcons.sitemap, route: '/team'),
  ];

  @override
  Widget build(BuildContext context) {
    final itemWidth = (MediaQuery.of(context).size.width - 80) / 4;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quản lý', style: AppTextStyles.bold(22)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (final it in _items)
                SizedBox(
                  width: itemWidth,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => navTo(context, it.route),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: FaIcon(it.icon,
                                size: 22, color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(it.label,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.semibold(13)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
