import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../../core/network/api_exception.dart';
import '../../core/network/dio_client.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_toast.dart';
import 'favorites_screen.dart';

/// Favorite add/remove/create-group operations.
class FavoritesService {
  FavoritesService(this._dio);
  final Dio _dio;

  Future<void> addToGroup({required int realEstateId, required int groupId}) {
    return _dio.post(
      '${AppConfig.agent}/add_to_favorite_group.json',
      queryParameters: {'real_estate_id': realEstateId, 'group_id': groupId},
    );
  }

  Future<void> removeFromGroup({required int realEstateId, required int groupId}) {
    return _dio.post(
      '${AppConfig.agent}/remove_from_favorite_group.json',
      data: {'real_estate_id': realEstateId, 'group_id': groupId},
    );
  }

  Future<void> createGroup(String title) {
    return _dio.post(
      '${AppConfig.customer}/create_favorite_group',
      data: {'title': title},
    );
  }

  /// Rename a favorite group — `update_favorite_group {id, title}` (v1).
  Future<void> updateGroup({required int id, required String title}) {
    return _dio.post(
      '${AppConfig.customer}/update_favorite_group',
      data: {'title': title, 'id': id},
    );
  }

  /// Delete a favorite group — `delete_favorite_group {id}` (v1).
  Future<void> removeGroup(int id) {
    return _dio.post(
      '${AppConfig.customer}/delete_favorite_group',
      data: {'id': id},
    );
  }
}

final favoritesServiceProvider =
    Provider<FavoritesService>((ref) => FavoritesService(ref.watch(dioProvider)));

/// Prompts for a group name (create + rename). Returns the trimmed input, or
/// null if cancelled/empty.
Future<String?> promptGroupName(BuildContext context, {String? initial}) async {
  final name = await showDialog<String>(
    context: context,
    builder: (_) => _NewGroupDialog(initial: initial),
  );
  final trimmed = name?.trim();
  return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
}

/// Confirms deleting a favorite group (v1 copy).
Future<bool> confirmDeleteGroup(BuildContext context) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Bạn có muốn xóa danh mục'),
      content:
          const Text('Toàn bộ dữ liệu sẽ bị xoá và không thể khôi phục lại'),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Huỷ')),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Xóa danh mục'),
        ),
      ],
    ),
  );
  return ok ?? false;
}

/// Opens a sheet to pick (or create) a favorite group, then saves the property.
/// Returns true if the property was added.
Future<bool> showSaveToFavoriteSheet(
  BuildContext context,
  WidgetRef ref,
  int realEstateId,
) async {
  final added = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _SaveSheet(realEstateId: realEstateId),
  );
  return added ?? false;
}

class _SaveSheet extends ConsumerStatefulWidget {
  const _SaveSheet({required this.realEstateId});
  final int realEstateId;

  @override
  ConsumerState<_SaveSheet> createState() => _SaveSheetState();
}

class _SaveSheetState extends ConsumerState<_SaveSheet> {
  bool _busy = false;

  Future<void> _save(int groupId) async {
    setState(() => _busy = true);
    try {
      await ref
          .read(favoritesServiceProvider)
          .addToGroup(realEstateId: widget.realEstateId, groupId: groupId);
      ref.invalidate(favoriteGroupsProvider);
      if (mounted) Navigator.pop(context, true);
    } on ApiException catch (e) {
      _toast(e.message);
    } catch (_) {
      _toast('Không lưu được');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _createAndSave() async {
    final title = await showDialog<String>(
      context: context,
      builder: (_) => const _NewGroupDialog(),
    );
    if (title == null || title.trim().isEmpty) return;
    setState(() => _busy = true);
    try {
      await ref.read(favoritesServiceProvider).createGroup(title.trim());
      ref.invalidate(favoriteGroupsProvider);
      // Re-fetch to find the new group then add.
      final groups = await ref.read(favoriteGroupsProvider.future);
      final g = groups.firstWhere(
        (e) => e.name == title.trim(),
        orElse: () => groups.isNotEmpty ? groups.last : const FavoriteGroup(id: 0, name: ''),
      );
      if (g.id != 0) {
        await ref
            .read(favoritesServiceProvider)
            .addToGroup(realEstateId: widget.realEstateId, groupId: g.id);
        ref.invalidate(favoriteGroupsProvider);
        if (mounted) Navigator.pop(context, true);
      }
    } catch (_) {
      _toast('Không tạo được nhóm');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _toast(String m) {
    if (mounted) AppToast.error(context, m);
  }

  @override
  Widget build(BuildContext context) {
    final groups = ref.watch(favoriteGroupsProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Lưu vào nhóm yêu thích', style: AppTypography.heading),
              const Spacer(),
              if (_busy)
                const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2)),
            ],
          ),
          const SizedBox(height: 12),
          groups.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const Text('Không tải được danh sách nhóm'),
            data: (list) => Column(
              children: [
                for (final g in list)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.folder_special_outlined,
                        color: AppColors.primary),
                    title: Text(g.name),
                    trailing: const Icon(Icons.add, color: AppColors.primary),
                    onTap: _busy ? null : () => _save(g.id),
                  ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.create_new_folder_outlined,
                      color: AppColors.textSecondary),
                  title: const Text('Tạo nhóm mới'),
                  onTap: _busy ? null : _createAndSave,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NewGroupDialog extends StatefulWidget {
  const _NewGroupDialog({this.initial});
  final String? initial;
  @override
  State<_NewGroupDialog> createState() => _NewGroupDialogState();
}

class _NewGroupDialogState extends State<_NewGroupDialog> {
  late final _ctrl = TextEditingController(text: widget.initial ?? '');

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initial == null ? 'Nhóm mới' : 'Đổi tên nhóm'),
      content: TextField(
        controller: _ctrl,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Tên nhóm'),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: const Text('Huỷ')),
        TextButton(
          onPressed: () => Navigator.pop(context, _ctrl.text),
          child: const Text('Tạo'),
        ),
      ],
    );
  }
}
