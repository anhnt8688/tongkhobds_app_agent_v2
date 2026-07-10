import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/money_format.dart';
import '../../../core/utils/thousands_input_formatter.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/custom_screen.dart';
import '../data/loan_api.dart';
import '../data/models/loan_bank.dart';
import '../data/models/loan_calculation.dart';
import '../data/models/loan_package.dart';
import 'widgets/loan_bank_sheet.dart';
import 'widgets/loan_form_fields.dart';
import 'widgets/loan_package_sheet.dart';

/// Loan calculator (v1 LoanCalculatorPage): amount + bank + package + floating
/// rate + term → `loan_schedule.json` → result card. "Tạo hồ sơ vay vốn"
/// forwards the picked package/bank/amount to the create form.
class LoanCalculatorScreen extends ConsumerStatefulWidget {
  const LoanCalculatorScreen({super.key});

  @override
  ConsumerState<LoanCalculatorScreen> createState() => _LoanCalculatorScreenState();
}

class _LoanCalculatorScreenState extends ConsumerState<LoanCalculatorScreen> {
  final _amount = TextEditingController();
  final _rate = TextEditingController();
  final _term = TextEditingController();

  LoanBank? _bank;
  LoanPackage? _package;
  List<LoanPackage> _packages = const [];
  LoanCalculation? _result;
  bool _busy = false;

  @override
  void dispose() {
    _amount.dispose();
    _rate.dispose();
    _term.dispose();
    super.dispose();
  }

  bool get _valid =>
      digitsOf(_amount.text) > 0 &&
      _term.text.trim().isNotEmpty &&
      _bank?.id != null &&
      _rate.text.trim().isNotEmpty &&
      _package?.id != null;

  Future<void> _pickBank() async {
    final banks = await ref.read(loanApiProvider).banks();
    if (!mounted) return;
    final picked = await showModalBottomSheet<LoanBank>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LoanBankSheet(banks: banks, selected: _bank),
    );
    if (picked == null) return;
    setState(() {
      _bank = picked;
      _package = null;
      _packages = const [];
    });
    final pkgs = await ref.read(loanApiProvider).packagesByBank(picked.id ?? 0);
    if (mounted) setState(() => _packages = pkgs);
  }

  Future<void> _pickPackage() async {
    final picked = await showModalBottomSheet<LoanPackage>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LoanPackageSheet(packages: _packages, selected: _package),
    );
    if (picked == null) return;
    setState(() {
      _package = picked;
      _rate.text = picked.interestRateFloat ?? '';
      final grace = int.tryParse(picked.gracePeriod ?? '0') ?? 0;
      _term.text = (grace ~/ 12).toString();
    });
  }

  Future<void> _calculate() async {
    setState(() => _busy = true);
    try {
      final result = await ref.read(loanApiProvider).schedule({
        'loan_amount': digitsOf(_amount.text).toDouble(),
        'loan_term_year': int.tryParse(_term.text) ?? 0,
        'annual_interest_rate': double.tryParse(_rate.text) ?? 0,
        'disbursement_date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'payment_method': 'equal_payment',
      });
      if (mounted) setState(() => _result = result);
    } on ApiException catch (e) {
      if (mounted) AppToast.error(context, e.message);
    } catch (_) {
      if (mounted) AppToast.error(context, 'Không tính được khoản vay');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _createProfile() {
    context.push('/loan/create', extra: {
      'loan_package': _package,
      'bank': _bank,
      'loan_amount': _amount.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _result == null,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _result = null);
      },
      child: CustomScreen(
        title: 'Tính toán vay vốn',
        backgroundColor: AppColors.bg,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _form(),
                    if (_result != null) _resultCard(_result!),
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: AppButton(
                  label: _result != null ? 'Tạo hồ sơ vay vốn' : 'Xem kết quả',
                  loading: _busy,
                  onPressed: !_valid
                      ? null
                      : (_result != null ? _createProfile : _calculate),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _form() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Thông tin khoản vay',
              style: AppTypography.title.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          LoanField(
            title: 'Số tiền vay',
            controller: _amount,
            hint: 'Nhập số tiền muốn vay',
            keyboardType: TextInputType.number,
            inputFormatters: [ThousandsInputFormatter()],
            suffixText: 'VNĐ',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          LoanSelectField(
            title: 'Ngân hàng vay',
            required: true,
            value: _bank?.abbreviations ?? '',
            hint: 'Chọn ngân hàng',
            leadingImageUrl: _bank?.image,
            onTap: _pickBank,
          ),
          const SizedBox(height: 16),
          LoanSelectField(
            title: 'Chọn gói vay',
            required: true,
            value: _package?.name ?? '',
            hint: 'Chọn gói vay phù hợp',
            enabled: _bank != null,
            onTap: _pickPackage,
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: LoanField(
                  title: 'Lãi suất thả nổi',
                  required: true,
                  controller: _rate,
                  hint: '0',
                  readOnly: _package?.id != null,
                  keyboardType: TextInputType.number,
                  suffixText: '% / năm',
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: LoanField(
                  title: 'Thời hạn vay',
                  required: true,
                  controller: _term,
                  hint: '0',
                  keyboardType: TextInputType.number,
                  suffixText: 'năm',
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _resultCard(LoanCalculation r) {
    final first = r.schedule.isNotEmpty ? r.schedule.first.total : 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: Divider(color: AppColors.border)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Kết quả tính toán',
                    style: AppTypography.subtitle
                        .copyWith(color: AppColors.textSecondary)),
              ),
              const Expanded(child: Divider(color: AppColors.border)),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text('Trả gốc + lãi cố định',
                    style: AppTypography.title.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                _row('Gốc + lãi tháng đầu trả', first),
                const SizedBox(height: 16),
                _row('Gốc + lãi sau ưu đãi', r.averageMonthlyPayment),
                const SizedBox(height: 16),
                _row('Tổng gốc + lãi phải trả', r.totalPayment),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Lưu ý: Công cụ tính toán này chỉ hỗ trợ cho việc ước tính khoản vay, '
            'không phải là sự đảm bảo về khoản vay từ Agent',
            style: AppTypography.caption.copyWith(color: AppColors.textMute),
          ),
        ],
      ),
    );
  }

  Widget _row(String title, double value) {
    return Row(
      children: [
        Expanded(
          child: Text('💰 $title',
              style: AppTypography.subtitle.copyWith(color: AppColors.textSecondary)),
        ),
        Text.rich(
          TextSpan(children: [
            TextSpan(
              text: formatMoney(value, currency: ''),
              style: AppTypography.subtitle.copyWith(
                  color: AppColors.primary, fontWeight: FontWeight.w600),
            ),
            TextSpan(
              text: ' VNĐ',
              style: AppTypography.subtitle.copyWith(fontWeight: FontWeight.w600),
            ),
          ]),
        ),
      ],
    );
  }
}
