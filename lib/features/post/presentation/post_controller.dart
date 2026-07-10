import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../locations/locations_screen.dart';
import '../../realestate/data/models/property_detail.dart';
import '../data/models/post_draft.dart';
import '../data/post_api.dart';

export '../data/models/post_draft.dart';

/// Drives the 4-step "Đăng tin BĐS" wizard. Field/logic parity with v1
/// `CreateNewsController`.
class PostController extends AutoDisposeNotifier<PostDraft> {
  PostApi get _api => ref.read(postApiProvider);

  @override
  PostDraft build() => const PostDraft();

  void update(PostDraft Function(PostDraft) fn) => state = fn(state);

  /// Marks the wizard as launched from a "Tin đăng" task on a nhu cầu bán —
  /// on successful submit, the new listing is linked back to that lead.
  void startFromSellLead(int leadId) {
    if (state.sellLeadId == leadId) return;
    state = state.copyWith(sellLeadId: leadId);
  }

  /// Seeds the wizard from an existing listing for the edit flow (v1 parity:
  /// `CreateNewsController` with a `product` argument). Submitting then sends
  /// `save_real_estate.json` with `id = realEstateId`.
  Future<void> loadForEdit(PropertyDetail d) async {
    state = PostDraft(
      realEstateId: d.id,
      transactionType: d.transactionType ?? 1,
      propertyTypeId: d.propertyTypeId,
      propertyTypeName: d.propertyTypeName ?? '',
      title: d.title,
      description: d.description ?? '',
      htmlContent: d.htmlContent ?? '',
      price: d.price,
      returnPrice: d.returnPrice,
      area: d.area,
      cityId: d.cityId ?? '',
      cityName: d.cityName ?? '',
      districtId: d.districtId ?? '',
      districtName: d.districtName ?? '',
      wardId: d.wardId ?? '',
      wardName: d.wardName ?? '',
      lat: d.lat,
      lng: d.lng,
      addressDetail: d.address,
      streetName: d.streetName ?? '',
      bedrooms: d.bedrooms ?? 0,
      bathrooms: d.bathrooms ?? 0,
      floors: d.floors ?? 0,
      houseDirection: d.houseDirection ?? '',
      balconyDirection: d.balconyDirection ?? '',
      landDirection: d.landDirection ?? '',
      legalDocumentType: d.legalDocumentType ?? '',
      furnitureName: d.furnitureName ?? '',
      images: d.gallery,
      videos: d.videos,
      legalDocs:
          d.legalDocs.where((e) => e.hasUrl).map((e) => e.url!).toList(),
      rose: d.commissionPercent == null
          ? ''
          : d.commissionPercent!.toStringAsFixed(1),
    );
    if (d.propertyTypeId != null) {
      state = state.copyWith(loadingFields: true);
      try {
        final fields = await _api.propertyTypeFields(d.propertyTypeId!);
        state = state.copyWith(fields: fields, loadingFields: false);
      } catch (_) {
        state = state.copyWith(loadingFields: false);
      }
    }
    _maybeFetchCommission();
  }

  // ---- Step 1: thông tin ----

  /// Switch demand (transaction type); resets property type + dynamic fields.
  void setDemand(int type) {
    if (type == state.transactionType) return;
    state = state.copyWith(
      transactionType: type,
      clearPropertyType: true,
      propertyTypeName: '',
      fields: const [],
      extraFields: const {},
    );
  }

  void setLocation(LocationSelection sel) {
    state = state.copyWith(
      cityId: sel.cityId,
      cityName: sel.cityName,
      districtId: sel.districtId ?? '',
      districtName: sel.districtName ?? '',
      wardId: sel.wardId ?? '',
      wardName: sel.wardName ?? '',
      lat: sel.districtLat ?? sel.cityLat,
      lng: sel.districtLng ?? sel.cityLng,
    );
    _maybeFetchCommission();
  }

  Future<void> selectPropertyType(int id, String name) async {
    state = state.copyWith(
      propertyTypeId: id,
      propertyTypeName: name,
      loadingFields: true,
      fields: const [],
      extraFields: const {},
    );
    try {
      final fields = await _api.propertyTypeFields(id);
      state = state.copyWith(fields: fields, loadingFields: false);
    } catch (_) {
      state = state.copyWith(loadingFields: false);
    }
    _maybeFetchCommission();
  }

  void setExtraField(String key, String value) {
    final next = Map<String, String>.from(state.extraFields);
    if (value.trim().isEmpty) {
      next.remove(key);
    } else {
      next[key] = value.trim();
    }
    state = state.copyWith(extraFields: next);
  }

