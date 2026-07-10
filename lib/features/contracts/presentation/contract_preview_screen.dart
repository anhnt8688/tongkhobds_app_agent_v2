import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/custom_screen.dart';
import '../data/contract_preview_data.dart';
import '../data/contracts_api.dart';
import 'widgets/contract_info_section.dart';
import 'widgets/library_file_preview_screen.dart';

/// "Nội dung hợp đồng" — preview a contract by id (v1 `ContractPreviewPage`).
/// Signed contracts get a bottom "Xem hợp đồng" action that opens the PDF;
/// unsigned contracts show the details only (matches v1).
class ContractPreviewScreen extends ConsumerStatefulWidget {
  const ContractPreviewScreen({
    super.key,
    required this.id,
    this.viewOnly = false,
    this.pdfUrl,
    this.title,
    this.contractType,
    this.signingMethod,
  });

  final int id;
  final bool viewOnly;
  final String? pdfUrl;
  final String? title;
  final dynamic contractType;
  final dynamic signingMethod;

  @override
  ConsumerState<ContractPreviewScreen> createState() =>
      _ContractPreviewScreenState();
}

class _ContractPreviewScreenState extends ConsumerState<ContractPreviewScreen> {
  bool _showMoreA = false;
  bool _showMoreB = false;

  @override
  Widget build(BuildContext context) {
    final preview = ref.watch(contractPreviewProvider(widget.id));
    return CustomScreen(
      title: 'Nội dung hợp đồng',
      backgroundColor: Colors.white,
      bottomNavigationBar: widget.viewOnly ? _buildBottomBar(context) : null,
      child: AsyncView<ContractPreview>(
        value: preview,
        onRetry: () => ref.invalidate(contractPreviewProvider(widget.id)),
        data: _buildContent,
      ),
    );
  }

  Widget _buildContent(ContractPreview p) {
    final viewOnly = widget.viewOnly;
    final commission = p.commissionText;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ContractSectionHeader('Thông tin hợp đồng'),
          const ContractHr(),
          ContractKV('Loại hợp đồng', p.contractTypeLabel(widget.contractType)),
          ContractKV('Phương thức ký', p.signMethodLabel(widget.signingMethod)),
          ContractKV('Giá trị hợp đồng', p.contractValue, bold: true),
          ContractKV('Phí môi giới (hoa hồng)', p.brokerageFee),
          if (commission.isNotEmpty && commission != '—')
            ContractNoteCard(text: commission),

          const SizedBox(height: 6),
          const ContractSectionHeader('Thông tin bên A'),
          const ContractHr(),
          ContractKV('Tên công ty', p.companyName, bold: true),
          ContractKV('Mã số doanh nghiệp', p.businessCode),
          if (!viewOnly) ...[
            ContractKV('Địa chỉ trụ sở chính', p.companyAddress),
            ContractKV('Người đại diện', p.representative),
            ContractKV('Chức vụ', p.representativePosition),
          ] else ...[
            ContractMoreButton(
              expanded: _showMoreA,
              onTap: () => setState(() => _showMoreA = !_showMoreA),
            ),
            if (_showMoreA) ...[
              ContractKV('Địa chỉ trụ sở chính', p.companyAddress),
              ContractKV('Người đại diện', p.representative),
              ContractKV('Chức vụ', p.representativePosition),
            ],
          ],

          const SizedBox(height: 6),
          const ContractSectionHeader('Thông tin bên B'),
          const ContractHr(),
          ContractKV('Ông/Bà', p.agentName, bold: true),
          ContractKV('Ngày sinh', p.agentBirthday),
          ContractKV('CCCD', p.agentCccd),
          ContractKV('Cấp ngày', p.agentCccdDate),
          ContractMoreButton(
            expanded: _showMoreB,
            onTap: () => setState(() => _showMoreB = !_showMoreB),
          ),
          if (_showMoreB) ...[
            ContractKV('Nơi cấp', p.agentCccdPlace),
            ContractKV('Địa chỉ thường trú', p.agentAddress),
            ContractKV('Số điện thoại', p.agentPhone),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, -2)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                label: 'Quay lại',
                variant: AppButtonVariant.ghost,
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton(
                label: 'Xem hợp đồng',
                onPressed: _openPdf,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openPdf() {
    final url = widget.pdfUrl ?? '';
    if (url.isEmpty) return;
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
      builder: (_) => LibraryFilePreviewScreen(
        url: url,
        name: widget.title ?? 'Hợp đồng',
      ),
    ));
  }
}
