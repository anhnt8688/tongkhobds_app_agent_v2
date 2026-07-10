// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$User {

@JsonKey(readValue: _id) int get id;@JsonKey(name: 'salesman_id', readValue: _salesmanId) int? get salesmanId;@JsonKey(name: 'full_name', readValue: _fullName) String get fullName;@JsonKey(readValue: _phone) String get phone;@JsonKey(readValue: _email) String get email;@JsonKey(readValue: _image) String? get image;// city_id / district_id kept as String to match v1 (backend sends them
// int/string interchangeably; v1 stored the raw string).
@JsonKey(name: 'city_id', readValue: _cityId) String? get cityId;@JsonKey(name: 'district_id', readValue: _districtId) String? get districtId;@JsonKey(readValue: _address) String? get address;@JsonKey(readValue: _birthday) String? get birthday;@JsonKey(readValue: _sex) String? get sex;@JsonKey(name: 'id_card', readValue: _idCard) String? get idCard;@JsonKey(name: 'id_day', readValue: _idDay) String? get idDay;@JsonKey(name: 'citizen_id_front', readValue: _citizenFront) String? get citizenIdFront;@JsonKey(name: 'citizen_id_back', readValue: _citizenBack) String? get citizenIdBack;@JsonKey(name: 'name_code', readValue: _code) String? get code;@JsonKey(name: 'position_name_code', readValue: _position) String? get position;@JsonKey(name: 'yoe', readValue: _yoe) int? get yoe;// Drives the biometric-staff prompt (v1 `checking_staff`).
@JsonKey(name: 'checking_staff', readValue: _checkingStaff) bool get checkingStaff;// Forces a profile-update flow when the backend flags stale data.
@JsonKey(name: 'require_update', readValue: _requireUpdate) bool get requireUpdate;@JsonKey(readValue: _step) int get step;// CTV contract state (drives the join/pending banners + notepad shortcut).
@JsonKey(name: 'contract_pdf', readValue: _contractPdf) String? get contractPdf;@JsonKey(name: 'contract_verify', readValue: _contractVerify) bool get contractVerify;@JsonKey(name: 'tax_code', readValue: _taxCode) String? get taxCode;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, id) || other.id == id)&&(identical(other.salesmanId, salesmanId) || other.salesmanId == salesmanId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.image, image) || other.image == image)&&(identical(other.cityId, cityId) || other.cityId == cityId)&&(identical(other.districtId, districtId) || other.districtId == districtId)&&(identical(other.address, address) || other.address == address)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.idCard, idCard) || other.idCard == idCard)&&(identical(other.idDay, idDay) || other.idDay == idDay)&&(identical(other.citizenIdFront, citizenIdFront) || other.citizenIdFront == citizenIdFront)&&(identical(other.citizenIdBack, citizenIdBack) || other.citizenIdBack == citizenIdBack)&&(identical(other.code, code) || other.code == code)&&(identical(other.position, position) || other.position == position)&&(identical(other.yoe, yoe) || other.yoe == yoe)&&(identical(other.checkingStaff, checkingStaff) || other.checkingStaff == checkingStaff)&&(identical(other.requireUpdate, requireUpdate) || other.requireUpdate == requireUpdate)&&(identical(other.step, step) || other.step == step)&&(identical(other.contractPdf, contractPdf) || other.contractPdf == contractPdf)&&(identical(other.contractVerify, contractVerify) || other.contractVerify == contractVerify)&&(identical(other.taxCode, taxCode) || other.taxCode == taxCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,salesmanId,fullName,phone,email,image,cityId,districtId,address,birthday,sex,idCard,idDay,citizenIdFront,citizenIdBack,code,position,yoe,checkingStaff,requireUpdate,step,contractPdf,contractVerify,taxCode]);

