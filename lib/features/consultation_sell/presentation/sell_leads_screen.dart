import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/tags_api.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/consultation_list_card.dart';
import '../../../core/widgets/custom_screen.dart';
import '../../../core/widgets/status_pill.dart';
import '../../../core/widgets/tag_picker_sheet.dart';
import '../data/consultation_sell_api.dart';
import '../data/models/sell_lead.dart';

class SellListState {
  const SellListState({
    this.status = 'all',
    this.search = '',
    this.items = const [],
    this.total = 0,
    this.page = 1,
    this.hasMore = false,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
  });
  final String status;
  final String search;
  final List<SellLead> items;
  final int total;
  final int page;
  final bool hasMore;
  final bool isLoading;
  final bool isLoadingMore;
  final Object? error;

  SellListState copyWith({
    String? status,
    String? search,
    List<SellLead>? items,
    int? total,
    int? page,
    bool? hasMore,
    bool? isLoading,
    bool? isLoadingMore,
    Object? error,
    bool clearError = false,
  }) =>
      SellListState(
        status: status ?? this.status,
        search: search ?? this.search,
        items: items ?? this.items,
        total: total ?? this.total,
        page: page ?? this.page,
        hasMore: hasMore ?? this.hasMore,
        isLoading: isLoading ?? this.isLoading,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        error: clearError ? null : (error ?? this.error),
      );
}

class SellListController extends AutoDisposeNotifier<SellListState> {
  ConsultationSellApi get _api => ref.read(consultationSellApiProvider);
  Timer? _debounce;

  @override
  SellListState build() {
    ref.onDispose(() => _debounce?.cancel());
    Future.microtask(refresh);
    return const SellListState(isLoading: true);
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final res = await _api.list(status: state.status, search: state.search, page: 1);
      state = state.copyWith(
          items: res.items,
          total: res.total,
          page: 1,
          hasMore: res.hasMore,
          isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final res = await _api.list(
          status: state.status, search: state.search, page: state.page + 1);
      state = state.copyWith(
          items: [...state.items, ...res.items],
          page: state.page + 1,
          hasMore: res.hasMore,
          isLoadingMore: false);
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e);
    }
  }

  void setStatus(String s) {
    if (s == state.status) return;
    state = state.copyWith(status: s);
    refresh();
  }

  void setSearch(String s) {
    state = state.copyWith(search: s);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), refresh);
  }
}

final sellListControllerProvider =
    AutoDisposeNotifierProvider<SellListController, SellListState>(
        SellListController.new);

class SellLeadsScreen extends ConsumerStatefulWidget {
  const SellLeadsScreen({super.key});
  @override
  ConsumerState<SellLeadsScreen> createState() => _SellLeadsScreenState();
}

class _SellLeadsScreenState extends ConsumerState<SellLeadsScreen> {
  final _scroll = ScrollController();
  final _searchCtrl = TextEditingController();

