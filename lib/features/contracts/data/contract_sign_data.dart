import '../../../core/config/app_config.dart';

/// Renderable contract for the signing screen (v1 `contract_agent.json`
/// `data.html` + `side_a` / `side_b`). Carries the HTML plus the names and the
/// Bên A signature image used to build the embedded signature panel.
class ContractSignData {
  const ContractSignData({
    required this.html,
    required this.repAName,
    required this.repASignUrl,
    required this.agentName,
  });

  /// Full contract HTML to render in the WebView.
  final String html;

  /// Bên A representative name (`side_a.company_representative`).
  final String repAName;

  /// Bên A signature image URL, resolved to an absolute URL.
  final String repASignUrl;

  /// Bên B (agent) name (`side_b.name`).
  final String agentName;

  factory ContractSignData.fromJson(Map data) {
    final sideA = data['side_a'] is Map ? data['side_a'] as Map : const {};
    final sideB = data['side_b'] is Map ? data['side_b'] as Map : const {};

    final repName = (sideA['company_representative'] ?? '').toString().trim();
    final rawSign = (sideA['signature_image'] ?? '').toString().trim();
    final agentName = (sideB['name'] ?? '').toString().trim();

    return ContractSignData(
      html: (data['html'] ?? '').toString(),
      repAName: repName.isEmpty ? '—' : repName,
      repASignUrl: rawSign.isEmpty
          ? ''
          : (rawSign.startsWith('http')
              ? rawSign
              : (AppConfig.imageUrl(rawSign) ?? rawSign)),
      agentName: agentName.isEmpty ? '—' : agentName,
    );
  }
}
