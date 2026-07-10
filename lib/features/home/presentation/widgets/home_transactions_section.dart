import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../realestate/data/models/property.dart' show formatVnd;
import '../../../transactions/data/models/transaction.dart';
import '../home_providers.dart';

/// "Giao dịch" (v1 `transactionView`): a swipeable carousel of the most recent
/// transactions with page dots and a "Xem tất cả" link. Hidden while empty.
class HomeTransactionsSection extends ConsumerStatefulWidget {
  const HomeTransactionsSection({super.key});

  @override
  ConsumerState<HomeTransactionsSection> createState() =>
      _HomeTransactionsSectionState();
}

class _HomeTransactionsSectionState
    extends ConsumerState<HomeTransactionsSection> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final txns = ref.watch(homeTransactionsProvider);
    return txns.maybeWhen(
      data: (list) {
        if (list.isEmpty) return const SizedBox.shrink();
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Giao dịch', style: AppTextStyles.bold(22)),
                  GestureDetector(
                    onTap: () => context.push('/transactions'),
                    child: Text('Xem tất cả',
                        style: AppTextStyles.semibold(15,
                            color: AppColors.primary)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 182,
              child: PageView.builder(
                controller: _controller,
                itemCount: list.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _TxnCard(txn: list[i]),
                ),
              ),
            ),
            if (list.length > 1) ...[
              const SizedBox(height: 8),
              _Dots(count: list.length, index: _index),
            ],
          ],
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _TxnCard extends StatelessWidget {
  const _TxnCard({required this.txn});
  final TransactionItem txn;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => context.push('/transaction/${txn.id}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.neutral200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: "Giao dịch #code" + transaction-type pill (v1 layout).
            Row(
              children: [
                Expanded(
                  child: Text(
                      txn.code != null ? 'Giao dịch #${txn.code}' : txn.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.semibold(17)),
                ),
                if (txn.transactionType != null &&
                    txn.transactionType!.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(txn.transactionType!,
                        style: AppTextStyles.semibold(13,
                            color: AppColors.primary)),
                  ),
                ],
              ],
            ),
            if (txn.customerName != null || txn.amount != null) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  if (txn.customerName != null) ...[
                    const Icon(Icons.person_outline,
                        size: 15, color: AppColors.textMute),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(txn.customerName!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.regular(13,
                              color: AppColors.textSecondary)),
                    ),
                  ] else
                    const Spacer(),
                  if (txn.amount != null)
                    Text(formatVnd(txn.amount),
                        style: AppTextStyles.semibold(15,
                            color: AppColors.primary)),
                ],
              ),
            ],
            const Spacer(),
            _StatusBox(txn: txn),
          ],
        ),
      ),
    );
  }
}

/// Coloured status chip tinted by the transaction's `color_code`, with the
/// seller commission line underneath (v1 status box).
class _StatusBox extends StatelessWidget {
  const _StatusBox({required this.txn});
  final TransactionItem txn;

  @override
  Widget build(BuildContext context) {
    if (txn.status == null || txn.status!.isEmpty) {
      return const SizedBox.shrink();
    }
    final color = txn.statusColor != null && txn.statusColor!.isNotEmpty
        ? AppColors.fromHex(txn.statusColor, fallback: AppColors.textSecondary)
        : AppColors.textSecondary;
    final rate = txn.commissionRate;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(txn.status!, style: AppTextStyles.semibold(15, color: color)),
          if (rate != null && rate != 0)
            Text('Tiền hoa hồng: ${rate.toStringAsFixed(0)}% Giá trị giao dịch',
                style: AppTextStyles.regular(13,
                    color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index});
  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return Container(
          width: active ? 16 : 8,
          height: 8,
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : AppColors.neutral200,
            borderRadius: BorderRadius.circular(100),
          ),
        );
      }),
    );
  }
}
