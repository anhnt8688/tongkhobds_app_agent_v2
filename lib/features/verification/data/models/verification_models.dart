import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/utils/json_parse.dart';

// ───────────────────────── status stage utils (v1 verification_status_utils) ─────────────────────────

enum VerificationRecordStage {
  pendingAssign,
  pendingConfirm,
  pendingApproval,
  approved,
  rejected,
  unknown,
}

VerificationRecordStage verificationRecordStageFromLabel(String? label) {
  switch ((label ?? '').trim()) {
    case 'Chờ gán':
      return VerificationRecordStage.pendingAssign;
    case 'Chờ xác nhận':
    case 'Chờ xác thực':
      return VerificationRecordStage.pendingConfirm;
    case 'Chờ phê duyệt':
    case 'Chờ duyệt':
      return VerificationRecordStage.pendingApproval;
    case 'Thành công':
    case 'Đã duyệt':
      return VerificationRecordStage.approved;
    case 'Từ chối':
      return VerificationRecordStage.rejected;
    default:
      return VerificationRecordStage.unknown;
  }
}

String verificationRecordStageLabel(VerificationRecordStage stage) {
  switch (stage) {
    case VerificationRecordStage.pendingAssign:
      return 'Chờ gán';
    case VerificationRecordStage.pendingConfirm:
      return 'Chờ xác nhận';
    case VerificationRecordStage.pendingApproval:
      return 'Chờ duyệt';
    case VerificationRecordStage.approved:
      return 'Thành công';
    case VerificationRecordStage.rejected:
      return 'Từ chối';
    case VerificationRecordStage.unknown:
      return 'Chưa xác thực';
  }
}

String normalizeVerificationRecordLabel(String? label) =>
    verificationRecordStageLabel(verificationRecordStageFromLabel(label));

// ───────────────────────── legal doc type (v1 real_estate_verification_item) ─────────────────────────

enum LegalDocType { redBook, contract, other }

extension LegalDocTypeX on LegalDocType {
  String get title {
    switch (this) {
      case LegalDocType.redBook:
        return 'Hợp đồng / Bìa đỏ';
      case LegalDocType.contract:
        return 'Hợp đồng mua bán';
      case LegalDocType.other:
        return 'Thông tin pháp lý khác';
    }
  }

  /// Backend `contract_type` value.
  String get apiValue {
    switch (this) {
      case LegalDocType.redBook:
        return '1';
      case LegalDocType.contract:
        return '2';
      case LegalDocType.other:
        return '3';
    }
  }
}

// ───────────────────────── UI list item ─────────────────────────

/// Flattened item the list + detail/article entry points consume.
class VerificationItem {
  final int id;
  final String title;
  final String location;
  final String price;
  final String area;
  final String status;
  final String date;
  final String imageUrl;
  final Color accent;
  final Color cardToneA;
  final Color cardToneB;
  final int salesmanId;
  final String salesmanName;
  final String agentSupportName;
  final String assignedToName;
  final String owner;
  final String company;

  const VerificationItem({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    required this.area,
    required this.status,
    required this.date,
    required this.imageUrl,
    required this.accent,
    required this.cardToneA,
    required this.cardToneB,
    required this.salesmanId,
    required this.salesmanName,
    required this.agentSupportName,
    required this.assignedToName,
    required this.owner,
    required this.company,
  });

  VerificationItem copyWith({
    String? assignedToName,
    String? agentSupportName,
  }) {
    return VerificationItem(
      id: id,
      title: title,
      location: location,
      price: price,
      area: area,
      status: status,
      date: date,
      imageUrl: imageUrl,
      accent: accent,
      cardToneA: cardToneA,
      cardToneB: cardToneB,
      salesmanId: salesmanId,
      salesmanName: salesmanName,
      agentSupportName: agentSupportName ?? this.agentSupportName,
      assignedToName: assignedToName ?? this.assignedToName,
      owner: owner,
      company: company,
    );
  }
}

Color parseHexColor(String value, {Color fallback = const Color(0xFFFB923C)}) {
  final hex = value.trim().replaceAll('#', '');
  if (hex.length != 6) return fallback;
  final v = int.tryParse('FF$hex', radix: 16);
  return v == null ? fallback : Color(v);
}

// ───────────────────────── status filter ─────────────────────────

class VerificationStatusFilter {
  final int id;
  final String name;
  final String code;
  final String description;

  const VerificationStatusFilter({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
  });

