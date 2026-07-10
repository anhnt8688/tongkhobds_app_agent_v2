import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/contracts_api.dart';

/// v1 contract grid card: cover image, "Đã ký" badge, title | price, address,
/// name_sale + colored contract-type badge, and a dark "Ký hợp đồng" overlay
/// covering unsigned contracts. Mirrors v1 `ContractPage._buildContractItem`.
class ContractGridCard extends StatelessWidget {
  const ContractGridCard({super.key, required this.contract, required this.onTap});

  final ContractItem contract;
  final VoidCallback onTap;

  static const _overlayOrange = Color(0xFFFF8C42); // v1 unsigned CTA accent
  static const _signedGreen = Color(0xFF34C759); // v1 "Đã ký" badge green

  @override
  Widget build(BuildContext context) {
    final c = contract;
    final typeName = c.contractTypeName ?? '';
    final typeColor = typeName.contains('Độc quyền')
        ? AppColors.danger
        : AppColors.info;
    final image = _resolveImage(c.contractTypeImage);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0D000000), blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: image,
                          width: double.infinity,
                          height: 130,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Container(
                            height: 130,
                            color: AppColors.primarySoft,
                            child: const Icon(Icons.description_outlined,
                                color: AppColors.primary, size: 36),
                          ),
                          placeholder: (_, __) => Container(
                            height: 130,
                            color: AppColors.primarySoft.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                      if (c.isSigned)
                        Positioned(
                          top: -8,
                          right: -8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: _signedGreen,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('Đã ký',
                                style: AppTextStyles.medium(12,
                                    color: Colors.white)),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(c.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.semibold(14)),
                            ),
                            if (_formatPrice(c.price).isNotEmpty) ...[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: Text('|',
                                    style: AppTextStyles.regular(14,
                                        color: AppColors.neutral400)),
                              ),
                              Text(_formatPrice(c.price),
                                  style: AppTextStyles.semibold(14)),
                            ],
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(c.address ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.regular(13,
                                color: AppColors.textSecondary)),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(c.nameSale ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.regular(13,
                                      color: AppColors.textMute)),
                            ),
                            if (typeName.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: typeColor),
                                ),
                                child: Text(typeName,
                                    style: AppTextStyles.semibold(12,
                                        color: typeColor)),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (!c.isSigned)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 140),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _overlayOrange, width: 1.5),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0x1A000000),
                              blurRadius: 8,
                              offset: Offset(0, 2)),
                        ],
                      ),
                      child: Text('Ký hợp đồng',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.semibold(16,
                              color: _overlayOrange)),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _resolveImage(String? raw) {
    final s = (raw ?? '').trim();
    if (s.isEmpty) return '';
    if (s.startsWith('http')) return s;
    return AppConfig.imageUrl(s) ?? '';
  }

  /// Format a raw price: keep if it already has a unit, else group thousands
  /// and append " đ" (v1 `_formatPrice`).
  String _formatPrice(dynamic price) {
    if (price == null || price.toString().trim().isEmpty) return '';
    final s = price.toString().trim();
    if (s.contains('tỷ') || s.contains('triệu') || s.contains('đ')) return s;
    final n = double.tryParse(s);
    if (n != null) {
      final grouped = n.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
      return '$grouped đ';
    }
    return s;
  }
}
