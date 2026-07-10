import '../../../../core/utils/json_parse.dart';

/// Customer for loan pickers (v1 CustomerModel). Kept loan-local because the
/// loan flow needs address/sex/birthday beyond the lean shared Customer model.
class LoanCustomer {
  const LoanCustomer({
    this.id = 0,
    this.name,
    this.phone,
    this.email,
    this.address,
    this.sex,
    this.birthday,
  });

  final int id;
  final String? name;
  final String? phone;
  final String? email;
  final String? address;
  final String? sex;
  final String? birthday;

  factory LoanCustomer.fromJson(Map d) => LoanCustomer(
        id: asInt(d['id']),
        name: d['name']?.toString(),
        phone: d['phone']?.toString(),
        email: d['email']?.toString(),
        address: d['address']?.toString(),
        sex: d['sex']?.toString(),
        birthday: d['birthday']?.toString(),
      );
}
