import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/custom_screen.dart';
import '../../../core/widgets/status_pill.dart';
import '../../../core/widgets/status_tone.dart';
import '../../realestate/data/models/property.dart';
import '../data/models/transaction.dart';
import '../data/transactions_api.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txns = ref.watch(transactionsProvider);
    return CustomScreen(
      title: 'Giao dịch',
      child: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          ref.invalidate(transactionsProvider);
          await ref.read(transactionsProvider.future);
        },
        child: AsyncView<List<TransactionItem>>(
          value: txns,
          onRetry: () => ref.invalidate(transactionsProvider),
          data: (list) {
            if (list.isEmpty) {
              return ListView(children: const [
                SizedBox(height: 120),
                Center(child: Text('Chưa có giao dịch')),
              ]);
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _TxnCard(
                txn: list[i],
                onTap: () => context.push('/transaction/${list[i].id}'),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TxnCard extends StatelessWidget {
  const _TxnCard({required this.txn, this.onTap});
  final TransactionItem txn;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(txn.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.body
                            .copyWith(fontWeight: FontWeight.w600)),
                  ),
                  if (txn.status != null)
                    StatusPill(label: txn.status!, tone: toneForStatus(txn.status)),
                ],
              ),
              const SizedBox(height: 6),
              if (txn.customerName != null)
                Row(children: [
                  const Icon(Icons.person_outline, size: 14, color: AppColors.textMute),
                  const SizedBox(width: 4),
                  Text(txn.customerName!, style: AppTypography.caption),
                ]),
              const SizedBox(height: 4),
              Row(
                children: [
                  if (txn.amount != null)
                    Text(formatVnd(txn.amount),
                        style: AppTypography.subtitle
                            .copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  if (txn.createdAt != null)
                    Text(txn.createdAt!, style: AppTypography.micro),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
