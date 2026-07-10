import '../../../../core/utils/json_parse.dart';

/// Collateral option (v1 MortgageModel). The backend sends it either as a full
/// object or a bare id, so use [parse] where a loan embeds it.
class LoanMortgage {
  const LoanMortgage({this.id, this.xtype, this.name, this.title, this.note});

  final int? id;
  final String? xtype;
  final String? name;
  final String? title;
  final String? note;

  factory LoanMortgage.fromJson(Map d) => LoanMortgage(
        id: asIntOrNull(d['id']),
        xtype: d['xtype']?.toString() ?? '0',
        name: d['name']?.toString(),
        title: d['title']?.toString(),
        note: d['note']?.toString(),
      );

  /// Tolerates Map (full object) or int (id only); null otherwise.
  static LoanMortgage? parse(Object? v) {
    if (v is Map) return LoanMortgage.fromJson(v);
    if (v is int) return LoanMortgage(id: v);
    return null;
  }
}
