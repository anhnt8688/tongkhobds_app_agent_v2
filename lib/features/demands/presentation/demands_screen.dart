import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/tags_api.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/consultation_list_card.dart';
import '../../../core/widgets/custom_screen.dart';
import '../../../core/widgets/status_pill.dart';
import '../../../core/widgets/tag_picker_sheet.dart';
import '../../locations/locations_screen.dart';
import '../data/demands_api.dart';
import '../data/models/demand.dart';

// ───────────────────────── controller ─────────────────────────

class DemandListState {
  const DemandListState({
    this.status = 'all',
    this.search = '',
    this.cityId,
    this.districtId,
    this.wardId,
    this.locationLabel,
    this.startDate,
    this.endDate,
    this.items = const [],
    this.statusTabs = const [],
    this.total = 0,
    this.page = 1,
    this.totalPages = 1,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
  });

  final String status;
  final String search;
  final String? cityId;
  final String? districtId;
  final String? wardId;
  final String? locationLabel;
  final String? startDate;
  final String? endDate;
  final List<Demand> items;
  final List<StatusTab> statusTabs;
  final int total;
  final int page;
  final int totalPages;
  final bool isLoading;
  final bool isLoadingMore;
  final Object? error;

  bool get hasMore => page < totalPages;
  bool get hasFilters => cityId != null || startDate != null || endDate != null;

  DemandListState copyWith({
    String? status,
    String? search,
    String? cityId,
    String? districtId,
    String? wardId,
    String? locationLabel,
    String? startDate,
    String? endDate,
    bool clearLocation = false,
    bool clearDates = false,
    List<Demand>? items,
    List<StatusTab>? statusTabs,
    int? total,
    int? page,
    int? totalPages,
    bool? isLoading,
    bool? isLoadingMore,
    Object? error,
    bool clearError = false,
  }) {
    return DemandListState(
      status: status ?? this.status,
      search: search ?? this.search,
      cityId: clearLocation ? null : (cityId ?? this.cityId),
      districtId: clearLocation ? null : (districtId ?? this.districtId),
      wardId: clearLocation ? null : (wardId ?? this.wardId),
      locationLabel:
          clearLocation ? null : (locationLabel ?? this.locationLabel),
      startDate: clearDates ? null : (startDate ?? this.startDate),
      endDate: clearDates ? null : (endDate ?? this.endDate),
      items: items ?? this.items,
      statusTabs: statusTabs ?? this.statusTabs,
      total: total ?? this.total,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class DemandListController extends AutoDisposeNotifier<DemandListState> {
  DemandsApi get _api => ref.read(demandsApiProvider);
  Timer? _debounce;

  @override
  DemandListState build() {
    ref.onDispose(() => _debounce?.cancel());
    Future.microtask(refresh);
    return const DemandListState(isLoading: true);
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final res = await _fetch(1);
      state = state.copyWith(
        items: res.items,
        statusTabs:
            res.statusTabs.isNotEmpty ? res.statusTabs : state.statusTabs,
        total: res.total,
        page: 1,
        totalPages: res.totalPages,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final res = await _fetch(state.page + 1);
      state = state.copyWith(
        items: [...state.items, ...res.items],
        page: state.page + 1,
        totalPages: res.totalPages,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e);
    }
  }

  Future<PagedDemands> _fetch(int page) => _api.list(
        status: state.status,
        search: state.search,
        page: page,
        cityId: state.cityId,
        districtId: state.districtId,
        wardId: state.wardId,
        startDate: state.startDate,
        endDate: state.endDate,
      );

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

  void setLocation({
    required String cityId,
    required String label,
    String? districtId,
    String? wardId,
  }) {
    state = state.copyWith(
      cityId: cityId,
      districtId: districtId,
      wardId: wardId,
      locationLabel: label,
    );
    refresh();
  }

  void setDateRange(String? start, String? end) {
    state = state.copyWith(startDate: start, endDate: end);
    refresh();
  }

  void clearFilters() {
    state = state.copyWith(clearLocation: true, clearDates: true);
    refresh();
  }
}

final demandListControllerProvider =
    AutoDisposeNotifierProvider<DemandListController, DemandListState>(
        DemandListController.new);

// ───────────────────────── screen ─────────────────────────

class DemandsScreen extends ConsumerStatefulWidget {
  const DemandsScreen({super.key});
  @override
  ConsumerState<DemandsScreen> createState() => _DemandsScreenState();
}

class _DemandsScreenState extends ConsumerState<DemandsScreen> {
  final _scroll = ScrollController();
  final _searchCtrl = TextEditingController();

  static const _fallbackTabs = [
    ('all', 'Tất cả'),
    ('new', 'Mới'),
    ('active', 'Đang diễn ra'),
    ('completed', 'Kết thúc'),
  ];

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 300) {
        ref.read(demandListControllerProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  DemandListController get _c => ref.read(demandListControllerProvider.notifier);

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(demandListControllerProvider);
    final tabs = state.statusTabs.isNotEmpty
        ? state.statusTabs
            .map((t) =>
                (t.id, '${t.name}${t.count > 0 ? ' (${t.count})' : ''}'))
            .toList()
        : _fallbackTabs;

    return CustomScreen(
      title: 'Nhu cầu mua',
      action: IconButton(
        icon: Icon(
            state.hasFilters ? Icons.filter_alt : Icons.filter_alt_outlined,
            color: state.hasFilters ? AppColors.primary : null),
        onPressed: _openFilters,
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'demands_add_fab',
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () async {
          final ok = await context.push<bool>('/demand/create');
          if (ok == true) _c.refresh();
        },
        icon: const Icon(Icons.add),
        label: Text('Tạo nhu cầu',
            style: AppTextStyles.semibold(15, color: Colors.white)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: _searchBox('Mã nhu cầu, SĐT khách hàng...'),
          ),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: tabs.length,
              separatorBuilder: (_, __) => const SizedBox(width: 20),
              itemBuilder: (_, i) => _Tab(
                label: tabs[i].$2,
                selected: state.status == tabs[i].$1,
                onTap: () => _c.setStatus(tabs[i].$1),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          Expanded(child: _body(state)),
        ],
      ),
    );
  }

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

  Widget _body(DemandListState state) {
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
          child: Text('Chưa có nhu cầu',
              style: AppTextStyles.regular(15, color: AppColors.textMute)));
    }
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _c.refresh,
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
          return _DemandCard(
            demand: d,
            onTap: () => context.push('/demand/${d.id}'),
            onLongPress: () => _manageTags(d),
          );
        },
      ),
    );
  }

  Future<void> _manageTags(Demand d) async {
    final res = await showTagPickerSheet(
      context,
      entity: TagEntity.consultation,
      entityId: d.id,
      selectedIds: d.tags.map((t) => t.id).toList(),
    );
    if (res == null) return;
    _c.refresh();
    if (mounted) AppToast.success(context, 'Đã cập nhật thẻ');
  }

  Future<void> _openFilters() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _FilterSheet(controller: _c),
    );
  }
}

