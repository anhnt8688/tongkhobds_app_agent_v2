import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/custom_screen.dart';
import '../data/projects_api.dart';

/// "Bảng hàng dự án" — sale-project boards grouped by project → subdivisions.
/// Tapping a subdivision runs the v1 access flow (KYC / sale registration).
class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(projectGroupsProvider);
    return CustomScreen(
      title: 'Bảng hàng dự án',
      child: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          ref.invalidate(projectGroupsProvider);
          await ref.read(projectGroupsProvider.future);
        },
        child: AsyncView<List<ProjectGroup>>(
          value: groups,
          onRetry: () => ref.invalidate(projectGroupsProvider),
          data: (list) {
            if (list.isEmpty) {
              return ListView(children: const [
                SizedBox(height: 120),
                Center(child: Text('Chưa có dự án')),
              ]);
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _GroupCard(
                group: list[i],
                onTapChild: (item) =>
                    _handleTap(context, ref, item, list[i].parent.name),
              ),
            );
          },
        ),
      ),
    );
  }

  void _goBoard(BuildContext context, SaleProjectItem item) {
    context.push(
        '/project/${item.code}?name=${Uri.encodeComponent(item.name)}');
  }

  void _handleTap(BuildContext context, WidgetRef ref, SaleProjectItem item,
      String parentName) {
    // Must verify personal info first.
    if (item.requiredInforVerify && !item.userInforVerify) {
      _kycDialog(context, subdivision: item.name, project: parentName);
      return;
    }
    switch (item.visibilityLevel) {
      case 1:
        _goBoard(context, item);
        break;
      case 2:
      case 3:
        if (item.registeredVerify) {
          _goBoard(context, item);
        } else {
          _registerDialog(context, ref, item, parentName);
        }
        break;
      default:
        _unknownDialog(context, item.visibilityLevel);
    }
  }

  Future<void> _kycDialog(BuildContext context,
      {required String subdivision, required String project}) {
    var agreed = false;
    return showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Yêu cầu xác thực thông tin',
              style: TextStyle(fontWeight: FontWeight.w700)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Bạn cần xác thực thông tin để xem bảng hàng của Phân khu [$subdivision] - Dự án [$project].'),
              const SizedBox(height: 12),
              _AgreeRow(
                value: agreed,
                onChanged: (v) => setState(() => agreed = v),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Huỷ'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: agreed
                  ? () {
                      Navigator.pop(ctx);
                      context.push('/kyc');
                    }
                  : null,
              child: const Text('Xác thực'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _registerDialog(BuildContext context, WidgetRef ref,
      SaleProjectItem item, String parentName) {
    var agreed = false;
    var loading = false;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Đăng ký thông tin bán hàng',
              style: TextStyle(fontWeight: FontWeight.w700)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Đăng ký thông tin bán hàng cho Phân khu [${item.name}] - Dự án [$parentName].'),
              const SizedBox(height: 12),
              _AgreeRow(
                value: agreed,
                onChanged:
                    loading ? null : (v) => setState(() => agreed = v),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: loading ? null : () => Navigator.pop(ctx),
              child: const Text('Huỷ'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: (!agreed || loading)
                  ? null
                  : () async {
                      setState(() => loading = true);
                      try {
                        final ok = await ref
                            .read(projectsApiProvider)
                            .registerSale(projectId: item.id);
                        if (ctx.mounted) Navigator.pop(ctx);
                        if (!ok) {
                          if (context.mounted) {
                            AppToast.error(context, 'Đăng ký thất bại');
                          }
                          return;
                        }
                        if (context.mounted) {
                          AppToast.success(context, 'Đăng ký thành công');
                          _goBoard(context, item);
                        }
                      } catch (_) {
                        setState(() => loading = false);
                        if (ctx.mounted) {
                          AppToast.error(ctx, 'Đăng ký thất bại');
                        }
                      }
                    },
              child: loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Text('Đăng ký'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _unknownDialog(BuildContext context, int level) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Không thể truy cập'),
        content: Text(
            'Mức hiển thị không hợp lệ (visibility_level=$level). Vui lòng liên hệ hỗ trợ.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Đóng')),
        ],
      ),
    );
  }
}

class _AgreeRow extends StatelessWidget {
  const _AgreeRow({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: value,
          activeColor: AppColors.primary,
          onChanged: onChanged == null ? null : (v) => onChanged!(v ?? false),
        ),
        const Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text(
                'Tôi đã hoàn thành khoá học và đồng ý đăng ký thông tin bán hàng.'),
          ),
        ),
      ],
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.group, required this.onTapChild});
  final ProjectGroup group;
  final ValueChanged<SaleProjectItem> onTapChild;

  @override
  Widget build(BuildContext context) {
    final children = group.children;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 44,
                height: 44,
                child: AppNetworkImage(
                  url: group.parent.imageUrl,
                  width: 44,
                  height: 44,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  placeholder: Container(
                    color: AppColors.primarySoft,
                    child: const Icon(Icons.apartment_rounded,
                        color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(group.parent.name,
                    style: AppTypography.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (children.isEmpty)
            Text('Chưa có phân khu',
                style:
                    AppTypography.caption.copyWith(color: AppColors.textMute))
          else
            for (int i = 0; i < children.length; i++) ...[
              _SubdivisionButton(
                label: children[i].name,
                onTap: () => onTapChild(children[i]),
              ),
              if (i != children.length - 1) const SizedBox(height: 10),
            ],
        ],
      ),
    );
  }
}

class _SubdivisionButton extends StatelessWidget {
  const _SubdivisionButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: AppTypography.subtitle.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.chevron_right, color: Colors.white, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
