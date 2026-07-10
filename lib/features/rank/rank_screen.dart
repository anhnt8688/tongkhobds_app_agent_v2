import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/custom_screen.dart';
import '../auth/presentation/controllers/auth_controller.dart';

class RankScreen extends ConsumerWidget {
  const RankScreen({super.key});

  static const _tiers = [
    ('Đồng', '0 giao dịch', Color(0xFFB45309)),
    ('Bạc', '5 giao dịch', Color(0xFF6B7280)),
    ('Vàng', '15 giao dịch', AppColors.warning),
    ('Bạch kim', '30 giao dịch', Color(0xFF0EA5E9)),
    ('Kim cương', '50+ giao dịch', Color(0xFF8B5CF6)),
  ];

  static const _perks = [
    (Icons.trending_up, 'Hoa hồng thưởng theo cấp hạng'),
    (Icons.verified, 'Huy hiệu xác thực nổi bật'),
    (Icons.support_agent, 'Hỗ trợ ưu tiên'),
    (Icons.campaign_outlined, 'Ưu tiên hiển thị tin đăng'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    return CustomScreen(
      title: 'Cấp hạng',
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(color: AppColors.primary),
            child: Column(
              children: [
                const Icon(Icons.workspace_premium,
                    color: Colors.white, size: 56),
                const SizedBox(height: 12),
                Text(user?.fullName ?? 'Bạn',
                    style: AppTypography.title.copyWith(color: Colors.white)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  ),
                  child: Text('Hạng hiện tại: Đồng',
                      style: AppTypography.subtitle.copyWith(color: Colors.white)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Các cấp hạng', style: AppTypography.title),
                const SizedBox(height: 12),
                for (final t in _tiers)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: t.$3.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          ),
                          child: Icon(Icons.military_tech, color: t.$3),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t.$1,
                                  style: AppTypography.body
                                      .copyWith(fontWeight: FontWeight.w700)),
                              Text(t.$2, style: AppTypography.caption),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                Text('Quyền lợi', style: AppTypography.title),
                const SizedBox(height: 12),
                for (final p in _perks)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Icon(p.$1, color: AppColors.primary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(child: Text(p.$2, style: AppTypography.body)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
