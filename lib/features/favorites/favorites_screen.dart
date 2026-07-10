import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_config.dart';
import '../../core/network/dio_client.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/json_parse.dart';
import '../../core/widgets/app_network_image.dart';
import '../../core/widgets/app_toast.dart';
import '../../core/widgets/async_view.dart';
import '../../core/widgets/custom_screen.dart';
import '../realestate/data/models/property.dart';
import '../realestate/presentation/open_property.dart';
import '../realestate/presentation/widgets/property_card.dart';
import 'favorites_actions.dart';

class FavoriteGroup {
  const FavoriteGroup({
    required this.id,
    required this.name,
    this.count = 0,
    this.breakdown = const [],
    this.images = const [],
    this.isDefault = false,
  });
  final int id;
  final String name;

  /// Total saved properties (sum of the counts across `description` lines).
  final int count;

  /// Human breakdown lines, e.g. ["199 đang bán", "23 cho thuê", "12 dự án"].
  final List<String> breakdown;

  /// Preview thumbnails for the collage.
  final List<String> images;

  /// The system "recently viewed" group (`default_group`).
  final bool isDefault;

  /// "199 đang bán · 23 cho thuê · 12 dự án".
  String get breakdownText => breakdown.join(' · ');

  factory FavoriteGroup.fromJson(Map d) {
    // The backend has no explicit count field; the count lives inside the
    // `description` lines ("199 đang bán", "23 cho thuê"...). Sum the leading
    // number of each line to get the total saved properties.
    final descRaw = d['description'];
    final breakdown = descRaw is List
        ? descRaw.map((e) => e.toString()).where((e) => e.trim().isNotEmpty).toList()
        : <String>[];
    final imagesRaw = d['images'];
    final images = imagesRaw is List
        ? imagesRaw
            .map((e) => e.toString())
            .where((e) => e.startsWith('http'))
            .toList()
        : <String>[];
    final leadingNumber = RegExp(r'\d+');
    var total = 0;
    for (final line in breakdown) {
      final m = leadingNumber.firstMatch(line);
      if (m != null) total += int.tryParse(m.group(0)!) ?? 0;
    }
    // Fallbacks: an explicit count field, else the image thumbnails count.
    if (total == 0) {
      total = asInt(d['count'] ?? d['total'] ?? d['item_count']);
      if (total == 0 && d['images'] is List) total = (d['images'] as List).length;
    }
    return FavoriteGroup(
      id: asInt(d['id'] ?? d['group_id']),
      name: (d['title'] ?? d['name'] ?? d['group_name'] ?? 'Nhóm').toString(),
      count: total,
      breakdown: breakdown,
      images: images,
      isDefault: d['default_group'] == true || d['default_group'] == 1,
    );
  }
}

final favoriteGroupsProvider =
    FutureProvider.autoDispose<List<FavoriteGroup>>((ref) async {
  final Dio dio = ref.watch(dioProvider);
  final res = await dio.get('${AppConfig.customer}/list_favorite_groups');
  final data = res.data;
  final List raw = data is Map
      ? (data['groups'] ?? data['items'] ?? data['data'] ?? []) as List
      : (data is List ? data : const []);
  return raw.whereType<Map>().map(FavoriteGroup.fromJson).toList();
});

