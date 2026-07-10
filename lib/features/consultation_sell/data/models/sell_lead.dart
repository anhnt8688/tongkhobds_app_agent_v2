import '../../../../core/utils/json_parse.dart';
import '../../../../core/widgets/status_pill.dart';

/// Nhu cầu bán (consultation_sell) status.
enum SellStatus {
  newd('new', 'Mới', StatusTone.blue),
  pending('pending', 'Chờ xử lý', StatusTone.amber),
  consulting('consulting', 'Đang tư vấn', StatusTone.blue),
  closed('closed', 'Đã đóng', StatusTone.neutral);

  const SellStatus(this.api, this.label, this.tone);
  final String api;
  final String label;
  final StatusTone tone;

  static SellStatus? fromApi(String? v) {
    for (final s in values) {
      if (s.api == v) return s;
    }
    return null;
  }
}

/// Transaction type codes (consultation_sell.transaction_type_id).
const kSellTransactionTypes = {1: 'Mua bán', 2: 'Cho thuê'};

/// Lead source options.
const kSellSources = [
  'Website', 'Facebook', 'Zalo', 'CTV', 'App', 'CMS', 'Tongkho', 'Crawl'
];

/// House direction options.
const kHouseDirections = [
  'Đông', 'Tây', 'Nam', 'Bắc', 'Đông Bắc', 'Đông Nam', 'Tây Bắc', 'Tây Nam'
];

/// Legal document options.
const kLegalDocuments = [
  'Sổ hồng', 'Sổ đỏ', 'Giấy tay', 'Hợp đồng mua bán', 'Đang xin giấy', 'Khác'
];

class SellTag {
  const SellTag({required this.id, required this.name, this.color});
  final int id;
  final String name;
  final String? color;
  factory SellTag.fromJson(Map d) => SellTag(
        id: asInt(d['tag_id'] ?? d['id']),
        name: (d['tag_name'] ?? d['name'] ?? '').toString(),
        color: (d['tag_color'] ?? d['color'])?.toString(),
      );
}

class StatusCount {
  const StatusCount({required this.status, this.count = 0, this.label});
  final String status;
  final int count;
  final String? label;
  factory StatusCount.fromJson(Map d) => StatusCount(
        status: (d['status'] ?? d['demand_status'] ?? '').toString(),
        count: asInt(d['count']),
        label: d['label']?.toString(),
      );
}

class ListingManager {
  const ListingManager(
      {required this.id, required this.name, this.phone, this.officeName});
  final int id;
  final String name;
  final String? phone;
  final String? officeName;

  /// `get_listing_managers_by_post_office` returns each person already
  /// flattened in `data.flat_list[]`, tagged `is_listing_manager` (org-tree
  /// header nodes like "TP 1" carry `false` and must be filtered out).
  static bool isListingManager(Map d) => d['is_listing_manager'] == true;

  factory ListingManager.fromJson(Map d) => ListingManager(
        id: asInt(d['id']),
        name: (d['full_name'] ?? d['name'] ?? '').toString(),
        phone: d['phone']?.toString(),
        officeName: (d['office_name'] ?? d['post_office_name'])?.toString(),
      );
}

/// `SELL_DEMAND_*` action gates returned in the top-level `permissions` map of
/// `list_consultation_sell` (not per-item). Same flexible-bool-parse pattern as
/// `VerificationPermissions`.
class SellPermissions {
  const SellPermissions({
    this.activity = false,
    this.edit = false,
    this.createVerify = false,
    this.list = false,
    this.close = false,
    this.assignListing = false,
    this.addSales = false,
    this.addOffice = false,
    this.createContract = false,
    this.createListing = false,
    this.editSales = false,
    this.add = false,
    this.addTag = false,
    this.export = false,
  });
  final bool activity;
  final bool edit;
  final bool createVerify;
  final bool list;
  final bool close;
  final bool assignListing;
  final bool addSales;
  final bool addOffice;
  final bool createContract;
  final bool createListing;
  final bool editSales;
  final bool add;
  final bool addTag;
  final bool export;

