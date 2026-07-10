import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/custom_screen.dart';
import '../data/projects_api.dart';
import 'widgets/apartment_filter.dart';
import 'widgets/apartment_filter_bar.dart';

/// "Bảng hàng" — apartment-status board for a project code. v1
/// `apartment_status_page` parity: a filter-chip bar over a white summary card
/// (Còn hàng / Đang giao dịch / Đã bán) and a floor-grouped 3-column apartment
/// grid colored by status. The tap-to-detail dialog is deferred.
class ApartmentStatusScreen extends ConsumerStatefulWidget {
  const ApartmentStatusScreen({super.key, required this.code, this.name});
  final String code;
  final String? name;

  @override
  ConsumerState<ApartmentStatusScreen> createState() =>
      _ApartmentStatusScreenState();
}

class _ApartmentStatusScreenState extends ConsumerState<ApartmentStatusScreen> {
  final Map<String, List<String>> _selected = {};

  @override
  Widget build(BuildContext context) {
    final code = widget.code;
    final board = ref.watch(subdivisionProvider(code));
    return CustomScreen(
      title: 'Bảng hàng',
      child: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          ref.invalidate(subdivisionProvider(code));
          await ref.read(subdivisionProvider(code).future);
        },
        child: AsyncView<SubdivisionBoard>(
          value: board,
          onRetry: () => ref.invalidate(subdivisionProvider(code)),
          data: (b) => b.apartments.isEmpty ? _empty() : _board(b),
        ),
      ),
    );
  }

  Widget _empty() => ListView(children: [
        const SizedBox(height: 120),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.apartment_outlined,
                  size: 64, color: AppColors.neutral300),
              const SizedBox(height: 12),
              Text('Không có dữ liệu',
                  style: AppTextStyles.regular(15, color: AppColors.neutral400)),
            ],
          ),
        ),
      ]);

  Widget _board(SubdivisionBoard b) {
    // Chips derive from the full list; the board reflects the active selection.
    final defs = deriveApartmentFilters(b.apartments);
    final shown = applyApartmentFilters(b.apartments, _selected);
    final floors = _groupByFloor(shown);
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        if (defs.isNotEmpty) ...[
          const SizedBox(height: 12),
          ApartmentFilterBar(
            defs: defs,
            selected: _selected,
            onChanged: (key, values) => setState(() {
              if (values.isEmpty) {
                _selected.remove(key);
              } else {
                _selected[key] = values;
              }
            }),
          ),
        ],
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: _SummaryCard(apartments: shown),
        ),
        if (shown.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 48),
            child: Center(
              child: Text('Không có căn phù hợp bộ lọc',
                  style: AppTextStyles.regular(15, color: AppColors.neutral400)),
            ),
          )
        else
          for (final e in floors.entries)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _FloorSection(floor: e.key, items: e.value),
            ),
      ],
    );
  }
}

/// Group apartments by floor (hammlet), naturally sorted; empty → "Khác".
Map<String, List<Apartment>> _groupByFloor(List<Apartment> apts) {
  final map = <String, List<Apartment>>{};
  for (final a in apts) {
    final key = (a.floor ?? '').trim().isEmpty ? 'Khác' : a.floor!.trim();
    map.putIfAbsent(key, () => []).add(a);
  }
  final keys = map.keys.toList()
    ..sort((a, b) {
      final ai = int.tryParse(a), bi = int.tryParse(b);
      if (ai != null && bi != null) return ai.compareTo(bi);
      return a.compareTo(b);
    });
  return {for (final k in keys) k: map[k]!};
}

/// White summary card: fixed Còn hàng / Đang giao dịch / Đã bán columns,
/// counting apartments by statusCode (v1 ACTIVE / IN_TRANSACTION / SOLD).
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.apartments});
  final List<Apartment> apartments;

  ({int count, Color color}) _stat(String code, String fallback) {
    final rows = apartments.where((a) => a.statusCode == code);
    final hex = rows.map((e) => e.statusColor).firstWhere(
          (c) => c != null && c.isNotEmpty,
          orElse: () => fallback,
        );
    return (count: rows.length, color: AppColors.fromHex(hex));
  }

  @override
  Widget build(BuildContext context) {
    final active = _stat('ACTIVE', '#34C759');
    final trans = _stat('IN_TRANSACTION', '#E8B900');
    final sold = _stat('SOLD', '#FF3B30');
    if (active.count == 0 && trans.count == 0 && sold.count == 0) {
      return const SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _item('Còn hàng', active),
          _item('Đang giao dịch', trans),
          _item('Đã bán', sold, isLast: true),
        ],
      ),
    );
  }

  Widget _item(String title, ({int count, Color color}) s,
      {bool isLast = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(right: BorderSide(color: AppColors.neutral200)),
        ),
        child: Column(
          children: [
            Text(title,
                textAlign: TextAlign.center,
                style: AppTextStyles.regular(11, color: s.color)),
            const SizedBox(height: 4),
            Text('${s.count}',
                style: AppTextStyles.semibold(17, color: s.color)),
          ],
        ),
      ),
    );
  }
}

/// A floor header (dark pill + "N căn") over its 3-column apartment grid.
class _FloorSection extends StatelessWidget {
  const _FloorSection({required this.floor, required this.items});
  final String floor;
  final List<Apartment> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.text,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(floor,
                    style: AppTextStyles.semibold(13, color: Colors.white)),
              ),
              const SizedBox(width: 8),
              Text('${items.length} căn',
                  style: AppTextStyles.regular(13, color: AppColors.neutral400)),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.85,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: items.length,
          itemBuilder: (_, i) => _ApartmentCard(apartment: items[i]),
        ),
      ],
    );
  }
}

/// Compact grid cell tinted by the apartment's status color.
class _ApartmentCard extends StatelessWidget {
  const _ApartmentCard({required this.apartment});
  final Apartment apartment;

  @override
  Widget build(BuildContext context) {
    final a = apartment;
    final color = AppColors.fromHex(a.statusColor, fallback: AppColors.neutral200);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(a.code,
                    style: AppTextStyles.semibold(13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(a.priceText,
              style: AppTextStyles.semibold(11, color: AppColors.price),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          if (a.area != null && a.area! > 0) ...[
            const SizedBox(height: 4),
            Text('${a.area} m²',
                style: AppTextStyles.regular(11, color: AppColors.neutral500)),
          ],
          const Spacer(),
          Row(
            children: [
              if ((a.direction ?? '').isNotEmpty)
                Expanded(
                  child: Text(a.direction!,
                      style:
                          AppTextStyles.regular(11, color: AppColors.neutral400),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
              if (a.bedrooms != null && a.bedrooms! > 0)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bed_outlined,
                        size: 12, color: AppColors.neutral400),
                    const SizedBox(width: 2),
                    Text('${a.bedrooms}',
                        style: AppTextStyles.regular(11,
                            color: AppColors.neutral400)),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