  factory VerificationStatusFilter.fromJson(Map json) => VerificationStatusFilter(
        id: asInt(json['id']),
        name: asString(json['name']),
        code: asString(json['code']),
        description: asString(json['description']),
      );
}

// ───────────────────────── list item + response ─────────────────────────

class VerificationRealEstateBrief {
  final int id;
  final String realEstateCode;
  final String title;
  final int price;
  final double? area;
  final String city;
  final String district;
  final String ward;
  final String image;

  const VerificationRealEstateBrief({
    required this.id,
    required this.realEstateCode,
    required this.title,
    required this.price,
    required this.area,
    required this.city,
    required this.district,
    required this.ward,
    required this.image,
  });

  factory VerificationRealEstateBrief.fromJson(Map json) =>
      VerificationRealEstateBrief(
        id: asInt(json['id']),
        realEstateCode: asString(json['real_estate_code']),
        title: asString(json['title']),
        price: asInt(json['price']),
        area: asDoubleOrNull(json['area']),
        city: asString(json['city']),
        district: asString(json['district']),
        ward: asString(json['ward']),
        image: asString(
            json['image'] ?? json['main_image'] ?? json['avatar']),
      );
}

class VerificationSalesmanBrief {
  final int id;
  final String name;
  final String phone;
  final String? avatar;

  const VerificationSalesmanBrief({
    required this.id,
    required this.name,
    required this.phone,
    required this.avatar,
  });

  factory VerificationSalesmanBrief.fromJson(Map json) => VerificationSalesmanBrief(
        id: asInt(json['id']),
        name: asString(json['name']),
        phone: asString(json['phone']),
        avatar: json['avatar']?.toString(),
      );
}

class VerificationAgentSupportBrief {
  final int id;
  final String name;
  final String phone;

  const VerificationAgentSupportBrief({
    required this.id,
    required this.name,
    required this.phone,
  });

  factory VerificationAgentSupportBrief.fromJson(Map json) =>
      VerificationAgentSupportBrief(
        id: asInt(json['id']),
        name: asString(json['name']),
        phone: asString(json['phone']),
      );
}

class VerificationMediaFile {
  final int id;
  final String url;

  const VerificationMediaFile({required this.id, required this.url});

  factory VerificationMediaFile.fromJson(Map json) => VerificationMediaFile(
        id: asInt(json['id']),
        url: asString(json['url']).trim(),
      );

  static List<VerificationMediaFile> listFromJson(dynamic value) {
    if (value is! List) return const [];
    return value
        .whereType<Map>()
        .map(VerificationMediaFile.fromJson)
        .where((e) => e.url.isNotEmpty)
        .toList();
  }
}

class VerificationLegalInfoBrief {
  final String? ownerNameFirst;
  final String? idCardFirst;
  final String? ownerNameSecond;
  final String? idCardSecond;
  final String? certificateNumber;
  final String? numberBook;
  final String? issuedDate;
  final String? contractNumber;
  final String? contractSignedDate;
  final String? sellerName;
  final String? buyerCompany;
  final String? verificationNotes;
  final List<VerificationMediaFile> redBookPhotos;
  final List<VerificationMediaFile> contractMedia;
  final List<VerificationMediaFile> otherMedia;

  const VerificationLegalInfoBrief({
    this.ownerNameFirst,
    this.idCardFirst,
    this.ownerNameSecond,
    this.idCardSecond,
    this.certificateNumber,
    this.numberBook,
    this.issuedDate,
    this.contractNumber,
    this.contractSignedDate,
    this.sellerName,
    this.buyerCompany,
    this.verificationNotes,
    this.redBookPhotos = const [],
    this.contractMedia = const [],
    this.otherMedia = const [],
  });

  factory VerificationLegalInfoBrief.fromJson(Map json) {
    String? s(dynamic v) {
      if (v == null) return null;
      final t = v.toString().trim();
      return t.isEmpty ? null : t;
    }

    return VerificationLegalInfoBrief(
      ownerNameFirst: s(json['owner_name_first']),
      idCardFirst: s(json['id_card_first']),
      ownerNameSecond: s(json['owner_name_second']),
      idCardSecond: s(json['id_card_second']),
      certificateNumber: s(json['certificate_number']),
      numberBook: s(json['number_book']),
      issuedDate: s(json['issued_date']),
      contractNumber: s(json['contract_number']),
      contractSignedDate: s(json['contract_signed_date']),
      sellerName: s(json['seller_name']),
      buyerCompany: s(json['buyer_company']),
      verificationNotes: s(json['verification_notes']),
      redBookPhotos: VerificationMediaFile.listFromJson(json['red_book_photos']),
      contractMedia: VerificationMediaFile.listFromJson(
          json['contract_media_ids'] ?? json['contract_media']),
      otherMedia: VerificationMediaFile.listFromJson(
          json['other_media_ids'] ?? json['other_media']),
    );
  }
}

