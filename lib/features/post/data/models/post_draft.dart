import 'dart:convert';

import 'form_field_spec.dart';

/// Immutable draft of a new listing across the 4-step wizard. Field set and the
/// [toListing] payload mirror v1's `CreatePostRequest` / `createPost`.
class PostDraft {
  const PostDraft({
    this.realEstateId = 0, // > 0 khi đang sửa tin (edit)
    this.sellLeadId, // set khi mở từ "Tin đăng" task của 1 nhu cầu bán
    this.transactionType = 1, // 1 = bán, 2 = cho thuê
    this.propertyTypeId,
    this.propertyTypeName = '',
    this.title = '',
    this.description = '',
    this.htmlContent = '',
    this.price,
    this.returnPrice,
    this.area,
    // structured location
    this.cityId = '',
    this.cityName = '',
    this.districtId = '',
    this.districtName = '',
    this.wardId = '',
    this.wardName = '',
    this.lat,
    this.lng,
    this.addressDetail = '',
    this.streetName = '',
    // counters
    this.bedrooms = 0,
    this.bathrooms = 0,
    this.floors = 0,
    this.numOfFloors = 0,
    this.floorBlock = 0,
    // directions / pickers
    this.houseDirection = '',
    this.balconyDirection = '',
    this.landDirection = '',
    this.legalDocumentType = '',
    this.furnitureName = '',
    // dynamic text fields keyed by field `type`
    this.extraFields = const {},
    this.fields = const [],
    // media
    this.images = const [],
    this.videos = const [],
    this.legalDocs = const [],
    // commission
    this.commissionMin,
    this.commissionMax,
    this.commissionEditable = true,
    this.commissionTitle = '',
    this.commissionDescription = '',
    this.rose = '',
    this.saveStatus,
    // transient flags
    this.uploading = false,
    this.generating = false,
    this.submitting = false,
    this.loadingFields = false,
  });

  final int realEstateId;
  final int? sellLeadId;
  final int transactionType;
  final int? propertyTypeId;
  final String propertyTypeName;
  final String title;
  final String description;
  final String htmlContent;
  final double? price;
  final double? returnPrice;
  final double? area;

  final String cityId;
  final String cityName;
  final String districtId;
  final String districtName;
  final String wardId;
  final String wardName;
  final double? lat;
  final double? lng;
  final String addressDetail;
  final String streetName;

  final int bedrooms;
  final int bathrooms;
  final int floors;
  final int numOfFloors;
  final int floorBlock;

  final String houseDirection;
  final String balconyDirection;
  final String landDirection;
  final String legalDocumentType;
  final String furnitureName;

  final Map<String, String> extraFields;
  final List<FormFieldSpec> fields;

  final List<String> images;
  final List<String> videos;
  final List<String> legalDocs;

  final double? commissionMin;
  final double? commissionMax;
  final bool commissionEditable;
  final String commissionTitle;
  final String commissionDescription;
  final String rose;
  final String? saveStatus;

  final bool uploading;
  final bool generating;
  final bool submitting;
  final bool loadingFields;

  /// "Phường, Quận, Tỉnh" trimmed to the deepest chosen level.
  String get locationLabel => [wardName, districtName, cityName]
      .where((e) => e.trim().isNotEmpty)
      .join(', ');

  /// Full street address = detail + administrative label.
  String get fullAddress => [addressDetail.trim(), locationLabel]
      .where((e) => e.isNotEmpty)
      .join(', ');

  bool get hasLocation => cityName.trim().isNotEmpty;

  /// Mirrors v1 `isStepOneValid`.
  bool get step1Valid =>
      title.trim().isNotEmpty &&
      (description.trim().isNotEmpty || htmlContent.trim().isNotEmpty) &&
      propertyTypeId != null &&
      area != null &&
      price != null &&
      hasLocation;

  /// Mirrors v1 `isStepTwoValid` (≥ 4 images).
  bool get step2Valid => images.length >= 4;

