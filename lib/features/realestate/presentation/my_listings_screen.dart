import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/custom_screen.dart';
import 'my_listings_controller.dart';
import 'open_property.dart';
import 'widgets/listing_filter_bar.dart';
import 'widgets/listing_filter_sheets.dart';
import 'widgets/my_listing_card.dart';

/// "BĐS của tôi" — the agent's own listings with status tabs, search, the full
/// v1 filter set + sort, and pagination (parity with v1 `MyProductPage`). Each
/// card opens the owned detail, where the status-aware agent actions live
/// (Gỡ bài / Chỉnh sửa / Xác thực / Ký HĐ).
class MyListingsScreen extends ConsumerStatefulWidget {
  const MyListingsScreen({super.key});

  @override
  ConsumerState<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends ConsumerState<MyListingsScreen> {
  final _scroll = ScrollController();
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      final p = _scroll.position;
      if (p.pixels >= p.maxScrollExtent - 300) {
        ref.read(myListingsControllerProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    _search.dispose();
    super.dispose();
  }

  MyListingsController get _c =>
      ref.read(myListingsControllerProvider.notifier);

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myListingsControllerProvider);
    return CustomScreen(
      title: 'BĐS của tôi',
      backgroundColor: AppColors.bg,
      action: state.filters.sorts.isEmpty
          ? null
          : IconButton(
              icon: const Icon(Icons.swap_vert),
              tooltip: 'Sắp xếp',
              onPressed: () => showSortSheet(
                context,
                values: state.filters.sorts,
                selected: state.sort,
                onSelected: _c.setSort,
              ),
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'my_listings_add_fab',
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () => context.go('/post'),
        child: const Icon(Icons.add),
      ),
      child: Column(
        children: [
          _statusTabs(state),
          const SizedBox(height: 12),
          _searchBox(),
          const SizedBox(height: 12),
          const ListingFilterBar(),
          const SizedBox(height: 8),
          const Divider(height: 1),
          Expanded(child: _body(state)),
        ],
      ),
    );
  }

  Widget _searchBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _search,
        onChanged: _c.setSearch,
        cursorColor: AppColors.primary,
        style: AppTextStyles.semibold(15),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: AppColors.neutral100,
          hintText: 'Tìm kiếm theo ID, tên dự án,...',
          hintStyle: AppTextStyles.semibold(15, color: AppColors.neutral400),
          prefixIcon: const Icon(Icons.search, color: AppColors.text),
          suffixIcon: _search.text.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () {
                    _search.clear();
                    _c.setSearch('');
                  },
                ),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide.none),
          enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide.none),
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: AppColors.primary, width: 2)),
        ),
      ),
    );
  }

  Widget _statusTabs(MyListingsState state) {
    final statuses = state.filters.statuses;
    if (statuses.isEmpty) return const SizedBox(height: 4);
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: statuses.length,
        separatorBuilder: (_, __) => const SizedBox(width: 20),
        itemBuilder: (_, i) {
          final s = statuses[i];
          final active = state.statusCode == (s.code ?? '');
          return GestureDetector(
            onTap: () => _c.setStatus(s.code ?? ''),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: active ? AppColors.primary : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
              child: Text(
                s.name,
                style: active
                    ? AppTextStyles.semibold(15, color: AppColors.primary)
                    : AppTextStyles.regular(15, color: AppColors.text),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _body(MyListingsState state) {
    if (state.isLoading && state.items.isEmpty) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (state.error != null && state.items.isEmpty) {
      final msg = state.error is ApiException
          ? (state.error as ApiException).message
          : 'Đã có lỗi xảy ra';
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.error_outline, color: AppColors.danger, size: 40),
          const SizedBox(height: 12),
          Text(msg, style: AppTypography.subtitle),
          const SizedBox(height: 16),
          TextButton(onPressed: _c.refresh, child: const Text('Thử lại')),
        ]),
      );
    }
    if (state.items.isEmpty) {
      return ListView(children: const [
        SizedBox(height: 120),
        Center(child: Text('Bạn chưa có tin nào ở trạng thái này')),
      ]);
    }
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _c.refresh,
      child: ListView.separated(
        controller: _scroll,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        itemCount: state.items.length + 1,
        separatorBuilder: (_, __) => const Divider(height: 32),
        itemBuilder: (context, i) {
          if (i == state.items.length) {
            return state.isLoadingMore
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primary)))
                : const SizedBox(height: 8);
          }
          final p = state.items[i];
          return MyListingCard(
            property: p,
            onTap: () => openProperty(context, p, owned: true),
          );
        },
      ),
    );
  }
}
