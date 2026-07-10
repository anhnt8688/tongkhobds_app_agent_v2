import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/custom_screen.dart';
import '../../realestate/data/models/property.dart' show formatVnd;
import '../data/deposit_models.dart';
import '../data/deposit_api.dart';
import 'deposit_list_screen.dart' show depositStatusColor;

class DepositDetailScreen extends ConsumerWidget {
  const DepositDetailScreen({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(depositDetailProvider(id));
    return CustomScreen(
      title: 'Chi tiết ký gửi',
      backgroundColor: AppColors.bg,
      child: AsyncView<DepositDetail>(
        value: detail,
        onRetry: () => ref.invalidate(depositDetailProvider(id)),
        data: (d) => _body(context, ref, d),
      ),
    );
  }

  Widget _body(BuildContext context, WidgetRef ref, DepositDetail d) {
    final color = depositStatusColor(d.status);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // status header
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.savings_outlined, color: color),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(d.statusText,
                        style: AppTypography.body.copyWith(
                            color: color, fontWeight: FontWeight.w700)),
                    Text('Tiền cọc: ${formatVnd(d.amount.toDouble())}',
                        style: AppTypography.caption
                            .copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // property
        _card('Bất động sản', [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: (d.estate.image ?? '').isNotEmpty
                      ? AppNetworkImage(url: d.estate.image, width: 64, height: 64)
                      : Container(
                          color: AppColors.primarySoft,
                          child: const Icon(Icons.home_work_outlined,
                              color: AppColors.primary)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(d.estate.title,
                        style: AppTypography.body
                            .copyWith(fontWeight: FontWeight.w600)),
                    if (d.estate.address.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(d.estate.address,
                          style: AppTypography.caption
                              .copyWith(color: AppColors.textMute)),
                    ],
                    if (d.estate.code != null) ...[
                      const SizedBox(height: 4),
                      Text('Mã: ${d.estate.code}',
                          style: AppTypography.micro
                              .copyWith(color: AppColors.textMute)),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ]),
        const SizedBox(height: 12),
        // info rows
        _card('Thông tin cọc', [
          _row('Loại cọc', d.typeName ?? '—'),
          _row('Số tiền', formatVnd(d.amount.toDouble())),
          if ((d.createdAt ?? '').isNotEmpty) _row('Ngày tạo', d.createdAt!),
          if ((d.timePayment ?? '').isNotEmpty) _row('Thanh toán', d.timePayment!),
          if ((d.timeCancel ?? '').isNotEmpty) _row('Huỷ lúc', d.timeCancel!),
          if (d.returnAmount != null)
            _row('Hoàn lại', formatVnd(d.returnAmount!.toDouble())),
          if ((d.reason ?? '').isNotEmpty) _row('Lý do', d.reason!),
        ]),
        if (d.customerName != null) ...[
          const SizedBox(height: 12),
          _card('Khách hàng', [
            _row('Tên', d.customerName ?? '—'),
            if ((d.customerPhone ?? '').isNotEmpty)
              _row('SĐT', d.customerPhone!),
          ]),
        ],
        if (d.comments.isNotEmpty) ...[
          const SizedBox(height: 12),
          _card('Ghi chú', [
            for (final c in d.comments)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c.content, style: AppTypography.body),
                    if ((c.createdAt ?? '').isNotEmpty)
                      Text(c.createdAt!,
                          style: AppTypography.micro
                              .copyWith(color: AppColors.textMute)),
                  ],
                ),
              ),
          ]),
        ],
        if (d.canCancel) ...[
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => _confirmCancel(context, ref),
            icon: const Icon(Icons.cancel_outlined, color: AppColors.danger),
            label: const Text('Huỷ ký gửi',
                style: TextStyle(color: AppColors.danger)),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              side: const BorderSide(color: AppColors.danger),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _confirmCancel(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Huỷ ký gửi?'),
        content: const Text('Bạn có chắc muốn huỷ giao dịch ký gửi này?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Không')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Huỷ ký gửi',
                style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(depositApiProvider).cancel(id);
      ref.invalidate(depositDetailProvider(id));
      if (context.mounted) AppToast.success(context, 'Đã huỷ ký gửi');
    } catch (_) {
      if (context.mounted) AppToast.error(context, 'Huỷ thất bại');
    }
  }

  Widget _card(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppTypography.caption.copyWith(
                  color: AppColors.textMute, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 110,
              child: Text(label,
                  style:
                      AppTypography.caption.copyWith(color: AppColors.textMute))),
          Expanded(
            child: Text(value,
                style:
                    AppTypography.body.copyWith(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
