import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/custom_screen.dart';
import '../../../core/widgets/segmented_button_slide.dart';
import '../data/contracts_api.dart';
import 'contract_library_controller.dart';

/// "Thư viện hợp đồng" — 3 transaction-type segments + debounced search,
/// mirroring v1's `ContractLibraryPage`. Reached from the profile quick-tool
/// (v1 `/contract_library`).
class ContractLibraryScreen extends ConsumerStatefulWidget {
  const ContractLibraryScreen({super.key});

  @override
  ConsumerState<ContractLibraryScreen> createState() =>
      _ContractLibraryScreenState();
}

class _ContractLibraryScreenState extends ConsumerState<ContractLibraryScreen> {
  static const _tabLabels = ['Mua bán', 'Đặt cọc', 'Thuê'];
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(contractLibraryControllerProvider);
    final controller = ref.read(contractLibraryControllerProvider.notifier);
    return CustomScreen(
      title: 'Thư viện hợp đồng',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            // v1 `SegmentedButtonSlide`: dark selected pill on a light bar.
            child: SegmentedButtonSlide(
              entries: [
                for (final l in _tabLabels) SegmentedButtonSlideEntry(label: l),
              ],
              selectedEntry: state.tab,
              onChange: controller.setTab,
              height: 36,
              borderRadius: BorderRadius.circular(14),
              colors: const SegmentedButtonSlideColors(
                barColor: AppColors.neutral100, // #F5F5F4
                backgroundSelectedColor: AppColors.text, // #292524
              ),
              selectedTextStyle: AppTextStyles.semibold(13, color: Colors.white),
              unselectedTextStyle:
                  AppTextStyles.regular(13, color: AppColors.textMute),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppTextField(
              label: '',
              controller: _searchController,
              hint: 'Bạn muốn tra cứu hợp đồng nào',
              prefixIcon: Icons.search,
              onChanged: controller.setKeyword,
            ),
          ),
          Expanded(child: _buildList(context, state, controller)),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, ContractLibraryState state,
      ContractLibraryController controller) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: controller.refresh,
      child: Builder(builder: (_) {
        if (state.isLoading && state.items.isEmpty) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primary));
        }
        if (state.error != null && state.items.isEmpty) {
          return ListView(children: [
            const SizedBox(height: 100),
            Center(
              child: Column(children: [
                Text('Đã xảy ra lỗi', style: AppTextStyles.regular(15)),
                const SizedBox(height: 8),
                AppButton(
                    label: 'Thử lại',
                    expand: false,
                    onPressed: controller.refresh),
              ]),
            ),
          ]);
        }
        if (state.items.isEmpty) {
          return ListView(children: [
            const SizedBox(height: 120),
            Center(
                child: Text('Chưa có tài liệu',
                    style: AppTextStyles.regular(15, color: AppColors.textMute))),
          ]);
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          itemCount: state.items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (_, i) => _LibraryCard(item: state.items[i]),
        );
      }),
    );
  }
}

/// v1 library card: white, radius 16, soft shadow; title + version/update rows
/// + full-width "Chi tiết" button (orange-100 fill, primary text).
class _LibraryCard extends StatelessWidget {
  const _LibraryCard({required this.item});
  final LibraryItem item;

  String? _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final dt = DateTime.tryParse(raw);
    if (dt == null) return raw;
    return DateFormat('dd/MM/yyyy HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final updated = _formatDate(item.publishOn);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.title, style: AppTextStyles.semibold(17)),
          if ((item.versionDocs ?? '').isNotEmpty) ...[
            const SizedBox(height: 16),
            _infoLine('Version ', item.versionDocs!),
          ],
          if (updated != null) ...[
            const SizedBox(height: 16),
            _infoLine('Cập nhật ', updated),
          ],
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => context.push('/contract-library/${item.id}'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 9),
              decoration: BoxDecoration(
                color: AppColors.primarySoft, // orange100 #FFEDD5
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('Chi tiết',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.semibold(17, color: AppColors.primary)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoLine(String label, String value) => Text.rich(TextSpan(
        text: label,
        style: AppTextStyles.regular(15),
        children: [
          TextSpan(text: value, style: AppTextStyles.semibold(15)),
        ],
      ));
}
