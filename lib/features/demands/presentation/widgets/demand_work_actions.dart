import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../work_actions/work_dialogs.dart';
import '../../data/demands_api.dart';
import '../../data/models/consultation_activity.dart';
import 'demand_work_dialogs.dart' show askWorkText;

/// Reusable `work_consultation` actions for a working BĐS (consultation
/// interest). Shared by the inline action chips and the more-menu sheet so the
/// posting logic, validation and refresh behaviour live in one place.
///
/// Action codes: call_owner · send_customer · note · request_verification ·
/// appointment · deposit · not_suitable (plus the local-only remove_from_list).
///
/// Callers pass a context that stays mounted across the async dialog flow — the
/// more-menu sheet therefore closes itself first and hands in the page context.
class DemandWorkActions {
  DemandWorkActions(
    this.ref,
    this.consultationId, {
    this.interest,
    this.customerName,
    this.customerPhone,
  });

  final WidgetRef ref;
  final int consultationId;
  final ConsultationInterest? interest;
  final String? customerName;
  final String? customerPhone;

  /// Datetime format the Web2py backend expects for `started_at`.
  static final _dateFmt = DateFormat('yyyy-MM-dd HH:mm:ss');

  /// True when the BĐS has an assigned đầu chủ (listing manager / agent).
  bool get _hasOwner =>
      (interest?.agentName ?? '').trim().isNotEmpty ||
      (interest?.agentPhone ?? '').trim().isNotEmpty;

  Map<String, dynamic> _base(String code) => interest != null
      ? {
          'tablename': 'consultation_interest',
          'table_id': interest!.id,
          'code': code,
        }
      : {
          'tablename': 'consultation',
          'table_id': consultationId,
          'code': code,
        };

  /// Dialog context with the đầu chủ as the contact (call / verify).
  WorkDialogContext _ownerCtx() => WorkDialogContext(
        contactRole: 'Đầu chủ',
        contactName: interest?.agentName,
        contactPhone: interest?.agentPhone,
        bdsCode: interest?.code,
        bdsTitle: interest?.title,
        bdsSubtitle: interest?.address,
        entityBadge: interest?.code,
        hasOwner: _hasOwner,
        ownerName: interest?.agentName,
      );

  /// Dialog context with the customer (buyer) as the contact (send / appt /
  /// deposit / note).
  WorkDialogContext _customerCtx() => WorkDialogContext(
        contactRole: 'Khách hàng',
        contactName: customerName,
        contactPhone: customerPhone,
        bdsCode: interest?.code,
        bdsTitle: interest?.title,
        bdsSubtitle: interest?.address,
        postLink: interest?.shareLink,
        entityBadge: interest?.code,
      );

  Future<void> _post(
      BuildContext context, Map<String, dynamic> payload, String okMsg) async {
    try {
      await ref.read(demandsApiProvider).work(payload);
      ref.invalidate(demandInterestsProvider(consultationId));
      ref.invalidate(demandActivitiesProvider(consultationId));
      if (interest != null) {
        ref.invalidate(demandInterestActivitiesProvider(interest!.id));
      }
      if (context.mounted) AppToast.success(context, okMsg);
    } on ApiException catch (e) {
      if (context.mounted) AppToast.error(context, e.message);
    } catch (_) {
      if (context.mounted) AppToast.error(context, 'Có lỗi xảy ra');
    }
  }

  // ---- 1. Gọi đầu chủ — no đầu chủ → info toast, no action ----
  Future<void> callOwner(BuildContext context) async {
    if (!_hasOwner) {
      AppToast.info(context, 'BĐS chưa có đầu chủ');
      return;
    }
    final r = await showCallDialog(context,
        ctx: _ownerCtx(), title: 'Gọi đầu chủ');
    if (r == null || !context.mounted) return;
    await _post(
        context,
        {
          ..._base('call_owner'),
          'call_result': r.result,
          if (r.note.isNotEmpty) 'content': r.note,
        },
        'Đã ghi nhận cuộc gọi');
  }

  // ---- 1b. Gọi khách hàng (buyer) ----
  Future<void> callCustomer(BuildContext context) async {
    final r = await showCallDialog(context,
        ctx: _customerCtx(), title: 'Gọi khách hàng');
    if (r == null || !context.mounted) return;
    await _post(
        context,
        {
          ..._base('call_customer'),
          'call_result': r.result,
          if (r.note.isNotEmpty) 'content': r.note,
        },
        'Đã ghi nhận cuộc gọi');
  }

