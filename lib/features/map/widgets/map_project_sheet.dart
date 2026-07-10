import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_network_image.dart';
import '../data/map_api.dart';
import 'map_sheet_widgets.dart';

/// Project bottom sheet for the map (parity with v1 `MapProjectListSheet`):
/// a project hero header + the paginated list of BĐS in the project. Tapping a
/// row opens that listing; the header button opens the full project page.
class MapProjectSheet extends ConsumerStatefulWidget {
  const MapProjectSheet({
    super.key,
    required this.projectId,
    required this.projectCode,
    required this.onItemTap,
    required this.onProjectDetail,
  });

  final int projectId;
  final String projectCode;
  final ValueChanged<int> onItemTap;
  final VoidCallback onProjectDetail;

  @override
  ConsumerState<MapProjectSheet> createState() => _MapProjectSheetState();
}

class _MapProjectSheetState extends ConsumerState<MapProjectSheet> {
  final _scroll = ScrollController();
  final _items = <ProjectMapItem>[];
  ProjectMapDetails? _details;
  int _page = 1;
  int _totalPages = 1;
  bool _loading = true;
  bool _loadingMore = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    _bootstrap();
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  MapApi get _api => ref.read(mapApiProvider);

  Future<void> _bootstrap() async {
    final results = await Future.wait([
      _api.projectProperties(widget.projectCode, page: 1),
      _api.projectDetails(widget.projectId),
    ]);
    if (!mounted) return;
    final firstPage = results[0] as ProjectMapPage;
    setState(() {
      _details = results[1] as ProjectMapDetails?;
      _items
        ..clear()
        ..addAll(firstPage.items);
      _page = firstPage.page;
      _totalPages = firstPage.totalPages;
      _loading = false;
    });
  }

  void _onScroll() {
    final p = _scroll.position;
    if (p.pixels >= p.maxScrollExtent - 240) _loadMore();
  }

  Future<void> _loadMore() async {
    if (_loadingMore || _page >= _totalPages) return;
    setState(() => _loadingMore = true);
    try {
      final next = await _api.projectProperties(widget.projectCode,
          page: _page + 1);
      if (!mounted) return;
      setState(() {
        _items.addAll(next.items);
        _page = next.page;
        _totalPages = next.totalPages;
        _loadingMore = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.65;
    return SafeArea(
      top: false,
      child: SizedBox(
        height: height,
        child: Column(
          children: [
            _header(),
            Expanded(child: _list()),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    final d = _details;
    if (d == null || d.image == null || d.image!.isEmpty) {
      return MapSheetHeader(d?.name.isNotEmpty == true ? d!.name : 'BĐS trong dự án');
    }
    return _ProjectHero(
      title: d.name,
      imageUrl: d.image!,
      price: d.price,
      area: d.area,
      onClose: () => Navigator.maybePop(context),
      onDetailTap: widget.onProjectDetail,
    );
  }

  Widget _list() {
    if (_loading) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (_items.isEmpty) {
      return const Center(child: Text('Không có BĐS trong dự án'));
    }
    return ListView.separated(
      controller: _scroll,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      itemCount: _items.length + (_loadingMore ? 1 : 0),
      separatorBuilder: (_, i) => i >= _items.length - 1
          ? const SizedBox(height: 16)
          : const Divider(
              height: 16, thickness: 0.5, color: Color(0xFFE7E5E4)),
      itemBuilder: (_, i) {
        if (i >= _items.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Center(
                child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2))),
          );
        }
        final item = _items[i];
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => widget.onItemTap(item.id),
          child: MapProductItem(
            imageUrl: item.image,
            title: item.title,
            price: item.priceDescription,
            area: item.area,
            bedrooms: item.bedrooms,
            bathrooms: item.bathrooms,
          ),
        );
      },
    );
  }
}

/// Project hero header — 1:1 with v1 `_ProjectHero` (200px image, dark gradient,
/// centered name/price/area, white "Xem chi tiết dự án" button).
class _ProjectHero extends StatelessWidget {
  const _ProjectHero({
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.area,
    required this.onClose,
    this.onDetailTap,
  });

  final String title;
  final String imageUrl;
  final String price;
  final String area;
  final VoidCallback onClose;
  final VoidCallback? onDetailTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: AppNetworkImage(url: imageUrl, height: 200, fit: BoxFit.cover),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x66000000), Color(0xB3000000)],
              ),
            ),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: GestureDetector(
            onTap: onClose,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
              if (price.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(price,
                    style:
                        const TextStyle(fontSize: 15, color: Colors.white)),
              ],
              if (area.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(area,
                    style: const TextStyle(
                        fontSize: 13, color: Colors.white70)),
              ],
              if (onDetailTap != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: 220,
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: onDetailTap,
                      borderRadius: BorderRadius.circular(10),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('Xem chi tiết dự án',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary)),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
