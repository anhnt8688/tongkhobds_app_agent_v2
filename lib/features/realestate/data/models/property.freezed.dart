// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'property.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Property {

@JsonKey(readValue: _id) int get id;@JsonKey(readValue: _title) String get title;@JsonKey(readValue: _address) String get address;@JsonKey(readValue: _price) double? get price;@JsonKey(name: 'price_display', readValue: _priceDisplay) String? get priceDisplay;@JsonKey(readValue: _area) double? get area;@JsonKey(readValue: _bedrooms) int? get bedrooms;@JsonKey(readValue: _bathrooms) int? get bathrooms;@JsonKey(name: 'property_type_name', readValue: _propertyTypeName) String? get propertyTypeName;@JsonKey(name: 'transaction_type', readValue: _transactionType) int? get transactionType;@JsonKey(readValue: _image) String? get image;@JsonKey(readValue: _slug) String? get slug;@JsonKey(readValue: _status) String? get status;@JsonKey(name: 'status_activity_label', readValue: _statusActivityLabel) String? get statusActivityLabel;@JsonKey(name: 'status_activity', readValue: _statusActivity) int? get statusActivity;@JsonKey(name: 'is_hot', readValue: _isHot) bool get isHot;@JsonKey(name: 'real_estate_code', readValue: _code) String? get code;@JsonKey(name: 'city', readValue: _city) String? get city;@JsonKey(name: 'district', readValue: _district) String? get district;@JsonKey(name: 'is_favorite', readValue: _isFavorite) bool get isFavorite;@JsonKey(name: 'is_verified', readValue: _verified) bool get isVerified;@JsonKey(name: 'project_code', readValue: _projectCode) String? get projectCode;@JsonKey(name: 'parent_name', readValue: _parentName) String? get parentName;// --- "BĐS của tôi" (my listings) fields, parity with v1 ProductModel ---
@JsonKey(name: 'price_description', readValue: _priceDescription) String? get priceDescription;@JsonKey(name: 'created_on', readValue: _createdOn) String? get createdOn;@JsonKey(name: 'status_name', readValue: _statusInfoName) String? get statusName;@JsonKey(name: 'status_color', readValue: _statusInfoColor) String? get statusColor;@JsonKey(name: 'label_list', readValue: _labels) List<String>? get labelList;@JsonKey(name: 'source_get', readValue: _sourceGet) String? get sourceGet;@JsonKey(name: 'is_verify_real_estate', readValue: _isVerifyRe) bool get isVerifyRealEstate;@JsonKey(name: 'is_request_signing', readValue: _isRequestSigning) bool get isRequestSigning;
/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PropertyCopyWith<Property> get copyWith => _$PropertyCopyWithImpl<Property>(this as Property, _$identity);

  /// Serializes this Property to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Property&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.address, address) || other.address == address)&&(identical(other.price, price) || other.price == price)&&(identical(other.priceDisplay, priceDisplay) || other.priceDisplay == priceDisplay)&&(identical(other.area, area) || other.area == area)&&(identical(other.bedrooms, bedrooms) || other.bedrooms == bedrooms)&&(identical(other.bathrooms, bathrooms) || other.bathrooms == bathrooms)&&(identical(other.propertyTypeName, propertyTypeName) || other.propertyTypeName == propertyTypeName)&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&(identical(other.image, image) || other.image == image)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusActivityLabel, statusActivityLabel) || other.statusActivityLabel == statusActivityLabel)&&(identical(other.statusActivity, statusActivity) || other.statusActivity == statusActivity)&&(identical(other.isHot, isHot) || other.isHot == isHot)&&(identical(other.code, code) || other.code == code)&&(identical(other.city, city) || other.city == city)&&(identical(other.district, district) || other.district == district)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.projectCode, projectCode) || other.projectCode == projectCode)&&(identical(other.parentName, parentName) || other.parentName == parentName)&&(identical(other.priceDescription, priceDescription) || other.priceDescription == priceDescription)&&(identical(other.createdOn, createdOn) || other.createdOn == createdOn)&&(identical(other.statusName, statusName) || other.statusName == statusName)&&(identical(other.statusColor, statusColor) || other.statusColor == statusColor)&&const DeepCollectionEquality().equals(other.labelList, labelList)&&(identical(other.sourceGet, sourceGet) || other.sourceGet == sourceGet)&&(identical(other.isVerifyRealEstate, isVerifyRealEstate) || other.isVerifyRealEstate == isVerifyRealEstate)&&(identical(other.isRequestSigning, isRequestSigning) || other.isRequestSigning == isRequestSigning));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,address,price,priceDisplay,area,bedrooms,bathrooms,propertyTypeName,transactionType,image,slug,status,statusActivityLabel,statusActivity,isHot,code,city,district,isFavorite,isVerified,projectCode,parentName,priceDescription,createdOn,statusName,statusColor,const DeepCollectionEquality().hash(labelList),sourceGet,isVerifyRealEstate,isRequestSigning]);

