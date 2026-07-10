import '../../../../core/utils/json_parse.dart';

/// Bank from `/api_agent/get_bank.json` (v1 ListBankModel). Used by pickers/hub.
class LoanBank {
  const LoanBank({
    this.id,
    this.abbreviations,
    this.bankNameVn,
    this.bankCodeVn,
    this.image,
  });

  final int? id;
  final String? abbreviations;
  final String? bankNameVn;
  final String? bankCodeVn;
  final String? image;

  factory LoanBank.fromJson(Map data) => LoanBank(
        id: asIntOrNull(data['id']),
        abbreviations: data['abbreviations']?.toString(),
        bankNameVn: data['bank_name_vn']?.toString(),
        bankCodeVn: data['bank_code_vn']?.toString(),
        image: data['image']?.toString(),
      );
}
