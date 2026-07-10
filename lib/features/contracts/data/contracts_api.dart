import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/json_parse.dart';
import 'contract_preview_data.dart';
import 'contract_sign_data.dart';

/// A contract from `contracts.json` (`result[]`). Fields per v1 contract_page.
class ContractItem {
  const ContractItem({
    required this.id,
    required this.title,
    this.code,
    this.price,
    this.address,
    this.nameSale,
    this.contractTypeName,
    this.contractTypeImage,
    this.contractType,
    this.signingMethods,
    this.signedStatus = 0,
    this.pdfUrl,
  });

  final int id;
  final String title;
  final String? code;
  final String? price;
  final String? address;
  final String? nameSale;
  final String? contractTypeName;

  /// Cover image shown on the card (`contract_type_image`).
  final String? contractTypeImage;

  /// Passed to the preview/sign flow when tapping the card.
  final int? contractType;
  final int? signingMethods;

  /// 1 = đã ký, 0 = chưa ký.
  final int signedStatus;
  final String? pdfUrl;

  bool get isSigned => signedStatus == 1;
  String get statusText => isSigned ? 'Đã ký' : 'Chưa ký';

  factory ContractItem.fromJson(Map d) => ContractItem(
        id: asInt(d['id'] ?? d['contract_id']),
        title: (d['title'] ?? d['contract_type_name'] ?? 'Hợp đồng').toString(),
        code: (d['code'] ?? d['contract_code'])?.toString(),
        price: (d['price'])?.toString(),
        address: (d['address'])?.toString(),
        nameSale: (d['name_sale'])?.toString(),
        contractTypeName: (d['contract_type_name'])?.toString(),
        contractTypeImage: (d['contract_type_image'])?.toString(),
        contractType: asIntOrNull(d['contract_type']),
        signingMethods: asIntOrNull(d['signing_methods']),
        signedStatus: asInt(d['signed_status']),
        pdfUrl: (d['pdf_url'])?.toString(),
      );
}

/// A library article from `news_by_folder.json` (matches v1 `NewModel`).
class LibraryItem {
  const LibraryItem({
    required this.id,
    required this.title,
    this.versionDocs,
    this.publishOn,
  });
  final int id;
  final String title;

  /// `version_docs` — shown as "Version" in the list item.
  final String? versionDocs;

  /// `publish_on` — shown as "Cập nhật" (dd/MM/yyyy HH:mm) in the list item.
  final String? publishOn;

  factory LibraryItem.fromJson(Map d) => LibraryItem(
        id: asInt(d['id']),
        title: (d['name'] ?? d['title'] ?? '').toString(),
        versionDocs: (d['version_docs'])?.toString(),
        publishOn: (d['publish_on'] ?? d['created_on'])?.toString(),
      );
}

class ContractsApi {
  ContractsApi(this._dio);

  final Dio _dio;

  Future<List<ContractItem>> list({int page = 1, int limit = 30}) async {
    final res = await _dio.get('${AppConfig.customer}/contracts.json');
    return _list(res.data).whereType<Map>().map(ContractItem.fromJson).toList();
  }

  /// Contract-library list — v1 `news_by_folder.json` under `/api_agent`.
  /// [description] filters by transaction type (`muaban` / `datcoc` / `thue`),
  /// [key] is the free-text search term.
  Future<List<LibraryItem>> library({
    int page = 1,
    int length = 50,
    String? description,
    String? key,
  }) async {
    final res = await _dio.get(
      '${AppConfig.agent}/news_by_folder.json',
      queryParameters: {
        'folder': 'thu-vien-hop-dong-agent',
        'page': page,
        'length': length,
        if (description != null) 'description': description,
        if (key != null && key.isNotEmpty) 'key': key,
      },
    );
    return _list(res.data).whereType<Map>().map(LibraryItem.fromJson).toList();
  }

  /// KYC step: 1 = chưa xác thực, 2 = chờ duyệt, 3 = đã duyệt.
  Future<int> verifyAccount() async {
    final res =
        await _dio.get('${AppConfig.agent}/check_account_authentication.json');
    return asInt(_inner(res.data)['step'], fallback: 0);
  }

  /// Contract-library article detail — `news_by_id.json?id=`.
  Future<LibraryDetail> libraryDetail(int id) async {
    final res = await _dio.get('${AppConfig.agent}/news_by_id.json',
        queryParameters: {'id': id});
    return LibraryDetail.fromJson(_inner(res.data));
  }