@override
String toString() {
  return 'User(id: $id, salesmanId: $salesmanId, fullName: $fullName, phone: $phone, email: $email, image: $image, cityId: $cityId, districtId: $districtId, address: $address, birthday: $birthday, sex: $sex, idCard: $idCard, idDay: $idDay, citizenIdFront: $citizenIdFront, citizenIdBack: $citizenIdBack, code: $code, position: $position, yoe: $yoe, checkingStaff: $checkingStaff, requireUpdate: $requireUpdate, step: $step, contractPdf: $contractPdf, contractVerify: $contractVerify, taxCode: $taxCode)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
@JsonKey(readValue: _id) int id,@JsonKey(name: 'salesman_id', readValue: _salesmanId) int? salesmanId,@JsonKey(name: 'full_name', readValue: _fullName) String fullName,@JsonKey(readValue: _phone) String phone,@JsonKey(readValue: _email) String email,@JsonKey(readValue: _image) String? image,@JsonKey(name: 'city_id', readValue: _cityId) String? cityId,@JsonKey(name: 'district_id', readValue: _districtId) String? districtId,@JsonKey(readValue: _address) String? address,@JsonKey(readValue: _birthday) String? birthday,@JsonKey(readValue: _sex) String? sex,@JsonKey(name: 'id_card', readValue: _idCard) String? idCard,@JsonKey(name: 'id_day', readValue: _idDay) String? idDay,@JsonKey(name: 'citizen_id_front', readValue: _citizenFront) String? citizenIdFront,@JsonKey(name: 'citizen_id_back', readValue: _citizenBack) String? citizenIdBack,@JsonKey(name: 'name_code', readValue: _code) String? code,@JsonKey(name: 'position_name_code', readValue: _position) String? position,@JsonKey(name: 'yoe', readValue: _yoe) int? yoe,@JsonKey(name: 'checking_staff', readValue: _checkingStaff) bool checkingStaff,@JsonKey(name: 'require_update', readValue: _requireUpdate) bool requireUpdate,@JsonKey(readValue: _step) int step,@JsonKey(name: 'contract_pdf', readValue: _contractPdf) String? contractPdf,@JsonKey(name: 'contract_verify', readValue: _contractVerify) bool contractVerify,@JsonKey(name: 'tax_code', readValue: _taxCode) String? taxCode
});




}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? salesmanId = freezed,Object? fullName = null,Object? phone = null,Object? email = null,Object? image = freezed,Object? cityId = freezed,Object? districtId = freezed,Object? address = freezed,Object? birthday = freezed,Object? sex = freezed,Object? idCard = freezed,Object? idDay = freezed,Object? citizenIdFront = freezed,Object? citizenIdBack = freezed,Object? code = freezed,Object? position = freezed,Object? yoe = freezed,Object? checkingStaff = null,Object? requireUpdate = null,Object? step = null,Object? contractPdf = freezed,Object? contractVerify = null,Object? taxCode = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,salesmanId: freezed == salesmanId ? _self.salesmanId : salesmanId // ignore: cast_nullable_to_non_nullable
as int?,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,cityId: freezed == cityId ? _self.cityId : cityId // ignore: cast_nullable_to_non_nullable
as String?,districtId: freezed == districtId ? _self.districtId : districtId // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as String?,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as String?,idCard: freezed == idCard ? _self.idCard : idCard // ignore: cast_nullable_to_non_nullable
as String?,idDay: freezed == idDay ? _self.idDay : idDay // ignore: cast_nullable_to_non_nullable
as String?,citizenIdFront: freezed == citizenIdFront ? _self.citizenIdFront : citizenIdFront // ignore: cast_nullable_to_non_nullable
as String?,citizenIdBack: freezed == citizenIdBack ? _self.citizenIdBack : citizenIdBack // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String?,yoe: freezed == yoe ? _self.yoe : yoe // ignore: cast_nullable_to_non_nullable
as int?,checkingStaff: null == checkingStaff ? _self.checkingStaff : checkingStaff // ignore: cast_nullable_to_non_nullable
as bool,requireUpdate: null == requireUpdate ? _self.requireUpdate : requireUpdate // ignore: cast_nullable_to_non_nullable
as bool,step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as int,contractPdf: freezed == contractPdf ? _self.contractPdf : contractPdf // ignore: cast_nullable_to_non_nullable
as String?,contractVerify: null == contractVerify ? _self.contractVerify : contractVerify // ignore: cast_nullable_to_non_nullable
as bool,taxCode: freezed == taxCode ? _self.taxCode : taxCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(readValue: _id)  int id, @JsonKey(name: 'salesman_id', readValue: _salesmanId)  int? salesmanId, @JsonKey(name: 'full_name', readValue: _fullName)  String fullName, @JsonKey(readValue: _phone)  String phone, @JsonKey(readValue: _email)  String email, @JsonKey(readValue: _image)  String? image, @JsonKey(name: 'city_id', readValue: _cityId)  String? cityId, @JsonKey(name: 'district_id', readValue: _districtId)  String? districtId, @JsonKey(readValue: _address)  String? address, @JsonKey(readValue: _birthday)  String? birthday, @JsonKey(readValue: _sex)  String? sex, @JsonKey(name: 'id_card', readValue: _idCard)  String? idCard, @JsonKey(name: 'id_day', readValue: _idDay)  String? idDay, @JsonKey(name: 'citizen_id_front', readValue: _citizenFront)  String? citizenIdFront, @JsonKey(name: 'citizen_id_back', readValue: _citizenBack)  String? citizenIdBack, @JsonKey(name: 'name_code', readValue: _code)  String? code, @JsonKey(name: 'position_name_code', readValue: _position)  String? position, @JsonKey(name: 'yoe', readValue: _yoe)  int? yoe, @JsonKey(name: 'checking_staff', readValue: _checkingStaff)  bool checkingStaff, @JsonKey(name: 'require_update', readValue: _requireUpdate)  bool requireUpdate, @JsonKey(readValue: _step)  int step, @JsonKey(name: 'contract_pdf', readValue: _contractPdf)  String? contractPdf, @JsonKey(name: 'contract_verify', readValue: _contractVerify)  bool contractVerify, @JsonKey(name: 'tax_code', readValue: _taxCode)  String? taxCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.salesmanId,_that.fullName,_that.phone,_that.email,_that.image,_that.cityId,_that.districtId,_that.address,_that.birthday,_that.sex,_that.idCard,_that.idDay,_that.citizenIdFront,_that.citizenIdBack,_that.code,_that.position,_that.yoe,_that.checkingStaff,_that.requireUpdate,_that.step,_that.contractPdf,_that.contractVerify,_that.taxCode);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(readValue: _id)  int id, @JsonKey(name: 'salesman_id', readValue: _salesmanId)  int? salesmanId, @JsonKey(name: 'full_name', readValue: _fullName)  String fullName, @JsonKey(readValue: _phone)  String phone, @JsonKey(readValue: _email)  String email, @JsonKey(readValue: _image)  String? image, @JsonKey(name: 'city_id', readValue: _cityId)  String? cityId, @JsonKey(name: 'district_id', readValue: _districtId)  String? districtId, @JsonKey(readValue: _address)  String? address, @JsonKey(readValue: _birthday)  String? birthday, @JsonKey(readValue: _sex)  String? sex, @JsonKey(name: 'id_card', readValue: _idCard)  String? idCard, @JsonKey(name: 'id_day', readValue: _idDay)  String? idDay, @JsonKey(name: 'citizen_id_front', readValue: _citizenFront)  String? citizenIdFront, @JsonKey(name: 'citizen_id_back', readValue: _citizenBack)  String? citizenIdBack, @JsonKey(name: 'name_code', readValue: _code)  String? code, @JsonKey(name: 'position_name_code', readValue: _position)  String? position, @JsonKey(name: 'yoe', readValue: _yoe)  int? yoe, @JsonKey(name: 'checking_staff', readValue: _checkingStaff)  bool checkingStaff, @JsonKey(name: 'require_update', readValue: _requireUpdate)  bool requireUpdate, @JsonKey(readValue: _step)  int step, @JsonKey(name: 'contract_pdf', readValue: _contractPdf)  String? contractPdf, @JsonKey(name: 'contract_verify', readValue: _contractVerify)  bool contractVerify, @JsonKey(name: 'tax_code', readValue: _taxCode)  String? taxCode)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.salesmanId,_that.fullName,_that.phone,_that.email,_that.image,_that.cityId,_that.districtId,_that.address,_that.birthday,_that.sex,_that.idCard,_that.idDay,_that.citizenIdFront,_that.citizenIdBack,_that.code,_that.position,_that.yoe,_that.checkingStaff,_that.requireUpdate,_that.step,_that.contractPdf,_that.contractVerify,_that.taxCode);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(readValue: _id)  int id, @JsonKey(name: 'salesman_id', readValue: _salesmanId)  int? salesmanId, @JsonKey(name: 'full_name', readValue: _fullName)  String fullName, @JsonKey(readValue: _phone)  String phone, @JsonKey(readValue: _email)  String email, @JsonKey(readValue: _image)  String? image, @JsonKey(name: 'city_id', readValue: _cityId)  String? cityId, @JsonKey(name: 'district_id', readValue: _districtId)  String? districtId, @JsonKey(readValue: _address)  String? address, @JsonKey(readValue: _birthday)  String? birthday, @JsonKey(readValue: _sex)  String? sex, @JsonKey(name: 'id_card', readValue: _idCard)  String? idCard, @JsonKey(name: 'id_day', readValue: _idDay)  String? idDay, @JsonKey(name: 'citizen_id_front', readValue: _citizenFront)  String? citizenIdFront, @JsonKey(name: 'citizen_id_back', readValue: _citizenBack)  String? citizenIdBack, @JsonKey(name: 'name_code', readValue: _code)  String? code, @JsonKey(name: 'position_name_code', readValue: _position)  String? position, @JsonKey(name: 'yoe', readValue: _yoe)  int? yoe, @JsonKey(name: 'checking_staff', readValue: _checkingStaff)  bool checkingStaff, @JsonKey(name: 'require_update', readValue: _requireUpdate)  bool requireUpdate, @JsonKey(readValue: _step)  int step, @JsonKey(name: 'contract_pdf', readValue: _contractPdf)  String? contractPdf, @JsonKey(name: 'contract_verify', readValue: _contractVerify)  bool contractVerify, @JsonKey(name: 'tax_code', readValue: _taxCode)  String? taxCode)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.salesmanId,_that.fullName,_that.phone,_that.email,_that.image,_that.cityId,_that.districtId,_that.address,_that.birthday,_that.sex,_that.idCard,_that.idDay,_that.citizenIdFront,_that.citizenIdBack,_that.code,_that.position,_that.yoe,_that.checkingStaff,_that.requireUpdate,_that.step,_that.contractPdf,_that.contractVerify,_that.taxCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _User extends User {
  const _User({@JsonKey(readValue: _id) this.id = 0, @JsonKey(name: 'salesman_id', readValue: _salesmanId) this.salesmanId, @JsonKey(name: 'full_name', readValue: _fullName) this.fullName = '', @JsonKey(readValue: _phone) this.phone = '', @JsonKey(readValue: _email) this.email = '', @JsonKey(readValue: _image) this.image, @JsonKey(name: 'city_id', readValue: _cityId) this.cityId, @JsonKey(name: 'district_id', readValue: _districtId) this.districtId, @JsonKey(readValue: _address) this.address, @JsonKey(readValue: _birthday) this.birthday, @JsonKey(readValue: _sex) this.sex, @JsonKey(name: 'id_card', readValue: _idCard) this.idCard, @JsonKey(name: 'id_day', readValue: _idDay) this.idDay, @JsonKey(name: 'citizen_id_front', readValue: _citizenFront) this.citizenIdFront, @JsonKey(name: 'citizen_id_back', readValue: _citizenBack) this.citizenIdBack, @JsonKey(name: 'name_code', readValue: _code) this.code, @JsonKey(name: 'position_name_code', readValue: _position) this.position, @JsonKey(name: 'yoe', readValue: _yoe) this.yoe, @JsonKey(name: 'checking_staff', readValue: _checkingStaff) this.checkingStaff = false, @JsonKey(name: 'require_update', readValue: _requireUpdate) this.requireUpdate = false, @JsonKey(readValue: _step) this.step = 1, @JsonKey(name: 'contract_pdf', readValue: _contractPdf) this.contractPdf, @JsonKey(name: 'contract_verify', readValue: _contractVerify) this.contractVerify = false, @JsonKey(name: 'tax_code', readValue: _taxCode) this.taxCode}): super._();
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override@JsonKey(readValue: _id) final  int id;
@override@JsonKey(name: 'salesman_id', readValue: _salesmanId) final  int? salesmanId;
@override@JsonKey(name: 'full_name', readValue: _fullName) final  String fullName;
@override@JsonKey(readValue: _phone) final  String phone;
@override@JsonKey(readValue: _email) final  String email;
@override@JsonKey(readValue: _image) final  String? image;
// city_id / district_id kept as String to match v1 (backend sends them
// int/string interchangeably; v1 stored the raw string).
@override@JsonKey(name: 'city_id', readValue: _cityId) final  String? cityId;
@override@JsonKey(name: 'district_id', readValue: _districtId) final  String? districtId;
@override@JsonKey(readValue: _address) final  String? address;
@override@JsonKey(readValue: _birthday) final  String? birthday;
@override@JsonKey(readValue: _sex) final  String? sex;
@override@JsonKey(name: 'id_card', readValue: _idCard) final  String? idCard;
@override@JsonKey(name: 'id_day', readValue: _idDay) final  String? idDay;
@override@JsonKey(name: 'citizen_id_front', readValue: _citizenFront) final  String? citizenIdFront;
@override@JsonKey(name: 'citizen_id_back', readValue: _citizenBack) final  String? citizenIdBack;
@override@JsonKey(name: 'name_code', readValue: _code) final  String? code;
@override@JsonKey(name: 'position_name_code', readValue: _position) final  String? position;
@override@JsonKey(name: 'yoe', readValue: _yoe) final  int? yoe;
// Drives the biometric-staff prompt (v1 `checking_staff`).
@override@JsonKey(name: 'checking_staff', readValue: _checkingStaff) final  bool checkingStaff;
// Forces a profile-update flow when the backend flags stale data.
@override@JsonKey(name: 'require_update', readValue: _requireUpdate) final  bool requireUpdate;
@override@JsonKey(readValue: _step) final  int step;
// CTV contract state (drives the join/pending banners + notepad shortcut).
@override@JsonKey(name: 'contract_pdf', readValue: _contractPdf) final  String? contractPdf;
@override@JsonKey(name: 'contract_verify', readValue: _contractVerify) final  bool contractVerify;
@override@JsonKey(name: 'tax_code', readValue: _taxCode) final  String? taxCode;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.salesmanId, salesmanId) || other.salesmanId == salesmanId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.image, image) || other.image == image)&&(identical(other.cityId, cityId) || other.cityId == cityId)&&(identical(other.districtId, districtId) || other.districtId == districtId)&&(identical(other.address, address) || other.address == address)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.idCard, idCard) || other.idCard == idCard)&&(identical(other.idDay, idDay) || other.idDay == idDay)&&(identical(other.citizenIdFront, citizenIdFront) || other.citizenIdFront == citizenIdFront)&&(identical(other.citizenIdBack, citizenIdBack) || other.citizenIdBack == citizenIdBack)&&(identical(other.code, code) || other.code == code)&&(identical(other.position, position) || other.position == position)&&(identical(other.yoe, yoe) || other.yoe == yoe)&&(identical(other.checkingStaff, checkingStaff) || other.checkingStaff == checkingStaff)&&(identical(other.requireUpdate, requireUpdate) || other.requireUpdate == requireUpdate)&&(identical(other.step, step) || other.step == step)&&(identical(other.contractPdf, contractPdf) || other.contractPdf == contractPdf)&&(identical(other.contractVerify, contractVerify) || other.contractVerify == contractVerify)&&(identical(other.taxCode, taxCode) || other.taxCode == taxCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,salesmanId,fullName,phone,email,image,cityId,districtId,address,birthday,sex,idCard,idDay,citizenIdFront,citizenIdBack,code,position,yoe,checkingStaff,requireUpdate,step,contractPdf,contractVerify,taxCode]);

