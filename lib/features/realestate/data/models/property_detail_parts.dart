import '../../../../core/config/app_config.dart';
import '../../../../core/utils/json_parse.dart';

/// A legal-document file attached to a listing (`legal_document_file[]`).
class LegalDocFile {
  const LegalDocFile({this.title, this.type, this.icon, this.url});

  final String? title;
  final String? type;
  final String? icon;
  final String? url;

  bool get hasUrl => url != null && url!.isNotEmpty;

  factory LegalDocFile.fromJson(Map data) => LegalDocFile(
        title: data['title']?.toString(),
        type: data['type']?.toString(),
        icon: data['icon']?.toString(),
        url: AppConfig.imageUrl(data['url']?.toString()),
      );
}

/// A key attribute chip/row shown in the spec section (`key_attributes[]`).
class KeyAttribute {
  const KeyAttribute({this.title, this.icon, this.value});

  final String? title;
  final String? icon;
  final String? value;

  bool get hasValue => value != null && value!.trim().isNotEmpty;

  factory KeyAttribute.fromJson(Map data) => KeyAttribute(
        title: data['title']?.toString(),
        icon: data['icon']?.toString(),
        value: data['value']?.toString(),
      );
}

/// A commission tier (`commissionRate[]`) — rate % + label.
class CommissionRate {
  const CommissionRate({this.title, this.rate, this.bonus, this.description});

  final String? title;
  final double? rate;
  final double? bonus;
  final String? description;

  factory CommissionRate.fromJson(Map data) => CommissionRate(
        title: data['title']?.toString(),
        rate: asDoubleOrNull(data['rate']),
        bonus: asDoubleOrNull(data['bonus']),
        description: data['description']?.toString(),
      );
}

/// Verified-by-agent contact block (`verified_by_agent_info`).
class VerifiedByAgentInfo {
  const VerifiedByAgentInfo({
    this.name,
    this.phone,
    this.contactFacebook,
    this.postOfficeName,
  });

  final String? name;
  final String? phone;
  final String? contactFacebook;
  final String? postOfficeName;

  bool get hasData =>
      (name?.trim().isNotEmpty ?? false) ||
      (phone?.trim().isNotEmpty ?? false) ||
      (contactFacebook?.trim().isNotEmpty ?? false) ||
      (postOfficeName?.trim().isNotEmpty ?? false);

  factory VerifiedByAgentInfo.fromJson(Map data) => VerifiedByAgentInfo(
        name: data['name']?.toString(),
        phone: data['phone']?.toString(),
        contactFacebook: data['contact_facebook']?.toString(),
        postOfficeName: data['post_office_name']?.toString(),
      );
}

/// A single verified-by-agent link row (`verified_by_agent_info_arr[]`).
class VerifiedByAgentItem {
  const VerifiedByAgentItem({this.type, this.label, this.url});

  final String? type;
  final String? label;
  final String? url;

  bool get hasLabel => label?.trim().isNotEmpty ?? false;

  factory VerifiedByAgentItem.fromJson(Map data) => VerifiedByAgentItem(
        type: data['type']?.toString(),
        label: data['label']?.toString(),
        url: data['url']?.toString(),
      );
}
