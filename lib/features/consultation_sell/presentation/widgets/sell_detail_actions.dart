import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/network/tags_api.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/tag_picker_sheet.dart';
import '../../../work_actions/work_dialogs.dart';
import '../../data/consultation_sell_api.dart';
import '../../data/models/sell_lead.dart';

/// Encapsulates the sell-lead detail actions (assign đầu chủ, link BĐS, close,
/// add work, manage tags, dial customer) so the screen stays focused on layout.
///
/// Work actions (call/note/appointment) post to the unified `work_consultation`
/// endpoint with `tablename=consultation_sell`, sharing the rich dialogs with
/// nhu-cầu-mua.
class SellDetailActions {
  SellDetailActions(this.ref, this.id);
  final WidgetRef ref;
  final int id;

  ConsultationSellApi get _api => ref.read(consultationSellApiProvider);

  WorkDialogContext _customerCtx(SellLeadDetail d) => WorkDialogContext(
    contactRole: 'Khách hàng',
    contactName: d.customerName,
    contactPhone: d.customerPhone,
    entityBadge: d.code,
  );

  Future<void> _run(
    BuildContext context,
    Future<void> Function() action,
    String ok,
  ) async {
    try {
      await action();
      ref.invalidate(sellDetailProvider(id));
      ref.invalidate(sellActivitiesProvider(id));
      if (context.mounted) AppToast.success(context, ok);
    } catch (e) {
      if (context.mounted) AppToast.error(context, _errText(e));
    }
  }

  /// Surfaces the real backend message (envelope `message`) instead of a generic
  /// string, so failures like an unsupported `tablename` are actionable.
  String _errText(Object e) {
    if (e is ApiException) return e.message;
    if (e is DioException) {
      final data = e.response?.data;
      final msg = data is Map ? data['message'] : null;
      final code = e.response?.statusCode;
      if (msg != null) return msg.toString();
      if (code != null) return 'Lỗi máy chủ ($code)';
    }
    return 'Có lỗi xảy ra';
  }

  // ---- Gọi chủ nhà, ghi nhận work (create_work_consultation_sell) ----
  Future<void> call(BuildContext context, SellLeadDetail d) async {
    final r = await showCallDialog(
      context,
      ctx: _customerCtx(d),
      title: 'Gọi khách hàng',
    );
    if (r == null || !context.mounted) return;
    await _run(
      context,
      () => _api.createWork(
        sellId: id,
        templateId: 42,
        name: 'Gọi điện - ${r.result}',
        description: r.note.isNotEmpty
            ? r.note
            : 'Gọi điện logged with outcome: ${r.result}',
      ),
      'Đã ghi nhận cuộc gọi',
    );
  }

  // ---- Quản lý thẻ (gán thẻ) ----
  Future<void> manageTags(BuildContext context, SellLeadDetail d) async {
    final res = await showTagPickerSheet(
      context,
      entity: TagEntity.consultationSell,
      entityId: id,
      selectedIds: d.tags.map((t) => t.id).toList(),
    );
    if (res == null) return;
    ref.invalidate(sellDetailProvider(id));
    if (context.mounted) AppToast.success(context, 'Đã cập nhật thẻ');
  }

  // ---- Close ----
  Future<void> close(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Đóng nhu cầu'),
        content: const Text('Đánh dấu nhu cầu bán này là đã đóng?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Huỷ'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    await _run(context, () => _api.close(id), 'Đã đóng nhu cầu');
  }

  // ---- Assign listing manager (đầu chủ) ----
  Future<void> assignManager(BuildContext context) async {
    final managers = await _api.listingManagers();
    if (!context.mounted) return;
    final picked = await showModalBottomSheet<ListingManager>(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Text('Chọn đầu chủ', style: AppTypography.title),
            const SizedBox(height: 8),
            if (managers.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Không có đầu chủ'),
              )
            else
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final m in managers)
                      ListTile(
                        leading: const Icon(
                          Icons.person_pin_outlined,
                          color: AppColors.primary,
                        ),
                        title: Text(m.name),
                        subtitle: m.officeName != null
                            ? Text(m.officeName!)
                            : null,
                        onTap: () => Navigator.pop(context, m),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
    if (picked == null || !context.mounted) return;
    await _run(
      context,
      () => _api.assignListingManager(id, picked.id),
      'Đã gán đầu chủ',
    );
  }

  // ---- Link real estate ----
  Future<void> linkRealEstate(BuildContext context) async {
    final ctrl = TextEditingController();
    final reId = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Liên kết BĐS'),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Mã / ID bất động sản',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Huỷ'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => Navigator.pop(ctx, int.tryParse(ctrl.text.trim())),
            child: const Text('Liên kết'),
          ),
        ],
      ),
    );
    if (reId == null || !context.mounted) return;
    await _run(context, () => _api.linkRealEstate(id, reId), 'Đã liên kết BĐS');
  }

  // ---- Ghi chú công việc (create_work_consultation_sell, template 42) ----
  Future<void> note(BuildContext context, SellLeadDetail d) async {
    final content = await showNoteDialog(context, ctx: _customerCtx(d));
    if (content == null || content.isEmpty || !context.mounted) return;
    await _run(
      context,
      () => _api.createWork(
        sellId: id,
        templateId: 42,
        name: 'Ghi chú',
        description: content,
      ),
      'Đã thêm ghi chú',
    );
  }

  // ---- Add internal comment (ghi chú nội bộ) ----
  Future<void> addComment(BuildContext context) async {
    final text = await _askText(context, 'Thêm ghi chú nội bộ', 'Nội dung...');
    if (text == null || text.isEmpty || !context.mounted) return;
    try {
      await _api.createComment(id, text);
      ref.invalidate(sellCommentsProvider(id));
      if (context.mounted) AppToast.success(context, 'Đã thêm ghi chú');
    } on ApiException catch (e) {
      if (context.mounted) AppToast.error(context, e.message);
    } catch (_) {
      if (context.mounted) AppToast.error(context, 'Không thêm được ghi chú');
    }
  }

  // ---- Lịch hẹn (create_work_consultation_sell, template 4) ----
  Future<void> appointment(BuildContext context, SellLeadDetail d) async {
    final r = await showAppointmentDialog(context, ctx: _customerCtx(d));
    if (r == null || !context.mounted) return;
    await _run(
      context,
      () => _api.createWork(
        sellId: id,
        templateId: 4,
        name: 'Hẹn xem BĐS',
        description: r.note.isNotEmpty ? r.note : null,
        // BE expects ISO-8601 UTC (web `toApiDateTime`).
        startedAt: r.when.toUtc().toIso8601String(),
        location: r.location.isNotEmpty ? r.location : null,
      ),
      'Đã đặt lịch hẹn',
    );
  }

  Future<String?> _askText(BuildContext context, String title, String hint) {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Huỷ'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('Xong'),
          ),
        ],
      ),
    );
  }
}
