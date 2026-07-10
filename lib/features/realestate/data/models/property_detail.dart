import '../../../../core/config/app_config.dart';
import '../../../../core/utils/json_parse.dart';
import 'property.dart';
import 'property_detail_parts.dart';

export 'property_detail_parts.dart';

/// Seller/owner shown on the property detail screen.
class Seller {
  const Seller({
    required this.name,
    required this.phone,
    this.email,
    this.avatar,
    this.rating,
  });

  final String name;
  final String phone;
  final String? email;
  final String? avatar;
  final double? rating;

  factory Seller.fromJson(Map data) => Seller(
        name: (data['full_name'] ?? data['name'] ?? '').toString(),
        phone: (data['phone'] ?? '').toString(),
        email: data['email']?.toString(),
        avatar:
            AppConfig.imageUrl((data['avatar'] ?? data['image'])?.toString()),
        rating: asDoubleOrNull(data['rating']),
      );
}

/// Full property detail. For browse it comes from `property.json`; for an
/// agent's own listing from `get_detail_real_estate.json` (data IS the product).
class PropertyDetail {
  const PropertyDetail({
    required this.id,
    required this.title,
    required this.address,
    this.description,
    this.htmlContent,
    this.price,
    this.priceDisplay,
    this.pricePerMeter,
    this.returnPrice,
    this.area,
    this.bedrooms,
    this.bathrooms,
    this.floors,
    this.direction,
    this.legalStatus,
    this.interior,
    this.propertyTypeName,
    this.transactionType,
    this.code,
    this.slug,
    this.statusName,
    this.statusCode,
    this.statusColor,
    this.statusActivityLabel,
    this.reasonReject,
    this.commissionPercent,
    this.commissionRates = const [],
    this.timeAgo,
    this.viewCount,
    this.isVerified = false,
    this.gallery = const [],
    this.videos = const [],
    this.legalDocs = const [],
    this.keyAttributes = const [],
    this.seller,
    this.verifiedByAgent,
    this.verifiedByAgentItems = const [],
    this.depositAllowed = false,
    this.lat,
    this.lng,
    this.realEstateSalesmanId,
    this.sourceGet,
    this.isVerifyRealEstate,
    this.isRequestSigning,
    this.verificationStage,
    // structured location (used to seed the edit form)
    this.cityId,
    this.cityName,
    this.districtId,
    this.districtName,
    this.wardId,
    this.wardName,
    this.streetName,
    this.propertyTypeId,
    this.houseDirection,
    this.balconyDirection,
    this.landDirection,
    this.legalDocumentType,
    this.furnitureName,
  });

  final int id;
  final String title;
  final String address;
  final String? description;
  final String? htmlContent;
  final double? price;
  final String? priceDisplay;
  final String? pricePerMeter;
  final double? returnPrice;
  final double? area;
  final int? bedrooms;
  final int? bathrooms;
  final int? floors;
  final String? direction;
  final String? legalStatus;
  final String? interior;
  final String? propertyTypeName;
  final int? transactionType;
  final String? code;
  final String? slug;
  final String? statusName;
  final String? statusCode;
  final String? statusColor;
  final String? statusActivityLabel;
  final String? reasonReject;
  final double? commissionPercent;
  final List<CommissionRate> commissionRates;
  final String? timeAgo;
  final int? viewCount;
  final bool isVerified;
  final List<String> gallery;
  final List<String> videos;
  final List<LegalDocFile> legalDocs;
  final List<KeyAttribute> keyAttributes;
  final Seller? seller;
  final VerifiedByAgentInfo? verifiedByAgent;
  final List<VerifiedByAgentItem> verifiedByAgentItems;
  final bool depositAllowed;
  final double? lat;
  final double? lng;
  final int? realEstateSalesmanId;
  final String? sourceGet;
  final bool? isVerifyRealEstate;
  final bool? isRequestSigning;
  final int? verificationStage;

  // structured location / type — seed for the edit form
  final String? cityId;
  final String? cityName;
  final String? districtId;
  final String? districtName;
  final String? wardId;
  final String? wardName;
  final String? streetName;
  final int? propertyTypeId;
  final String? houseDirection;
  final String? balconyDirection;
  final String? landDirection;
  final String? legalDocumentType;
  final String? furnitureName;

