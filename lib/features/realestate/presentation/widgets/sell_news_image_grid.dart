import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Horizontal selectable image strip for the "Đăng bán" share. Tap toggles an
/// image; broken images are dropped. Mirrors v1's image picker.
class SellNewsImageGrid extends StatefulWidget {
  const SellNewsImageGrid({
    super.key,
    required this.images,
    required this.selected,
    required this.onToggle,
  });

  final List<String> images;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  State<SellNewsImageGrid> createState() => _SellNewsImageGridState();
}

class _SellNewsImageGridState extends State<SellNewsImageGrid> {
  final Set<String> _invalid = {};

  @override
  Widget build(BuildContext context) {
    final visible =
        widget.images.where((e) => !_invalid.contains(e)).toList();
    if (visible.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child:
            Text('Không có ảnh hợp lệ để hiển thị.', style: AppTypography.caption),
      );
    }
    final itemWidth = (MediaQuery.of(context).size.width - 80) / 3.5;
    return SizedBox(
      height: itemWidth * 1.08,
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 24),
        scrollDirection: Axis.horizontal,
        itemCount: visible.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final url = visible[i];
          final isSelected = widget.selected.contains(url);
          return GestureDetector(
            onTap: () => widget.onToggle(url),
            child: SizedBox(
              width: itemWidth,
              child: Stack(children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) setState(() => _invalid.add(url));
                        });
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                Positioned.fill(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color:
                            isSelected ? AppColors.primary : Colors.transparent,
                        width: 2,
                      ),
                      color: Colors.black
                          .withValues(alpha: isSelected ? 0.12 : 0.28),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isSelected
                          ? Icons.check
                          : Icons.check_box_outline_blank,
                      size: 16,
                      color: isSelected ? Colors.white : AppColors.textMute,
                    ),
                  ),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }
}
