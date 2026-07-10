import '../../../../core/utils/json_parse.dart';

/// Minimal real-estate product shown on a loan transaction (v1 real_estate_info).
class LoanProduct {
  const LoanProduct({this.id, this.title, this.mainImage});

  final int? id;
  final String? title;
  final String? mainImage;

  factory LoanProduct.fromJson(Map d) => LoanProduct(
        id: asIntOrNull(d['id']),
        title: d['title']?.toString(),
        mainImage: d['main_image']?.toString(),
      );
}

/// Transaction a loan is tied to (v1 TransactionModel, loan-relevant subset).
class LoanTransaction {
  const LoanTransaction({
    this.id,
    this.transactionTitle,
    this.transactionCode,
    this.groupId,
    this.currentStatus,
    this.product,
  });

  final int? id;
  final String? transactionTitle;
  final String? transactionCode;
  final String? groupId;
  final int? currentStatus;
  final LoanProduct? product;

  factory LoanTransaction.fromJson(Map d) => LoanTransaction(
        id: asIntOrNull(d['id']),
        transactionTitle: d['transaction_title']?.toString(),
        transactionCode: d['transaction_code']?.toString(),
        groupId: d['group_id']?.toString(),
        currentStatus: asIntOrNull(d['current_status']),
        product: d['real_estate_info'] is Map
            ? LoanProduct.fromJson(d['real_estate_info'] as Map)
            : null,
      );
}
