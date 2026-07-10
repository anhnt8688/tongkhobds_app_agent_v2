import '../../../core/widgets/status_pill.dart';

/// Loan profile status (v1 TabBarEnum). Backend value is a numeric string 0–3.
enum LoanStatus { waiting, processing, success, failed }

extension LoanStatusX on LoanStatus {
  String get value => switch (this) {
        LoanStatus.waiting => '0',
        LoanStatus.processing => '1',
        LoanStatus.success => '2',
        LoanStatus.failed => '3',
      };

  String get title => switch (this) {
        LoanStatus.waiting => 'Chờ xử lý',
        LoanStatus.processing => 'Đang xử lý',
        LoanStatus.success => 'Đã hoàn tất',
        LoanStatus.failed => 'Thất bại',
      };

  // amber≈v1 primary orange, blue/green/red match v1 exactly.
  StatusTone get tone => switch (this) {
        LoanStatus.waiting => StatusTone.amber,
        LoanStatus.processing => StatusTone.blue,
        LoanStatus.success => StatusTone.green,
        LoanStatus.failed => StatusTone.red,
      };
}

LoanStatus loanStatusFromValue(String? v) => switch (v) {
      '1' => LoanStatus.processing,
      '2' => LoanStatus.success,
      '3' => LoanStatus.failed,
      _ => LoanStatus.waiting,
    };
