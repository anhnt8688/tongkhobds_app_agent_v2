import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import '../../home/data/models/quick_tool.dart';
import 'models/award.dart';

class ProfileApi {
  ProfileApi(this._dio);

  final Dio _dio;

  /// Profile "Công cụ nhanh" — server-driven from the `menu-admin` folder
  /// (matches v1, distinct from the home grid's folder=19):
  /// `GET /api_customer/news_by_folder.json?folder=menu-admin`.
  Future<List<QuickTool>> quickToolsMenuAdmin() async {
    final res = await _dio.get(
      '${AppConfig.customer}/news_by_folder.json',
      queryParameters: {'folder': 'menu-admin'},
    );
    final data = res.data;
    final raw = (data is Map
            ? (data['result'] ?? data['items'] ?? data['data'])
            : data) ??
        const [];
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map(QuickTool.fromJson)
        .where((t) => t.name.isNotEmpty)
        .toList();
  }

  /// Company info HTML block shown at the bottom of the profile (v1 news id=248):
  /// `GET /api_agent/news_by_id.json?id=248` → `htmlcontent`.
  Future<String> companyInfoHtml() async {
    final res = await _dio.get('${AppConfig.agent}/news_by_id.json',
        queryParameters: {'id': 248});
    final data = res.data;
    Map? node;
    if (data is Map) {
      node = data['result'] is Map
          ? data['result'] as Map
          : (data['data'] is Map ? data['data'] as Map : data);
    }
    final raw =
        (node?['htmlcontent'] ?? node?['html_content'] ?? '').toString();
    return _normalizeHtml(raw);
  }

  /// Rewrite malformed/relative image sources so they resolve (ported from v1).
  String _normalizeHtml(String html) {
    if (html.isEmpty) return html;
    var out = html.replaceAll('src="/https://', 'src="https://');
    const base = 'https://quanly.tongkhobds.com';
    out = out.replaceAllMapped(
      RegExp(r'src="/(?!https?://)([^"]+)"'),
      (m) => 'src="$base/${m.group(1)}"',
    );
    return out;
  }

  /// Agent award/rank — `get_award_detail_by_user.json`.
  Future<AwardDetail?> award() async {
    final res =
        await _dio.get('${AppConfig.agent}/get_award_detail_by_user.json');
    final data = res.data;
    final Map? d = data is Map
        ? (data['data'] is Map
            ? data['data'] as Map
            : (data['result'] is Map ? data['result'] as Map : data))
        : null;
    if (d == null || d.isEmpty) return null;
    final a = AwardDetail.fromJson(d);
    return a.hasAward ? a : null;
  }

  /// Change password while logged in (v1 `update_password.json`). The
  /// password-less variant (`create_new_password`) belongs to the forgot flow.
  Future<void> changePassword(String oldPassword, String newPassword) async {
    await _dio.post('${AppConfig.agent}/update_password.json', data: {
      'old_password': oldPassword,
      'new_password': newPassword,
    });
  }

  Future<void> updateProfile({
    required String fullName,
    required String phone,
    String? email,
    String? address,
    String? birthday,
    int? yoe,
    String? cityId,
    String? districtId,
    String? wardId,
  }) async {
    await _dio.post('${AppConfig.agent}/update_profile.json', data: {
      'full_name': fullName,
      'phone': phone,
      if (email != null && email.isNotEmpty) 'email': email,
      if (address != null && address.isNotEmpty) 'address': address,
      if (birthday != null && birthday.isNotEmpty) 'birthday': birthday,
      if (yoe != null) 'yoe': yoe,
      if (cityId != null && cityId.isNotEmpty) 'city_id': cityId,
      if (districtId != null && districtId.isNotEmpty) 'district_id': districtId,
      if (wardId != null && wardId.isNotEmpty) 'ward_id': wardId,
    });
  }

  Future<void> updateAvatar(String path) async {
    final form = FormData.fromMap({'file': await MultipartFile.fromFile(path)});
    await _dio.post('${AppConfig.agent}/update_avatar.json', data: form);
  }

  /// Update the agent's tax code (MST) — `update_profile.json {tax_code}`.
  Future<void> updateTaxCode(String taxCode) async {
    await _dio.post('${AppConfig.agent}/update_profile.json',
        data: {'tax_code': taxCode});
  }

  /// Request account deletion — `delete_acc {username}`.
  Future<void> deleteAccount(String username) async {
    await _dio.post('${AppConfig.agent}/delete_acc', data: {'username': username});
  }

}

final profileApiProvider =
    Provider<ProfileApi>((ref) => ProfileApi(ref.watch(dioProvider)));

final awardProvider = FutureProvider.autoDispose<AwardDetail?>((ref) {
  return ref.watch(profileApiProvider).award();
});

final profileQuickToolsProvider =
    FutureProvider.autoDispose<List<QuickTool>>((ref) {
  return ref.watch(profileApiProvider).quickToolsMenuAdmin();
});

final companyInfoProvider = FutureProvider.autoDispose<String>((ref) {
  return ref.watch(profileApiProvider).companyInfoHtml();
});
