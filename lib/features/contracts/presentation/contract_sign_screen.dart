import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_screen.dart';
import '../../auth/presentation/controllers/auth_controller.dart';
import '../data/contract_sign_data.dart';
import '../data/contracts_api.dart';
import 'widgets/contract_signature_panel_js.dart';
import 'widgets/signature_pad_dialog.dart';

/// Ký hợp đồng (v1 `ContractReaderPage`): renders the contract in a WebView,
/// embeds an A/B signature panel, lets the agent draw their signature into the
/// Bên B slot, then continues to the OTP screen to finalise.
class ContractSignScreen extends ConsumerStatefulWidget {
  const ContractSignScreen({super.key, this.infoOffice = 1});

  /// `info_office` id used to load the contract HTML and create the contract.
  final int infoOffice;

  @override
  ConsumerState<ContractSignScreen> createState() => _ContractSignScreenState();
}

class _ContractSignScreenState extends ConsumerState<ContractSignScreen> {
  WebViewController? _controller;
  bool _loading = true;
  String? _error;
  String _title = 'Hợp đồng CTV';
  Uint8List? _signature;

  bool get _canSign => _signature != null && _signature!.isNotEmpty;
  String get _phone => ref.read(currentUserProvider)?.phone ?? '';

  @override
  void initState() {
    super.initState();
    _fetchContract();
  }

  Future<void> _fetchContract() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await ref
          .read(contractsApiProvider)
          .contractContent(infoOffice: widget.infoOffice);
      if (data.html.trim().isEmpty) {
        throw Exception('Không có nội dung hợp đồng');
      }
      _applyTitle(data.html);

      final ctrl = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..addJavaScriptChannel('ContractBridge',
            onMessageReceived: (msg) {
          if (msg.message == 'open-sign') _openSignDialog();
        })
        ..setNavigationDelegate(NavigationDelegate(
          onPageFinished: (_) async {
            await _injectPanel(data);
            if (mounted) setState(() => _loading = false);
          },
          onWebResourceError: (e) {
            if (e.isForMainFrame == true && mounted) {
              setState(() {
                _loading = false;
                _error = e.description;
              });
            }
          },
        ))
        ..loadHtmlString(data.html);

      if (mounted) setState(() => _controller = ctrl);
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.toString();
        });
      }
    }
  }

  void _applyTitle(String html) {
    final m = RegExp(r'<title>([^<]+)</title>', caseSensitive: false)
        .firstMatch(html);
    if (m != null) _title = m.group(1)!.trim();
  }

  Future<void> _injectPanel(ContractSignData data) async {
    final js = ContractSignaturePanelJs.build(
      repAName: data.repAName,
      repASignUrl: data.repASignUrl,
      agentName: data.agentName,
    );
    try {
      await _controller?.runJavaScript(js);
      // Re-attach a previously captured signature after a reload.
      if (_signature != null) {
        await _controller
            ?.runJavaScript(ContractSignaturePanelJs.attachSignature(_signature!));
      }
    } catch (_) {}
  }

  Future<void> _openSignDialog() async {
    final png = await SignaturePadDialog.show(context);
    if (png == null || png.isEmpty) return;
    _signature = png;
    await _controller
        ?.runJavaScript(ContractSignaturePanelJs.attachSignature(png));
    if (mounted) setState(() {});
  }

  void _goToOtp() {
    if (_phone.isEmpty) return;
    context.push('/contract/otp', extra: {
      'phone': _phone,
      'infoOffice': widget.infoOffice,
      'signature': _signature,
      'title': _title,
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: _title.isEmpty ? 'Hợp đồng' : _title,
      bottomNavigationBar: _BottomBar(
        onBack: () => context.pop(),
        onSign: _canSign ? _goToOtp : null,
      ),
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Không tải được hợp đồng', style: AppTextStyles.semibold(16)),
            const SizedBox(height: 8),
            Text(_error!,
                textAlign: TextAlign.center,
                style: AppTextStyles.regular(15, color: AppColors.danger)),
            const SizedBox(height: 12),
            OutlinedButton(
                onPressed: _fetchContract, child: const Text('Thử lại')),
          ],
        ),
      );
    }
    return _controller == null
        ? const SizedBox.shrink()
        : WebViewWidget(controller: _controller!);
  }
}

/// Bottom action bar: Quay lại + Ký hợp đồng (disabled until a signature is
/// drawn).
class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.onBack, this.onSign});
  final VoidCallback onBack;
  final VoidCallback? onSign;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, -2)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onBack,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Quay lại',
                    style: AppTextStyles.semibold(16, color: AppColors.text)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: onSign,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.primarySoft,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Ký hợp đồng',
                    style: AppTextStyles.semibold(16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