  static const _tabs = [
    ('all', 'Tất cả'),
    ('new', 'Mới'),
    ('pending', 'Chờ xử lý'),
    ('consulting', 'Đang tư vấn'),
    ('closed', 'Đã đóng'),
  ];

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 300) {
        ref.read(sellListControllerProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  SellListController get _c => ref.read(sellListControllerProvider.notifier);

  Widget _searchBox(String hint) => TextField(
        controller: _searchCtrl,
        onChanged: _c.setSearch,
        cursorColor: AppColors.primary,
        style: AppTextStyles.semibold(15),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: AppColors.neutral100,
          hintText: hint,
          hintStyle: AppTextStyles.semibold(15, color: AppColors.neutral400),
          prefixIcon: const Icon(Icons.search, color: AppColors.text),
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
      );

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sellListControllerProvider);
    final counts = ref.watch(sellStatusCountsProvider).valueOrNull ?? const [];
    final canAdd = ref.watch(sellPermissionsProvider).valueOrNull?.add ?? false;
    int countFor(String s) =>
        counts.firstWhere((c) => c.status == s, orElse: () => const StatusCount(status: '')).count;

    return CustomScreen(
      title: 'Nhu cầu bán',
      floatingActionButton: !canAdd
          ? null
          : FloatingActionButton.extended(
              heroTag: 'sell_leads_add_fab',
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              onPressed: () async {
                final ok = await context.push<bool>('/nhu-cau-ban/create');
                if (ok == true) {
                  _c.refresh();
                  ref.invalidate(sellStatusCountsProvider);
                }
              },
              icon: const Icon(Icons.add),
              label: Text('Tạo nhu cầu bán',
                  style: AppTextStyles.semibold(15, color: Colors.white)),
            ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: _searchBox('Mã, tên / SĐT chủ nhà...'),
          ),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _tabs.length,
              separatorBuilder: (_, __) => const SizedBox(width: 20),
              itemBuilder: (_, i) {
                final t = _tabs[i];
                return _Tab(
                  label: t.$1 == 'all'
                      ? t.$2
                      : '${t.$2}${countFor(t.$1) > 0 ? ' (${countFor(t.$1)})' : ''}',
                  selected: state.status == t.$1,
                  onTap: () => _c.setStatus(t.$1),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          Expanded(child: _body(state)),
        ],
      ),
    );
  }

  Future<void> _manageTags(SellLead d) async {
    final res = await showTagPickerSheet(
      context,
      entity: TagEntity.consultationSell,
      entityId: d.id,
      selectedIds: d.tags.map((t) => t.id).toList(),
    );
    if (res == null) return;
    _c.refresh();
    if (mounted) AppToast.success(context, 'Đã cập nhật thẻ');
  }

  Widget _body(SellListState state) {
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
          Text(msg,
              style: AppTextStyles.medium(13, color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          TextButton(onPressed: _c.refresh, child: const Text('Thử lại')),
        ]),
      );
    }
    if (state.items.isEmpty) {
      return Center(
          child: Text('Chưa có nhu cầu bán',
              style: AppTextStyles.regular(15, color: AppColors.textMute)));
    }
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        ref.invalidate(sellStatusCountsProvider);
        await _c.refresh();
      },
      child: ListView.separated(
        controller: _scroll,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        itemCount: state.items.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          if (i == state.items.length) {
            if (state.isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                    child:
                        CircularProgressIndicator(color: AppColors.primary)),
              );
            }
            return const SizedBox(height: 24);
          }
          final d = state.items[i];
          return _SellCard(
            lead: d,
            onTap: () => context.push('/nhu-cau-ban/${d.id}'),
            onLongPress: () => _manageTags(d),
          );
        },
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab(
      {required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected ? AppColors.primary : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(label,
              style: selected
                  ? AppTextStyles.semibold(15, color: AppColors.primary)
                  : AppTextStyles.regular(15, color: AppColors.text)),
        ),
      );
}

class _SellCard extends StatelessWidget {
  const _SellCard({required this.lead, required this.onTap, this.onLongPress});
  final SellLead lead;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  static String _priceText(double? p) {
    if (p == null) return 'Thỏa thuận';
    if (p >= 1e9) {
      final b = p / 1e9;
      return '${b == b.roundToDouble() ? b.toInt() : b.toStringAsFixed(1)} tỷ';
    }
    if (p >= 1e6) return '${(p / 1e6).toStringAsFixed(0)} triệu';
    return p.toStringAsFixed(0);
  }

  static String _areaText(num? a) =>
      a == null ? '—' : '${a == a.roundToDouble() ? a.toInt() : a} m²';

  @override
  Widget build(BuildContext context) {
    final d = lead;
    // Văn phòng + người phụ trách (đầu chủ) for the list secondary line.
    final secondary = [
      if ((d.officeName ?? '').isNotEmpty) d.officeName!,
      if ((d.supportName ?? '').isNotEmpty)
        d.supportName!
      else if ((d.listingManagerName ?? '').isNotEmpty)
        d.listingManagerName!,
    ].join('  •  ');
    return ConsultationListCard(
      code: d.code ?? '',
      name: d.customerName ?? 'Chủ nhà',
      statusBadge: StatusPill(
          label: d.statusLabel, tone: d.statusEnum?.tone ?? StatusTone.neutral),
      phone: d.customerPhone,
      box1Title: 'Giá',
      box1Value: _priceText(d.price),
      box2Title: 'Diện tích',
      box2Value: _areaText(d.area),
      location: d.fullAddress,
      secondaryIcon: Icons.apartment_outlined,
      secondaryText: secondary,
      tags: [for (final t in d.tags) (label: t.name, color: t.color)],
      createdAt: d.createdOn,
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