  factory SellPermissions.fromJson(Map d) {
    bool b(dynamic v) {
      if (v == null) return false;
      if (v is bool) return v;
      if (v is num) return v != 0;
      final n = v.toString().trim().toLowerCase();
      return n == 'true' || n == '1';
    }

    return SellPermissions(
      activity: b(d['SELL_DEMAND_ACTIVITY']),
      edit: b(d['SELL_DEMAND_EDIT']),
      createVerify: b(d['SELL_DEMAND_CREATE_VERIFY']),
      list: b(d['SELL_DEMAND_LIST']),
      close: b(d['SELL_DEMAND_CLOSE']),
      assignListing: b(d['SELL_DEMAND_ASSIGN_LISTING']),
      addSales: b(d['SELL_DEMAND_ADD_SALES']),
      addOffice: b(d['SELL_DEMAND_ADD_OFFICE']),
      createContract: b(d['SELL_DEMAND_CREATE_CONTRACT']),
      createListing: b(d['SELL_DEMAND_CREATE_LISTING']),
      editSales: b(d['SELL_DEMAND_EDIT_SALES']),
      add: b(d['SELL_DEMAND_ADD']),
      addTag: b(d['SELL_DEMAND_ADD_TAG']),
      export: b(d['SELL_DEMAND_EXPORT']),
    );
  }
}

class SellOffice {
  const SellOffice({required this.id, required this.name});
  final int id;
  final String name;
  factory SellOffice.fromJson(Map d) =>
      SellOffice(id: asInt(d['id']), name: (d['name'] ?? '').toString());
}

class SellPropertyType {
  const SellPropertyType({required this.id, required this.name});
  final int id;
  final String name;
  factory SellPropertyType.fromJson(Map d) => SellPropertyType(
      id: asInt(d['id']), name: (d['name'] ?? d['title'] ?? '').toString());
}

/// A nhu-cau-ban list item.
class SellLead {
  const SellLead({
    required this.id,
    this.code,
    this.status,
    this.customerName,
    this.customerPhone,
    this.propertyTypeName,
    this.area,
    this.price,
    this.address,
    this.cityName,
    this.districtName,
    this.wardName,
    this.listingManagerName,
    this.source,
    this.officeName,
    this.supportName,
    this.tags = const [],
    this.updatedOn,
    this.createdOn,
  });

  final int id;
  final String? code;
  final String? status;
  final String? customerName;
  final String? customerPhone;
  final String? propertyTypeName;
  final num? area;
  final double? price;
  final String? address;
  final String? cityName;
  final String? districtName;
  final String? wardName;
  final String? listingManagerName;
  final String? source;
  final String? officeName;
  final String? supportName;
  final List<SellTag> tags;
  final String? updatedOn;
  final String? createdOn;

  SellStatus? get statusEnum => SellStatus.fromApi(status);
  String get statusLabel => statusEnum?.label ?? (status ?? '');

  String get fullAddress {
    final parts = [address, wardName, districtName, cityName]
        .map((e) => (e ?? '').trim())
        .where((e) => e.isNotEmpty)
        .toList();
    return parts.join(', ');
  }

  factory SellLead.fromJson(Map d) {
    final lm = d['listing_manager'];
    final support = d['user_support'] ?? d['salesman_support'];
    return SellLead(
      id: asInt(d['id']),
      code: (d['demand_code'] ?? d['code'])?.toString(),
      status: (d['demand_status'] ?? d['status'])?.toString(),
      customerName: (d['customer_name'] ??
              (d['customer'] is Map ? d['customer']['name'] : null))
          ?.toString(),
      customerPhone: (d['customer_phone'] ??
              (d['customer'] is Map ? d['customer']['phone'] : null))
          ?.toString(),
      propertyTypeName: d['property_type_name']?.toString(),
      area: asDoubleOrNull(d['area']),
      price: asDoubleOrNull(d['price']),
      address: d['address']?.toString(),
      cityName: d['city_name']?.toString(),
      districtName: d['district_name']?.toString(),
      wardName: d['ward_name']?.toString(),
      listingManagerName: lm is Map
          ? lm['name']?.toString()
          : d['listing_manager_name']?.toString(),
      source: d['source']?.toString(),
      officeName: d['office_name']?.toString(),
      supportName: support is Map ? support['name']?.toString() : null,
      tags: (d['tags'] is List ? d['tags'] as List : const [])
          .whereType<Map>()
          .map(SellTag.fromJson)
          .where((t) => t.name.isNotEmpty)
          .toList(),
      updatedOn: d['updated_on']?.toString(),
      createdOn: d['created_on']?.toString(),
    );
  }
}

