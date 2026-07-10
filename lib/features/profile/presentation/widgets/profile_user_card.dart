import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../auth/data/models/user.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/models/award.dart';

/// v1 profile header: orange card (tap → edit profile) holding the avatar,
/// name, phone, an optional notepad shortcut (when the CTV contract is signed
/// & verified), and a nested banner that switches by account state:
/// award card → join-CTV banner → contract-pending banner.
class ProfileUserCard extends StatelessWidget {
  const ProfileUserCard({super.key, required this.user, this.award});

  final User user;
  final AwardDetail? award;

  @override
  Widget build(BuildContext context) {
    final hasContract = (user.contractPdf ?? '').isNotEmpty;
    final isContractVerified = user.contractVerify == true;

    Widget? banner;
    if (award != null && (award!.name ?? '').isNotEmpty) {
      banner = _AwardCard(award: award!);
    } else if (!hasContract) {
      banner = _JoinCtvBanner(user: user);
    } else if (!isContractVerified) {
      banner = _ContractPendingBanner(user: user);
    }

    // v1 profile has no page title — the orange card is the first element.
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push('/edit-profile'),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  _Avatar(image: user.image, verified: user.step == 3),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.fullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bold(17, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.phone_rounded,
                                size: 18, color: Colors.white70),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                user.phone,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.regular(15,
                                    color: Colors.white70),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (hasContract && isContractVerified) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _openContract(context),
                      child: Image.asset('assets/images/notepad.png',
                          width: 28, height: 28),
                    ),
                  ],
                ],
              ),
              if (banner != null) ...[
                const SizedBox(height: 12),
                banner,
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _openContract(BuildContext context) =>
      openContractPdf(context, user.contractPdf);
}

/// Opens the signed CTV contract PDF directly (v1 `_openContractIfAny`) — a
/// native PDF view, never the contract list.
void openContractPdf(BuildContext context, String? pdf) {
  final url = pdf ?? '';
  if (url.isEmpty) return;
  context.push('/contract-pdf', extra: {'url': url, 'title': 'Hợp đồng CTV'});
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.image, required this.verified});
  final String? image;
  final bool verified;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.white24,
          backgroundImage: (image != null && image!.isNotEmpty)
              ? CachedNetworkImageProvider(image!, maxWidth: 160, maxHeight: 160)
                  as ImageProvider
              : const AssetImage('assets/images/no_avatar.png'),
        ),
        if (verified)
          const Positioned(
            right: 0,
            bottom: 0,
            child: CircleAvatar(
              radius: 8,
              backgroundColor: Colors.white,
              child: Icon(Icons.verified, size: 14, color: AppColors.success),
            ),
          ),
      ],
    );
  }
}

/// White award card nested inside the orange header (v1 `_buildAwardCard`).
class _AwardCard extends StatelessWidget {
  const _AwardCard({required this.award});
  final AwardDetail award;

  @override
  Widget build(BuildContext context) {
    final title = award.name ?? '';
    final desc = award.description ?? '';
    final html = award.htmlContent ?? '';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bold(16)),
                const SizedBox(height: 6),
                Text(desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.regular(13,
                            color: AppColors.textSecondary)
                        .copyWith(height: 1.35)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 36,
                  child: FilledButton(
                    onPressed:
                        html.trim().isEmpty ? null : () => context.push('/award-benefits'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Quyền lợi',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 90,
            height: 90,
            child: Image.asset('assets/images/ctvIllustration.png',
                fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }
}

/// "Gia nhập đội ngũ CTV" banner shown when no contract exists (v1).
class _JoinCtvBanner extends ConsumerWidget {
  const _JoinCtvBanner({required this.user});
  final User user;

  /// v1 `_handleJoinOrShow`: route by contract/KYC state.
  Future<void> _handleJoinOrShow(BuildContext context, WidgetRef ref) async {
    final pdf = user.contractPdf ?? '';
    if (pdf.isNotEmpty) {
      openContractPdf(context, pdf);
      return;
    }
    if (user.step == 3) {
      context.push('/contract/join-preview');
      return;
    }
    if (user.step == 2) {
      showAppConfirmDialog(
        context,
        imageAsset: 'assets/images/ic_info.png',
        title: 'Tài khoản chờ duyệt xác thực',
        description: 'Hệ thống sẽ tiến hành xét duyệt thông tin xác thực của bạn',
        confirmLabel: 'Đã hiểu',
        cancelLabel: 'Xác thực lại',
        onCancel: () => context.push('/kyc'),
      );
      return;
    }
    // step 1: verify KYC first, then continue to signing if approved.
    await context.push('/kyc');
    if (!context.mounted) return;
    if (ref.read(currentUserProvider)?.step == 3) {
      context.push('/contract/join-preview');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Gia nhập đội ngũ CTV',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bold(15)),
                const SizedBox(height: 8),
                Text(
                  'Trở thành đối tác của TongkhoBDS để có cơ hội tiếp cận nguồn bất động sản chất lượng, tiềm năng nhất!',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style:
                      AppTextStyles.regular(13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton(
                    onPressed: () => _handleJoinOrShow(context, ref),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Ký hợp đồng ngay',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 110,
            height: 120,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
              child: Image.asset('assets/images/ctvIllustration.png',
                  fit: BoxFit.fitHeight),
            ),
          ),
        ],
      ),
    );
  }
}

/// "Hợp đồng đang được xem xét" banner when a contract exists but is unverified.
class _ContractPendingBanner extends StatelessWidget {
  const _ContractPendingBanner({required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hợp đồng đang được xem xét',
                    style: AppTextStyles.bold(15)),
                const SizedBox(height: 6),
                Text(
                  'Hệ thống đang rà soát thông tin hợp đồng của bạn để đảm bảo tính chính xác trước khi kích hoạt hợp đồng',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.regular(13,
                          color: AppColors.textSecondary)
                      .copyWith(height: 1.35),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 38,
                  child: FilledButton(
                    onPressed: () => openContractPdf(context, user.contractPdf),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Xem hợp đồng',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 110,
            height: 120,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
              child: Image.asset('assets/images/ctvIllustration.png',
                  fit: BoxFit.fitHeight),
            ),
          ),
        ],
      ),
    );
  }
}
