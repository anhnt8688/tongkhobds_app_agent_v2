import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/custom_screen.dart';
import '../data/loan_api.dart';
import '../data/models/loan_package.dart';
import 'widgets/loan_package_card.dart';

/// Packages for a partner bank (v1 ListLoanPackagePage), opened from the hub
/// carousel "Xem thêm". Pull to refresh.
class LoanPackagesScreen extends ConsumerWidget {
  const LoanPackagesScreen({super.key, required this.bankId});

  final int bankId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(loanPackagesByBankProvider(bankId));
    return CustomScreen(
      title: 'Danh sách gói vay',
      backgroundColor: AppColors.bg,
      child: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async => ref.invalidate(loanPackagesByBankProvider(bankId)),
        child: AsyncView<List<LoanPackage>>(
          value: async,
          onRetry: () => ref.invalidate(loanPackagesByBankProvider(bankId)),
          data: (packages) => packages.isEmpty
              ? ListView(children: [
                  const SizedBox(height: 160),
                  Center(
                    child: Text('Chưa có gói vay',
                        style: AppTypography.body
                            .copyWith(color: AppColors.textMute)),
                  ),
                ])
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: packages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (_, i) => LoanPackageCard(package: packages[i]),
                ),
        ),
      ),
    );
  }
}
