import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../customers/data/customers_api.dart';
import '../../../customers/data/models/customer.dart';

/// Bottom sheet for searching and selecting an existing customer. Returns the
/// picked [Customer] via Navigator.pop.
class CustomerPickerSheet extends ConsumerWidget {
  const CustomerPickerSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(customersProvider);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        children: [
          const SizedBox(height: 12),
          Text('Chọn khách hàng', style: AppTypography.heading),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) =>
                  ref.read(customerSearchProvider.notifier).state = v,
              decoration: InputDecoration(
                hintText: 'Tìm khách hàng...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
              ),
            ),
          ),
          Expanded(
            child: list.when(
              loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary)),
              error: (_, __) =>
                  const Center(child: Text('Không tải được khách hàng')),
              data: (customers) => customers.isEmpty
                  ? const Center(child: Text('Không có khách hàng'))
                  : ListView.separated(
                      itemCount: customers.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final c = customers[i];
                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: AppColors.primarySoft,
                            child: Icon(Icons.person_outline,
                                color: AppColors.primary),
                          ),
                          title: Text(c.name),
                          subtitle: Text(c.phone),
                          onTap: () => Navigator.pop(context, c),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
