import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_toast.dart';
import '../../../data/models/project_detail.dart';

/// Sticky bottom bar (v1 detail_project footer, minus chat): Gọi điện +
/// "Tôi có khách" → Tạo lịch hẹn / Đặt cọc.
class ProjectBottomBar extends StatelessWidget {
  const ProjectBottomBar({super.key, required this.project});
  final ProjectDetail project;

  @override
  Widget build(BuildContext context) {
    final phone = project.contactPhone ?? '';
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            if (phone.isNotEmpty) ...[
              _CallButton(phone: phone),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.price,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => _showCustomerSheet(context),
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text('Tôi có khách'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomerSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.event_available,
                  color: AppColors.primary),
              title: const Text('Tạo lịch hẹn'),
              onTap: () {
                Navigator.pop(sheetCtx);
                context.push('/appointments/create');
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.account_balance_wallet_outlined,
                      color: AppColors.primary),
              title: const Text('Đặt cọc'),
              onTap: () {
                Navigator.pop(sheetCtx);
                context.push('/deposit');
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _CallButton extends StatelessWidget {
  const _CallButton({required this.phone});
  final String phone;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      onPressed: () async {
        final ok = await launchUrl(Uri.parse('tel:$phone'));
        if (!ok && context.mounted) {
          AppToast.error(context, 'Không gọi được $phone');
        }
      },
      icon: const Icon(Icons.phone_outlined),
      label: const Text('Gọi điện'),
    );
  }
}
