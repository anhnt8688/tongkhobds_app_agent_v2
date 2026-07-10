import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/custom_screen.dart';
import '../data/appointments_api.dart';
import 'cancel_reason_sheet.dart';
import 'widgets/appointment_status_pill.dart';

class AppointmentDetailScreen extends ConsumerStatefulWidget {
  const AppointmentDetailScreen({super.key, required this.id});
  final int id;

  @override
  ConsumerState<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState
    extends ConsumerState<AppointmentDetailScreen> {
  bool _busy = false;

  void _refresh() {
    ref.invalidate(appointmentDetailProvider(widget.id));
    for (final s in AppointmentStatus.values) {
      ref.invalidate(appointmentListProvider(s));
    }
  }

  Future<void> _run(
    Future<AppointmentResult> Function() action, {
    required String okMessage,
    bool popToCancelled = false,
  }) async {
    setState(() => _busy = true);
    try {
      final res = await action();
      if (!res.success) {
        if (mounted) AppToast.error(context, res.message ?? 'Có lỗi xảy ra');
        return;
      }
      _refresh();
      if (!mounted) return;
      AppToast.success(
          context, res.message?.isNotEmpty == true ? res.message! : okMessage);
      if (popToCancelled) {
        context.pop<Map>({'switchToCancelled': true});
      }
    } on ApiException catch (e) {
      if (mounted) AppToast.error(context, e.message);
    } catch (_) {
      if (mounted) AppToast.error(context, 'Có lỗi xảy ra');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _cancel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => CancelReasonSheet(
        onSend: (note) => _run(
          () => ref.read(appointmentsApiProvider).updateStatus(
                appointmentId: widget.id,
                status: 'cancelled',
                note: note,
              ),
          okMessage: 'Đã huỷ lịch hẹn',
          popToCancelled: true,
        ),
      ),
    );
  }

  void _complete() => _run(
        () => ref.read(appointmentsApiProvider).updateStatus(
              appointmentId: widget.id,
              status: 'completed',
            ),
        okMessage: 'Đã hoàn thành lịch hẹn',
      );

  Future<void> _edit(Appointment a) async {
    final saved =
        await context.push<bool>('/appointments/create', extra: a);
    if (saved == true) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final detail = ref.watch(appointmentDetailProvider(widget.id));
    return CustomScreen(
      title: 'Chi tiết lịch hẹn',
      child: AsyncView<Appointment>(
        value: detail,
        onRetry: () => ref.invalidate(appointmentDetailProvider(widget.id)),
        data: (a) {
          final st = a.statusEnum;
          final showButtons = st == AppointmentStatus.pending ||
              st == AppointmentStatus.inProgress;
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _Card(
                      title: 'Thông tin lịch hẹn',
                      trailing:
                          st == null ? null : AppointmentStatusPill(status: st),
                      rows: [
                        ('Ngày hẹn', a.dateText),
                        ('Giờ hẹn', a.timeText),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _Card(
                      title: 'Thông tin BĐS',
                      rows: [
                        ('Tên BĐS', a.propertyTitle ?? ''),
                        ('Địa chỉ', a.propertyAddress ?? ''),
                      ],
                    ),
                    if ((a.customerName ?? '').isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _Card(
                        title: 'Khách hàng',
                        rows: [
                          ('Tên khách hàng', a.customerName ?? ''),
                          ('Số điện thoại', a.customerPhone ?? ''),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (showButtons) _buttons(a, st!),
            ],
          );
        },
      ),
    );
  }

  Widget _buttons(Appointment a, AppointmentStatus st) {
    final isPending = st == AppointmentStatus.pending;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                label: isPending ? 'Huỷ' : 'Đã đặt lịch',
                variant: AppButtonVariant.danger,
                onPressed: _busy ? null : _cancel,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton(
                label: isPending ? 'Chỉnh sửa' : 'Hoàn thành',
                loading: _busy,
                onPressed: _busy
                    ? null
                    : (isPending ? () => _edit(a) : _complete),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.rows, this.trailing});
  final String title;
  final List<(String, String)> rows;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 16,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(child: Text(title, style: AppTextStyles.semibold(20))),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 12),
          for (final r in rows) _kv(r.$1, r.$2),
        ],
      ),
    );
  }

  Widget _kv(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label,
                style: AppTextStyles.regular(15, color: AppColors.neutral400)),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              value.isEmpty ? '--' : value,
              textAlign: TextAlign.right,
              style: AppTextStyles.semibold(15),
            ),
          ),
        ],
      ),
    );
  }
}