  /// Structured contract content for the preview-by-id screen
  /// (`contract_content_by_id.json` → `result`). Matches v1.
  ///
  /// The backend returns the content under a top-level `result` key alongside a
  /// sibling `data` flag. The default envelope unwrap replaces the payload with
  /// `data`, which would discard `result` and leave every field blank — so we
  /// opt out (`rawEnvelope`) and resolve `result` whether it sits at the top
  /// level or nested under `data`.
  Future<ContractPreview> contractPreview(int contractId) async {
    final res = await _dio.get(
      '${AppConfig.customer}/contract_content_by_id.json',
      queryParameters: {'contract_id': contractId},
      options: Options(extra: {'rawEnvelope': true}),
    );
    final root = res.data is Map ? res.data as Map : const {};
    final body = root['data'] is Map ? root['data'] as Map : root;
    final result = body['result'] is Map ? body['result'] as Map : body;
    return ContractPreview.fromJson(result);
  }

  /// Renderable contract to sign — v1 `contract_agent.json` (POST, body
  /// `{info_office}`): HTML under `data.html` plus `side_a` / `side_b` used for
  /// the embedded signature panel. (`contract_content.json` only carries the
  /// structured office/agent info used by the preview.)
  Future<ContractSignData> contractContent({int infoOffice = 1}) async {
    final res = await _dio.post(
      '${AppConfig.agent}/contract_agent.json',
      data: {'info_office': infoOffice},
    );
    return ContractSignData.fromJson(_inner(res.data));
  }

  /// Structured CTV-contract content for the "Nội dung hợp đồng" preview shown
  /// before signing (v1 join flow). Same `contract_content.json` endpoint as
  /// [contractContent], but parsed for the office (Bên A) / agent (Bên B) info.
  ///
  /// v1 reads the office/agent info from a top-level `result` key and never
  /// unwraps the `{status, message, data}` envelope. We opt out of unwrapping
  /// (`rawEnvelope`) so a sibling `data` key can't strip `result`, then resolve
  /// `result` whether it sits at the top level or nested under `data`.
  Future<ContractPreview> contractJoinPreview() async {
    final res = await _dio.get(
      '${AppConfig.agent}/contract_content.json',
      options: Options(extra: {'rawEnvelope': true}),
    );
    final root = res.data is Map ? res.data as Map : const {};
    final body = root['data'] is Map ? root['data'] as Map : root;
    final result = body['result'] is Map ? body['result'] as Map : body;
    return ContractPreview.fromJson(result);
  }

  /// Send the signing OTP (purpose 1).
  Future<void> sendOtp(String phone, {String channel = 'sms'}) async {
    await _dio.post('${AppConfig.agent}/contract_otp.json',
        data: {'phone': phone, 'purpose': 1, 'channel': channel});
  }

  /// Verify the signing OTP.
  Future<bool> verifyOtp(String phone, String otp) async {
    final res = await _dio.put('${AppConfig.agent}/contract_otp.json',
        data: {'phone': phone, 'purpose': 1, 'otp': otp});
    final d = _inner(res.data);
    return d['success'] != false; // success unless explicitly false
  }

  /// Uploads the signature PNG and returns its URL — `upload_file.json`
  /// (multipart `file`). Response is a String URL or `{data: url}`.
  Future<String?> uploadSignature(Uint8List bytes) async {
    final form = FormData.fromMap({
      'file': MultipartFile.fromBytes(bytes, filename: 'signature.png'),
    });
    final res =
        await _dio.post('${AppConfig.agent}/upload_file.json', data: form);
    final data = res.data;
    if (data is String) return data.trim().isEmpty ? null : data.trim();
    if (data is Map) {
      final url = (data['data'] ?? data['url'] ?? data['result'])?.toString();
      return (url == null || url.isEmpty) ? null : url;
    }
    return null;
  }

  /// Create (sign) the contract. `signatureImage` is the uploaded signature
  /// URL (not base64). Success when the response `status == 'success'`.
  Future<({bool success, String? message, String? contractId, String? pdf})>
      createContract({
    required String signedAt,
    required String signatureImage,
    int infoOffice = 1,
    int contractType = 1,
    int signingMethod = 2,
  }) async {
    final res =
        await _dio.post('${AppConfig.agent}/contract_create.json', data: {
      'info_office': infoOffice,
      'contract_type': contractType,
      'signing_method': signingMethod,
      'signed_at': signedAt,
      'signature_image': signatureImage,
    });
    final root = res.data is Map ? res.data as Map : const {};
    final status = (root['status'] ?? '').toString().toLowerCase();
    final inner = _inner(res.data);
    return (
      success: status == 'success',
      message: (root['message'] ?? inner['message'])?.toString(),
      contractId: root['contract_id']?.toString(),
      pdf: (root['pdf'] ?? root['pdf_url'])?.toString(),
    );
  }

