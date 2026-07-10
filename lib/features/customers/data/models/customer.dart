import '../../../../core/utils/json_parse.dart';

/// A customer/lead from `get_list_customer.json`. Field set mirrors v1
/// `CustomerModel`.
class Customer {
  const Customer({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.address,
    this.sex,
    this.birthday,
    this.createdOn,
  });

  final int id;
  final String name;
  final String phone;
  final String? email;
  final String? address;
  final String? sex;
  final String? birthday;
  final String? createdOn;

  factory Customer.fromJson(Map data) => Customer(
        id: asInt(data['id'] ?? data['customer_id']),
        name: (data['name'] ?? data['full_name'] ?? '').toString(),
        phone: (data['phone'] ?? '').toString(),
        email: data['email']?.toString(),
        address: data['address']?.toString(),
        sex: data['sex']?.toString(),
        birthday: data['birthday']?.toString(),
        createdOn: data['created_on']?.toString(),
      );
}