class VerificationSalesmanListItem {
  final int id;
  final int verificationStatus;
  final int status;
  final String statusName;
  final String statusColor;
  final String? createdVerificationAt;
  final String? verifiedAt;
  final String? verifiedByName;
  final bool verifiedWithOwner;
  final String? realEstateValue;
  final String? brokerageFeeValue;
  final String? postOfficeName;
  final VerificationRealEstateBrief realEstate;
  final VerificationSalesmanBrief salesman;
  final VerificationAgentSupportBrief? agentSupport;
  final String? assignedToName;

  const VerificationSalesmanListItem({
    required this.id,
    required this.verificationStatus,
    required this.status,
    required this.statusName,
    required this.statusColor,
    required this.createdVerificationAt,
    required this.verifiedAt,
    required this.verifiedByName,
    required this.verifiedWithOwner,
    required this.realEstateValue,
    required this.brokerageFeeValue,
    required this.postOfficeName,
    required this.realEstate,
    required this.salesman,
    required this.agentSupport,
    required this.assignedToName,
  });

  factory VerificationSalesmanListItem.fromJson(Map json) {
    final rawAgentSupport = json['agent_support'];
    final rawVerifyingAgent = json['verifying_agent'];
    final agentSupport = rawAgentSupport is Map
        ? VerificationAgentSupportBrief.fromJson(rawAgentSupport)
        : rawVerifyingAgent is Map
            ? VerificationAgentSupportBrief.fromJson(rawVerifyingAgent)
            : null;

    final assignedToName = json['assigned_to_name']?.toString() ??
        (rawVerifyingAgent is Map
            ? (rawVerifyingAgent['name'] ?? '').toString()
            : '');

    return VerificationSalesmanListItem(
      id: asInt(json['id']),
      verificationStatus: asInt(json['verification_status']),
      status: asInt(json['status']),
      statusName: asString(json['status_name']),
      statusColor: asString(json['status_color']),
      createdVerificationAt: json['created_verification_at']?.toString(),
      verifiedAt: json['verified_at']?.toString(),
      verifiedByName: json['verified_by_name']?.toString(),
      verifiedWithOwner: json['verified_with_owner'] == true,
      realEstateValue: json['real_estate_value']?.toString(),
      brokerageFeeValue: json['brokerage_fee_value']?.toString(),
      postOfficeName: json['post_office_name']?.toString(),
      realEstate:
          VerificationRealEstateBrief.fromJson(json['real_estate'] is Map ? json['real_estate'] : const {}),
      salesman: VerificationSalesmanBrief.fromJson(
          json['salesman'] is Map ? json['salesman'] : const {}),
      agentSupport: agentSupport,
      assignedToName: assignedToName.trim().isEmpty ? null : assignedToName.trim(),
    );
  }

  VerificationItem toUiItem() {
    final accent = parseHexColor(statusColor);
    return VerificationItem(
      id: id,
      title: realEstate.title.isNotEmpty ? realEstate.title : 'BĐS chưa có tiêu đề',
      location: _locationLabel(realEstate),
      price: _formatPrice(),
      area: realEstate.area == null
          ? ''
          : '${realEstate.area!.toStringAsFixed(0)} m2',
      status: statusName.isNotEmpty
          ? statusName
          : normalizeVerificationRecordLabel(statusName),
      date: _formatDate(createdVerificationAt),
      imageUrl: realEstate.image,
      accent: accent,
      cardToneA: accent.withValues(alpha: 0.20),
      cardToneB: accent.withValues(alpha: 0.55),
      salesmanId: salesman.id,
      salesmanName: salesman.name,
      agentSupportName: agentSupport?.name ?? '',
      assignedToName: assignedToName ?? '',
      owner: salesman.name,
      company: agentSupport?.name ?? postOfficeName ?? '',
    );
  }