final favoriteItemsProvider =
    FutureProvider.autoDispose.family<List<Property>, int>((ref, groupId) async {
  final Dio dio = ref.watch(dioProvider);
  final res = await dio.get(
    '${AppConfig.agent}/list_favorite_items_by_group',
    queryParameters: {'group_id': groupId},
  );
  final data = res.data;
  final List raw = data is Map
      ? (data['items'] ?? data['data'] ?? []) as List
      : (data is List ? data : const []);
  return raw
      .whereType<Map>()
      .map((e) => Property.fromJson(Map<String, dynamic>.from(e)))
      .toList();
});

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(favoriteGroupsProvider);
    return CustomScreen(
      title: 'Yêu thích',
      action: IconButton(
        tooltip: 'Tạo nhóm',
        icon: const Icon(Icons.add),
        onPressed: () => _createGroup(context, ref),
      ),
      child: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          ref.invalidate(favoriteGroupsProvider);
          await ref.read(favoriteGroupsProvider.future);
        },
        child: AsyncView<List<FavoriteGroup>>(
          value: groups,
          onRetry: () => ref.invalidate(favoriteGroupsProvider),
          data: (list) {
            if (list.isEmpty) {
              return ListView(children: const [
                SizedBox(height: 120),
                Center(child: Text('Chưa có nhóm yêu thích')),
              ]);
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final g = list[i];
                return _GroupCard(
                  group: g,
                  onTap: () => context.push(
                      '/favorite-group/${g.id}?name=${Uri.encodeComponent(g.name)}'),
                  // Default ("recently viewed") group can't be renamed/deleted.
                  onEdit: g.isDefault ? null : () => _renameGroup(context, ref, g),
                  onDelete:
                      g.isDefault ? null : () => _deleteGroup(context, ref, g),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _createGroup(BuildContext context, WidgetRef ref) async {
    final title = await promptGroupName(context);
    if (title == null) return;
    try {
      await ref.read(favoritesServiceProvider).createGroup(title);
      ref.invalidate(favoriteGroupsProvider);
    } catch (_) {
      if (context.mounted) AppToast.error(context, 'Không tạo được nhóm');
    }
  }

  Future<void> _renameGroup(
      BuildContext context, WidgetRef ref, FavoriteGroup g) async {
    final title = await promptGroupName(context, initial: g.name);
    if (title == null || title == g.name) return;
    try {
      await ref.read(favoritesServiceProvider).updateGroup(id: g.id, title: title);
      ref.invalidate(favoriteGroupsProvider);
    } catch (_) {
      if (context.mounted) AppToast.error(context, 'Không đổi tên được nhóm');
    }
  }

  Future<void> _deleteGroup(
      BuildContext context, WidgetRef ref, FavoriteGroup g) async {
    if (!await confirmDeleteGroup(context)) return;
    try {
      await ref.read(favoritesServiceProvider).removeGroup(g.id);
      ref.invalidate(favoriteGroupsProvider);
    } catch (_) {
      if (context.mounted) AppToast.error(context, 'Không xoá được nhóm');
    }
  }
}

/// A favorite group row: image collage + title + the `description` breakdown
/// rendered as soft pills (e.g. "199 đang bán", "23 cho thuê", "12 dự án").
class _GroupCard extends StatelessWidget {
  const _GroupCard({
    required this.group,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  final FavoriteGroup group;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _Collage(images: group.images),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            group.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.title,
                          ),
                        ),
                        if (group.isDefault)
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primarySoft,
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.radiusPill),
                            ),
                            child: Text('Mặc định',
                                style: AppTypography.micro
                                    .copyWith(color: AppColors.primary)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    if (group.breakdown.isEmpty)
                      Text('Chưa có bất động sản',
                          style: AppTypography.caption
                              .copyWith(color: AppColors.textMute))
                    else
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final line in group.breakdown) _Pill(text: line),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              // Non-default groups expose rename/delete (v1 PopupMenuButton).
              if (onEdit != null || onDelete != null)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: AppColors.textMute),
                  onSelected: (v) {
                    if (v == 'edit') onEdit?.call();
                    if (v == 'delete') onDelete?.call();
                  },
                  itemBuilder: (_) => [
                    if (onEdit != null)
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(children: [
                          Icon(Icons.edit_note, size: 22),
                          SizedBox(width: 8),
                          Text('Chỉnh sửa'),
                        ]),
                      ),
                    if (onDelete != null)
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(children: [
                          Icon(Icons.delete_outline,
                              size: 22, color: AppColors.danger),
                          SizedBox(width: 8),
                          Text('Xóa danh mục',
                              style: TextStyle(color: AppColors.danger)),
                        ]),
                      ),
                  ],
                )
              else
                const Icon(Icons.chevron_right, color: AppColors.textMute),
            ],
          ),
        ),
      ),
    );
  }
}

/// A 2×2 thumbnail collage built from the group's preview images.
class _Collage extends StatelessWidget {
  const _Collage({required this.images});
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    const size = 60.0;
    if (images.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.primarySoft,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.folder_special_outlined,
            color: AppColors.primary),
      );
    }
    // 1 image → full tile; 2+ → 2-column grid (max 4 cells).
    final shown = images.take(4).toList();
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: size,
        height: size,
        child: shown.length == 1
            ? _Thumb(url: shown.first)
            : GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                children: [for (final u in shown) _Thumb(url: u)],
              ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return AppNetworkImage(
      url: url,
      placeholder: Container(color: AppColors.primarySoft),
      errorWidget: Container(
        color: AppColors.border,
        child: const Icon(Icons.image_not_supported_outlined,
            size: 16, color: AppColors.textMute),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text});
  final String text;

  /// Picks (background, foreground) by the line's transaction keyword.
  (Color, Color) _colors() {
    final t = text.toLowerCase();
    if (t.contains('bán')) return (AppColors.greenBg, AppColors.greenFg);
    if (t.contains('thuê')) return (AppColors.blueBg, AppColors.blueFg);
    if (t.contains('dự án')) return (AppColors.primarySoft, AppColors.primaryDark);
    return (AppColors.amberBg, AppColors.amberFg);
  }

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = _colors();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Text(
        text,
        style: AppTypography.caption
            .copyWith(color: fg, fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// Properties inside a favorite group — `list_favorite_items_by_group`.
class FavoriteItemsScreen extends ConsumerWidget {
  const FavoriteItemsScreen({super.key, required this.groupId, required this.name});
  final int groupId;
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(favoriteItemsProvider(groupId));
    return CustomScreen(
      title: name.isEmpty ? 'Nhóm yêu thích' : name,
      child: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          ref.invalidate(favoriteItemsProvider(groupId));
          await ref.read(favoriteItemsProvider(groupId).future);
        },
        child: AsyncView<List<Property>>(
          value: items,
          onRetry: () => ref.invalidate(favoriteItemsProvider(groupId)),
          data: (list) {
            if (list.isEmpty) {
              return ListView(children: const [
                SizedBox(height: 120),
                Center(child: Text('Nhóm chưa có BĐS')),
              ]);
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => PropertyCard(
                property: list[i],
                onTap: () => openProperty(context, list[i]),
                onRemoveFavorite: () async {
                  await ref.read(favoritesServiceProvider).removeFromGroup(
                        realEstateId: list[i].id,
                        groupId: groupId,
                      );
                  ref.invalidate(favoriteItemsProvider(groupId));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