  // ---- 2. Gửi khách hàng ----
  Future<void> sendCustomer(BuildContext context) async {
    final r = await showSendCustomerDialog(context, ctx: _customerCtx());
    if (r == null || !context.mounted) return;
    // Content posted to BE/Zalo must carry the share link (user-editable in
    // the dialog, prefilled from interest.shareLink).
    final content = [r.message, r.link].where((e) => e.isNotEmpty).join('\n');
    await _post(
        context,
        {
          ..._base('send_customer'),
          'send_channel': r.channel,
          if (content.isNotEmpty) 'content': content,
        },
        'Đã gửi khách');
  }

  // ---- 3. Ghi chú ----
  Future<void> note(BuildContext context) async {
    final content = await showNoteDialog(context, ctx: _customerCtx());
    if (content == null || content.isEmpty || !context.mounted) return;
    await _post(
        context,
        {..._base('note'), 'content': content, 'visibility': 'public'},
        'Đã thêm ghi chú');
  }

  // ---- 4. Nhắc xác thực — owner: nhắc; no owner: gửi vào pool ----
  // Both go through work_consultation/request_verification; the backend routes
  // to the đầu chủ pool when the BĐS has no assigned đầu chủ.
  Future<void> remindVerify(BuildContext context) async {
    final r = await showVerifyDialog(context, ctx: _ownerCtx());
    if (r == null || !context.mounted) return;
    await _post(
        context,
        {..._base('request_verification'), if (r.note.isNotEmpty) 'content': r.note},
        _hasOwner ? 'Đã gửi nhắc xác thực' : 'Đã gửi yêu cầu vào pool');
  }

  // ---- 5. Hẹn xem ----
  Future<void> appointment(BuildContext context) async {
    final r = await showAppointmentDialog(context, ctx: _customerCtx());
    if (r == null || !context.mounted) return;
    await _post(
        context,
        {
          ..._base('appointment'),
          'started_at': _dateFmt.format(r.when),
          if (r.location.isNotEmpty) 'location': r.location,
          if (r.note.isNotEmpty) 'note': r.note,
          'notify_owner': r.notifyOwner,
        },
        'Đã đặt lịch hẹn');
  }

  // ---- 6. Đặt cọc ----
  Future<void> deposit(BuildContext context) async {
    final r = await showDepositDialog(context, ctx: _customerCtx());
    if (r == null || !context.mounted) return;
    await _post(
        context,
        {
          ..._base('deposit'),
          'deposit_type': r.type,
          'deposit_amount': r.amount,
          if (r.note.isNotEmpty) 'deposit_notes': r.note,
        },
        'Đã ghi nhận đặt cọc');
  }

  // ---- 7. Không phù hợp — content required if reason 'other' ----
  Future<void> notSuitable(BuildContext context) async {
    final reasons = await ref.read(demandsApiProvider).notSuitableReasons();
    if (!context.mounted) return;
    final picked = await showModalBottomSheet<NotSuitableReason>(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Text('Lý do không phù hợp', style: AppTypography.title),
            const SizedBox(height: 8),
            if (reasons.isEmpty)
              const Padding(
                  padding: EdgeInsets.all(16), child: Text('Không có lý do'))
            else
              for (final r in reasons)
                ListTile(
                  title: Text(r.label),
                  onTap: () => Navigator.pop(context, r),
                ),
          ],
        ),
      ),
    );
    if (picked == null || !context.mounted) return;
    String? content;
    if (picked.code == 'other') {
      content = await askWorkText(context, 'Lý do khác', 'Nhập lý do');
      if (content == null || content.isEmpty) {
        if (context.mounted) AppToast.error(context, 'Vui lòng nhập lý do');
        return;
      }
      if (!context.mounted) return;
    }
    await _post(
        context,
        {
          ..._base('not_suitable'),
          'reason_code': picked.code,
          if (content != null && content.isNotEmpty) 'content': content,
        },
        'Đã đánh dấu không phù hợp');
  }

  // ---- Local-only: remove from working list ----
  Future<void> remove(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Gỡ BĐS'),
        content: const Text('Gỡ BĐS này khỏi danh sách đang làm việc?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Huỷ')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Gỡ'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    await _post(context, _base('remove_from_list'), 'Đã gỡ khỏi danh sách');
  }
}
