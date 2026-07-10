// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: (_id(json, 'id') as num?)?.toInt() ?? 0,
  salesmanId: (_salesmanId(json, 'salesman_id') as num?)?.toInt(),
  fullName: _fullName(json, 'full_name') as String? ?? '',
  phone: _phone(json, 'phone') as String? ?? '',
  email: _email(json, 'email') as String? ?? '',
  image: _image(json, 'image') as String?,
  cityId: _cityId(json, 'city_id') as String?,
  districtId: _districtId(json, 'district_id') as String?,
  address: _address(json, 'address') as String?,
  birthday: _birthday(json, 'birthday') as String?,
  sex: _sex(json, 'sex') as String?,
  idCard: _idCard(json, 'id_card') as String?,
  idDay: _idDay(json, 'id_day') as String?,
  citizenIdFront: _citizenFront(json, 'citizen_id_front') as String?,
  citizenIdBack: _citizenBack(json, 'citizen_id_back') as String?,
  code: _code(json, 'name_code') as String?,
  position: _position(json, 'position_name_code') as String?,
  yoe: (_yoe(json, 'yoe') as num?)?.toInt(),
  checkingStaff: _checkingStaff(json, 'checking_staff') as bool? ?? false,
  requireUpdate: _requireUpdate(json, 'require_update') as bool? ?? false,
  step: (_step(json, 'step') as num?)?.toInt() ?? 1,
  contractPdf: _contractPdf(json, 'contract_pdf') as String?,
  contractVerify: _contractVerify(json, 'contract_verify') as bool? ?? false,
  taxCode: _taxCode(json, 'tax_code') as String?,
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'salesman_id': instance.salesmanId,
  'full_name': instance.fullName,
  'phone': instance.phone,
  'email': instance.email,
  'image': instance.image,
  'city_id': instance.cityId,
  'district_id': instance.districtId,
  'address': instance.address,
  'birthday': instance.birthday,
  'sex': instance.sex,
  'id_card': instance.idCard,
  'id_day': instance.idDay,
  'citizen_id_front': instance.citizenIdFront,
  'citizen_id_back': instance.citizenIdBack,
  'name_code': instance.code,
  'position_name_code': instance.position,
  'yoe': instance.yoe,
  'checking_staff': instance.checkingStaff,
  'require_update': instance.requireUpdate,
  'step': instance.step,
  'contract_pdf': instance.contractPdf,
  'contract_verify': instance.contractVerify,
  'tax_code': instance.taxCode,
};