  String _formatPrice() {
    final raw = realEstateValue?.trim();
    if (raw != null && raw.isNotEmpty) {
      final parsed = _parseAmount(raw);
      if (parsed != null) return _formatAmount(parsed);
      return raw;
    }
    if (realEstate.price <= 0) return '0 VND';
    return _formatAmount(realEstate.price.toDouble());
  }

  static double? _parseAmount(String value) {
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.isEmpty ? null : double.tryParse(digits);
  }

  static String _formatAmount(double amount) {
    final abs = amount.abs();
    if (abs >= 1000000000000) return '${_unit(abs / 1000000000000)} nghìn tỷ';
    if (abs >= 1000000000) return '${_unit(abs / 1000000000)} tỷ';
    if (abs >= 1000000) return '${_unit(abs / 1000000)} triệu';
    if (abs >= 1000) return '${_unit(abs / 1000)} nghìn';
    return '${abs.toStringAsFixed(0)} VNĐ';
  }

  static String _unit(double value) {
    final rounded =
        value >= 10 ? value.toStringAsFixed(0) : value.toStringAsFixed(1);
    return rounded.replaceAll(RegExp(r'\.0$'), '').replaceAll('.', ',');
  }

  static String _formatDate(String? raw) {
    if (raw == null || raw.trim().isEmpty) return '';
    final dt = DateTime.tryParse(raw.trim());
    if (dt == null) return raw.trim().split(' ').first;
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(dt.day)}/${two(dt.month)}/${dt.year}';
  }

  static String _locationLabel(VerificationRealEstateBrief item) {
    final parts = <String>[
      if (item.ward.trim().isNotEmpty) item.ward.trim(),
      if (item.district.trim().isNotEmpty) item.district.trim(),
      if (item.city.trim().isNotEmpty) item.city.trim(),
    ];
    if (parts.isEmpty) return 'Chưa có vị trí';
    if (parts.length == 1) return parts.first;
    return '${parts[parts.length - 2]}, ${parts.last}';
  }
}

class VerificationSalesmanListResponse {
  final List<VerificationSalesmanListItem> items;
  final int total;

  const VerificationSalesmanListResponse({required this.items, required this.total});

  /// `data` here is already the inner payload after the EnvelopeInterceptor
  /// unwrapped `{status, data}` → `data` (which is `{data:[...], total:N}`).
  factory VerificationSalesmanListResponse.fromJson(dynamic data) {
    final root = data is Map
        ? data
        : data is List
            ? {'data': data}
            : const {};
    final rawItems = root['data'] is List
        ? root['data'] as List
        : (root['items'] is List ? root['items'] as List : const []);
    final total = asIntOrNull(root['total']) ?? asIntOrNull(root['count']);
    return VerificationSalesmanListResponse(
      items: rawItems
          .whereType<Map>()
          .map(VerificationSalesmanListItem.fromJson)
          .toList(),
      total: total ?? rawItems.length,
    );
  }
}

// ───────────────────────── detail ─────────────────────────

class VerificationCoordinates {
  final double? lat;
  final double? lng;
  const VerificationCoordinates({this.lat, this.lng});
  factory VerificationCoordinates.fromJson(Map json) => VerificationCoordinates(
        lat: asDoubleOrNull(json['lat']),
        lng: asDoubleOrNull(json['lng']),
      );
}

class VerificationHistoryItem {
  final String description;
  final String userComment;
  final String fullName;
  final String timeStamp;
  const VerificationHistoryItem({
    required this.description,
    required this.userComment,
    required this.fullName,
    required this.timeStamp,
  });
  factory VerificationHistoryItem.fromJson(Map json) => VerificationHistoryItem(
        description: asString(json['description']),
        userComment: asString(json['user_comment']),
        fullName: asString(json['full_name']),
        timeStamp: asString(json['time_stamp']),
      );
}

class VerificationPermissions {
  final bool canEdit;
  final bool canApprove;
  final bool canRequestReverify;
  final bool canAgentConfirm;
  final bool canAgentReject;
  final bool canAssignListingManager;
  final bool canAddOffice;
  final bool canAddSale;
  final bool canEditSale;

  const VerificationPermissions({
    this.canEdit = false,
    this.canApprove = false,
    this.canRequestReverify = false,
    this.canAgentConfirm = false,
    this.canAgentReject = false,
    this.canAssignListingManager = false,
    this.canAddOffice = false,
    this.canAddSale = false,
    this.canEditSale = false,
  });

