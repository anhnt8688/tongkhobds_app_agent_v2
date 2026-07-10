import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/thousands_input_formatter.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/custom_screen.dart';
import '../data/loan_api.dart';
import '../data/models/loan.dart';
import '../data/models/loan_bank.dart';
import '../data/models/loan_customer.dart';
import '../data/models/loan_mortgage.dart';
import '../data/models/loan_package.dart';
import '../data/models/loan_transaction.dart';
import 'widgets/loan_bank_sheet.dart';
import 'widgets/loan_collateral_sheet.dart';
import 'widgets/loan_customer_sheet.dart';
import 'widgets/loan_form_fields.dart';
import 'widgets/loan_package_sheet.dart';
import 'widgets/loan_transaction_sheet.dart';

/// Create / edit a loan profile (v1 CreateProfileLoanPage). Non-edit create has
/// a preview step (isReadOnly) before submit. `prefill` carries the calculator
/// hand-off ({loan_package, bank, loan_amount}); `edit` loads an existing loan.
class LoanCreateScreen extends ConsumerStatefulWidget {
  const LoanCreateScreen({super.key, this.prefill, this.edit});

  final Map<String, dynamic>? prefill;
  final Loan? edit;

  @override
  ConsumerState<LoanCreateScreen> createState() => _LoanCreateScreenState();
}

class _LoanCreateScreenState extends ConsumerState<LoanCreateScreen> {
  final _amount = TextEditingController();
  final _interestRate = TextEditingController();
  final _promotionPeriod = TextEditingController();
  final _floatingRate = TextEditingController();
  final _loanPeriod = TextEditingController();

  LoanBank? _bank;
  LoanPackage? _package;
  LoanCustomer? _customer;
  LoanTransaction? _transaction;
  LoanMortgage? _collateral;
  String _note = '';
  List<LoanPackage> _packages = const [];
  List<LoanTransaction> _transactions = const [];

  bool _readOnly = false;
  bool _busy = false;
  bool get _isEdit => widget.edit != null;

  @override
  void initState() {
    super.initState();
    _applyPrefill();
    _applyEdit();
  }

  @override
  void dispose() {
    _amount.dispose();
    _interestRate.dispose();
    _promotionPeriod.dispose();
    _floatingRate.dispose();
    _loanPeriod.dispose();
    super.dispose();
  }

  /// Months string → whole years string (v1 `_monthsToYears`).
  String _years(String? months) =>
      ((int.tryParse(months ?? '0') ?? 0) ~/ 12).toString();

  void _applyPackageFields(LoanPackage p) {
    _interestRate.text = p.interestRate ?? '';
    _promotionPeriod.text = _years(p.termMonths);
    _floatingRate.text = p.interestRateFloat ?? '';
    _loanPeriod.text = _years(p.gracePeriod);
  }

  void _applyPrefill() {
    final args = widget.prefill;
    if (args == null) return;
    if (args['loan_package'] is LoanPackage) {
      _package = args['loan_package'] as LoanPackage;
      _applyPackageFields(_package!);
    }
    if (args['bank'] is LoanBank) _bank = args['bank'] as LoanBank;
    final amt = args['loan_amount'];
    if (amt != null) _amount.text = amt.toString();
  }

  void _applyEdit() {
    final loan = widget.edit;
    if (loan == null) return;
    _package = loan.loanPackage;
    if (_package != null) _applyPackageFields(_package!);
    _loanPeriod.text = _years(loan.loanTerm);
    _customer = loan.customer;
    _transaction = loan.transaction;
    final b = loan.loanPackage?.bank;
    _bank = LoanBank(
      id: b?.id,
      bankNameVn: b?.name,
      abbreviations: b?.abbreviations,
      image: b?.image,
    );
    _amount.text = ThousandsInputFormatter()
        .formatEditUpdate(
            TextEditingValue.empty, TextEditingValue(text: loan.loanAmount ?? ''))
        .text;
    _collateral = loan.mortgage;
    _note = loan.note ?? '';
  }

  bool get _valid =>
      _bank?.id != null &&
      _package?.id != null &&
      digitsOf(_amount.text) > 0 &&
      _transaction?.id != null &&
      (_customer?.id ?? 0) != 0 &&
      _collateral?.id != null;

