import '../../../../core/utils/json_parse.dart';

/// One amortization row (v1 CalculatorLoanScheduleItem).
class LoanScheduleItem {
  const LoanScheduleItem({
    required this.month,
    required this.paymentDate,
    required this.remainingPrincipal,
    required this.principal,
    required this.interest,
    required this.total,
  });

  final int month;
  final String paymentDate;
  final double remainingPrincipal;
  final double principal;
  final double interest;
  final double total;

  factory LoanScheduleItem.fromJson(Map d) => LoanScheduleItem(
        month: asInt(d['month']),
        paymentDate: d['payment_date']?.toString() ?? '',
        remainingPrincipal: asDouble(d['remaining_principal']),
        principal: asDouble(d['principal']),
        interest: asDouble(d['interest']),
        total: asDouble(d['total']),
      );
}

/// Loan repayment calculation result (v1 CalculatorLoanModel).
class LoanCalculation {
  const LoanCalculation({
    required this.loanAmount,
    required this.months,
    required this.annualInterestRate,
    required this.monthlyInterestRate,
    required this.paymentMethod,
    required this.totalInterest,
    required this.totalPayment,
    required this.averageMonthlyPayment,
    required this.minMonthlyPayment,
    required this.maxMonthlyPayment,
    required this.schedule,
  });

  final double loanAmount;
  final int months;
  final double annualInterestRate;
  final double monthlyInterestRate;
  final String paymentMethod;
  final double totalInterest;
  final double totalPayment;
  final double averageMonthlyPayment;
  final double minMonthlyPayment;
  final double maxMonthlyPayment;
  final List<LoanScheduleItem> schedule;

  factory LoanCalculation.fromJson(Map d) => LoanCalculation(
        loanAmount: asDouble(d['loan_amount']),
        months: asInt(d['months']),
        annualInterestRate: asDouble(d['annual_interest_rate']),
        monthlyInterestRate: asDouble(d['monthly_interest_rate']),
        paymentMethod: d['payment_method']?.toString() ?? '',
        totalInterest: asDouble(d['total_interest']),
        totalPayment: asDouble(d['total_payment']),
        averageMonthlyPayment: asDouble(d['average_monthly_payment']),
        minMonthlyPayment: asDouble(d['min_monthly_payment']),
        maxMonthlyPayment: asDouble(d['max_monthly_payment']),
        schedule: d['schedule'] is List
            ? (d['schedule'] as List)
                .whereType<Map>()
                .map(LoanScheduleItem.fromJson)
                .toList()
            : const [],
      );
}
