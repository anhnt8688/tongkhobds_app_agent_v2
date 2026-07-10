/// Structured contract content for the preview-by-id screen
/// (`contract_content_by_id.json` → `result`). Mirrors v1
/// `ContractPreviewPage` parsing/formatting.
class ContractPreview {
  const ContractPreview({
    required this.companyName,
    required this.businessCode,
    required this.companyAddress,
    required this.representative,
    required this.representativePosition,
    required this.agentName,
    required this.agentBirthday,
    required this.agentCccd,
    required this.agentCccdDate,
    required this.agentCccdPlace,
    required this.agentAddress,
    required this.agentPhone,
    required this.contractValue,
    required this.brokerageFee,
    required this.commissionText,
    required this.contractTypeId,
    required this.contractTypes,
    required this.signingMethods,
    this.officeId,
  });

  // Bên A (info_office)
  final String companyName;
  final String businessCode;
  final String companyAddress;
  final String representative;
  final String representativePosition;

  // Bên B (verify_agent)
  final String agentName;
  final String agentBirthday;
  final String agentCccd;
  final String agentCccdDate;
  final String agentCccdPlace;
  final String agentAddress;
  final String agentPhone;

  // Thông tin hợp đồng (real_estate_salesman)
  final String contractValue; // formatted money
  final String brokerageFee; // formatted
  final String commissionText; // text_percent or '—'
  final dynamic contractTypeId;

  // Option label lookups (contract_options)
  final List contractTypes; // [{id,label}]
  final List signingMethods; // [{id,label}]

  /// `info_office.id` — needed to fetch the contract HTML (`contract_agent.json`)
  /// and to create the contract for the right office.
  final int? officeId;

  factory ContractPreview.fromJson(Map result) {
    final office = _map(result['info_office']);
    final agent = _map(result['verify_agent']);
    final sale = _map(result['real_estate_salesman']);
    final options = _map(result['contract_options']);

    final commission = (sale['text_percent'] ?? '').toString();
    final ownerPhone = (sale['owner_phone'] ?? '').toString();

    return ContractPreview(
      companyName: _s(office['company_name']),
      businessCode: _s(office['business_code']),
      companyAddress: _s(office['company_address']),
      representative: _s(office['company_representative']),
      representativePosition: _s(office['position_representative']),
      agentName: _s(agent['name']),
      agentBirthday: _fmtDate(agent['birthday']),
      agentCccd: _s(agent['id_card']),
      agentCccdDate: _fmtDate(agent['id_day']),
      agentCccdPlace: _s(agent['id_by']),
      agentAddress: _s(agent['address']),
      agentPhone:
          (ownerPhone.isNotEmpty && ownerPhone != 'null') ? ownerPhone : '—',
      contractValue: _formatMoney(sale['real_estate_value']),
      brokerageFee: _formatBrokerageFee(
          sale['brokerage_fee_value'], (sale['brokerage_fee_unit'] ?? '').toString()),
      commissionText: (commission.isNotEmpty && commission != 'null')
          ? commission
          : '—',
      contractTypeId: sale['contract_type'],
      contractTypes: result['contract_options'] != null
          ? (options['contract_types'] is List
              ? options['contract_types'] as List
              : const [])
          : const [],
      signingMethods: options['signing_methods'] is List
          ? options['signing_methods'] as List
          : const [],
      officeId: int.tryParse('${office['id']}'),
    );
  }

  /// Resolve a contract-type label from its id (falls back to the raw value).
  String contractTypeLabel(dynamic arg) =>
      _label(arg ?? contractTypeId, contractTypes);

  /// Resolve a signing-method label from its id (falls back to the raw value).
  String signMethodLabel(dynamic arg) => _label(arg, signingMethods);

  static String _label(dynamic id, List options) {
    if (id == null) return '—';
    if (id is String && id.length > 2) return id; // already a label
    final target = id is int ? id : int.tryParse(id.toString());
    for (final o in options) {
      if (o is Map && o['id'] == target) {
        return (o['label'] ?? id).toString();
      }
    }
    return id.toString();
  }
}

Map _map(dynamic v) => v is Map ? v : const {};
String _s(dynamic v) {
  final s = (v ?? '').toString().trim();
  return s.isEmpty ? '—' : s;
}

String _formatMoney(dynamic value) {
  if (value == null) return '—';
  final n = double.tryParse(value.toString());
  if (n == null) return '—';
  final grouped = n.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  return '$grouped đ';
}

String _formatBrokerageFee(dynamic value, String unit) {
  if (value == null) return '—';
  final n = double.tryParse(value.toString());
  if (n == null) return '—';
  return unit == 'percent' ? '$n%' : _formatMoney(n);
}

/// Normalize a `yyyy-MM-dd` date to `dd/MM/yyyy` (v1 `_fmtDate`).
String _fmtDate(dynamic v) {
  final s = (v ?? '').toString().trim();
  if (s.isEmpty) return '—';
  final parts = s.split('-');
  if (parts.length == 3 && parts[0].length == 4) {
    final d = parts[2].padLeft(2, '0');
    final m = parts[1].padLeft(2, '0');
    return '$d/$m/${parts[0]}';
  }
  return s;
}