  Future<void> _pickBank() async {
    final banks = await ref.read(loanApiProvider).banks();
    if (!mounted) return;
    final picked = await showModalBottomSheet<LoanBank>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LoanBankSheet(banks: banks, selected: _bank),
    );
    if (picked == null || picked.id == _bank?.id) return;
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
      _applyPackageFields(picked);
    });
  }

  Future<void> _pickCustomer() async {
    final customers = await ref.read(loanCustomersProvider.future);
    if (!mounted) return;
    final picked = await showModalBottomSheet<LoanCustomer>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LoanCustomerSheet(customers: customers, selected: _customer),
    );
    if (picked == null) return;
    setState(() {
      _customer = picked;
      _transaction = null;
      _transactions = const [];
    });
    final txns = await ref.read(loanApiProvider).transactionsByCustomer(picked.id);
    if (mounted) setState(() => _transactions = txns);
  }

  Future<void> _pickTransaction() async {
    if (_customer == null) return;
    final picked = await showModalBottomSheet<LoanTransaction>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          LoanTransactionSheet(transactions: _transactions, selected: _transaction),
    );
    if (picked != null) setState(() => _transaction = picked);
  }

  Future<void> _pickCollateral() async {
    final mortgages = await ref.read(loanMortgagesProvider.future);
    if (!mounted) return;
    final result = await showModalBottomSheet<LoanCollateralResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LoanCollateralSheet(
        mortgages: mortgages,
        selected: _collateral,
        note: _note,
      ),
    );
    if (result != null) {
      setState(() {
        _collateral = result.mortgage;
        _note = result.note;
      });
    }
  }

  void _submit() {
    if (!_readOnly && !_isEdit) {
      setState(() => _readOnly = true);
      return;
    }
    _create();
  }

  Future<void> _create() async {
    setState(() => _busy = true);
    try {
      final res = await ref.read(loanApiProvider).save({
        'customer': _customer?.id,
        'transaction_id': _transaction?.id,
        'loan_mortgage': _collateral?.id,
        'loan_amount': digitsOf(_amount.text),
        'loan_term_year': int.tryParse(_loanPeriod.text) ?? 0,
        'loan_package': _package?.id ?? 0,
        'disbursement_date': '',
        'note': _note,
        'payment_method': 'equal_payment',
        if (widget.edit?.id != null) 'id': widget.edit!.id,
      });
      if (!mounted) return;
      if (res.id != 0) {
        ref.read(loanRefreshProvider.notifier).state++;
        if (widget.edit?.id != null) {
          ref.invalidate(loanDetailProvider(widget.edit!.id!));
        }
        AppToast.success(context,
            _isEdit ? 'Cập nhật hồ sơ thành công' : 'Tạo hồ sơ thành công');
        context.pop();
      } else {
        AppToast.error(context, res.message ?? 'Không thể lưu hồ sơ');
      }
    } catch (_) {
      if (mounted) AppToast.error(context, 'Không thể lưu hồ sơ');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String get _title => _isEdit
      ? 'Chỉnh sửa hồ sơ'
      : !_readOnly
          ? 'Tạo hồ sơ vay'
          : 'Xác nhận hồ sơ';

  String get _buttonLabel => _isEdit
      ? 'Cập nhật hồ sơ'
      : _readOnly
          ? 'Xác nhận và gửi hồ sơ'
          : 'Tạo hồ sơ vay';

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_readOnly,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _readOnly = false);
      },
      child: CustomScreen(
        title: _title,
        backgroundColor: AppColors.bg,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _formCard(),
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: AppButton(
                    label: _buttonLabel,
                    loading: _busy,
                    onPressed: _valid ? _submit : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _formCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Thông tin hồ sơ',
              style: AppTypography.title.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          LoanSelectField(
            title: 'Ngân hàng vay',
            required: true,
            value: _bank?.abbreviations ?? '',
            hint: 'Chọn ngân hàng',
            leadingImageUrl: _bank?.image,
            enabled: !_readOnly,
            onTap: _pickBank,
          ),
          const SizedBox(height: 16),
          LoanSelectField(
            title: 'Chọn gói vay',
            required: true,
            value: _package?.name ?? '',
            hint: 'Chọn gói vay phù hợp',
            enabled: !_readOnly && _bank != null,
            onTap: _pickPackage,
          ),
          const SizedBox(height: 16),
          LoanField(
            title: 'Số tiền vay',
            controller: _amount,
            hint: 'Nhập số tiền muốn vay',
            readOnly: _readOnly,
            keyboardType: TextInputType.number,
            inputFormatters: [ThousandsInputFormatter()],
            suffixText: 'VNĐ',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: LoanField(
                  title: 'Lãi suất ưu đãi',
                  controller: _interestRate,
                  hint: '0',
                  readOnly: true,
                  suffixText: '% / năm',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: LoanField(
                  title: 'Thời hạn ưu đãi',
                  controller: _promotionPeriod,
                  hint: '0',
                  readOnly: true,
                  suffixText: 'năm',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: LoanField(
                  title: 'Lãi suất thả nổi',
                  required: true,
                  controller: _floatingRate,
                  hint: '0',
                  readOnly: true,
                  suffixText: '% / năm',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: LoanField(
                  title: 'Thời hạn vay',
                  required: true,
                  controller: _loanPeriod,
                  hint: '0',
                  readOnly: _readOnly,
                  keyboardType: TextInputType.number,
                  suffixText: 'năm',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LoanSelectField(
            title: 'Khách hàng',
            value: _customer?.name ?? '',
            hint: 'Chọn khách hàng',
            enabled: !_readOnly,
            onTap: _pickCustomer,
          ),
          const SizedBox(height: 16),
          LoanSelectField(
            title: 'Giao dịch cần vay',
            value: _transaction?.transactionTitle ?? '',
            hint: 'Chọn giao dịch',
            enabled: !_readOnly && _customer != null,
            onTap: _pickTransaction,
          ),
          const SizedBox(height: 16),
          LoanSelectField(
            title: 'Tài sản thế chấp',
            value: _collateral?.name ?? _collateral?.title ?? '',
            hint: 'Chọn tài sản thế chấp',
            enabled: !_readOnly,
            onTap: _pickCollateral,
          ),
        ],
      ),
    );
  }
}