  /// Request a seller contract for a listing (v1 "Ký HĐ với chủ nhà" →
  /// `contract_seller_create.json`). `signingMethod`: 2 = điện tử, 1 = trực
  /// tiếp. `contractType`: 2 = thông thường, 3 = độc quyền.
  Future<({bool success, String? message})> createSellerContract({
    required int realEstateSalesmanId,
    required int signingMethod,
    required int contractType,
    int infoOffice = 1,
  }) async {
    final res =
        await _dio.post('${AppConfig.agent}/contract_seller_create.json', data: {
      'signing_method': signingMethod,
      'contract_type': contractType,
      'real_estate_salesman_id': realEstateSalesmanId,
      'info_office': infoOffice,
    });
    final root = res.data is Map ? res.data as Map : const {};
    final inner = _inner(res.data);
    final status = (root['status'] ?? '').toString().toLowerCase();
    final ok = status == 'success' ||
        root['status'] == 1 ||
        inner['success'] == true;
    return (
      success: ok,
      message: (root['message'] ?? inner['message'])?.toString(),
    );
  }

  List _list(Object? data) {
    if (data is Map) {
      return (data['result'] ?? data['items'] ?? data['data'] ?? []) as List;
    }
    if (data is List) return data;
    return const [];
  }

  /// Resolves the meaningful inner map from `result` / `data`, else the map.
  Map _inner(Object? data) {
    if (data is! Map) return const {};
    if (data['result'] is Map) return data['result'] as Map;
    if (data['data'] is Map) return data['data'] as Map;
    return data;
  }
}

/// A file attached to a library article (`list_gallery`).
class GalleryFile {
  const GalleryFile({required this.name, required this.url});
  final String name;
  final String url;

  bool get isPdf => name.toLowerCase().endsWith('.pdf');

  factory GalleryFile.fromJson(Map d) {
    final url = (d['url'] ?? '').toString();
    return GalleryFile(
      name: (d['name'] ?? url.split('/').last).toString(),
      url: url.startsWith('http') ? url : (AppConfig.imageUrl(url) ?? url),
    );
  }
}

/// Library article detail (`news_by_id.json`).
class LibraryDetail {
  const LibraryDetail({
    required this.name,
    this.htmlContent = '',
    this.folderName,
    this.createdOn,
    this.gallery = const [],
  });
  final String name;
  final String htmlContent;
  final String? folderName;
  final String? createdOn;
  final List<GalleryFile> gallery;

  factory LibraryDetail.fromJson(Map d) => LibraryDetail(
        name: (d['name'] ?? d['title'] ?? '').toString(),
        htmlContent:
            (d['htmlcontent'] ?? d['html_content'] ?? d['content'] ?? '')
                .toString(),
        folderName: (d['folder_name'] ?? d['folder_label'])?.toString(),
        createdOn: (d['created_on'] ?? d['publish_on'])?.toString(),
        gallery: (d['list_gallery'] is List ? d['list_gallery'] as List : [])
            .whereType<Map>()
            .map(GalleryFile.fromJson)
            .where((g) => g.url.isNotEmpty)
            .toList(),
      );
}

final contractsApiProvider =
    Provider<ContractsApi>((ref) => ContractsApi(ref.watch(dioProvider)));

final contractsProvider =
    FutureProvider.autoDispose<List<ContractItem>>((ref) {
  return ref.watch(contractsApiProvider).list();
});

final libraryDetailProvider =
    FutureProvider.autoDispose.family<LibraryDetail, int>((ref, id) {
  return ref.watch(contractsApiProvider).libraryDetail(id);
});

final contractPreviewProvider =
    FutureProvider.autoDispose.family<ContractPreview, int>((ref, id) {
  return ref.watch(contractsApiProvider).contractPreview(id);
});

/// CTV-contract preview ("Nội dung hợp đồng") shown before signing.
final contractJoinPreviewProvider =
    FutureProvider.autoDispose<ContractPreview>((ref) {
  return ref.watch(contractsApiProvider).contractJoinPreview();
});