class SellPersonRef {
  const SellPersonRef({required this.id, this.name, this.phone});
  final int id;
  final String? name;
  final String? phone;
  factory SellPersonRef.fromJson(Map d) => SellPersonRef(
        id: asInt(d['id']),
        name: d['name']?.toString(),
        phone: d['phone']?.toString(),
      );
}

/// The tin đăng (`real_estate`) linked to a sell lead — top-level sibling of
/// `verifying_real_estate_salesman`/`contract` in `get_consultation_sell`, not
/// nested inside either.
class SellRealEstateRef {
  const SellRealEstateRef({
    required this.id,
    this.code,
    this.title,
    this.price,
    this.priceDescription,
    this.area,
    this.mainImage,
  });

  final int id;
  final String? code;
  final String? title;
  final double? price;
  final String? priceDescription;
  final num? area;
  final String? mainImage;

  factory SellRealEstateRef.fromJson(Map d) => SellRealEstateRef(
        id: asInt(d['id']),
        code: d['real_estate_code']?.toString(),
        title: d['title']?.toString(),
        price: asDoubleOrNull(d['price']),
        priceDescription: d['price_description']?.toString(),
        area: asDoubleOrNull(d['area']),
        mainImage: (d['main_image'] ??
                (d['images'] is List && (d['images'] as List).isNotEmpty
                    ? (d['images'] as List).first
                    : null))
            ?.toString(),
      );
}

/// The xác thực (`verifying_real_estate_salesman`) linked to a sell lead.
/// `realEstateSalesmanId` doubles as the id `fetchVerificationDetail`/
/// `VerificationItem` expect (verified against `detail_footer.dart`'s working
/// "Yêu cầu xác thực" flow — same field feeds both).
class SellVerificationRef {
  const SellVerificationRef({
    required this.realEstateSalesmanId,
    this.realEstateId,
    this.realEstateTitle,
    this.realEstateCode,
    this.verificationStatus,
    this.verificationName,
    this.verificationColor,
    this.verificationTypeName,
    this.isOwner = false,
  });

  final int realEstateSalesmanId;
  final int? realEstateId;
  final String? realEstateTitle;
  final String? realEstateCode;
  final int? verificationStatus;
  final String? verificationName;
  final String? verificationColor;
  final String? verificationTypeName;
  final bool isOwner;

  /// `verification_status == 2` → "Đã duyệt" in the sample payload.
  bool get isApproved => verificationStatus == 2;

  factory SellVerificationRef.fromJson(Map d) => SellVerificationRef(
        realEstateSalesmanId: asInt(d['real_estate_salesman_id']),
        realEstateId: asIntOrNull(d['real_estate_id']),
        realEstateTitle: d['real_estate_title']?.toString(),
        realEstateCode: d['real_estate_code']?.toString(),
        verificationStatus: asIntOrNull(d['verification_status']),
        verificationName: d['verification_name']?.toString(),
        verificationColor: d['verification_color']?.toString(),
        verificationTypeName: d['verification_type_name']?.toString(),
        isOwner: d['is_owner'] == true,
      );
}

/// The HĐ trích thưởng (`contract`) linked to a sell lead.
class SellContractRef {
  const SellContractRef({
    required this.id,
    this.contractCode,
    this.statusName,
    this.statusColor,
    this.officeName,
    this.contractTypeName,
  });

  final int id;
  final String? contractCode;
  final String? statusName;
  final String? statusColor;
  final String? officeName;
  final String? contractTypeName;

  factory SellContractRef.fromJson(Map d) => SellContractRef(
        id: asInt(d['id']),
        contractCode: d['contract_code']?.toString(),
        statusName: d['status_name']?.toString(),
        statusColor: d['status_color']?.toString(),
        officeName: d['office_name']?.toString(),
        contractTypeName: d['contract_type_name']?.toString(),
      );
}

/// Full nhu-cau-ban detail.
class SellLeadDetail {
  const SellLeadDetail({
    required this.id,
    this.code,
    this.status,
    this.customerName,
    this.customerPhone,
    this.customerEmail,
    this.transactionTypeId,
    this.propertyTypeId,
    this.propertyTypeName,
    this.area,
    this.price,
    this.address,
    this.cityName,
    this.districtName,
    this.wardName,
    this.bedrooms,
    this.bathrooms,
    this.floors,
    this.houseDirection,
    this.legalDocument,
    this.note,
    this.source,
    this.officeName,
    this.listingManager,
    this.salesmanSupport,
    this.realEstateRef,
    this.verificationRef,
    this.contractRef,
    this.tags = const [],
    this.createdOn,
    this.raw = const {},
  });