  /// Builds the `save_real_estate.json` payload (v1 parity); entries that are
  /// null / blank / zero are dropped, matching v1's filter.
  Map<String, dynamic> toListing() {
    final raw = <String, dynamic>{
      // id > 0 → cập nhật tin (edit); 0 bị lọc bỏ → backend tạo mới.
      'id': realEstateId,
      'title': title.trim(),
      'price': price?.toInt(),
      'return_price': returnPrice?.toInt(),
      'property_type_id': propertyTypeId,
      'description': description.trim(),
      'html_content': htmlContent.isNotEmpty ? htmlContent : description.trim(),
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'floors': floors,
      'num_of_floors': numOfFloors,
      'floor_block': floorBlock,
      'house_direction': houseDirection,
      'balcony_direction': balconyDirection,
      'land_direction': landDirection,
      'transaction_type': transactionType,
      'city': cityName,
      'district': districtName,
      'ward': wardName,
      'city_id': cityId,
      'district_id': districtId,
      'ward_id': wardId,
      'street_name': streetName,
      'street_address': fullAddress,
      'area': area?.toInt(),
      'legal_document_type': legalDocumentType,
      'furniture': furnitureName,
      'images': images.isNotEmpty ? jsonEncode(images) : '',
      'main_image': images.isNotEmpty ? images.first : '',
      'video_url': videos.isNotEmpty ? jsonEncode(videos) : '',
      'legal_document_url': legalDocs.isNotEmpty ? legalDocs.first : '',
      'latlng': (lat != null && lng != null) ? '$lat, $lng' : '',
      'save_status': saveStatus,
      'total_rate': rose.trim(),
      ...extraFields,
    };
    // v1 parity: drop null / blank / numeric-zero, then send EVERY value as a
    // String — the Web2py backend is loosely typed and rejects native JSON
    // numbers in this payload, so stringifying is required (not cosmetic).
    final out = <String, dynamic>{};
    raw.forEach((k, v) {
      if (v == null) return;
      if (v.toString().trim().isEmpty) return;
      if (v == 0) return; // numeric zero dropped; a string "0" is kept (v1)
      out[k] = v.toString();
    });
    return out;
  }

  bool get isEdit => realEstateId > 0;

  PostDraft copyWith({
    int? realEstateId,
    int? sellLeadId,
    int? transactionType,
    int? propertyTypeId,
    String? propertyTypeName,
    String? title,
    String? description,
    String? htmlContent,
    double? price,
    double? returnPrice,
    double? area,
    String? cityId,
    String? cityName,
    String? districtId,
    String? districtName,
    String? wardId,
    String? wardName,
    double? lat,
    double? lng,
    String? addressDetail,
    String? streetName,
    int? bedrooms,
    int? bathrooms,
    int? floors,
    int? numOfFloors,
    int? floorBlock,
    String? houseDirection,
    String? balconyDirection,
    String? landDirection,
    String? legalDocumentType,
    String? furnitureName,
    Map<String, String>? extraFields,
    List<FormFieldSpec>? fields,
    List<String>? images,
    List<String>? videos,
    List<String>? legalDocs,
    double? commissionMin,
    double? commissionMax,
    bool? commissionEditable,
    String? commissionTitle,
    String? commissionDescription,
    String? rose,
    String? saveStatus,
    bool? uploading,
    bool? generating,
    bool? submitting,
    bool? loadingFields,
    bool clearPropertyType = false,
    bool clearPrice = false,
    bool clearReturnPrice = false,
    bool clearArea = false,
  }) {
    return PostDraft(
      realEstateId: realEstateId ?? this.realEstateId,
      sellLeadId: sellLeadId ?? this.sellLeadId,
      transactionType: transactionType ?? this.transactionType,
      propertyTypeId:
          clearPropertyType ? null : (propertyTypeId ?? this.propertyTypeId),
      propertyTypeName: propertyTypeName ?? this.propertyTypeName,
      title: title ?? this.title,
      description: description ?? this.description,
      htmlContent: htmlContent ?? this.htmlContent,
      price: clearPrice ? null : (price ?? this.price),
      returnPrice: clearReturnPrice ? null : (returnPrice ?? this.returnPrice),
      area: clearArea ? null : (area ?? this.area),
      cityId: cityId ?? this.cityId,
      cityName: cityName ?? this.cityName,
      districtId: districtId ?? this.districtId,
      districtName: districtName ?? this.districtName,
      wardId: wardId ?? this.wardId,
      wardName: wardName ?? this.wardName,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      addressDetail: addressDetail ?? this.addressDetail,
      streetName: streetName ?? this.streetName,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      floors: floors ?? this.floors,
      numOfFloors: numOfFloors ?? this.numOfFloors,
      floorBlock: floorBlock ?? this.floorBlock,
      houseDirection: houseDirection ?? this.houseDirection,
      balconyDirection: balconyDirection ?? this.balconyDirection,
      landDirection: landDirection ?? this.landDirection,
      legalDocumentType: legalDocumentType ?? this.legalDocumentType,
      furnitureName: furnitureName ?? this.furnitureName,
      extraFields: extraFields ?? this.extraFields,
      fields: fields ?? this.fields,
      images: images ?? this.images,
      videos: videos ?? this.videos,
      legalDocs: legalDocs ?? this.legalDocs,
      commissionMin: commissionMin ?? this.commissionMin,
      commissionMax: commissionMax ?? this.commissionMax,
      commissionEditable: commissionEditable ?? this.commissionEditable,
      commissionTitle: commissionTitle ?? this.commissionTitle,
      commissionDescription:
          commissionDescription ?? this.commissionDescription,
      rose: rose ?? this.rose,
      saveStatus: saveStatus ?? this.saveStatus,
      uploading: uploading ?? this.uploading,
      generating: generating ?? this.generating,
      submitting: submitting ?? this.submitting,
      loadingFields: loadingFields ?? this.loadingFields,
    );
  }
}
