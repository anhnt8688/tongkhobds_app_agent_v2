import '../../../../core/utils/json_parse.dart';

/// One dynamic field of the "Mô tả thêm" section, from
/// `get_property_type_fields` → `data.fields_array[]` (matches v1 GiuFieldModel).
/// [type] drives which widget renders (e.g. `bedrooms`, `house_direction`,
/// `legal_document_type`, `frontage`, ...).
class FormFieldSpec {
  const FormFieldSpec({required this.title, required this.type});

  final String title;
  final String type;

  factory FormFieldSpec.fromJson(Map d) => FormFieldSpec(
        title: asString(d['title']),
        type: asString(d['type']),
      );
}
