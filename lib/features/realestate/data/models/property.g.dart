// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Property _$PropertyFromJson(Map<String, dynamic> json) => _Property(
  id: (_id(json, 'id') as num?)?.toInt() ?? 0,
  title: _title(json, 'title') as String? ?? '',
  address: _address(json, 'address') as String? ?? '',
  price: (_price(json, 'price') as num?)?.toDouble(),
  priceDisplay: _priceDisplay(json, 'price_display') as String?,
  area: (_area(json, 'area') as num?)?.toDouble(),
  bedrooms: (_bedrooms(json, 'bedrooms') as num?)?.toInt(),
  bathrooms: (_bathrooms(json, 'bathrooms') as num?)?.toInt(),
  propertyTypeName: _propertyTypeName(json, 'property_type_name') as String?,
  transactionType: (_transactionType(json, 'transaction_type') as num?)
      ?.toInt(),
  image: _image(json, 'image') as String?,
  slug: _slug(json, 'slug') as String?,
  status: _status(json, 'status') as String?,
  statusActivityLabel:
      _statusActivityLabel(json, 'status_activity_label') as String?,
  statusActivity: (_statusActivity(json, 'status_activity') as num?)?.toInt(),
  isHot: _isHot(json, 'is_hot') as bool? ?? false,
  code: _code(json, 'real_estate_code') as String?,
  city: _city(json, 'city') as String?,
  district: _district(json, 'district') as String?,
  isFavorite: _isFavorite(json, 'is_favorite') as bool? ?? false,
  isVerified: _verified(json, 'is_verified') as bool? ?? false,
  projectCode: _projectCode(json, 'project_code') as String?,
  parentName: _parentName(json, 'parent_name') as String?,
  priceDescription: _priceDescription(json, 'price_description') as String?,
  createdOn: _createdOn(json, 'created_on') as String?,
  statusName: _statusInfoName(json, 'status_name') as String?,
  statusColor: _statusInfoColor(json, 'status_color') as String?,
  labelList: (_labels(json, 'label_list') as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  sourceGet: _sourceGet(json, 'source_get') as String?,
  isVerifyRealEstate:
      _isVerifyRe(json, 'is_verify_real_estate') as bool? ?? false,
  isRequestSigning:
      _isRequestSigning(json, 'is_request_signing') as bool? ?? false,
);

Map<String, dynamic> _$PropertyToJson(_Property instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'address': instance.address,
  'price': instance.price,
  'price_display': instance.priceDisplay,
  'area': instance.area,
  'bedrooms': instance.bedrooms,
  'bathrooms': instance.bathrooms,
  'property_type_name': instance.propertyTypeName,
  'transaction_type': instance.transactionType,
  'image': instance.image,
  'slug': instance.slug,
  'status': instance.status,
  'status_activity_label': instance.statusActivityLabel,
  'status_activity': instance.statusActivity,
  'is_hot': instance.isHot,
  'real_estate_code': instance.code,
  'city': instance.city,
  'district': instance.district,
  'is_favorite': instance.isFavorite,
  'is_verified': instance.isVerified,
  'project_code': instance.projectCode,
  'parent_name': instance.parentName,
  'price_description': instance.priceDescription,
  'created_on': instance.createdOn,
  'status_name': instance.statusName,
  'status_color': instance.statusColor,
  'label_list': instance.labelList,
  'source_get': instance.sourceGet,
  'is_verify_real_estate': instance.isVerifyRealEstate,
  'is_request_signing': instance.isRequestSigning,
};