@override
String toString() {
  return 'Property(id: $id, title: $title, address: $address, price: $price, priceDisplay: $priceDisplay, area: $area, bedrooms: $bedrooms, bathrooms: $bathrooms, propertyTypeName: $propertyTypeName, transactionType: $transactionType, image: $image, slug: $slug, status: $status, statusActivityLabel: $statusActivityLabel, statusActivity: $statusActivity, isHot: $isHot, code: $code, city: $city, district: $district, isFavorite: $isFavorite, isVerified: $isVerified, projectCode: $projectCode, parentName: $parentName, priceDescription: $priceDescription, createdOn: $createdOn, statusName: $statusName, statusColor: $statusColor, labelList: $labelList, sourceGet: $sourceGet, isVerifyRealEstate: $isVerifyRealEstate, isRequestSigning: $isRequestSigning)';
}


}

/// @nodoc
abstract mixin class $PropertyCopyWith<$Res>  {
  factory $PropertyCopyWith(Property value, $Res Function(Property) _then) = _$PropertyCopyWithImpl;
@useResult
$Res call({
@JsonKey(readValue: _id) int id,@JsonKey(readValue: _title) String title,@JsonKey(readValue: _address) String address,@JsonKey(readValue: _price) double? price,@JsonKey(name: 'price_display', readValue: _priceDisplay) String? priceDisplay,@JsonKey(readValue: _area) double? area,@JsonKey(readValue: _bedrooms) int? bedrooms,@JsonKey(readValue: _bathrooms) int? bathrooms,@JsonKey(name: 'property_type_name', readValue: _propertyTypeName) String? propertyTypeName,@JsonKey(name: 'transaction_type', readValue: _transactionType) int? transactionType,@JsonKey(readValue: _image) String? image,@JsonKey(readValue: _slug) String? slug,@JsonKey(readValue: _status) String? status,@JsonKey(name: 'status_activity_label', readValue: _statusActivityLabel) String? statusActivityLabel,@JsonKey(name: 'status_activity', readValue: _statusActivity) int? statusActivity,@JsonKey(name: 'is_hot', readValue: _isHot) bool isHot,@JsonKey(name: 'real_estate_code', readValue: _code) String? code,@JsonKey(name: 'city', readValue: _city) String? city,@JsonKey(name: 'district', readValue: _district) String? district,@JsonKey(name: 'is_favorite', readValue: _isFavorite) bool isFavorite,@JsonKey(name: 'is_verified', readValue: _verified) bool isVerified,@JsonKey(name: 'project_code', readValue: _projectCode) String? projectCode,@JsonKey(name: 'parent_name', readValue: _parentName) String? parentName,@JsonKey(name: 'price_description', readValue: _priceDescription) String? priceDescription,@JsonKey(name: 'created_on', readValue: _createdOn) String? createdOn,@JsonKey(name: 'status_name', readValue: _statusInfoName) String? statusName,@JsonKey(name: 'status_color', readValue: _statusInfoColor) String? statusColor,@JsonKey(name: 'label_list', readValue: _labels) List<String>? labelList,@JsonKey(name: 'source_get', readValue: _sourceGet) String? sourceGet,@JsonKey(name: 'is_verify_real_estate', readValue: _isVerifyRe) bool isVerifyRealEstate,@JsonKey(name: 'is_request_signing', readValue: _isRequestSigning) bool isRequestSigning
});




}
/// @nodoc
class _$PropertyCopyWithImpl<$Res>
    implements $PropertyCopyWith<$Res> {
  _$PropertyCopyWithImpl(this._self, this._then);

  final Property _self;
  final $Res Function(Property) _then;

/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? address = null,Object? price = freezed,Object? priceDisplay = freezed,Object? area = freezed,Object? bedrooms = freezed,Object? bathrooms = freezed,Object? propertyTypeName = freezed,Object? transactionType = freezed,Object? image = freezed,Object? slug = freezed,Object? status = freezed,Object? statusActivityLabel = freezed,Object? statusActivity = freezed,Object? isHot = null,Object? code = freezed,Object? city = freezed,Object? district = freezed,Object? isFavorite = null,Object? isVerified = null,Object? projectCode = freezed,Object? parentName = freezed,Object? priceDescription = freezed,Object? createdOn = freezed,Object? statusName = freezed,Object? statusColor = freezed,Object? labelList = freezed,Object? sourceGet = freezed,Object? isVerifyRealEstate = null,Object? isRequestSigning = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,priceDisplay: freezed == priceDisplay ? _self.priceDisplay : priceDisplay // ignore: cast_nullable_to_non_nullable
as String?,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as double?,bedrooms: freezed == bedrooms ? _self.bedrooms : bedrooms // ignore: cast_nullable_to_non_nullable
as int?,bathrooms: freezed == bathrooms ? _self.bathrooms : bathrooms // ignore: cast_nullable_to_non_nullable
as int?,propertyTypeName: freezed == propertyTypeName ? _self.propertyTypeName : propertyTypeName // ignore: cast_nullable_to_non_nullable
as String?,transactionType: freezed == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as int?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,statusActivityLabel: freezed == statusActivityLabel ? _self.statusActivityLabel : statusActivityLabel // ignore: cast_nullable_to_non_nullable
as String?,statusActivity: freezed == statusActivity ? _self.statusActivity : statusActivity // ignore: cast_nullable_to_non_nullable
as int?,isHot: null == isHot ? _self.isHot : isHot // ignore: cast_nullable_to_non_nullable
as bool,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,projectCode: freezed == projectCode ? _self.projectCode : projectCode // ignore: cast_nullable_to_non_nullable
as String?,parentName: freezed == parentName ? _self.parentName : parentName // ignore: cast_nullable_to_non_nullable
as String?,priceDescription: freezed == priceDescription ? _self.priceDescription : priceDescription // ignore: cast_nullable_to_non_nullable
as String?,createdOn: freezed == createdOn ? _self.createdOn : createdOn // ignore: cast_nullable_to_non_nullable
as String?,statusName: freezed == statusName ? _self.statusName : statusName // ignore: cast_nullable_to_non_nullable
as String?,statusColor: freezed == statusColor ? _self.statusColor : statusColor // ignore: cast_nullable_to_non_nullable
as String?,labelList: freezed == labelList ? _self.labelList : labelList // ignore: cast_nullable_to_non_nullable
as List<String>?,sourceGet: freezed == sourceGet ? _self.sourceGet : sourceGet // ignore: cast_nullable_to_non_nullable
as String?,isVerifyRealEstate: null == isVerifyRealEstate ? _self.isVerifyRealEstate : isVerifyRealEstate // ignore: cast_nullable_to_non_nullable
as bool,isRequestSigning: null == isRequestSigning ? _self.isRequestSigning : isRequestSigning // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Property].
extension PropertyPatterns on Property {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Property value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Property() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Property value)  $default,){
final _that = this;
switch (_that) {
case _Property():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Property value)?  $default,){
final _that = this;
switch (_that) {
case _Property() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(readValue: _id)  int id, @JsonKey(readValue: _title)  String title, @JsonKey(readValue: _address)  String address, @JsonKey(readValue: _price)  double? price, @JsonKey(name: 'price_display', readValue: _priceDisplay)  String? priceDisplay, @JsonKey(readValue: _area)  double? area, @JsonKey(readValue: _bedrooms)  int? bedrooms, @JsonKey(readValue: _bathrooms)  int? bathrooms, @JsonKey(name: 'property_type_name', readValue: _propertyTypeName)  String? propertyTypeName, @JsonKey(name: 'transaction_type', readValue: _transactionType)  int? transactionType, @JsonKey(readValue: _image)  String? image, @JsonKey(readValue: _slug)  String? slug, @JsonKey(readValue: _status)  String? status, @JsonKey(name: 'status_activity_label', readValue: _statusActivityLabel)  String? statusActivityLabel, @JsonKey(name: 'status_activity', readValue: _statusActivity)  int? statusActivity, @JsonKey(name: 'is_hot', readValue: _isHot)  bool isHot, @JsonKey(name: 'real_estate_code', readValue: _code)  String? code, @JsonKey(name: 'city', readValue: _city)  String? city, @JsonKey(name: 'district', readValue: _district)  String? district, @JsonKey(name: 'is_favorite', readValue: _isFavorite)  bool isFavorite, @JsonKey(name: 'is_verified', readValue: _verified)  bool isVerified, @JsonKey(name: 'project_code', readValue: _projectCode)  String? projectCode, @JsonKey(name: 'parent_name', readValue: _parentName)  String? parentName, @JsonKey(name: 'price_description', readValue: _priceDescription)  String? priceDescription, @JsonKey(name: 'created_on', readValue: _createdOn)  String? createdOn, @JsonKey(name: 'status_name', readValue: _statusInfoName)  String? statusName, @JsonKey(name: 'status_color', readValue: _statusInfoColor)  String? statusColor, @JsonKey(name: 'label_list', readValue: _labels)  List<String>? labelList, @JsonKey(name: 'source_get', readValue: _sourceGet)  String? sourceGet, @JsonKey(name: 'is_verify_real_estate', readValue: _isVerifyRe)  bool isVerifyRealEstate, @JsonKey(name: 'is_request_signing', readValue: _isRequestSigning)  bool isRequestSigning)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Property() when $default != null:
return $default(_that.id,_that.title,_that.address,_that.price,_that.priceDisplay,_that.area,_that.bedrooms,_that.bathrooms,_that.propertyTypeName,_that.transactionType,_that.image,_that.slug,_that.status,_that.statusActivityLabel,_that.statusActivity,_that.isHot,_that.code,_that.city,_that.district,_that.isFavorite,_that.isVerified,_that.projectCode,_that.parentName,_that.priceDescription,_that.createdOn,_that.statusName,_that.statusColor,_that.labelList,_that.sourceGet,_that.isVerifyRealEstate,_that.isRequestSigning);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(readValue: _id)  int id, @JsonKey(readValue: _title)  String title, @JsonKey(readValue: _address)  String address, @JsonKey(readValue: _price)  double? price, @JsonKey(name: 'price_display', readValue: _priceDisplay)  String? priceDisplay, @JsonKey(readValue: _area)  double? area, @JsonKey(readValue: _bedrooms)  int? bedrooms, @JsonKey(readValue: _bathrooms)  int? bathrooms, @JsonKey(name: 'property_type_name', readValue: _propertyTypeName)  String? propertyTypeName, @JsonKey(name: 'transaction_type', readValue: _transactionType)  int? transactionType, @JsonKey(readValue: _image)  String? image, @JsonKey(readValue: _slug)  String? slug, @JsonKey(readValue: _status)  String? status, @JsonKey(name: 'status_activity_label', readValue: _statusActivityLabel)  String? statusActivityLabel, @JsonKey(name: 'status_activity', readValue: _statusActivity)  int? statusActivity, @JsonKey(name: 'is_hot', readValue: _isHot)  bool isHot, @JsonKey(name: 'real_estate_code', readValue: _code)  String? code, @JsonKey(name: 'city', readValue: _city)  String? city, @JsonKey(name: 'district', readValue: _district)  String? district, @JsonKey(name: 'is_favorite', readValue: _isFavorite)  bool isFavorite, @JsonKey(name: 'is_verified', readValue: _verified)  bool isVerified, @JsonKey(name: 'project_code', readValue: _projectCode)  String? projectCode, @JsonKey(name: 'parent_name', readValue: _parentName)  String? parentName, @JsonKey(name: 'price_description', readValue: _priceDescription)  String? priceDescription, @JsonKey(name: 'created_on', readValue: _createdOn)  String? createdOn, @JsonKey(name: 'status_name', readValue: _statusInfoName)  String? statusName, @JsonKey(name: 'status_color', readValue: _statusInfoColor)  String? statusColor, @JsonKey(name: 'label_list', readValue: _labels)  List<String>? labelList, @JsonKey(name: 'source_get', readValue: _sourceGet)  String? sourceGet, @JsonKey(name: 'is_verify_real_estate', readValue: _isVerifyRe)  bool isVerifyRealEstate, @JsonKey(name: 'is_request_signing', readValue: _isRequestSigning)  bool isRequestSigning)  $default,) {final _that = this;
switch (_that) {
case _Property():
return $default(_that.id,_that.title,_that.address,_that.price,_that.priceDisplay,_that.area,_that.bedrooms,_that.bathrooms,_that.propertyTypeName,_that.transactionType,_that.image,_that.slug,_that.status,_that.statusActivityLabel,_that.statusActivity,_that.isHot,_that.code,_that.city,_that.district,_that.isFavorite,_that.isVerified,_that.projectCode,_that.parentName,_that.priceDescription,_that.createdOn,_that.statusName,_that.statusColor,_that.labelList,_that.sourceGet,_that.isVerifyRealEstate,_that.isRequestSigning);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(readValue: _id)  int id, @JsonKey(readValue: _title)  String title, @JsonKey(readValue: _address)  String address, @JsonKey(readValue: _price)  double? price, @JsonKey(name: 'price_display', readValue: _priceDisplay)  String? priceDisplay, @JsonKey(readValue: _area)  double? area, @JsonKey(readValue: _bedrooms)  int? bedrooms, @JsonKey(readValue: _bathrooms)  int? bathrooms, @JsonKey(name: 'property_type_name', readValue: _propertyTypeName)  String? propertyTypeName, @JsonKey(name: 'transaction_type', readValue: _transactionType)  int? transactionType, @JsonKey(readValue: _image)  String? image, @JsonKey(readValue: _slug)  String? slug, @JsonKey(readValue: _status)  String? status, @JsonKey(name: 'status_activity_label', readValue: _statusActivityLabel)  String? statusActivityLabel, @JsonKey(name: 'status_activity', readValue: _statusActivity)  int? statusActivity, @JsonKey(name: 'is_hot', readValue: _isHot)  bool isHot, @JsonKey(name: 'real_estate_code', readValue: _code)  String? code, @JsonKey(name: 'city', readValue: _city)  String? city, @JsonKey(name: 'district', readValue: _district)  String? district, @JsonKey(name: 'is_favorite', readValue: _isFavorite)  bool isFavorite, @JsonKey(name: 'is_verified', readValue: _verified)  bool isVerified, @JsonKey(name: 'project_code', readValue: _projectCode)  String? projectCode, @JsonKey(name: 'parent_name', readValue: _parentName)  String? parentName, @JsonKey(name: 'price_description', readValue: _priceDescription)  String? priceDescription, @JsonKey(name: 'created_on', readValue: _createdOn)  String? createdOn, @JsonKey(name: 'status_name', readValue: _statusInfoName)  String? statusName, @JsonKey(name: 'status_color', readValue: _statusInfoColor)  String? statusColor, @JsonKey(name: 'label_list', readValue: _labels)  List<String>? labelList, @JsonKey(name: 'source_get', readValue: _sourceGet)  String? sourceGet, @JsonKey(name: 'is_verify_real_estate', readValue: _isVerifyRe)  bool isVerifyRealEstate, @JsonKey(name: 'is_request_signing', readValue: _isRequestSigning)  bool isRequestSigning)?  $default,) {final _that = this;
switch (_that) {
case _Property() when $default != null:
return $default(_that.id,_that.title,_that.address,_that.price,_that.priceDisplay,_that.area,_that.bedrooms,_that.bathrooms,_that.propertyTypeName,_that.transactionType,_that.image,_that.slug,_that.status,_that.statusActivityLabel,_that.statusActivity,_that.isHot,_that.code,_that.city,_that.district,_that.isFavorite,_that.isVerified,_that.projectCode,_that.parentName,_that.priceDescription,_that.createdOn,_that.statusName,_that.statusColor,_that.labelList,_that.sourceGet,_that.isVerifyRealEstate,_that.isRequestSigning);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Property extends Property {
  const _Property({@JsonKey(readValue: _id) this.id = 0, @JsonKey(readValue: _title) this.title = '', @JsonKey(readValue: _address) this.address = '', @JsonKey(readValue: _price) this.price, @JsonKey(name: 'price_display', readValue: _priceDisplay) this.priceDisplay, @JsonKey(readValue: _area) this.area, @JsonKey(readValue: _bedrooms) this.bedrooms, @JsonKey(readValue: _bathrooms) this.bathrooms, @JsonKey(name: 'property_type_name', readValue: _propertyTypeName) this.propertyTypeName, @JsonKey(name: 'transaction_type', readValue: _transactionType) this.transactionType, @JsonKey(readValue: _image) this.image, @JsonKey(readValue: _slug) this.slug, @JsonKey(readValue: _status) this.status, @JsonKey(name: 'status_activity_label', readValue: _statusActivityLabel) this.statusActivityLabel, @JsonKey(name: 'status_activity', readValue: _statusActivity) this.statusActivity, @JsonKey(name: 'is_hot', readValue: _isHot) this.isHot = false, @JsonKey(name: 'real_estate_code', readValue: _code) this.code, @JsonKey(name: 'city', readValue: _city) this.city, @JsonKey(name: 'district', readValue: _district) this.district, @JsonKey(name: 'is_favorite', readValue: _isFavorite) this.isFavorite = false, @JsonKey(name: 'is_verified', readValue: _verified) this.isVerified = false, @JsonKey(name: 'project_code', readValue: _projectCode) this.projectCode, @JsonKey(name: 'parent_name', readValue: _parentName) this.parentName, @JsonKey(name: 'price_description', readValue: _priceDescription) this.priceDescription, @JsonKey(name: 'created_on', readValue: _createdOn) this.createdOn, @JsonKey(name: 'status_name', readValue: _statusInfoName) this.statusName, @JsonKey(name: 'status_color', readValue: _statusInfoColor) this.statusColor, @JsonKey(name: 'label_list', readValue: _labels) final  List<String>? labelList, @JsonKey(name: 'source_get', readValue: _sourceGet) this.sourceGet, @JsonKey(name: 'is_verify_real_estate', readValue: _isVerifyRe) this.isVerifyRealEstate = false, @JsonKey(name: 'is_request_signing', readValue: _isRequestSigning) this.isRequestSigning = false}): _labelList = labelList,super._();
  factory _Property.fromJson(Map<String, dynamic> json) => _$PropertyFromJson(json);

@override@JsonKey(readValue: _id) final  int id;
@override@JsonKey(readValue: _title) final  String title;
@override@JsonKey(readValue: _address) final  String address;
@override@JsonKey(readValue: _price) final  double? price;
@override@JsonKey(name: 'price_display', readValue: _priceDisplay) final  String? priceDisplay;
@override@JsonKey(readValue: _area) final  double? area;
@override@JsonKey(readValue: _bedrooms) final  int? bedrooms;
@override@JsonKey(readValue: _bathrooms) final  int? bathrooms;
@override@JsonKey(name: 'property_type_name', readValue: _propertyTypeName) final  String? propertyTypeName;
@override@JsonKey(name: 'transaction_type', readValue: _transactionType) final  int? transactionType;
@override@JsonKey(readValue: _image) final  String? image;
@override@JsonKey(readValue: _slug) final  String? slug;
@override@JsonKey(readValue: _status) final  String? status;
@override@JsonKey(name: 'status_activity_label', readValue: _statusActivityLabel) final  String? statusActivityLabel;
@override@JsonKey(name: 'status_activity', readValue: _statusActivity) final  int? statusActivity;
@override@JsonKey(name: 'is_hot', readValue: _isHot) final  bool isHot;
@override@JsonKey(name: 'real_estate_code', readValue: _code) final  String? code;
@override@JsonKey(name: 'city', readValue: _city) final  String? city;
@override@JsonKey(name: 'district', readValue: _district) final  String? district;
@override@JsonKey(name: 'is_favorite', readValue: _isFavorite) final  bool isFavorite;
@override@JsonKey(name: 'is_verified', readValue: _verified) final  bool isVerified;
@override@JsonKey(name: 'project_code', readValue: _projectCode) final  String? projectCode;
@override@JsonKey(name: 'parent_name', readValue: _parentName) final  String? parentName;
// --- "BĐS của tôi" (my listings) fields, parity with v1 ProductModel ---
@override@JsonKey(name: 'price_description', readValue: _priceDescription) final  String? priceDescription;
@override@JsonKey(name: 'created_on', readValue: _createdOn) final  String? createdOn;
@override@JsonKey(name: 'status_name', readValue: _statusInfoName) final  String? statusName;
@override@JsonKey(name: 'status_color', readValue: _statusInfoColor) final  String? statusColor;
 final  List<String>? _labelList;
@override@JsonKey(name: 'label_list', readValue: _labels) List<String>? get labelList {
  final value = _labelList;
  if (value == null) return null;
  if (_labelList is EqualUnmodifiableListView) return _labelList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'source_get', readValue: _sourceGet) final  String? sourceGet;
@override@JsonKey(name: 'is_verify_real_estate', readValue: _isVerifyRe) final  bool isVerifyRealEstate;
@override@JsonKey(name: 'is_request_signing', readValue: _isRequestSigning) final  bool isRequestSigning;

/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PropertyCopyWith<_Property> get copyWith => __$PropertyCopyWithImpl<_Property>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PropertyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Property&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.address, address) || other.address == address)&&(identical(other.price, price) || other.price == price)&&(identical(other.priceDisplay, priceDisplay) || other.priceDisplay == priceDisplay)&&(identical(other.area, area) || other.area == area)&&(identical(other.bedrooms, bedrooms) || other.bedrooms == bedrooms)&&(identical(other.bathrooms, bathrooms) || other.bathrooms == bathrooms)&&(identical(other.propertyTypeName, propertyTypeName) || other.propertyTypeName == propertyTypeName)&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&(identical(other.image, image) || other.image == image)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusActivityLabel, statusActivityLabel) || other.statusActivityLabel == statusActivityLabel)&&(identical(other.statusActivity, statusActivity) || other.statusActivity == statusActivity)&&(identical(other.isHot, isHot) || other.isHot == isHot)&&(identical(other.code, code) || other.code == code)&&(identical(other.city, city) || other.city == city)&&(identical(other.district, district) || other.district == district)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.projectCode, projectCode) || other.projectCode == projectCode)&&(identical(other.parentName, parentName) || other.parentName == parentName)&&(identical(other.priceDescription, priceDescription) || other.priceDescription == priceDescription)&&(identical(other.createdOn, createdOn) || other.createdOn == createdOn)&&(identical(other.statusName, statusName) || other.statusName == statusName)&&(identical(other.statusColor, statusColor) || other.statusColor == statusColor)&&const DeepCollectionEquality().equals(other._labelList, _labelList)&&(identical(other.sourceGet, sourceGet) || other.sourceGet == sourceGet)&&(identical(other.isVerifyRealEstate, isVerifyRealEstate) || other.isVerifyRealEstate == isVerifyRealEstate)&&(identical(other.isRequestSigning, isRequestSigning) || other.isRequestSigning == isRequestSigning));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,address,price,priceDisplay,area,bedrooms,bathrooms,propertyTypeName,transactionType,image,slug,status,statusActivityLabel,statusActivity,isHot,code,city,district,isFavorite,isVerified,projectCode,parentName,priceDescription,createdOn,statusName,statusColor,const DeepCollectionEquality().hash(_labelList),sourceGet,isVerifyRealEstate,isRequestSigning]);

