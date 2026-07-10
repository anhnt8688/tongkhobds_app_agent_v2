import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/share_util.dart';
import '../../../core/widgets/async_view.dart';
import '../../favorites/favorites_actions.dart';
import '../data/models/property_detail.dart';
import 'search_controller.dart';
import 'widgets/detail/detail_commission.dart';
import 'widgets/detail/detail_description.dart';
import 'widgets/detail/detail_footer.dart';
import 'widgets/detail/detail_gallery.dart';
import 'widgets/detail/detail_head.dart';
import 'widgets/detail/detail_legal_docs.dart';
import 'widgets/detail/detail_map.dart';
import 'widgets/detail/detail_reject_banner.dart';
import 'widgets/detail/detail_spec_grid.dart';

/// BĐS detail — layout mirrors v1 `DetailProductPage`: a collapsing image header
/// then description → hoa hồng → mô tả → giấy tờ → đặc điểm → bản đồ.
class PropertyDetailScreen extends ConsumerWidget {
  const PropertyDetailScreen({super.key, required this.id, this.owned = false});

  final int id;
  final bool owned;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = (id: id, owned: owned);
    final detail = ref.watch(propertyDetailProvider(key));

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: AsyncView<PropertyDetail>(
        value: detail,
        onRetry: () => ref.invalidate(propertyDetailProvider(key)),
        data: (d) => _Content(detail: d, detailKey: key, ref: ref),
      ),
      bottomNavigationBar: detail.maybeWhen(
        data: (d) => DetailFooter(detail: d, detailKey: key),
        orElse: () => const SizedBox.shrink(),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content(
      {required this.detail, required this.detailKey, required this.ref});
  final PropertyDetail detail;
  final PropertyDetailKey detailKey;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final d = detail;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 304,
          collapsedHeight: kToolbarHeight,
          backgroundColor: AppColors.surface,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          leadingWidth: 48,
          leading: _imgBtn(
              'assets/images/backIcon.png', () => Navigator.maybePop(context)),
          actions: [
            _imgBtn('assets/images/icShare.png', () {
              sharePropertyInfo(
                title: d.title,
                priceText: d.priceText,
                address: d.address,
                code: d.code,
                slug: (d.slug ?? '').isNotEmpty ? d.slug : d.id.toString(),
                context: context,
              );
            }),
            _imgBtn('assets/images/icHeartOutline.png',
                () => showSaveToFavoriteSheet(context, ref, d.id)),
            const SizedBox(width: 8),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: DetailGallery(
              images: d.gallery,
              videoCount: d.videos.length,
              code: d.code,
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            const SizedBox(height: 16),
            if (d.isOwned &&
                d.reasonReject != null &&
                d.reasonReject!.isNotEmpty)
              DetailRejectBanner(reason: d.reasonReject!),
            DetailHead(detail: d),
            if (d.commissionRates.isNotEmpty) ...[
              _divider(),
              DetailCommission(detail: d),
            ],
            _divider(),
            DetailDescription(html: d.htmlContent, text: d.description),
            if (d.legalDocs.isNotEmpty) ...[
              const SizedBox(height: 8),
              DetailLegalDocs(docs: d.legalDocs),
            ],
            const SizedBox(height: 8),
            DetailSpecGrid(detail: d),
            if (d.hasLatLng) DetailMap(lat: d.lat!, lng: d.lng!),
            const SizedBox(height: 24),
          ]),
        ),
      ],
    );
  }

  Widget _divider() => const Divider(
        height: 32,
        thickness: 0.5,
        indent: 16,
        endIndent: 16,
        color: AppColors.border,
      );

  // v1 header buttons: bare 32×32 asset icons (backIcon / icShare / heart),
  // no background box.
  Widget _imgBtn(String asset, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Center(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(asset, width: 32, height: 32),
        ),
      ),
    );
  }
}
