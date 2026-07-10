import '../../../../core/utils/json_parse.dart';
import '../../../realestate/data/models/property.dart';

/// A home "block" from `home_blocks.json` (v1 `BlockModel`): a titled group of
/// listings. [xtype] 1 = horizontal carousel, otherwise a vertical list.
class HomeBlock {
  const HomeBlock({
    required this.title,
    required this.xtype,
    required this.products,
  });

  final String title;
  final int xtype;
  final List<Property> products;

  bool get isHorizontal => xtype == 1;

  factory HomeBlock.fromJson(Map data) {
    final rawList = (data['data'] ?? data['list'] ?? data['products'] ?? [])
        as List? ??
        const [];
    final products = rawList
        .whereType<Map>()
        .map((e) => Property.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return HomeBlock(
      title: (data['title'] ?? data['name'] ?? '').toString(),
      xtype: asInt(data['xtype']),
      products: products,
    );
  }
}