  String get priceText {
    if (priceDisplay != null && priceDisplay!.isNotEmpty) return priceDisplay!;
    return formatVnd(price);
  }

  String get transactionLabel => transactionType == 2 ? 'Cho thuê' : 'Bán';

  /// "120 m²" or empty when area is unknown.
  String get areaDisplay => area == null ? '' : '${area!.toInt()} m²';

  /// True when this listing belongs to the current agent (drives the footer).
  bool get isOwned => sourceGet != null && sourceGet!.isNotEmpty;

  bool get hasLatLng => lat != null && lng != null;

  /// Estimated commission amount = price × commissionPercent%.
  double? get commissionAmount {
    if (price == null || commissionPercent == null) return null;
    return price! * commissionPercent! / 100;
  }

  factory PropertyDetail.fromResponse(Map data) {
    final pd = (data['product_detail'] ?? data['product'] ?? data) as Map;

    Object? typeName() {
      final pt = pd['property_type'];
      if (pt is Map) return pt['name'];
      return pt ?? pd['property_type_name'];
    }

    final gallery = <String>[];
    void addImg(Object? v) {
      String? url;
      if (v is String) {
        url = v;
      } else if (v is Map) {
        url = (v['url'] ?? v['thumb'])?.toString();
      }
      final full = AppConfig.imageUrl(url);
      if (full != null) gallery.add(full);
    }

    final main = pd['main_image'];
    if (main != null && main.toString().isNotEmpty) addImg(main);
    final rawGallery = data['gallery'] ?? pd['gallery'] ?? pd['images'];
    if (rawGallery is List) {
      for (final g in rawGallery) {
        addImg(g);
      }
    }

    final videos = <String>[];
    final rawVideos = pd['video_url'] ?? pd['videos'];
    for (final v in asStringList(rawVideos)) {
      final full = AppConfig.imageUrl(v);
      if (full != null) videos.add(full);
    }

    final legalDocs = (pd['legal_document_file'] is List)
        ? (pd['legal_document_file'] as List)
            .whereType<Map>()
            .map(LegalDocFile.fromJson)
            .where((e) => e.hasUrl)
            .toList()
        : <LegalDocFile>[];

    final keyAttributes = (pd['key_attributes'] is List)
        ? (pd['key_attributes'] as List)
            .whereType<Map>()
            .map(KeyAttribute.fromJson)
            .where((e) => e.hasValue)
            .toList()
        : <KeyAttribute>[];

    final commissionRates = (pd['commissionRate'] is List)
        ? (pd['commissionRate'] as List)
            .whereType<Map>()
            .map(CommissionRate.fromJson)
            .toList()
        : <CommissionRate>[];

    final seller = _parseSeller(data, pd);

    double? commission;
    if (commissionRates.isNotEmpty) commission = commissionRates.first.rate;
    commission ??= asDoubleOrNull(pd['total_rate']);

    final status = pd['status_info'];
    final statusMap = status is Map ? status : const {};

    final rawVerified = pd['verified_by_agent_info'];
    final verifiedByAgent =
        rawVerified is Map ? VerifiedByAgentInfo.fromJson(rawVerified) : null;
    final verifiedItems = (pd['verified_by_agent_info_arr'] is List)
        ? (pd['verified_by_agent_info_arr'] as List)
            .whereType<Map>()
            .map(VerifiedByAgentItem.fromJson)
            .where((e) => e.hasLabel)
            .toList()
        : <VerifiedByAgentItem>[];

    return PropertyDetail(
      id: asInt(pd['id']),
      title: (pd['title'] ?? pd['name'] ?? '').toString(),
      address: (pd['street_address'] ?? pd['address'] ?? '').toString(),
      description: pd['description']?.toString(),
      htmlContent: pd['html_content']?.toString(),
      price: asDoubleOrNull(pd['price'] ?? pd['price_min']),
      priceDisplay:
          (pd['price_display'] ?? pd['price_description'])?.toString(),
      pricePerMeter: pd['price_per_meter']?.toString(),
      returnPrice: asDoubleOrNull(pd['return_price']),
      area: asDoubleOrNull(pd['area']),
      bedrooms: asIntOrNull(pd['bedrooms'] ?? pd['bedroom']),
      bathrooms: asIntOrNull(pd['bathrooms'] ?? pd['bathroom'] ?? pd['toilet']),
      floors: asIntOrNull(pd['floors'] ?? pd['floor'] ?? pd['num_of_floors']),
      direction: (pd['house_direction'] ?? pd['direction'])?.toString(),
      legalStatus: (pd['legal_document'] ?? pd['legal_status'] ?? pd['legal'])
          ?.toString(),
      interior: pd['interior']?.toString(),
      propertyTypeName: typeName()?.toString(),
      transactionType: asIntOrNull(pd['transaction_type']),
      code: (pd['real_estate_code'] ?? pd['code'])?.toString(),
      slug: pd['slug']?.toString(),
      statusName: statusMap['name']?.toString(),
      statusCode: statusMap['code']?.toString(),
      statusColor: statusMap['color']?.toString(),
      statusActivityLabel: pd['status_activity_label']?.toString(),
      reasonReject: pd['reason_reject']?.toString(),
      commissionPercent: commission,
      commissionRates: commissionRates,
      timeAgo: pd['time_ago']?.toString(),
      viewCount: asIntOrNull(pd['view_count']),
      isVerified: pd['is_verified'] == true ||
          pd['is_verified'] == 1 ||
          pd['is_verify_real_estate'] == true,
      gallery: gallery,
      videos: videos,
      legalDocs: legalDocs,
      keyAttributes: keyAttributes,
      seller: seller,
      verifiedByAgent: verifiedByAgent,
      verifiedByAgentItems: verifiedItems,
      depositAllowed: (pd['deposit'] is Map)
          ? (pd['deposit'] as Map)['allowed_to_deposit'] == true
          : false,
      lat: asDoubleOrNull(pd['lat']),
      lng: asDoubleOrNull(pd['lng'] ?? pd['long']),
      realEstateSalesmanId: asIntOrNull(pd['real_estate_salesman_id']),
      sourceGet: pd['source_get']?.toString(),
      isVerifyRealEstate: pd['is_verify_real_estate'] is bool
          ? pd['is_verify_real_estate'] as bool
          : null,
      isRequestSigning: pd['is_request_signing'] is bool
          ? pd['is_request_signing'] as bool
          : null,
      verificationStage: asIntOrNull(pd['verification_stage']),
      cityId: pd['city_id']?.toString(),
      cityName: pd['city']?.toString(),
      districtId: pd['district_id']?.toString(),
      districtName: pd['district']?.toString(),
      wardId: pd['ward_id']?.toString(),
      wardName: pd['ward']?.toString(),
      streetName: pd['street_name']?.toString(),
      propertyTypeId: asIntOrNull(pd['property_type_id']),
      houseDirection: pd['house_direction']?.toString(),
      balconyDirection: pd['balcony_direction']?.toString(),
      landDirection: pd['land_direction']?.toString(),
      legalDocumentType: pd['legal_document_type']?.toString(),
      furnitureName: (pd['furniture'] ?? pd['interior'])?.toString(),
    );
  }