  Future<void> _maybeFetchCommission() async {
    final d = state;
    if (!d.hasLocation ||
        d.propertyTypeId == null ||
        d.area == null ||
        d.price == null) {
      return;
    }
    try {
      final c = await _api.commissionDefault(
        cityId: int.tryParse(d.cityId),
        districtId: int.tryParse(d.districtId),
        wardId: int.tryParse(d.wardId),
        area: d.area,
        price: d.price,
        propertyType: d.propertyTypeId,
      );
      state = state.copyWith(
        commissionMin: c.min,
        commissionMax: c.max,
        commissionEditable: c.editable,
        commissionTitle: c.title,
        commissionDescription: c.description,
      );
    } catch (_) {
      // keep previous commission
    }
  }

  Future<void> fetchCommission() => _maybeFetchCommission();

  /// Calls the AI sample-generator (v1 `generate_real_estate_sample`) and
  /// returns the generated content WITHOUT touching the draft — the dedicated
  /// "Tạo nội dung tự động" page previews/edits it and only commits via
  /// [applyGeneratedContent] when the user taps "Sử dụng" (v1 page flow).
  /// [hint] is the user's prompt (v1 `content`/`title`); [length]/[tone] are the
  /// selected option values (e.g. "auto", "short", "friendly").
  Future<AiDescription> generateContent({
    required String hint,
    required String length,
    required String tone,
  }) async {
    final d = state;
    state = state.copyWith(generating: true);
    try {
      // Payload matches the live `generate_real_estate_sample.json` contract
      // exactly (verified curl): JSON number price/min/max, content = hint,
      // length/tone, and NO `use_ai` field.
      final price = d.price?.toInt() ?? 0;
      return await _api.generateDescription({
        'title': hint,
        'price': price,
        'min_price': price,
        'max_price': d.returnPrice?.toInt() ?? price,
        'property_type_id': d.propertyTypeId ?? 0,
        'description': d.description,
        'furniture': d.furnitureName,
        'bedrooms': d.bedrooms,
        'bathrooms': d.bathrooms,
        'floors': d.floors,
        'house_direction': d.houseDirection,
        'balcony_direction': d.balconyDirection,
        'transaction_type': d.transactionType,
        'city': d.cityName,
        'district': d.districtName,
        'ward': d.wardName,
        'street_name': d.streetName,
        'street_address': d.fullAddress,
        'legal_document_type': d.legalDocumentType,
        'content': hint,
        'length': length,
        'tone': tone,
      });
    } finally {
      state = state.copyWith(generating: false);
    }
  }

  /// Commits AI-generated content into the draft (v1 `useContent`).
  void applyGeneratedContent({
    required String plain,
    required String html,
    String? title,
  }) {
    state = state.copyWith(
      description: plain,
      htmlContent: html,
      title: (title != null && title.isNotEmpty) ? title : state.title,
    );
  }

  // ---- Step 2: media ----

  Future<void> addImages(List<String> paths) =>
      _upload(paths, (urls) => state.copyWith(images: urls));

  void removeImage(int i) =>
      state = state.copyWith(images: [...state.images]..removeAt(i));

  Future<void> addVideos(List<String> paths) =>
      _upload(paths, (urls) => state.copyWith(videos: urls), base: state.videos);

  void removeVideo(int i) =>
      state = state.copyWith(videos: [...state.videos]..removeAt(i));

  Future<void> addLegalDocs(List<String> paths) => _upload(
      paths, (urls) => state.copyWith(legalDocs: urls), base: state.legalDocs);

  void removeLegalDoc(int i) =>
      state = state.copyWith(legalDocs: [...state.legalDocs]..removeAt(i));

  /// Uploads [paths] and applies the merged URL list via [apply].
  Future<void> _upload(
    List<String> paths,
    PostDraft Function(List<String>) apply, {
    List<String>? base,
  }) async {
    state = state.copyWith(uploading: true);
    final urls = <String>[...(base ?? state.images)];
    for (final p in paths) {
      final url = await _api.uploadFile(p);
      if (url != null) urls.add(url);
    }
    state = apply(urls).copyWith(uploading: false);
  }

  // ---- Step 4: submit ----

  /// Submits the listing with the given save status; returns the new id (0 if
  /// unknown) and optionally the salesman id. `PENDING_APPROVAL` = đăng tin,
  /// `DRAFT` = lưu nháp.
  Future<({int id, int? salesmanId})> submit(
      {String status = 'PENDING_APPROVAL'}) async {
    state = state.copyWith(saveStatus: status, submitting: true);
    try {
      return await _api.save(state.toListing());
    } finally {
      state = state.copyWith(submitting: false);
    }
  }

  /// Clears the wizard back to a blank draft. Called after a successful create
  /// so re-opening the "Đăng tin" tab (kept alive by the indexed-stack shell)
  /// starts fresh instead of showing the just-submitted post.
  void reset() => state = const PostDraft();
}

final postControllerProvider =
    AutoDisposeNotifierProvider<PostController, PostDraft>(PostController.new);
