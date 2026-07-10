import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/custom_screen.dart';
import '../../auth/presentation/controllers/auth_controller.dart';
import '../data/contract_preview_data.dart';
import '../data/contracts_api.dart';
import 'widgets/contract_info_section.dart';

/// "Nội dung hợp đồng" — CTV contract preview shown before signing (v1
/// `ContractPreviewPage` in the join flow). Lists the contract terms plus the
/// office (Bên A) and agent (Bên B) info, then a "Tiếp tục" action that opens
/// the signing screen.
class ContractJoinPreviewScreen extends ConsumerStatefulWidget {
  const ContractJoinPreviewScreen({super.key});

  @override
  ConsumerState<ContractJoinPreviewScreen> createState() =>
      _ContractJoinPreviewScreenState();
}

class _ContractJoinPreviewScreenState
    extends ConsumerState<ContractJoinPreviewScreen> {
  bool _showMoreA = false;
  bool _showMoreB = false;

  @override
  Widget build(BuildContext context) {
    final preview = ref.watch(contractJoinPreviewProvider);
    return CustomScreen(
      title: 'Nội dung hợp đồng',
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomBar(context),
      child: AsyncView<ContractPreview>(
        value: preview,
        onRetry: () => ref.invalidate(contractJoinPreviewProvider),
        data: _buildContent,
      ),
    );
  }

  Widget _buildContent(ContractPreview p) {
    // v1 defaults when the option label can't be resolved from the id.
    final typeLabel = _withFallback(p.contractTypeLabel(1), 'Hợp đồng CTV');
    final signLabel = _withFallback(p.signMethodLabel(2), 'Ký điện tử');

    // Bên B phone comes from the logged-in user (v1 used the passed-in user's
    // phone); the join endpoint has no listing owner phone to read.
    final userPhone = ref.watch(currentUserProvider)?.phone ?? '';
    final agentPhone = userPhone.isNotEmpty ? userPhone : p.agentPhone;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ContractSectionHeader('Thông tin hợp đồng'),
          const ContractHr(),
          ContractKV('Loại hợp đồng', typeLabel),
          ContractKV('Phương thức ký', signLabel),

          const ContractSectionHeader('Thông tin bên A'),
          const ContractHr(),
          ContractKV('Tên công ty', p.companyName, bold: true),
          ContractKV('Mã số doanh nghiệp', p.businessCode),
          if (_showMoreA) ...[
            ContractKV('Địa chỉ trụ sở chính', p.companyAddress),
            ContractKV('Người đại diện', p.representative),
            ContractKV('Chức vụ', p.representativePosition),
          ],
          ContractMoreButton(
            expanded: _showMoreA,
            onTap: () => setState(() => _showMoreA = !_showMoreA),
          ),

          const ContractSectionHeader('Thông tin bên B'),
          const ContractHr(),
          ContractKV('Ông/Bà', p.agentName, bold: true),
          ContractKV('Ngày sinh', p.agentBirthday),
          ContractKV('CCCD', p.agentCccd),
          ContractKV('Cấp ngày', p.agentCccdDate),
          if (_showMoreB) ...[
            ContractKV('Địa chỉ thường trú', p.agentAddress),
            ContractKV('Số điện thoại', agentPhone),
          ],
          ContractMoreButton(
            expanded: _showMoreB,
            onTap: () => setState(() => _showMoreB = !_showMoreB),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                label: 'Quay lại',
                variant: AppButtonVariant.ghost,
                onPressed: () => context.pop(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: AppButton(
                label: 'Tiếp tục',
                icon: Icons.draw_outlined,
                onPressed: () {
                  final officeId =
                      ref.read(contractJoinPreviewProvider).valueOrNull?.officeId;
                  context.push('/contract/sign',
                      extra: {'infoOffice': officeId ?? 1});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// v1 fell back to a hard-coded label when the option id wasn't in the list;
  /// our resolver returns the raw id string in that case, so swap it out.
  String _withFallback(String resolved, String fallback) {
    final t = resolved.trim();
    if (t.isEmpty || t == '—' || int.tryParse(t) != null) return fallback;
    return t;
  }
}