  /// Seller: nested object → salesman[] array (real shape) → contact_* fields.
  static Seller? _parseSeller(Map data, Map pd) {
    final rawSeller = data['seller'] ?? pd['seller'] ?? pd['user'];
    if (rawSeller is Map) return Seller.fromJson(rawSeller);

    final salesmen = pd['salesman'];
    if (salesmen is List && salesmen.isNotEmpty && salesmen.first is Map) {
      final s = salesmen.first as Map;
      final res = s['real_estate_salesman'] is Map
          ? s['real_estate_salesman'] as Map
          : const {};
      final sm = s['salesman'] is Map ? s['salesman'] as Map : const {};
      final au = s['auth_user'] is Map ? s['auth_user'] as Map : const {};
      final name = (res['agent'] ?? sm['name'] ?? '').toString();
      final phone =
          (res['phone'] ?? sm['phone'] ?? pd['contact_phone'] ?? '').toString();
      if (name.isNotEmpty || phone.isNotEmpty) {
        return Seller(
          name: name,
          phone: phone,
          avatar: AppConfig.imageUrl(au['image']?.toString()),
        );
      }
    }
    if ((pd['contact_phone'] ?? pd['hotline']) != null) {
      return Seller(
        name: (pd['contact_name'] ?? '').toString(),
        phone: (pd['contact_phone'] ?? pd['hotline'] ?? '').toString(),
        email: pd['contact_email']?.toString(),
      );
    }
    return null;
  }
}
