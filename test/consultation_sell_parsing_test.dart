import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_app_v2/features/consultation_sell/data/models/sell_lead.dart';

void main() {
  group('SellPermissions.fromJson', () {
    test('parses SELL_DEMAND_* bool map (tester sample)', () {
      final p = SellPermissions.fromJson(const {
        'SELL_DEMAND_ACTIVITY': true,
        'SELL_DEMAND_EDIT': true,
        'SELL_DEMAND_CREATE_VERIFY': true,
        'SELL_DEMAND_LIST': true,
        'SELL_DEMAND_CLOSE': true,
        'SELL_DEMAND_ASSIGN_LISTING': true,
        'SELL_DEMAND_ADD_SALES': true,
        'SELL_DEMAND_ADD_OFFICE': true,
        'SELL_DEMAND_CREATE_CONTRACT': true,
        'SELL_DEMAND_CREATE_LISTING': true,
        'SELL_DEMAND_EDIT_SALES': true,
        'SELL_DEMAND_ADD': true,
        'SELL_DEMAND_ADD_TAG': true,
        'SELL_DEMAND_EXPORT': true,
      });
      expect(p.activity, true);
      expect(p.assignListing, true);
      expect(p.createVerify, true);
      expect(p.createContract, true);
      expect(p.createListing, true);
      expect(p.close, true);
      expect(p.add, true);
      expect(p.addTag, true);
    });

    test('missing/false keys default to false', () {
      final p = SellPermissions.fromJson(const {'SELL_DEMAND_CLOSE': false});
      expect(p.close, false);
      expect(p.add, false); // absent key
      expect(const SellPermissions().add, false); // default ctor
    });
  });

  group('ListingManager.fromJson + isListingManager filter', () {
    // Trimmed shape of the real `get_listing_managers_by_post_office`
    // response's `data.flat_list[]` (tester-provided sample).
    const flatList = [
      {
        'id': 253380,
        'name': 'Trần Nguyễn Trường Phi',
        'phone': '0987813833',
        'is_listing_manager': false, // org header node — must be filtered out
        'post_office_id': 7,
        'post_office_name': 'VP Nghệ An',
      },
      {
        'id': 617995,
        'name': 'user test',
        'phone': '0940000011',
        'is_listing_manager': true,
        'post_office_id': 7,
        'post_office_name': 'VP Nghệ An',
      },
    ];

    test('isListingManager filters out non-manager org nodes', () {
      final managers = flatList.where(ListingManager.isListingManager).toList();
      expect(managers.length, 1);
      expect(managers.first['id'], 617995);
    });

    test('fromJson parses name/phone/officeName from post_office_name', () {
      final m = ListingManager.fromJson(flatList[1]);
      expect(m.id, 617995);
      expect(m.name, 'user test');
      expect(m.phone, '0940000011');
      expect(m.officeName, 'VP Nghệ An');
    });
  });

  group('SellLeadDetail.fromJson — real_estate/verification/contract siblings', () {
    // Trimmed shape of `get_consultation_sell?id=62` (user-provided sample,
    // devquanly). The 3 objects are siblings at the top level, not nested.
    final sample = {
      'id': 62,
      'verifying_real_estate_salesman': {
        'real_estate_salesman_id': 7873914,
        'real_estate_id': 6814399,
        'real_estate_title': 'Tin đabgw test nhu cầu babns',
        'real_estate_code': 'M15TT6814399',
        'verification_status': 2,
        'verification_name': 'Đã duyệt',
        'verification_color': '#D1FAE5',
        'is_owner': false,
        'verification_type': 'collaborator',
        'verification_type_name': 'CTV',
      },
      'contract': {
        'id': 515,
        'contract_code': null,
        'status_name': 'Chờ duyệt',
        'status_color': '#FEF3C7',
        'office_name': 'VP Nghệ An',
        'contract_type': 2,
        'contract_type_name': 'Thông thường',
      },
      'real_estate': {
        'id': 6814399,
        'title': 'Tin đabgw test nhu cầu babns',
        'real_estate_code': 'M15TT6814399',
        'area': 120.0,
        'price': 34000000000,
        'price_description': '34 tỷ',
        'bedrooms': null,
        'bathrooms': null,
        'images': [
          'https://s3-han02.fptcloud.com/bds-crawl-data/uploads/2026/07/1783319549456.jpg',
        ],
        'main_image':
            'https://s3-han02.fptcloud.com/bds-crawl-data/uploads/2026/07/1783319549456.jpg',
      },
    };

    test('parses real_estate into realEstateRef', () {
      final d = SellLeadDetail.fromJson(sample);
      expect(d.realEstateRef?.id, 6814399);
      expect(d.realEstateRef?.title, 'Tin đabgw test nhu cầu babns');
      expect(d.realEstateRef?.code, 'M15TT6814399');
      expect(d.realEstateRef?.priceDescription, '34 tỷ');
      expect(d.realEstateRef?.area, 120.0);
      expect(d.hasLinkedRealEstate, true);
    });

    test('parses verifying_real_estate_salesman into verificationRef', () {
      final v = SellLeadDetail.fromJson(sample).verificationRef;
      expect(v?.realEstateSalesmanId, 7873914);
      expect(v?.verificationName, 'Đã duyệt');
      expect(v?.verificationColor, '#D1FAE5');
      expect(v?.verificationTypeName, 'CTV');
      expect(v?.isApproved, true); // verification_status == 2
      expect(v?.isOwner, false);
    });

    test('parses contract into contractRef', () {
      final c = SellLeadDetail.fromJson(sample).contractRef;
      expect(c?.id, 515);
      expect(c?.statusName, 'Chờ duyệt');
      expect(c?.statusColor, '#FEF3C7');
      expect(c?.officeName, 'VP Nghệ An');
      expect(c?.contractTypeName, 'Thông thường');
      expect(c?.contractCode, null); // API sent null literal
    });

    test('missing siblings parse to null refs (no crash)', () {
      final d = SellLeadDetail.fromJson({'id': 1});
      expect(d.realEstateRef, null);
      expect(d.verificationRef, null);
      expect(d.contractRef, null);
      expect(d.hasLinkedRealEstate, false);
    });
  });
}
