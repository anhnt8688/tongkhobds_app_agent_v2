import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/json_parse.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/custom_screen.dart';
import '../../realestate/data/models/property.dart';
import '../data/transactions_api.dart';

class TransactionDetailScreen extends ConsumerWidget {
  const TransactionDetailScreen({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(transactionDetailProvider(id));
    return CustomScreen(
      title: 'Chi tiết giao dịch',
      child: AsyncView<Map>(
        value: detail,
        onRetry: () => ref.invalidate(transactionDetailProvider(id)),
        data: (d) => _Body(data: d),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.data});
  final Map data;

  String _s(List<String> keys) {
    for (final k in keys) {
      final v = data[k];
      if (v != null && v.toString().isNotEmpty) return v.toString();
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final amount = asDoubleOrNull(data['amount'] ?? data['price'] ?? data['value']);
    final rows = <(String, String)>[
      ('Mã GD', _s(['code', 'transaction_code'])),
      ('Khách hàng', _s(['customer_name', 'customer', 'buyer_name'])),
      ('BĐS', _s(['real_estate_title', 'property_title', 'title'])),
      ('Trạng thái', _s(['status_name', 'status'])),
      ('Ngày tạo', _s(['created_on', 'created_at', 'date'])),
      ('Ghi chú', _s(['note', 'noted', 'description'])),
    ].where((e) => e.$2.isNotEmpty).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (amount != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Giá trị giao dịch',
                    style: AppTypography.caption.copyWith(color: AppColors.primaryDark)),
                Text(formatVnd(amount),
                    style: AppTypography.display.copyWith(color: AppColors.primaryDark)),
              ],
            ),
          ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              for (final r in rows)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 100, child: Text(r.$1, style: AppTypography.caption)),
                      Expanded(child: Text(r.$2, style: AppTypography.body)),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        AppButton(
          label: 'Tạo đặt cọc',
          icon: Icons.payments_outlined,
          variant: AppButtonVariant.success,
          onPressed: () =>
              AppToast.info(context, 'Luồng đặt cọc đang hoàn thiện'),
        ),
      ],
    );
  }
}
