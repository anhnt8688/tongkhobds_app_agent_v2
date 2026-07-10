import '../../../../core/utils/json_parse.dart';

/// A generic selectable option (id + display name) used by the legal-document
/// and furniture pickers (`get_legal_documents` / `get_furniture`).
class OptionItem {
  const OptionItem({required this.id, required this.name});

  final int id;
  final String name;

  factory OptionItem.fromJson(Map d) => OptionItem(
        id: asInt(d['id']),
        name: asString(d['name'] ?? d['title'] ?? d['vietnamese']),
      );

  @override
  bool operator ==(Object other) =>
      other is OptionItem && other.id == id && other.name == name;

  @override
  int get hashCode => Object.hash(id, name);
}
