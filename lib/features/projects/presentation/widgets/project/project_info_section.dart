import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/project_detail.dart';

/// Project key info rows (v1 `InfoProject`): location, developer, units, towers,
/// area, legal, price. Each row = Material icon + label + value; "Giá bán" is
/// emphasised in the price color, matching v1.
class ProjectInfoSection extends StatelessWidget {
  const ProjectInfoSection({super.key, required this.project});
  final ProjectDetail project;

  @override
  Widget build(BuildContext context) {
    final p = project;
    final rows = <Widget>[
      if ((p.address ?? '').isNotEmpty)
        _row(Icons.location_on_outlined, 'Vị trí', p.address!),
      if ((p.developerName ?? '').isNotEmpty)
        _row(Icons.corporate_fare, 'Chủ đầu tư', p.developerName!),
      if (p.totalUnits != null)
        _row(Icons.home_work_outlined, 'Tổng số căn', '${p.totalUnits} căn'),
      if (p.totalTowers != null)
        _row(Icons.business, 'Số toà', '${p.totalTowers} toà'),
      if (p.areaText.isNotEmpty)
        _row(Icons.straighten, 'Diện tích', p.areaText),
      if ((p.legalStatus ?? '').isNotEmpty)
        _row(Icons.gavel, 'Pháp lý', p.legalStatus!),
      if ((p.priceDescription ?? '').isNotEmpty)
        _row(Icons.sell_outlined, 'Giá bán', p.priceDescription!,
            price: true),
    ];
    if (rows.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(p.name, style: AppTextStyles.semibold(22)),
        ),
        ...rows,
      ],
    );
  }

  Widget _row(IconData icon, String label, String value, {bool price = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style:
                        AppTextStyles.regular(13, color: AppColors.textMute)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: price
                      ? AppTextStyles.semibold(15, color: AppColors.price)
                      : AppTextStyles.semibold(15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