  factory VerificationPermissions.fromJson(Map json) {
    bool b(dynamic v) {
      if (v == null) return false;
      if (v is bool) return v;
      if (v is num) return v != 0;
      final n = v.toString().trim().toLowerCase();
      return n == 'true' || n == '1';
    }

    return VerificationPermissions(
      canEdit: b(json['can_edit']),
      canApprove: b(json['can_approve']),
      canRequestReverify: b(json['can_request_reverify']),
      canAgentConfirm: b(json['can_agent_confirm']),
      canAgentReject: b(json['can_agent_reject']),
      canAssignListingManager: b(json['can_assign_listing_manager']),
      canAddOffice: b(json['can_add_office']),
      canAddSale: b(json['can_add_sale']),
      canEditSale: b(json['can_edit_sale']),
    );
  }
}

/// Real-estate payload inside the verification detail (replaces v1 ProductModel).
class VerificationRealEstateDetail {
  final int id;
  final String realEstateCode;
  final String title;
  final String priceDisplay;
  final String priceDescription;
  final double? area;
  final int? bedrooms;
  final int? bathrooms;
  final String streetAddress;
  final String propertyType;
  final String legalDocument;
  final String interior;
  final String descriptionHtml;
  final List<String> images;
  final List<String> videos;
  final double? lat;
  final double? lng;
  final String googleMapLink;
  final List<Map<String, dynamic>> legalDocumentFiles;

  const VerificationRealEstateDetail({
    required this.id,
    required this.realEstateCode,
    required this.title,
    required this.priceDisplay,
    required this.priceDescription,
    required this.area,
    required this.bedrooms,
    required this.bathrooms,
    required this.streetAddress,
    required this.propertyType,
    required this.legalDocument,
    required this.interior,
    required this.descriptionHtml,
    required this.images,
    required this.videos,
    required this.lat,
    required this.lng,
    required this.googleMapLink,
    required this.legalDocumentFiles,
  });

  factory VerificationRealEstateDetail.fromRaw(Map source) {
    final mainImage = asString(source['main_image']).trim();
    final baseOrigin =
        mainImage.isNotEmpty ? (Uri.tryParse(mainImage)?.origin ?? '') : '';

    String abs(String e) {
      if (e.startsWith('http://') || e.startsWith('https://')) return e;
      if (baseOrigin.isNotEmpty) {
        return '$baseOrigin/${e.startsWith('/') ? e.substring(1) : e}';
      }
      return e;
    }

    // media[] split into images / videos
    final imageUrls = <String>[];
    final videoUrls = <String>[];
    final media = source['media'];
    if (media is List) {
      for (final m in media.whereType<Map>()) {
        final url = asString(m['url']).trim();
        if (url.isEmpty) continue;
        final type = asString(m['type']).trim().toLowerCase();
        (type == 'video' ? videoUrls : imageUrls).add(url);
      }
    }

    // images can be a JSON string or list
    var decodedImages = <String>[];
    final rawImages = source['images'];
    if (rawImages is String && rawImages.trim().isNotEmpty) {
      try {
        final parsed = jsonDecode(rawImages);
        if (parsed is List) {
          decodedImages = parsed
              .map((e) => e.toString().trim())
              .where((e) => e.isNotEmpty)
              .map(abs)
              .toList();
        }
      } catch (_) {}
    } else if (rawImages is List) {
      decodedImages = rawImages
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .map(abs)
          .toList();
    }

    final images = imageUrls.isNotEmpty
        ? imageUrls
        : (decodedImages.isNotEmpty
            ? decodedImages
            : (mainImage.isNotEmpty ? [mainImage] : <String>[]));

    // latlng "lat,lng" or explicit fields
    double? lat = asDoubleOrNull(source['lat']);
    double? lng = asDoubleOrNull(source['lng'] ?? source['long']);
    final latlng = asString(source['latlng']).trim();
    if ((lat == null || lng == null) && latlng.contains(',')) {
      final parts = latlng.split(',');
      if (parts.length >= 2) {
        lat = double.tryParse(parts[0].trim());
        lng = double.tryParse(parts[1].trim());
      }
    }

    // legal document file (single → list)
    final legalDocs = <Map<String, dynamic>>[];
    final legalDocumentUrl = asString(source['legal_document_url']).trim();
    final legalDocuments = asString(source['legal_documents']).trim();
    if (legalDocumentUrl.isNotEmpty) {
      legalDocs.add({
        'title': legalDocuments.isNotEmpty ? legalDocuments : 'Tài liệu pháp lý',
        'url': abs(legalDocumentUrl),
      });
    }
    final rawLegalFiles = source['legal_document_file'];
    if (rawLegalFiles is List) {
      for (final f in rawLegalFiles.whereType<Map>()) {
        legalDocs.add({
          'title': asString(f['title'], fallback: 'Tài liệu'),
          'url': abs(asString(f['url'])),
        });
      }
    }

    return VerificationRealEstateDetail(
      id: asInt(source['id']),
      realEstateCode: asString(source['real_estate_code'] ?? source['code']),
      title: asString(source['title']),
      priceDisplay: asString(
          source['price_formatted'] ?? source['price_display'] ?? source['price_description']),
      priceDescription: asString(source['price_description'] ?? source['price_display']),
      area: asDoubleOrNull(source['area']),
      bedrooms: asIntOrNull(source['bedroom'] ?? source['bedrooms'] ?? source['num_bedroom']),
      bathrooms: asIntOrNull(source['bathroom'] ?? source['bathrooms'] ?? source['num_bathroom'] ?? source['toilet']),
      streetAddress: asString(source['full_address'] ?? source['street_address'] ?? source['address']),
      propertyType: asString(source['category_name'] ?? source['property_type']),
      legalDocument: legalDocuments,
      interior: asString(source['interior'] ?? source['furniture'] ?? source['interior_status']),
      descriptionHtml: asString(source['description'] ?? source['content'] ?? source['html_content']),
      images: images,
      videos: videoUrls,
      lat: lat,
      lng: lng,
      googleMapLink: asString(source['google_map_link'] ?? source['google_maps_url']),
      legalDocumentFiles: legalDocs,
    );
  }
}

