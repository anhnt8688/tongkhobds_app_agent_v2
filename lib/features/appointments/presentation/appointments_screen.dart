import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/custom_screen.dart';
import '../data/appointments_api.dart';
import 'widgets/appointment_status_pill.dart';

/// Appointment list with one tab per status (Chờ duyệt / Chờ diễn ra / Đang
/// diễn ra / Hoàn thành / Huỷ) — mirrors the v1 AppointmentPage.
class AppointmentsScreen extends ConsumerStatefulWidget {
  const AppointmentsScreen({super.key, this.initialStatus});

  /// Optional tab to open on (e.g. after cancelling jump to "Huỷ").
  final AppointmentStatus? initialStatus;

  @override
  ConsumerState<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends ConsumerState<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  static const _statuses = AppointmentStatus.values;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialStatus == null
        ? 0
        : _statuses.indexOf(widget.initialStatus!);
    _tab = TabController(
      length: _statuses.length,
      vsync: this,
      initialIndex: initial < 0 ? 0 : initial,
    );
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'Lịch hẹn',
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'appointments_add_fab',
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () => _openCreate(),
        icon: const Icon(Icons.add),
        label: Text('Đặt lịch', style: AppTextStyles.semibold(15, color: Colors.white)),
      ),
      child: Column(
        children: [
          TabBar(
            controller: _tab,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: AppTextStyles.semibold(15),
            unselectedLabelStyle: AppTextStyles.regular(15),
            tabs: [for (final s in _statuses) Tab(text: s.label)],
          ),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [for (final s in _statuses) _StatusTab(status: s)],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openCreate() async {
    final created = await context.push<bool>('/appointments/create');
    if (created == true) {
      for (final s in _statuses) {
        ref.invalidate(appointmentListProvider(s));
      }
    }
  }
}

class _StatusTab extends ConsumerWidget {
  const _StatusTab({required this.status});
  final AppointmentStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(appointmentListProvider(status));
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        ref.invalidate(appointmentListProvider(status));
        await ref.read(appointmentListProvider(status).future);
      },
      child: AsyncView<List<Appointment>>(
        value: items,
        onRetry: () => ref.invalidate(appointmentListProvider(status)),
        data: (list) {
          if (list.isEmpty) {
            return ListView(children: [
              const SizedBox(height: 140),
              Center(
                child: Text('Chưa có lịch hẹn',
                    style: AppTextStyles.regular(15, color: AppColors.textMute)),
              ),
            ]);
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) =>
                _AppointmentCard(item: list[i], fallbackStatus: status),
          );
        },
      ),
    );
  }
}

class _AppointmentCard extends ConsumerWidget {
  const _AppointmentCard({required this.item, required this.fallbackStatus});
  final Appointment item;
  final AppointmentStatus fallbackStatus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final st = item.statusEnum ?? fallbackStatus;
    final customer = [
      if ((item.customerName ?? '').isNotEmpty) item.customerName,
      if ((item.customerPhone ?? '').isNotEmpty) item.customerPhone,
    ].whereType<String>().join(' - ');

    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      onTap: () async {
        final result =
            await context.push<Map>('/appointments/${item.id}');
        if (result != null && result['switchToCancelled'] == true) {
          ref.invalidate(appointmentListProvider(AppointmentStatus.cancelled));
          ref.invalidate(appointmentListProvider(fallbackStatus));
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    customer.isEmpty ? 'Khách hàng' : customer,
                    style: AppTextStyles.semibold(17),
                  ),
                ),
                const SizedBox(width: 12),
                AppointmentStatusPill(status: st),
              ],
            ),
            const Divider(height: 24, color: AppColors.border),
            if ((item.propertyTitle ?? '').isNotEmpty)
              _row(Icons.home_work_outlined, item.propertyTitle!),
            if ((item.propertyAddress ?? '').isNotEmpty)
              _row(Icons.location_on_outlined, item.propertyAddress!),
            if (item.startedAt != null && item.startedAt!.isNotEmpty)
              _row(Icons.schedule_outlined, item.startedAt!),
          ],
        ),
      ),
    );
  }

  Widget _row(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.textMute),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: AppTextStyles.regular(15, color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}
