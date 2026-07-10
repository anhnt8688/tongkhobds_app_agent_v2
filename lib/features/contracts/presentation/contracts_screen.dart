import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/vietnamese_text.dart';
import '../../../core/widgets/async_view.dart';
import '../data/contracts_api.dart';
import 'widgets/contract_grid_card.dart';

/// "Danh sách hợp đồng" — v1 `ContractPage`: a 2-column grid of contract cards
/// with an AppBar search toggle (accent-insensitive filter). The KYC-step gate
/// and the contract library live elsewhere (profile entry + quick-tool).
class ContractsScreen extends ConsumerStatefulWidget {
  const ContractsScreen({super.key});

  @override
  ConsumerState<ContractsScreen> createState() => _ContractsScreenState();
}

class _ContractsScreenState extends ConsumerState<ContractsScreen> {
  bool _searching = false;
  String _query = '';

  List<ContractItem> _filter(List<ContractItem> all) {
    final q = _query.trim();
    if (q.isEmpty) return all;
    final ql = q.toLowerCase();
    final qn = removeDiacritics(q);
    bool hit(String? v) {
      final s = (v ?? '').toLowerCase();
      return s.contains(ql) || removeDiacritics(s).contains(qn);
    }

    return all
        .where((c) =>
            hit(c.title) || hit(c.price) || hit(c.address) || hit(c.nameSale))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final contracts = ref.watch(contractsProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          ref.invalidate(contractsProvider);
          await ref.read(contractsProvider.future);
        },
        child: AsyncView<List<ContractItem>>(
          value: contracts,
          onRetry: () => ref.invalidate(contractsProvider),
          data: (all) {
            final list = _filter(all);
            if (list.isEmpty) {
              return ListView(children: [
                const SizedBox(height: 160),
                Center(
                  child: Text(
                    _query.isEmpty
                        ? 'Không có hợp đồng nào'
                        : 'Không tìm thấy hợp đồng phù hợp',
                    style: AppTextStyles.regular(14, color: AppColors.textMute),
                  ),
                ),
              ]);
            }
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                childAspectRatio: 0.70,
              ),
              itemBuilder: (_, i) {
                final c = list[i];
                return ContractGridCard(
                  contract: c,
                  onTap: () => context.push('/contract/${c.id}', extra: {
                    'viewOnly': c.isSigned,
                    'pdfUrl': c.pdfUrl,
                    'title': c.title,
                    'contractType': c.contractType,
                    'signingMethod': c.signingMethods,
                  }),
                );
              },
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    if (_searching) {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            autofocus: true,
            textAlignVertical: TextAlignVertical.center,
            onChanged: (v) => setState(() => _query = v),
            style: AppTextStyles.regular(16),
            decoration: InputDecoration(
              hintText: 'Tìm kiếm',
              hintStyle: AppTextStyles.regular(16, color: AppColors.neutral400),
              prefixIcon: const Icon(Icons.search,
                  color: Color(0xFF9CA3AF), size: 20),
              border: InputBorder.none,
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => setState(() {
              _searching = false;
              _query = '';
            }),
            child: Text('Huỷ bỏ',
                style: AppTextStyles.regular(16, color: AppColors.text)),
          ),
        ],
      );
    }
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text('Danh sách hợp đồng', style: AppTextStyles.bold(20)),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black),
          onPressed: () => setState(() => _searching = true),
        ),
      ],
    );
  }
}