class VerificationSalesmanDetailResponse {
  final int id;
  final int verificationStatus;
  final int status;
  final String statusName;
  final String statusColor;
  final String? createdVerificationAt;
  final String? verifiedAt;
  final String? verificationNotes;
  final String? verifiedByName;
  final bool verifiedWithOwner;
  final String? realEstateValue;
  final String? brokerageFeeValue;
  final String? brokerageFeeUnit;
  final double? completionPayoutPercent;
  final double? depositPercent;
  final String? taxBearer;
  final String? googleMapsUrl;
  final VerificationCoordinates? coordinates;
  final String? address;
  final String? city;
  final String? district;
  final String? ward;
  final VerificationRealEstateDetail realEstate;
  final VerificationSalesmanBrief salesman;
  final VerificationAgentSupportBrief? agentSupport;
  final String? assignedToName;
  final String? ownerName;
  final String? ownerPhone;
  final String? ownerNameFirst;
  final String? ownerNameSecond;
  final String? idCardFirst;
  final String? idCardSecond;
  final int? saleOffMemberId;
  final VerificationLegalInfoBrief legalInfo;
  final List<VerificationHistoryItem> historys;
  final VerificationPermissions? permissions;

  const VerificationSalesmanDetailResponse({
    required this.id,
    required this.verificationStatus,
    required this.status,
    required this.statusName,
    required this.statusColor,
    required this.createdVerificationAt,
    required this.verifiedAt,
    required this.verificationNotes,
    required this.verifiedByName,
    required this.verifiedWithOwner,
    required this.realEstateValue,
    required this.brokerageFeeValue,
    required this.brokerageFeeUnit,
    required this.completionPayoutPercent,
    required this.depositPercent,
    required this.taxBearer,
    required this.googleMapsUrl,
    required this.coordinates,
    required this.address,
    required this.city,
    required this.district,
    required this.ward,
    required this.realEstate,
    required this.salesman,
    required this.agentSupport,
    required this.assignedToName,
    required this.ownerName,
    required this.ownerPhone,
    required this.ownerNameFirst,
    required this.ownerNameSecond,
    required this.idCardFirst,
    required this.idCardSecond,
    required this.saleOffMemberId,
    required this.legalInfo,
    required this.historys,
    required this.permissions,
  });

