import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_toast.dart';
import '../../../../contracts/data/contracts_api.dart';
import '../../../../transactions/presentation/deposit_sheet.dart';
import '../../../../verification/data/models/verification_models.dart';
import '../../../../verification/data/verification_api.dart';
import '../../../data/models/property.dart';
import '../../../data/models/property_detail.dart';
import '../../../data/realestate_api.dart';
import '../../search_controller.dart';
import '../../sell_news_screen.dart';

/// Bottom action bar. For an agent's own listing it mirrors v1's status-based
/// `_buildMyFooter` (Gỡ bài / Chỉnh sửa / Xác thực / Ký HĐ); otherwise the
/// browse actions (liên hệ / chia sẻ / tôi có khách).
class DetailFooter extends ConsumerWidget {
  const DetailFooter({super.key, required this.detail, required this.detailKey});

  final PropertyDetail detail;
  final PropertyDetailKey detailKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: SafeArea(
        top: false,
        child: detail.isOwned ? _ownedFooter(context, ref) : _browseFooter(context),
      ),
    );
  }

  // ───────── owned (agent) footer ─────────

  Widget _ownedFooter(BuildContext context, WidgetRef ref) {
    final code = detail.statusCode;
    final name = detail.statusName;
    final verified =
        detail.isVerifyRealEstate == true && detail.isRequestSigning != true;

    if (verified) {
      return AppButton(
        label: 'Ký HĐ với chủ nhà',
        onPressed: () => _signContract(context, ref),
      );
    }
    if (code == 'PENDING_APPROVAL' || name == 'Chờ duyệt') {
      return Row(children: [
        _iconBtn(Icons.delete_outline, AppColors.danger,
            () => _confirmUnpublish(context, ref)),
        const SizedBox(width: 12),
        _iconBtn(Icons.edit_outlined, AppColors.primary,
            () => _edit(context)),
        const SizedBox(width: 12),
        Expanded(
          child: AppButton(
            label: 'Xác thực',
            onPressed: () => _verify(context, ref),
          ),
        ),
      ]);
    }
    if (code == 'REJECTED') {
      return Row(children: [
        Expanded(
          child: AppButton(
            label: 'Gỡ bài',
            variant: AppButtonVariant.ghost,
            onPressed: () => _confirmUnpublish(context, ref),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
            child: AppButton(label: 'Chỉnh sửa', onPressed: () => _edit(context))),
      ]);
    }
    if (code == 'DRAFT') {
      return AppButton(label: 'Chỉnh sửa', onPressed: () => _edit(context));
    }
    return AppButton(
      label: 'Gỡ bài',
      variant: AppButtonVariant.ghost,
      onPressed: () => _confirmUnpublish(context, ref),
    );
  }

  void _edit(BuildContext context) =>
      context.push('/post/edit', extra: detail);

  Future<void> _confirmUnpublish(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Gỡ tin này?'),
        content: const Text('Tin sẽ bị gỡ và không thể khôi phục lại.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Huỷ')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Gỡ', style: TextStyle(color: AppColors.danger))),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    try {
      await ref.read(realEstateApiProvider).unpublish(detail.id);
      ref.invalidate(propertyDetailProvider(detailKey));
      if (!context.mounted) return;
      AppToast.success(context, 'Gỡ tin thành công');
      context.pop();
    } catch (_) {
      if (context.mounted) AppToast.error(context, 'Gỡ tin thất bại, thử lại');
    }
  }

  Future<void> _verify(BuildContext context, WidgetRef ref) async {
    final salesmanId = detail.realEstateSalesmanId;
    if (salesmanId == null) {
      AppToast.warning(context, 'Tin chưa sẵn sàng để xác thực');
      return;
    }
    try {
      final api = ref.read(verificationApiProvider);
      final vDetail = await api.fetchVerificationDetail(salesmanId);
      if (!context.mounted) return;
      final item = _verificationItem(salesmanId);
      context.push('/real-estate-verification/form',
          extra: {'item': item, 'detail': vDetail});
    } catch (_) {
      if (context.mounted) {
        AppToast.error(context, 'Không tải được thông tin xác thực');
      }
    }
  }

  VerificationItem _verificationItem(int salesmanId) => VerificationItem(
        id: salesmanId,
        title: detail.title,
        location: detail.address,
        price: detail.priceText,
        area: detail.area == null ? '' : '${detail.area!.toInt()} m²',
        status: detail.statusName ?? '',
        date: detail.timeAgo ?? '',
        imageUrl: detail.gallery.isNotEmpty ? detail.gallery.first : '',
        accent: AppColors.primary,
        cardToneA: AppColors.primarySoft,
        cardToneB: AppColors.surface,
        salesmanId: salesmanId,
        salesmanName: detail.seller?.name ?? '',
        agentSupportName: '',
        assignedToName: '',
        owner: detail.seller?.name ?? '',
        company: '',
      );

  /// "Ký HĐ với chủ nhà": choose signing method + contract type → request the
  /// seller contract (`contract_seller_create.json`). Mirrors v1.
  Future<void> _signContract(BuildContext context, WidgetRef ref) async {
    final salesmanId = detail.realEstateSalesmanId;
    if (salesmanId == null) {
      AppToast.warning(context, 'Tin chưa sẵn sàng để ký hợp đồng');
      return;
    }
    final choice = await showModalBottomSheet<({int signing, int contract})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _SignContractSheet(),
    );
    if (choice == null || !context.mounted) return;
    try {
      final res = await ref.read(contractsApiProvider).createSellerContract(
            realEstateSalesmanId: salesmanId,
            signingMethod: choice.signing,
            contractType: choice.contract,
          );
      if (!context.mounted) return;
      if (res.success) {
        AppToast.success(context, res.message?.isNotEmpty == true
            ? res.message!
            : 'Đã gửi yêu cầu ký hợp đồng');
        ref.invalidate(propertyDetailProvider(detailKey));
      } else {
        AppToast.error(
            context, res.message?.isNotEmpty == true ? res.message! : 'Gửi yêu cầu thất bại');
      }
    } catch (_) {
      if (context.mounted) AppToast.error(context, 'Gửi yêu cầu thất bại, thử lại');
    }
  }

  // ───────── browse footer ─────────

  Widget _browseFooter(BuildContext context) {
    return Row(children: [
      _iconBtn(Icons.phone, AppColors.success, () {
        final phone = detail.seller?.phone ?? '';
        if (phone.isEmpty) {
          AppToast.info(context, 'Chưa có số điện thoại');
        } else {
          launchUrl(Uri.parse('tel:$phone'));
        }
      }),
      const SizedBox(width: 12),
      _iconBtn(Icons.share_outlined, AppColors.primary, () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => SellNewsScreen(
            realEstateId: detail.id,
            fallbackImages: detail.gallery,
          ),
        ));
      }),
      const SizedBox(width: 12),
      Expanded(
        child: AppButton(
          label: 'Tôi có khách',
          onPressed: () => _customerSheet(context),
        ),
      ),
    ]);
  }

  void _customerSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.event_outlined, color: AppColors.info),
              title: const Text('Tạo lịch hẹn'),
              subtitle: const Text('Hẹn dẫn khách đi xem bất động sản'),
              onTap: () {
                Navigator.pop(sheetCtx);
                context.push('/appointments/create',
                    extra: Property(
                        id: detail.id,
                        title: detail.title,
                        address: detail.address));
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.check_circle_outline, color: AppColors.success),
              title: const Text('Đặt cọc'),
              subtitle: const Text('Thực hiện đặt cọc cho BĐS muốn giao dịch'),
              onTap: () {
                Navigator.pop(sheetCtx);
                showDepositSheet(context,
                    tableName: 'real_estate', tableId: detail.id);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon, Color color, VoidCallback onTap) => Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Container(
            width: AppSpacing.controlHeight,
            height: AppSpacing.controlHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
        ),
      );
}