@override
String toString() {
  return 'User(id: $id, salesmanId: $salesmanId, fullName: $fullName, phone: $phone, email: $email, image: $image, cityId: $cityId, districtId: $districtId, address: $address, birthday: $birthday, sex: $sex, idCard: $idCard, idDay: $idDay, citizenIdFront: $citizenIdFront, citizenIdBack: $citizenIdBack, code: $code, position: $position, yoe: $yoe, checkingStaff: $checkingStaff, requireUpdate: $requireUpdate, step: $step, contractPdf: $contractPdf, contractVerify: $contractVerify, taxCode: $taxCode)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(readValue: _id) int id,@JsonKey(name: 'salesman_id', readValue: _salesmanId) int? salesmanId,@JsonKey(name: 'full_name', readValue: _fullName) String fullName,@JsonKey(readValue: _phone) String phone,@JsonKey(readValue: _email) String email,@JsonKey(readValue: _image) String? image,@JsonKey(name: 'city_id', readValue: _cityId) String? cityId,@JsonKey(name: 'district_id', readValue: _districtId) String? districtId,@JsonKey(readValue: _address) String? address,@JsonKey(readValue: _birthday) String? birthday,@JsonKey(readValue: _sex) String? sex,@JsonKey(name: 'id_card', readValue: _idCard) String? idCard,@JsonKey(name: 'id_day', readValue: _idDay) String? idDay,@JsonKey(name: 'citizen_id_front', readValue: _citizenFront) String? citizenIdFront,@JsonKey(name: 'citizen_id_back', readValue: _citizenBack) String? citizenIdBack,@JsonKey(name: 'name_code', readValue: _code) String? code,@JsonKey(name: 'position_name_code', readValue: _position) String? position,@JsonKey(name: 'yoe', readValue: _yoe) int? yoe,@JsonKey(name: 'checking_staff', readValue: _checkingStaff) bool checkingStaff,@JsonKey(name: 'require_update', readValue: _requireUpdate) bool requireUpdate,@JsonKey(readValue: _step) int step,@JsonKey(name: 'contract_pdf', readValue: _contractPdf) String? contractPdf,@JsonKey(name: 'contract_verify', readValue: _contractVerify) bool contractVerify,@JsonKey(name: 'tax_code', readValue: _taxCode) String? taxCode
});




}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? salesmanId = freezed,Object? fullName = null,Object? phone = null,Object? email = null,Object? image = freezed,Object? cityId = freezed,Object? districtId = freezed,Object? address = freezed,Object? birthday = freezed,Object? sex = freezed,Object? idCard = freezed,Object? idDay = freezed,Object? citizenIdFront = freezed,Object? citizenIdBack = freezed,Object? code = freezed,Object? position = freezed,Object? yoe = freezed,Object? checkingStaff = null,Object? requireUpdate = null,Object? step = null,Object? contractPdf = freezed,Object? contractVerify = null,Object? taxCode = freezed,}) {
  return _then(_User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,salesmanId: freezed == salesmanId ? _self.salesmanId : salesmanId // ignore: cast_nullable_to_non_nullable
as int?,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,cityId: freezed == cityId ? _self.cityId : cityId // ignore: cast_nullable_to_non_nullable
as String?,districtId: freezed == districtId ? _self.districtId : districtId // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as String?,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as String?,idCard: freezed == idCard ? _self.idCard : idCard // ignore: cast_nullable_to_non_nullable
as String?,idDay: freezed == idDay ? _self.idDay : idDay // ignore: cast_nullable_to_non_nullable
as String?,citizenIdFront: freezed == citizenIdFront ? _self.citizenIdFront : citizenIdFront // ignore: cast_nullable_to_non_nullable
as String?,citizenIdBack: freezed == citizenIdBack ? _self.citizenIdBack : citizenIdBack // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String?,yoe: freezed == yoe ? _self.yoe : yoe // ignore: cast_nullable_to_non_nullable
as int?,checkingStaff: null == checkingStaff ? _self.checkingStaff : checkingStaff // ignore: cast_nullable_to_non_nullable
as bool,requireUpdate: null == requireUpdate ? _self.requireUpdate : requireUpdate // ignore: cast_nullable_to_non_nullable
as bool,step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as int,contractPdf: freezed == contractPdf ? _self.contractPdf : contractPdf // ignore: cast_nullable_to_non_nullable
as String?,contractVerify: null == contractVerify ? _self.contractVerify : contractVerify // ignore: cast_nullable_to_non_nullable
as bool,taxCode: freezed == taxCode ? _self.taxCode : taxCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