  factory VerificationSalesmanDetailResponse.fromJson(Map json) {
    final root = json['data'] is Map ? json['data'] as Map : json;
    final rawHistorys = root['historys'] is List ? root['historys'] as List : const [];
    return VerificationSalesmanDetailResponse(
      id: asInt(root['id']),
      verificationStatus: asInt(root['verification_status']),
      status: asInt(root['status']),
      statusName: asString(root['status_name']),
      statusColor: asString(root['status_color']),
      createdVerificationAt: root['created_verification_at']?.toString(),
      verifiedAt: root['verified_at']?.toString(),
      verificationNotes: root['verification_notes']?.toString(),
      verifiedByName: root['verified_by_name']?.toString(),
      verifiedWithOwner: root['verified_with_owner'] == true,
      realEstateValue: root['real_estate_value']?.toString(),
      brokerageFeeValue: root['brokerage_fee_value']?.toString(),
      brokerageFeeUnit: root['brokerage_fee_unit']?.toString(),
      completionPayoutPercent: asDoubleOrNull(root['completion_payout_percent']),
      depositPercent: asDoubleOrNull(root['deposit_percent']),
      taxBearer: root['tax_bearer']?.toString(),
      googleMapsUrl: root['google_maps_url']?.toString(),
      coordinates: root['coordinates'] is Map
          ? VerificationCoordinates.fromJson(root['coordinates'])
          : null,
      address: root['address']?.toString(),
      city: root['city']?.toString(),
      district: root['district']?.toString(),
      ward: root['ward']?.toString(),
      realEstate: VerificationRealEstateDetail.fromRaw(
          root['real_estate'] is Map ? root['real_estate'] : const {}),
      salesman: VerificationSalesmanBrief.fromJson(
          root['salesman'] is Map ? root['salesman'] : const {}),
      agentSupport: root['agent_support'] is Map
          ? VerificationAgentSupportBrief.fromJson(root['agent_support'])
          : null,
      assignedToName: root['assigned_to_name']?.toString(),
      ownerName: root['owner_name']?.toString(),
      ownerPhone: root['owner_phone']?.toString(),
      ownerNameFirst: root['owner_name_first']?.toString(),
      ownerNameSecond: root['owner_name_second']?.toString(),
      idCardFirst: root['id_card_first']?.toString(),
      idCardSecond: root['id_card_second']?.toString(),
      saleOffMemberId: asIntOrNull(root['sale_off_member_id']),
      legalInfo: VerificationLegalInfoBrief.fromJson(
          root['legal_info'] is Map ? root['legal_info'] : const {}),
      historys: rawHistorys
          .whereType<Map>()
          .map(VerificationHistoryItem.fromJson)
          .toList(),
      permissions: root['permissions'] is Map
          ? VerificationPermissions.fromJson(root['permissions'])
          : null,
    );
  }
}

// ───────────────────────── filter options + state ─────────────────────────

enum VerificationDatePreset { all, today, sevenDays, thirtyDays, custom }

enum VerificationCreatedType { me, assigned, managed }

enum VerificationAgentScope { office, team }

extension VerificationDatePresetX on VerificationDatePreset {
  String get label => switch (this) {
        VerificationDatePreset.all => 'Tất cả',
        VerificationDatePreset.today => 'Hôm nay',
        VerificationDatePreset.sevenDays => '7 ngày',
        VerificationDatePreset.thirtyDays => '30 ngày',
        VerificationDatePreset.custom => 'Tùy chọn',
      };
}

extension VerificationCreatedTypeX on VerificationCreatedType {
  String get label => switch (this) {
        VerificationCreatedType.me => 'Tôi tạo',
        VerificationCreatedType.assigned => 'Được gán',
        VerificationCreatedType.managed => 'Tôi quản lý',
      };
  String get value => switch (this) {
        VerificationCreatedType.me => 'me',
        VerificationCreatedType.assigned => 'assigned',
        VerificationCreatedType.managed => 'managed',
      };
}

extension VerificationAgentScopeX on VerificationAgentScope {
  String get label => switch (this) {
        VerificationAgentScope.office => 'Toàn VP',
        VerificationAgentScope.team => 'Đội của tôi',
      };
}

class VerificationOfficeOption {
  final int id;
  final String name;
  final String fullName;
  const VerificationOfficeOption(
      {required this.id, required this.name, required this.fullName});
  factory VerificationOfficeOption.fromJson(Map json) {
    final name = asString(json['name']);
    return VerificationOfficeOption(
      id: asInt(json['id']),
      name: name,
      fullName: asString(json['full_name'], fallback: name),
    );
  }
}

class VerificationSalesUserOption {
  final int id;
  final int authUserId;
  final String name;
  final String phone;
  final int officeId;
  final String officeName;
  final String managerCode;
  final String titleName;

