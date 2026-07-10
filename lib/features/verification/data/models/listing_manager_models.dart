import '../../../../core/config/app_config.dart';
import '../../../../core/utils/json_parse.dart';

/// Tree node from `get_listing_manager.json`.
class ListingManagerTreeNode {
  final int id;
  final int salesmanId;
  final String name;
  final String? nameCode;
  final String? phone;
  final String? avatar;
  final String? titleCode;
  final String? titleName;
  final int depth;
  final bool hasChildren;
  final bool isListingManager;
  final List<ListingManagerTreeNode> children;

  const ListingManagerTreeNode({
    required this.id,
    required this.salesmanId,
    required this.name,
    required this.nameCode,
    required this.phone,
    required this.avatar,
    required this.titleCode,
    required this.titleName,
    required this.depth,
    required this.hasChildren,
    required this.isListingManager,
    required this.children,
  });

  factory ListingManagerTreeNode.fromJson(Map json) {
    final rawChildren = json['children'];
    return ListingManagerTreeNode(
      id: asInt(json['id']),
      salesmanId: asInt(json['salesman_id']),
      name: asString(json['name']),
      nameCode: json['name_code']?.toString(),
      phone: json['phone']?.toString(),
      avatar: json['avatar']?.toString(),
      titleCode: json['title_code']?.toString(),
      titleName: json['title_name']?.toString(),
      depth: asInt(json['depth']),
      hasChildren: json['has_children'] == true,
      isListingManager: json['is_listing_manager'] == true,
      children: rawChildren is List
          ? rawChildren
              .whereType<Map>()
              .map(ListingManagerTreeNode.fromJson)
              .toList()
          : const [],
    );
  }

  /// Flatten the whole subtree into view-models (parent name = team label).
  List<ListingManagerItemViewModel> flattenItems({String parentLabel = ''}) {
    final out = <ListingManagerItemViewModel>[];
    out.add(ListingManagerItemViewModel.fromNode(this, parentLabel));
    for (final c in children) {
      out.addAll(c.flattenItems(parentLabel: name));
    }
    return out;
  }
}

class ListingManagerResponse {
  final int status;
  final int count;
  final ListingManagerTreeNode? tree;
  final String message;

  const ListingManagerResponse({
    required this.status,
    required this.count,
    required this.tree,
    required this.message,
  });

  /// `data` is already unwrapped by the EnvelopeInterceptor → `{tree, meta,...}`.
  factory ListingManagerResponse.fromData(dynamic data) {
    final root = data is Map ? data : const {};
    final rawTree = root['tree'];
    return ListingManagerResponse(
      status: asInt(root['status'], fallback: 1),
      count: asInt(root['count']),
      tree: rawTree is Map ? ListingManagerTreeNode.fromJson(rawTree) : null,
      message: asString(root['message']),
    );
  }

  /// All selectable items flattened from the tree.
  List<ListingManagerItemViewModel> get items =>
      tree == null ? const [] : tree!.flattenItems();
}

class ListingManagerItemViewModel {
  final int id;
  final int salesmanId;
  final String name;
  final String phone;
  final String role;
  final String teamLabel;
  final String avatar;
  final bool isListingManager;
  final int depth;

  const ListingManagerItemViewModel({
    required this.id,
    required this.salesmanId,
    required this.name,
    required this.phone,
    required this.role,
    required this.teamLabel,
    required this.avatar,
    required this.isListingManager,
    required this.depth,
  });

  int get effectiveId => salesmanId != 0 ? salesmanId : id;

  factory ListingManagerItemViewModel.fromNode(
      ListingManagerTreeNode node, String teamLabel) {
    return ListingManagerItemViewModel(
      id: node.id,
      salesmanId: node.salesmanId,
      name: node.name,
      phone: node.phone ?? '',
      role: node.titleName ?? '',
      teamLabel: teamLabel,
      avatar: AppConfig.imageUrl(node.avatar) ?? '',
      isListingManager: node.isListingManager,
      depth: node.depth,
    );
  }
}
