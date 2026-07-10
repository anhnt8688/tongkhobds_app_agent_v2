import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_network_image.dart';
import '../realestate/data/models/property.dart';
import '../realestate/data/models/search_filter.dart';
import '../realestate/data/realestate_api.dart';
import '../realestate/presentation/widgets/property_card.dart';
import '../../core/widgets/custom_screen.dart';

/// "So sánh BĐS" — pick two properties and compare key attributes side by side.
class CompareScreen extends ConsumerStatefulWidget {
  const CompareScreen({super.key});
  @override
  ConsumerState<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends ConsumerState<CompareScreen> {
  Property? _left;
  Property? _right;

  Future<void> _pick(bool left) async {
    final p = await showModalBottomSheet<Property>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (_) => const _PropertyPickerSheet(),
    );
    if (p != null) setState(() => left ? _left = p : _right = p);
  }

  String _pricePerM2(Property? p) {
    if (p == null || p.price == null || p.area == null || p.area == 0) {
      return '—';
    }
    return '${formatVnd(p.price! / p.area!)}/m²';
  }

  @override
  Widget build(BuildContext context) {
    final rows = <(String, String, String)>[
      ('Giá', _left?.priceText ?? '—', _right?.priceText ?? '—'),
      ('Giá/m²', _pricePerM2(_left), _pricePerM2(_right)),
      ('Diện tích', _left?.areaText ?? '—', _right?.areaText ?? '—'),
      ('Phòng ngủ', _left?.bedrooms?.toString() ?? '—',
          _right?.bedrooms?.toString() ?? '—'),
      ('Phòng tắm', _left?.bathrooms?.toString() ?? '—',
          _right?.bathrooms?.toString() ?? '—'),
      ('Loại BĐS', _left?.propertyTypeName ?? '—', _right?.propertyTypeName ?? '—'),
      ('Khu vực', _loc(_left), _loc(_right)),
      ('Mã tin', _left?.code ?? '—', _right?.code ?? '—'),
    ];

    return CustomScreen(
      title: 'So sánh BĐS',
      backgroundColor: AppColors.bg,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(child: _slot(_left, () => _pick(true))),
              const SizedBox(width: 12),
              Expanded(child: _slot(_right, () => _pick(false))),
            ],
          ),
          const SizedBox(height: 16),
          if (_left != null && _right != null)
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  for (var i = 0; i < rows.length; i++)
                    Container(
                      decoration: BoxDecoration(
                        color: i.isEven ? AppColors.bg : AppColors.surface,
                        borderRadius: i == rows.length - 1
                            ? const BorderRadius.vertical(
                                bottom: Radius.circular(AppSpacing.radiusLg))
                            : null,
                      ),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(rows[i].$1,
                                style: AppTypography.caption
                                    .copyWith(color: AppColors.textMute)),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(rows[i].$2,
                                textAlign: TextAlign.center,
                                style: AppTypography.body
                                    .copyWith(fontWeight: FontWeight.w600)),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(rows[i].$3,
                                textAlign: TextAlign.center,
                                style: AppTypography.body
                                    .copyWith(fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Center(
                child: Text('Chọn 2 bất động sản để so sánh',
                    style:
                        AppTypography.body.copyWith(color: AppColors.textMute)),
              ),
            ),
        ],
      ),
    );
  }

  String _loc(Property? p) {
    if (p == null) return '—';
    final parts =
        [p.district, p.city].where((e) => (e ?? '').isNotEmpty).toList();
    return parts.isEmpty ? '—' : parts.join(', ');
  }

  Widget _slot(Property? p, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 168,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
              color: p == null ? AppColors.border : AppColors.primary),
        ),
        child: p == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_circle_outline,
                      color: AppColors.primary, size: 32),
                  const SizedBox(height: 8),
                  Text('Chọn BĐS',
                      style: AppTypography.caption
                          .copyWith(color: AppColors.primary)),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      child: SizedBox(
                        width: double.infinity,
                        child: (p.image ?? '').isNotEmpty
                            ? AppNetworkImage(url: p.image)
                            : Container(color: AppColors.primarySoft),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(p.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption
                          .copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
      ),
    );
  }
}

class _PropertyPickerSheet extends ConsumerStatefulWidget {
  const _PropertyPickerSheet();
  @override
  ConsumerState<_PropertyPickerSheet> createState() =>
      _PropertyPickerSheetState();
}

class _PropertyPickerSheetState extends ConsumerState<_PropertyPickerSheet> {
  String _query = '';
  List<Property> _results = const [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _search();
  }

  Future<void> _search() async {
    setState(() => _loading = true);
    try {
      final res = await ref
          .read(realEstateApiProvider)
          .search(SearchFilter(keyword: _query), page: 1, limit: 20);
      if (mounted) setState(() => _results = res.items);
    } catch (_) {
      if (mounted) setState(() => _results = const []);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Text('Chọn bất động sản', style: AppTypography.title),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                textInputAction: TextInputAction.search,
                onChanged: (v) => _query = v,
                onSubmitted: (_) => _search(),
                decoration: InputDecoration(
                  hintText: 'Tìm theo tên / mã / khu vực...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                      icon: const Icon(Icons.arrow_forward), onPressed: _search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
                ),
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.primary))
                  : _results.isEmpty
                      ? const Center(child: Text('Không tìm thấy BĐS'))
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                          itemCount: _results.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (_, i) => PropertyCard(
                            property: _results[i],
                            onTap: () => Navigator.pop(context, _results[i]),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
