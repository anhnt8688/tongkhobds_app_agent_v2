import '../../../../core/utils/json_parse.dart';

/// Bank embedded inside a loan package (v1 BankModel — note `name`/`code`,
/// distinct from the picker's [LoanBank] shape which uses `bank_name_vn`).
class LoanPackageBank {
  const LoanPackageBank({
    this.id,
    this.name,
    this.abbreviations,
    this.code,
    this.image,
  });

  final int? id;
  final String? name;
  final String? abbreviations;
  final String? code;
  final String? image;

  factory LoanPackageBank.fromJson(Map d) => LoanPackageBank(
        id: asIntOrNull(d['id']),
        name: d['name']?.toString(),
        abbreviations: d['abbreviations']?.toString(),
        code: d['code']?.toString(),
        image: d['image']?.toString(),
      );
}

/// Loan package (v1 LoanPackageModel). Rates/periods arrive as strings; periods
/// are in months (converted to years for display).
class LoanPackage {
  const LoanPackage({
    this.id,
    this.bank,
    this.interestRate,
    this.termMonths,
    this.maxTermMonths,
    this.gracePeriod,
    this.name,
    this.interestRateFloat,
  });

  final int? id;
  final LoanPackageBank? bank;
  final String? interestRate;
  final String? termMonths;
  final String? maxTermMonths;
  final String? gracePeriod;
  final String? name;
  final String? interestRateFloat;

  factory LoanPackage.fromJson(Map d) => LoanPackage(
        id: asIntOrNull(d['id']),
        bank: d['bank'] is Map ? LoanPackageBank.fromJson(d['bank'] as Map) : null,
        interestRate: d['interest_rate']?.toString(),
        termMonths: d['term_months']?.toString(),
        maxTermMonths: d['max_term_months']?.toString(),
        gracePeriod: d['grace_period']?.toString(),
        name: d['name']?.toString(),
        interestRateFloat: d['interest_rate_float']?.toString(),
      );
}