class _FilterSheet extends ConsumerWidget {
  const _FilterSheet({required this.controller});
  final DemandListController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(demandListControllerProvider);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bộ lọc', style: AppTextStyles.bold(18)),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.location_on_outlined,
                  color: AppColors.primary),
              title: Text(state.locationLabel ?? 'Khu vực',
                  style: AppTextStyles.regular(15)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final sel = await showLocationPickerSheet(context);
                if (sel != null) {
                  controller.setLocation(
                    cityId: sel.cityId,
                    label: sel.label,
                    districtId: sel.districtId,
                    wardId: sel.wardId,
                  );
                  if (context.mounted) Navigator.pop(context);
                }
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.date_range_outlined,
                  color: AppColors.primary),
              title: Text(
                  state.startDate == null
                      ? 'Khoảng ngày tạo'
                      : '${state.startDate} → ${state.endDate ?? '...'}',
                  style: AppTextStyles.regular(15)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final now = DateTime.now();
                final range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(now.year - 2),
                  lastDate: now,
                );
                if (range != null) {
                  String f(DateTime d) =>
                      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
                  controller.setDateRange(f(range.start), f(range.end));
                  if (context.mounted) Navigator.pop(context);
                }
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      controller.clearFilters();
                      Navigator.pop(context);
                    },
                    child: const Text('Xoá lọc'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Xong'),
                  ),
                ),
              ],
            ),
          ],
        ),
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
  Widget build(BuildContext context) {
    return GestureDetector(
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
}

class _DemandCard extends StatelessWidget {
  const _DemandCard(
      {required this.demand, required this.onTap, this.onLongPress});
  final Demand demand;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final d = demand;
    final secondary = [d.officeName, d.supportName]
        .where((e) => (e ?? '').trim().isNotEmpty)
        .join('  •  ');
    return ConsultationListCard(
      code: d.code ?? '',
      name: d.customerName ?? 'Khách hàng',
      roleBadge: 'KH',
      statusBadge: demandStatusBadge(
          d.statusLabel, d.statusName?.color, d.statusEnum?.tone),
      phone: d.customerPhone,
      box1Title: 'Ngân sách',
      box1Value: budgetRangeText(d.budgetMin, d.budgetMax),
      box2Title: 'Diện tích',
      box2Value: areaRangeText(d.areaMin, d.areaMax),
      location: d.locationNames.join(', '),
      secondaryText: secondary,
      tags: [for (final t in d.tags) (label: t.name, color: t.color)],
      createdAt: d.createdAt,
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}

/// Status badge using the backend hex color when present, else a tone pill.
Widget demandStatusBadge(String label, String? hex, StatusTone? tone) {
  final color = hexColor(hex);
  if (color != null) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Text(label, style: AppTextStyles.bold(11, color: color)),
    );
  }
  return StatusPill(
      label: label.isEmpty ? '—' : label, tone: tone ?? StatusTone.neutral);
}

Widget demandTagChip(DemandTag t) {
  final color = hexColor(t.color) ?? AppColors.primary;
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
    ),
    child: Text(t.name, style: AppTextStyles.semibold(11, color: color)),
  );
}

/// Parses "#RRGGBB" / "RRGGBB" → Color (null if invalid).
Color? hexColor(String? hex) {
  if (hex == null) return null;
  var h = hex.trim().replaceFirst('#', '');
  if (h.length == 6) h = 'FF$h';
  if (h.length != 8) return null;
  final v = int.tryParse(h, radix: 16);
  return v == null ? null : Color(v);
}
