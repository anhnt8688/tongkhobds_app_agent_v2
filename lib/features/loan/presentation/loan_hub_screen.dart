import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../core/widgets/custom_screen.dart';
import '../data/loan_api.dart';
import '../data/models/loan_bank.dart';
import '../data/models/loan_package.dart';
import 'widgets/loan_package_card.dart';

/// Loan hub (v1 LoanPage): intro gradient header, create/manage buttons,
/// disclaimer, and a partner-bank package carousel. Calculator icon in appbar.
class LoanHubScreen extends ConsumerStatefulWidget {
  const LoanHubScreen({super.key});

  @override
  ConsumerState<LoanHubScreen> createState() => _LoanHubScreenState();
}

class _LoanHubScreenState extends ConsumerState<LoanHubScreen> {
  final _page = PageController();
  int _index = 0;

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banks = ref.watch(loanBanksProvider).valueOrNull ?? const <LoanBank>[];
    final packages =
        ref.watch(loanAllPackagesProvider).valueOrNull ?? const <LoanPackage>[];
    return CustomScreen(
      title: 'Vay vốn',
      backgroundColor: AppColors.surface,
      action: GestureDetector(
        onTap: () => context.push('/loan/calculator'),
        child: Container(
          margin: const EdgeInsets.only(right: 16),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: FaIcon(FontAwesomeIcons.calculator,
                size: 16, color: AppColors.text),
          ),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _header(banks),
            _carousel(packages),
          ],
        ),
      ),
    );
  }

  Widget _header(List<LoanBank> banks) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFF9A05C), AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: Column(
        children: [
          if (banks.isNotEmpty) _iconStack(banks),
          const SizedBox(height: 32),
          Text('Giới thiệu khoản vay',
              textAlign: TextAlign.center,
              style: AppTypography.display.copyWith(color: Colors.white)),
          const SizedBox(height: 4),
          Text('Lãi suất hợp lí, hoa hồng nhân đôi',
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(color: Colors.white)),
          const SizedBox(height: 36),
          AppButton(
            label: 'Tạo hồ sơ vay vốn',
            variant: AppButtonVariant.ghost,
            onPressed: () => context.push('/loan/create'),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => context.push('/loan/profiles'),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text('Quản lý hồ sơ',
                  style: AppTypography.body.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  /// Fanned, rotated bank logos (v1 buildIconStack) — up to 4.
  Widget _iconStack(List<LoanBank> banks) {
    const offsets = [Offset(-90, 0), Offset(-30, 0), Offset(30, -15), Offset(90, 6)];
    const angles = [-0.5, -0.2, 0.3, -0.2];
    return SizedBox(
      height: 90,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (var i = 0; i < banks.length && i < 4; i++)
            Transform.translate(
              offset: offsets[i],
              child: Transform.rotate(
                angle: angles[i],
                child: _bankTile(banks[i].image),
              ),
            ),
        ],
      ),
    );
  }

  Widget _bankTile(String? image) {
    return Container(
      height: 70,
      width: 70,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: AppNetworkImage(
        url: image,
        width: 45,
        height: 45,
        fit: BoxFit.contain,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget _carousel(List<LoanPackage> packages) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Lưu ý: Thông tin tài chính trong ứng dụng chỉ mang tính chất tham '
              'khảo. Ứng dụng không cung cấp, môi giới hoặc xử lý bất kỳ dịch vụ '
              'vay vốn nào. Người dùng cần tự tìm hiểu và liên hệ trực tiếp với '
              'các tổ chức tài chính hợp pháp khi có nhu cầu',
              style: AppTypography.body.copyWith(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FaIcon(FontAwesomeIcons.buildingColumns,
                  size: 18, color: AppColors.text),
              const SizedBox(width: 8),
              Text('Ngân hàng đối tác',
                  style: AppTypography.title.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 16),
          if (packages.isNotEmpty) ...[
            SizedBox(
              height: 330,
              child: PageView.builder(
                controller: _page,
                itemCount: packages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) =>
                    LoanPackageCard(package: packages[i], showMore: true),
              ),
            ),
            const SizedBox(height: 10),
            _dots(packages.length),
          ],
        ],
      ),
    );
  }

  Widget _dots(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == _index ? 20 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == _index ? AppColors.primary : AppColors.border,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
      ],
    );
  }
}
