import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Shown after a contract is signed (v1 `ContractSignSuccessPage`): a success
/// illustration with actions to view the contract list or open the signed PDF.
class ContractSignSuccessScreen extends StatelessWidget {
  const ContractSignSuccessScreen({super.key, this.pdfUrl, this.contractId});

  final String? pdfUrl;
  final String? contractId;

  String? get _resolvedPdf {
    final p = pdfUrl?.trim() ?? '';
    if (p.isEmpty) return null;
    return p.startsWith('http') ? p : AppConfig.imageUrl(p);
  }

  @override
  Widget build(BuildContext context) {
    final pdf = _resolvedPdf;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Image(
                        image: AssetImage('assets/images/contract_success.png'),
                        width: 220,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Ký hợp đồng thành công',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bold(22).copyWith(height: 1.25),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Hệ thống sẽ rà soát thông tin hợp đồng của bạn để đảm bảo tính chính xác trước khi kích hoạt hợp đồng',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.regular(15,
                                color: AppColors.neutral400)
                            .copyWith(height: 1.4),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.go('/contracts'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text('Danh sách',
                          style: AppTextStyles.semibold(16, color: AppColors.text)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: pdf == null
                          ? null
                          : () => context.push('/contract-pdf',
                              extra: {'url': pdf, 'title': 'Hợp đồng CTV'}),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.price, // v1 #F58229 CTA
                        disabledBackgroundColor: const Color(0xFFF1D8C8),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text('Xem hợp đồng',
                          style: AppTextStyles.semibold(16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
