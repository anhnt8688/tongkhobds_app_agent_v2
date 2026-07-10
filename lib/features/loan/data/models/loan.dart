import '../../../../core/utils/json_parse.dart';
import 'loan_customer.dart';
import 'loan_mortgage.dart';
import 'loan_package.dart';
import 'loan_transaction.dart';

/// One entry in a loan's processing timeline (v1 TrackingModel).
class LoanTracking {
  const LoanTracking({this.id, this.title, this.note, this.createdOn});

  final int? id;
  final String? title;
  final String? note;
  final String? createdOn;

  factory LoanTracking.fromJson(Map d) => LoanTracking(
        id: asIntOrNull(d['id']),
        title: d['title']?.toString(),
        note: d['note']?.toString(),
        createdOn: d['created_on']?.toString() ?? '',
      );
}

/// A loan profile (v1 LoanModel). `loanAmount`/`loanTerm` are strings; term is
/// in months. Bank is reached via `loanPackage.bank`.
class Loan {
  const Loan({
    this.id,
    this.customer,
    this.loanPackage,
    this.loanAmount = '0',
    this.paymentMethod = '',
    this.loanTerm = '0',
    this.disbursementDate = '',
    this.transactionId = 0,
    this.mortgage,
    this.tracking = const [],
    this.note = '',
    this.status = '0',
    this.createdOn = '',
    this.updatedOn = '',
    this.transaction,
  });

  final int? id;
  final LoanCustomer? customer;
  final LoanPackage? loanPackage;
  final String? loanAmount;
  final String? paymentMethod;
  final String? loanTerm;
  final String? disbursementDate;
  final int? transactionId;
  final LoanMortgage? mortgage;
  final List<LoanTracking> tracking;
  final String? note;
  final String? status;
  final String? createdOn;
  final String? updatedOn;
  final LoanTransaction? transaction;

  factory Loan.fromJson(Map d) => Loan(
        id: asIntOrNull(d['id']),
        customer:
            d['customer'] is Map ? LoanCustomer.fromJson(d['customer'] as Map) : null,
        loanPackage: d['loan_package'] is Map
            ? LoanPackage.fromJson(d['loan_package'] as Map)
            : null,
        loanAmount: d['loan_amount']?.toString() ?? '0',
        paymentMethod: d['payment_method']?.toString() ?? '',
        loanTerm: d['loan_term']?.toString() ?? '0',
        disbursementDate: d['disbursement_date']?.toString() ?? '',
        transactionId: asIntOrNull(d['transaction_id']),
        mortgage: LoanMortgage.parse(d['mortgage']),
        tracking: d['tracking'] is List
            ? (d['tracking'] as List)
                .whereType<Map>()
                .map(LoanTracking.fromJson)
                .toList()
            : const [],
        note: d['note']?.toString() ?? '',
        status: d['status']?.toString() ?? '0',
        createdOn: d['created_on']?.toString() ?? '',
        updatedOn: d['updated_on']?.toString() ?? '',
        transaction: d['transaction'] is Map
            ? LoanTransaction.fromJson(d['transaction'] as Map)
            : null,
      );
}
