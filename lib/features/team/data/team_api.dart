import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import '../../auth/presentation/controllers/auth_controller.dart';
import 'models/team_member.dart';
import 'models/tree_node.dart';

// Re-export models so `import '../data/team_api.dart'` callers keep resolving
// TeamMemberItem / TreeNode.
export 'models/team_member.dart';
export 'models/tree_node.dart';

/// Team-management API (v1 `/api_agent` team endpoints). Responses are wrapped
/// as `{data: {...}}`; [_data] resolves the inner map and [_items] the list.
class TeamApi {
  TeamApi(this._dio);
  final Dio _dio;

  Map _data(Object? raw) {
    if (raw is Map) return raw['data'] is Map ? raw['data'] as Map : raw;
    return const {};
  }

  List _items(Object? raw) {
    final d = _data(raw);
    final v = d['items'] ?? d['members'] ?? d['data'];
    return v is List ? v : const [];
  }

  Future<Response> _get(String path, Map<String, dynamic> params) =>
      _dio.get('${AppConfig.agent}/$path', queryParameters: params);

  // ── Overview ────────────────────────────────────────────────────────────────

  /// Raw overview map (member detail reads many personal_*/team_* keys).
  Future<Map> overviewRaw(int salesmanId) async {
    final res = await _get('api_team_overview.json', {'salesman_id': salesmanId});
    return _data(res.data);
  }

  // ── Member detail sources ─────────────────────────────────────────────────────

  Future<Map> memberDetail(int salesmanId) async {
    final res = await _get('api_member_detail', {'salesman_id': salesmanId});
    return _data(res.data);
  }

  /// Full descendant list for the member-detail "Thành viên" tab (v1
  /// `tree_type: 'referral'`).
  Future<List<TeamMemberItem>> subMembers({
    required int salesmanId,
    int maxDepth = 10,
    bool includeSelf = true,
    String treeType = 'referral',
  }) async {
    final res = await _get('api_sub_members', {
      'salesman_id': salesmanId,
      'max_depth': maxDepth,
      'include_self': includeSelf,
      'tree_type': treeType,
    });
    return _items(res.data).whereType<Map>().map(TeamMemberItem.fromJson).toList();
  }

  Future<List<TeamMemberItem>> memberSubordinates(int salesmanId) =>
      _memberList('api_member_subordinates', salesmanId);

  Future<List<Map>> memberTransactions(int salesmanId) =>
      _rawList('api_member_transactions', salesmanId);
  Future<List<Map>> memberInventory(int salesmanId) =>
      _rawList('api_member_inventory', salesmanId);
  Future<List<Map>> memberActivityLog(int salesmanId) =>
      _rawList('api_member_activity_log', salesmanId);

  // ── Team (descendant-aggregate) sources ───────────────────────────────────────

  Future<List<Map>> teamTransactions(int salesmanId) =>
      _rawList('api_team_transactions', salesmanId);
  Future<List<Map>> teamInventory(int salesmanId) =>
      _rawList('api_team_inventory', salesmanId);
  Future<List<Map>> teamActivityLog(int salesmanId) =>
      _rawList('api_team_activity_log', salesmanId);

  // ── Org-chart trees ────────────────────────────────────────────────────────────

  /// "Sơ đồ danh hiệu" — `api_get_title_full_tree`.
  Future<TreeNode?> titleTree(int salesmanId) async {
    final res = await _get('api_get_title_full_tree', {
      'salesman_id': salesmanId,
      'max_depth': 10,
      'include_parents': true,
      'max_parents': 2,
    });
    return _treeRoot(res.data);
  }

  /// "Sơ đồ vòng đời" — `api_get_full_tree`.
  Future<TreeNode?> fullTree(int salesmanId) async {
    final res = await _get('api_get_full_tree', {
      'salesman_id': salesmanId,
      'include_parents': true,
      'max_parents': 2,
    });
    return _treeRoot(res.data);
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  Future<List<TeamMemberItem>> _memberList(String path, int salesmanId) async {
    final res = await _get(path, {'salesman_id': salesmanId});
    return _items(res.data).whereType<Map>().map(TeamMemberItem.fromJson).toList();
  }

  Future<List<Map>> _rawList(String path, int salesmanId) async {
    final res = await _get(path, {'salesman_id': salesmanId});
    return _items(res.data).whereType<Map>().toList();
  }

  TreeNode? _treeRoot(Object? raw) {
    final d = _data(raw);
    final tree = d['tree'] ?? d['root'] ?? d;
    if (tree is Map && tree.isNotEmpty) return TreeNode.fromJson(tree);
    if (tree is List && tree.isNotEmpty && tree.first is Map) {
      return TreeNode.fromJson(tree.first as Map);
    }
    return null;
  }
}

final teamApiProvider = Provider<TeamApi>((ref) => TeamApi(ref.watch(dioProvider)));

/// The current agent's salesman_id (from the auth profile).
final currentSalesmanIdProvider = Provider<int>((ref) {
  return ref.watch(currentUserProvider)?.salesmanId ?? 0;
});
