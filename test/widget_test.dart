import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_app_v2/features/realestate/data/models/property.dart';

void main() {
  group('Property parsing', () {
    test('parses loosely-typed fields and nested property_type', () {
      final p = Property.fromJson({
        'id': '901',
        'title': 'Bán căn hộ Quận 7',
        'address': '123 Nguyễn Huệ',
        'price': '2800000000',
        'area': 75,
        'bedrooms': '2',
        'property_type': {'id': 5, 'name': 'Chung cư'},
        'images': ['https://example.com/a.jpg'],
      });

      expect(p.id, 901);
      expect(p.bedrooms, 2);
      expect(p.propertyTypeName, 'Chung cư');
      expect(p.image, 'https://example.com/a.jpg');
    });

    test('formatVnd shortens to tỷ/triệu', () {
      expect(formatVnd(2800000000), '2.8 tỷ');
      expect(formatVnd(500000000), '500 triệu');
      expect(formatVnd(0), 'Thỏa thuận');
    });
  });
}