/// Bottom sheet to pick signing method + contract type before requesting a
/// seller contract. Returns `(signing, contract)` codes or null on cancel.
class _SignContractSheet extends StatefulWidget {
  const _SignContractSheet();

  @override
  State<_SignContractSheet> createState() => _SignContractSheetState();
}

class _SignContractSheetState extends State<_SignContractSheet> {
  // signing: 2 = điện tử, 1 = trực tiếp | contract: 2 = thông thường, 3 = độc quyền
  int _signing = 2;
  int _contract = 2;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Yêu cầu ký hợp đồng', style: AppTextStyles.semibold(18)),
            const SizedBox(height: 16),
            Text('Cách thức ký',
                style: AppTextStyles.regular(13, color: AppColors.textMute)),
            const SizedBox(height: 8),
            _options(
              current: _signing,
              options: const {2: 'Ký điện tử', 1: 'Ký trực tiếp'},
              onSelect: (v) => setState(() => _signing = v),
            ),
            const SizedBox(height: 16),
            Text('Loại hợp đồng',
                style: AppTextStyles.regular(13, color: AppColors.textMute)),
            const SizedBox(height: 8),
            _options(
              current: _contract,
              options: const {2: 'Môi giới thông thường', 3: 'Môi giới độc quyền'},
              onSelect: (v) => setState(() => _contract = v),
            ),
            const SizedBox(height: 24),
            Row(children: [
              Expanded(
                child: AppButton(
                  label: 'Quay lại',
                  variant: AppButtonVariant.ghost,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  label: 'Gửi',
                  onPressed: () => Navigator.pop(
                      context, (signing: _signing, contract: _contract)),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _options({
    required int current,
    required Map<int, String> options,
    required ValueChanged<int> onSelect,
  }) {
    return Column(
      children: [
        for (final e in options.entries)
          InkWell(
            onTap: () => onSelect(e.key),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: current == e.key
                    ? AppColors.primary.withValues(alpha: 0.08)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color:
                      current == e.key ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    current == e.key
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    size: 20,
                    color:
                        current == e.key ? AppColors.primary : AppColors.textMute,
                  ),
                  const SizedBox(width: 10),
                  Text(e.value, style: AppTextStyles.regular(15)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
