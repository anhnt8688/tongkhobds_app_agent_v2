import '../../../../core/utils/json_parse.dart';

/// A node in the org-chart tree (`api_get_title_full_tree` /
/// `api_get_full_tree` → `data.tree`). v1 `_TreeNodeData`.
class TreeNode {
  const TreeNode({
    required this.salesmanId,
    required this.name,
    required this.titleName,
    required this.childrenCount,
    required this.children,
    required this.nodeKey,
    required this.codeText,
  });

  final int salesmanId;
  final String name;
  final String titleName;
  final int childrenCount;
  final List<TreeNode> children;

  /// Stable key for expand/collapse state.
  final String nodeKey;

  /// Short code shown under the name.
  final String codeText;

  factory TreeNode.fromJson(Map json) {
    final childrenRaw = json['children'] is List ? json['children'] as List : const [];
    final children = childrenRaw
        .whereType<Map>()
        .map(TreeNode.fromJson)
        .toList();

    final id = asInt(json['salesman_id'] ?? json['id']);
    return TreeNode(
      salesmanId: id,
      name: (json['name'] ?? '--').toString(),
      titleName: (json['title_name'] ?? json['title_code'] ?? '--').toString(),
      childrenCount: asInt(
          json['children_count'] ?? json['total_descendants'],
          fallback: children.length),
      children: children,
      nodeKey:
          (json['salesman_id'] ?? json['id'] ?? json['name'] ?? '?').toString(),
      codeText: (json['name_code'] ??
              json['title_code'] ??
              json['salesman_id'] ??
              json['id'] ??
              '--')
          .toString(),
    );
  }
}