  final int id;
  final String? code;
  final String? status;
  final String? customerName;
  final String? customerPhone;
  final String? customerEmail;
  final int? transactionTypeId;
  final int? propertyTypeId;
  final String? propertyTypeName;
  final num? area;
  final double? price;
  final String? address;
  final String? cityName;
  final String? districtName;
  final String? wardName;
  final int? bedrooms;
  final int? bathrooms;
  final int? floors;
  final String? houseDirection;
  final String? legalDocument;
  final String? note;
  final String? source;
  final String? officeName;
  final SellPersonRef? listingManager;
  final SellPersonRef? salesmanSupport;
  final SellRealEstateRef? realEstateRef;
  final SellVerificationRef? verificationRef;
  final SellContractRef? contractRef;
  final List<SellTag> tags;
  final String? createdOn;
  final Map raw;

  SellStatus? get statusEnum => SellStatus.fromApi(status);
  String get statusLabel => statusEnum?.label ?? (status ?? '');
  bool get isClosed => statusEnum == SellStatus.closed;
  bool get hasListingManager => listingManager != null;
  bool get hasLinkedRealEstate => realEstateRef != null;
  String? get transactionLabel =>
      transactionTypeId == null ? null : kSellTransactionTypes[transactionTypeId];

  String get fullAddress {
    final parts = [address, wardName, districtName, cityName]
        .map((e) => (e ?? '').trim())
        .where((e) => e.isNotEmpty)
        .toList();
    return parts.join(', ');
  }

  factory SellLeadDetail.fromJson(Map d) {
    final customer = d['customer'];
    final lm = d['listing_manager'];
    final support = d['user_support'] ?? d['salesman_support'];
    final re = d['real_estate'];
    final verify = d['verifying_real_estate_salesman'];
    final contract = d['contract'];

    return SellLeadDetail(
      id: asInt(d['id']),
      code: (d['demand_code'] ?? d['code'])?.toString(),
      status: (d['demand_status'] ?? d['status'])?.toString(),
      customerName: (d['customer_name'] ??
              (customer is Map ? customer['name'] : null))
          ?.toString(),
      customerPhone: (d['customer_phone'] ??
              (customer is Map ? customer['phone'] : null))
          ?.toString(),
      customerEmail:
          (customer is Map ? customer['email'] : d['customer_email'])?.toString(),
      transactionTypeId: asIntOrNull(d['transaction_type_id']),
      propertyTypeId: asIntOrNull(d['property_type_id']),
      propertyTypeName: d['property_type_name']?.toString(),
      area: asDoubleOrNull(d['area']),
      price: asDoubleOrNull(d['price']),
      address: d['address']?.toString(),
      cityName: d['city_name']?.toString(),
      districtName: d['district_name']?.toString(),
      wardName: d['ward_name']?.toString(),
      bedrooms: asIntOrNull(d['bedrooms']),
      bathrooms: asIntOrNull(d['bathrooms']),
      floors: asIntOrNull(d['floors']),
      houseDirection: d['house_direction']?.toString(),
      legalDocument: d['legal_document']?.toString(),
      note: d['note']?.toString(),
      source: d['source']?.toString(),
      officeName: d['office_name']?.toString(),
      listingManager: lm is Map ? SellPersonRef.fromJson(lm) : null,
      salesmanSupport: support is Map ? SellPersonRef.fromJson(support) : null,
      realEstateRef: re is Map ? SellRealEstateRef.fromJson(re) : null,
      verificationRef:
          verify is Map ? SellVerificationRef.fromJson(verify) : null,
      contractRef: contract is Map ? SellContractRef.fromJson(contract) : null,
      tags: (d['tags'] is List ? d['tags'] as List : const [])
          .whereType<Map>()
          .map(SellTag.fromJson)
          .where((t) => t.name.isNotEmpty)
          .toList(),
      createdOn: d['created_on']?.toString(),
      raw: d,
    );
  }
}

class PagedSellLeads {
  const PagedSellLeads(
      {required this.items, this.total = 0, this.page = 1, this.hasMore = false});
  final List<SellLead> items;
  final int total;
  final int page;
  final bool hasMore;
}