  const VerificationSalesUserOption({
    required this.id,
    required this.authUserId,
    required this.name,
    required this.phone,
    required this.officeId,
    required this.officeName,
    required this.managerCode,
    required this.titleName,
  });

  factory VerificationSalesUserOption.fromJson(Map json) {
    final salesmanId = asInt(json['salesman_id']);
    final authId = asInt(json['auth_user_id']);
    return VerificationSalesUserOption(
      id: salesmanId != 0 ? salesmanId : asInt(json['id']),
      authUserId: authId != 0 ? authId : asInt(json['user_id']),
      name: asString(json['name'], fallback: asString(json['full_name'])),
      phone: asString(json['phone']),
      officeId: asInt(json['office_id']),
      officeName: asString(json['office_name'], fallback: asString(json['office'])),
      managerCode: asString(json['s_manager_name_code'],
          fallback: asString(json['manager_code'])),
      titleName:
          asString(json['title_name'], fallback: asString(json['position_name'])),
    );
  }
}

class VerificationTagOption {
  final int id;
  final String name;
  final String code;
  final String color;
  const VerificationTagOption(
      {required this.id, required this.name, required this.code, required this.color});
  factory VerificationTagOption.fromJson(Map json) => VerificationTagOption(
        id: asInt(json['id']),
        name: asString(json['name'], fallback: asString(json['tag_name'])),
        code: asString(json['code'], fallback: asString(json['tag_code'])),
        color: asString(json['color'], fallback: asString(json['tag_color'])),
      );
}

class VerificationListFilterState {
  final List<int> statusIds;
  final String searchText;
  final VerificationDatePreset datePreset;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String timeField;
  final int? officeId;
  final String? officeName;
  final int? salesOffId;
  final String? salesOffName;
  final List<int> verifyingAgentIds;
  final VerificationAgentScope agentScope;
  final VerificationCreatedType? createdType;
  final List<int> tagIds;
  final String tagOperator;

  const VerificationListFilterState({
    this.statusIds = const [],
    this.searchText = '',
    this.datePreset = VerificationDatePreset.all,
    this.dateFrom,
    this.dateTo,
    this.timeField = 'created_verification_at',
    this.officeId,
    this.officeName,
    this.salesOffId,
    this.salesOffName,
    this.verifyingAgentIds = const [],
    this.agentScope = VerificationAgentScope.office,
    this.createdType,
    this.tagIds = const [],
    this.tagOperator = 'or',
  });

  VerificationListFilterState copyWith({
    List<int>? statusIds,
    String? searchText,
    VerificationDatePreset? datePreset,
    DateTime? dateFrom,
    DateTime? dateTo,
    bool clearDateFrom = false,
    bool clearDateTo = false,
    String? timeField,
    int? officeId,
    String? officeName,
    bool clearOffice = false,
    int? salesOffId,
    String? salesOffName,
    bool clearSalesOff = false,
    List<int>? verifyingAgentIds,
    VerificationAgentScope? agentScope,
    VerificationCreatedType? createdType,
    bool clearCreatedType = false,
    List<int>? tagIds,
    String? tagOperator,
  }) {
    return VerificationListFilterState(
      statusIds: statusIds ?? this.statusIds,
      searchText: searchText ?? this.searchText,
      datePreset: datePreset ?? this.datePreset,
      dateFrom: clearDateFrom ? null : (dateFrom ?? this.dateFrom),
      dateTo: clearDateTo ? null : (dateTo ?? this.dateTo),
      timeField: timeField ?? this.timeField,
      officeId: clearOffice ? null : (officeId ?? this.officeId),
      officeName: clearOffice ? null : (officeName ?? this.officeName),
      salesOffId: clearSalesOff ? null : (salesOffId ?? this.salesOffId),
      salesOffName: clearSalesOff ? null : (salesOffName ?? this.salesOffName),
      verifyingAgentIds: verifyingAgentIds ?? this.verifyingAgentIds,
      agentScope: agentScope ?? this.agentScope,
      createdType: clearCreatedType ? null : (createdType ?? this.createdType),
      tagIds: tagIds ?? this.tagIds,
      tagOperator: tagOperator ?? this.tagOperator,
    );
  }

  bool get hasCustomDateRange =>
      datePreset == VerificationDatePreset.custom &&
      dateFrom != null &&
      dateTo != null;
}

/// Image base helper for verification thumbnails.
String? verificationImageUrl(String? path) => AppConfig.imageUrl(path);
