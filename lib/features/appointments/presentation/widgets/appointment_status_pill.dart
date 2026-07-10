import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/appointments_api.dart';

/// v1-style appointment status badge: a tinted square chip whose text uses the
/// status colour (matches v1 `AppointmentPage` pill — pending orange, chờ diễn
/// ra pink, đang diễn ra blue, hoàn thành green, huỷ red).
class AppointmentStatusPill extends StatelessWidget {
  const AppointmentStatusPill({super.key, required this.status});

  final AppointmentStatus status;

  static Color colorOf(AppointmentStatus s) => switch (s) {
        AppointmentStatus.pending => AppColors.primary,
        AppointmentStatus.onHold => const Color(0xFFEC4899),
        AppointmentStatus.inProgress => AppColors.info,
        AppointmentStatus.completed => AppColors.success,
        AppointmentStatus.cancelled => AppColors.danger,
      };

  @override
  Widget build(BuildContext context) {
    final c = colorOf(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(status.label, style: AppTextStyles.semibold(13, color: c)),
    );
  }
}