@override
String toString() {
  return 'Property(id: $id, title: $title, address: $address, price: $price, priceDisplay: $priceDisplay, area: $area, bedrooms: $bedrooms, bathrooms: $bathrooms, propertyTypeName: $propertyTypeName, transactionType: $transactionType, image: $image, slug: $slug, status: $status, statusActivityLabel: $statusActivityLabel, statusActivity: $statusActivity, isHot: $isHot, code: $code, city: $city, district: $district, isFavorite: $isFavorite, isVerified: $isVerified, projectCode: $projectCode, parentName: $parentName, priceDescription: $priceDescription, createdOn: $createdOn, statusName: $statusName, statusColor: $statusColor, labelList: $labelList, sourceGet: $sourceGet, isVerifyRealEstate: $isVerifyRealEstate, isRequestSigning: $isRequestSigning)';
}


}

/// @nodoc
abstract mixin class _$PropertyCopyWith<$Res> implements $PropertyCopyWith<$Res> {
  factory _$PropertyCopyWith(_Property value, $Res Function(_Property) _then) = __$PropertyCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(readValue: _id) int id,@JsonKey(readValue: _title) String title,@JsonKey(readValue: _address) String address,@JsonKey(readValue: _price) double? price,@JsonKey(name: 'price_display', readValue: _priceDisplay) String? priceDisplay,@JsonKey(readValue: _area) double? area,@JsonKey(readValue: _bedrooms) int? bedrooms,@JsonKey(readValue: _bathrooms) int? bathrooms,@JsonKey(name: 'property_type_name', readValue: _propertyTypeName) String? propertyTypeName,@JsonKey(name: 'transaction_type', readValue: _transactionType) int? transactionType,@JsonKey(readValue: _image) String? image,@JsonKey(readValue: _slug) String? slug,@JsonKey(readValue: _status) String? status,@JsonKey(name: 'status_activity_label', readValue: _statusActivityLabel) String? statusActivityLabel,@JsonKey(name: 'status_activity', readValue: _statusActivity) int? statusActivity,@JsonKey(name: 'is_hot', readValue: _isHot) bool isHot,@JsonKey(name: 'real_estate_code', readValue: _code) String? code,@JsonKey(name: 'city', readValue: _city) String? city,@JsonKey(name: 'district', readValue: _district) String? district,@JsonKey(name: 'is_favorite', readValue: _isFavorite) bool isFavorite,@JsonKey(name: 'is_verified', readValue: _verified) bool isVerified,@JsonKey(name: 'project_code', readValue: _projectCode) String? projectCode,@JsonKey(name: 'parent_name', readValue: _parentName) String? parentName,@JsonKey(name: 'price_description', readValue: _priceDescription) String? priceDescription,@JsonKey(name: 'created_on', readValue: _createdOn) String? createdOn,@JsonKey(name: 'status_name', readValue: _statusInfoName) String? statusName,@JsonKey(name: 'status_color', readValue: _statusInfoColor) String? statusColor,@JsonKey(name: 'label_list', readValue: _labels) List<String>? labelList,@JsonKey(name: 'source_get', readValue: _sourceGet) String? sourceGet,@JsonKey(name: 'is_verify_real_estate', readValue: _isVerifyRe) bool isVerifyRealEstate,@JsonKey(name: 'is_request_signing', readValue: _isRequestSigning) bool isRequestSigning
});




}
/// @nodoc
class __$PropertyCopyWithImpl<$Res>
    implements _$PropertyCopyWith<$Res> {
  __$PropertyCopyWithImpl(this._self, this._then);

  final _Property _self;
  final $Res Function(_Property) _then;

/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? address = null,Object? price = freezed,Object? priceDisplay = freezed,Object? area = freezed,Object? bedrooms = freezed,Object? bathrooms = freezed,Object? propertyTypeName = freezed,Object? transactionType = freezed,Object? image = freezed,Object? slug = freezed,Object? status = freezed,Object? statusActivityLabel = freezed,Object? statusActivity = freezed,Object? isHot = null,Object? code = freezed,Object? city = freezed,Object? district = freezed,Object? isFavorite = null,Object? isVerified = null,Object? projectCode = freezed,Object? parentName = freezed,Object? priceDescription = freezed,Object? createdOn = freezed,Object? statusName = freezed,Object? statusColor = freezed,Object? labelList = freezed,Object? sourceGet = freezed,Object? isVerifyRealEstate = null,Object? isRequestSigning = null,}) {
  return _then(_Property(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,priceDisplay: freezed == priceDisplay ? _self.priceDisplay : priceDisplay // ignore: cast_nullable_to_non_nullable
as String?,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as double?,bedrooms: freezed == bedrooms ? _self.bedrooms : bedrooms // ignore: cast_nullable_to_non_nullable
as int?,bathrooms: freezed == bathrooms ? _self.bathrooms : bathrooms // ignore: cast_nullable_to_non_nullable
as int?,propertyTypeName: freezed == propertyTypeName ? _self.propertyTypeName : propertyTypeName // ignore: cast_nullable_to_non_nullable
as String?,transactionType: freezed == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as int?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,statusActivityLabel: freezed == statusActivityLabel ? _self.statusActivityLabel : statusActivityLabel // ignore: cast_nullable_to_non_nullable
as String?,statusActivity: freezed == statusActivity ? _self.statusActivity : statusActivity // ignore: cast_nullable_to_non_nullable
as int?,isHot: null == isHot ? _self.isHot : isHot // ignore: cast_nullable_to_non_nullable
as bool,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,projectCode: freezed == projectCode ? _self.projectCode : projectCode // ignore: cast_nullable_to_non_nullable
as String?,parentName: freezed == parentName ? _self.parentName : parentName // ignore: cast_nullable_to_non_nullable
as String?,priceDescription: freezed == priceDescription ? _self.priceDescription : priceDescription // ignore: cast_nullable_to_non_nullable
as String?,createdOn: freezed == createdOn ? _self.createdOn : createdOn // ignore: cast_nullable_to_non_nullable
as String?,statusName: freezed == statusName ? _self.statusName : statusName // ignore: cast_nullable_to_non_nullable
as String?,statusColor: freezed == statusColor ? _self.statusColor : statusColor // ignore: cast_nullable_to_non_nullable
as String?,labelList: freezed == labelList ? _self._labelList : labelList // ignore: cast_nullable_to_non_nullable
as List<String>?,sourceGet: freezed == sourceGet ? _self.sourceGet : sourceGet // ignore: cast_nullable_to_non_nullable
as String?,isVerifyRealEstate: null == isVerifyRealEstate ? _self.isVerifyRealEstate : isVerifyRealEstate // ignore: cast_nullable_to_non_nullable
as bool,isRequestSigning: null == isRequestSigning ? _self.isRequestSigning : isRequestSigning // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
