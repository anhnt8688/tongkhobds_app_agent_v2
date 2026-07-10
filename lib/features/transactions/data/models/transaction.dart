import '../../../../core/utils/json_parse.dart';

/// A transaction record from `real_estate_transaction.json`.
///
/// The list endpoint is loosely typed and may nest data under `real_estate`,
/// `status_info` and `rate_seller` (v1 `TransactionModel`); all such fields are
/// parsed defensively and left null when absent.
class TransactionItem {
  const TransactionItem({
    required this.id,
    required this.title,
    this.code,
    this.customerName,
    this.amount,
    this.status,
    this.createdAt,
    this.transactionType,
    this.statusColor,
    this.commissionRate,
  });

  final int id;
  final String title;
  final String? code;
  final String? customerName;
  final double? amount;
  final String? status;
  final String? createdAt;

  /// "Bán" / "Cho thuê" — v1 `real_estate.transaction_type`, shown as a pill.
  final String? transactionType;

  /// Status hex colour — v1 `status_info.color_code`, tints the status chip.
  final String? statusColor;

  /// Seller commission percent — v1 `rate_seller.rate`.
  final double? commissionRate;

  factory TransactionItem.fromJson(Map d) {
    final realEstate = d['real_estate'] is Map ? d['real_estate'] as Map : null;
    final statusInfo = d['status_info'] is Map ? d['status_info'] as Map : null;
    final rateSeller = d['rate_seller'] is Map ? d['rate_seller'] as Map : null;
    return TransactionItem(
      id: asInt(d['id'] ?? d['transaction_id']),
      title: (d['transaction_title'] ??
              d['title'] ??
              d['real_estate_title'] ??
              d['property_title'] ??
              d['name'] ??
              'Giao dịch')
          .toString(),
      code: (d['code'] ?? d['transaction_code'])?.toString(),
      customerName:
          (d['customer_name'] ?? d['customer'] ?? d['buyer_name'])?.toString(),
      amount: asDoubleOrNull(d['amount'] ?? d['price'] ?? d['value']),
      status: (statusInfo?['status_name'] ?? d['status_name'] ?? d['status'])
          ?.toString(),
      createdAt:
          (d['created_on'] ?? d['created_at'] ?? d['date'])?.toString(),
      transactionType:
          (realEstate?['transaction_type'] ?? d['transaction_type'])
              ?.toString(),
      statusColor:
          (statusInfo?['color_code'] ?? d['color_code'])?.toString(),
      commissionRate: asDoubleOrNull(rateSeller?['rate'] ?? d['rate']),
    );
  }
}
