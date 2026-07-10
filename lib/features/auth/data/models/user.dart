import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/utils/json_parse.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// Authenticated agent profile. Tolerant of int/string variations from the
/// Web2py backend via custom converters.
@freezed
abstract class User with _$User {
  const factory User({
    @JsonKey(readValue: _id) @Default(0) int id,
    @JsonKey(name: 'salesman_id', readValue: _salesmanId) int? salesmanId,
    @JsonKey(name: 'full_name', readValue: _fullName) @Default('') String fullName,
    @JsonKey(readValue: _phone) @Default('') String phone,
    @JsonKey(readValue: _email) @Default('') String email,
    @JsonKey(readValue: _image) String? image,
    // city_id / district_id kept as String to match v1 (backend sends them
    // int/string interchangeably; v1 stored the raw string).
    @JsonKey(name: 'city_id', readValue: _cityId) String? cityId,
    @JsonKey(name: 'district_id', readValue: _districtId) String? districtId,
    @JsonKey(readValue: _address) String? address,
    @JsonKey(readValue: _birthday) String? birthday,
    @JsonKey(readValue: _sex) String? sex,
    @JsonKey(name: 'id_card', readValue: _idCard) String? idCard,
    @JsonKey(name: 'id_day', readValue: _idDay) String? idDay,
    @JsonKey(name: 'citizen_id_front', readValue: _citizenFront)
    String? citizenIdFront,
    @JsonKey(name: 'citizen_id_back', readValue: _citizenBack)
    String? citizenIdBack,
    @JsonKey(name: 'name_code', readValue: _code) String? code,
    @JsonKey(name: 'position_name_code', readValue: _position) String? position,
    @JsonKey(name: 'yoe', readValue: _yoe) int? yoe,
    // Drives the biometric-staff prompt (v1 `checking_staff`).
    @JsonKey(name: 'checking_staff', readValue: _checkingStaff)
    @Default(false)
    bool checkingStaff,
    // Forces a profile-update flow when the backend flags stale data.
    @JsonKey(name: 'require_update', readValue: _requireUpdate)
    @Default(false)
    bool requireUpdate,
    @JsonKey(readValue: _step) @Default(1) int step,
    // CTV contract state (drives the join/pending banners + notepad shortcut).
    @JsonKey(name: 'contract_pdf', readValue: _contractPdf) String? contractPdf,
    @JsonKey(name: 'contract_verify', readValue: _contractVerify)
    @Default(false)
    bool contractVerify,
    @JsonKey(name: 'tax_code', readValue: _taxCode) String? taxCode,
  }) = _User;

  const User._();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// KYC verified when step reaches 3.
  bool get isVerified => step >= 3;
}

// readValue helpers tolerate alternate key names / types from the backend.
Object? _id(Map m, String _) => asInt(m['id'] ?? m['user_id']);
Object? _salesmanId(Map m, String _) => asIntOrNull(m['salesman_id']);
Object? _fullName(Map m, String _) => m['full_name'] ?? m['name'] ?? '';
Object? _phone(Map m, String _) => m['phone']?.toString() ?? '';
Object? _email(Map m, String _) => m['email']?.toString() ?? '';
Object? _image(Map m, String _) =>
    AppConfig.imageUrl((m['image'] ?? m['avatar'])?.toString());
Object? _cityId(Map m, String _) => m['city_id']?.toString();
Object? _districtId(Map m, String _) => m['district_id']?.toString();
Object? _address(Map m, String _) => m['address']?.toString();
Object? _birthday(Map m, String _) => m['birthday']?.toString();
Object? _sex(Map m, String _) => m['sex']?.toString();
Object? _idCard(Map m, String _) => m['id_card']?.toString();
Object? _idDay(Map m, String _) => m['id_day']?.toString();
Object? _citizenFront(Map m, String _) =>
    AppConfig.imageUrl(m['citizen_id_front']?.toString());
Object? _citizenBack(Map m, String _) =>
    AppConfig.imageUrl(m['citizen_id_back']?.toString());
Object? _code(Map m, String _) =>
    (m['name_code'] ?? m['agent_code'] ?? m['code'])?.toString();
Object? _position(Map m, String _) =>
    (m['position_name_code'] ?? m['position_name'] ?? m['position'])?.toString();
Object? _yoe(Map m, String _) => asIntOrNull(m['yoe']);
Object? _checkingStaff(Map m, String _) => m['checking_staff'] == true;
Object? _requireUpdate(Map m, String _) => m['require_update'] == true;
Object? _step(Map m, String _) => asInt(m['step'], fallback: 1);
Object? _contractPdf(Map m, String _) => m['contract_pdf']?.toString();
Object? _contractVerify(Map m, String _) => m['contract_verify'] == true;
Object? _taxCode(Map m, String _) => m['tax_code']?.toString();
