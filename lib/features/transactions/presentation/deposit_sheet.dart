import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_toast.dart';
import '../data/transactions_api.dart';

/// Opens the deposit (đặt cọc) creation sheet for a given table row.
Future<void> showDepositSheet(
  BuildContext context, {
  required String tableName,
  required int tableId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _DepositSheet(tableName: tableName, tableId: tableId),
  );
}

class _DepositSheet extends ConsumerStatefulWidget {
  const _DepositSheet({required this.tableName, required this.tableId});
  final String tableName;
  final int tableId;

  @override
  ConsumerState<_DepositSheet> createState() => _DepositSheetState();
}

class _DepositSheetState extends ConsumerState<_DepositSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _customer = TextEditingController();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _amount.dispose();
    _customer.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(transactionsApiProvider).createDeposit(
            tableName: widget.tableName,
            tableId: widget.tableId,
            amount: double.parse(_amount.text.trim()),
          );
      if (!mounted) return;
      AppToast.success(context, 'Tạo đặt cọc thành công');
      Navigator.pop(context);
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } catch (_) {
      setState(() => _error = 'Không tạo được đặt cọc');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottom),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tạo đặt cọc', style: AppTypography.heading),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Số tiền cọc (VNĐ) *',
              controller: _amount,
              keyboardType: TextInputType.number,
              validator: (v) {
                final n = double.tryParse(v?.trim() ?? '');
                if (n == null || n <= 0) return 'Nhập số tiền hợp lệ';
                return null;
              },
            ),
            const SizedBox(height: 12),
            AppTextField(label: 'Khách hàng (tuỳ chọn)', controller: _customer),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 20),
            AppButton(label: 'Xác nhận đặt cọc', loading: _saving, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
