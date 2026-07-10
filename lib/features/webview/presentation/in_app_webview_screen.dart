import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../auth/presentation/controllers/auth_controller.dart';

/// In-app browser for embedded TongkhoBDS pages (e-learning, webview quick
/// tools). Ported from v1 `InAppWebViewPage`: injects the bearer token as both
/// an `Authorization` header and a `token` cookie (host + `.tongkhobds.com`),
/// and re-loads main-frame navigations with the header so auth survives links.
class InAppWebViewScreen extends ConsumerStatefulWidget {
  const InAppWebViewScreen({
    super.key,
    required this.url,
    this.title = 'Xem chi tiết',
  });

  final String url;
  final String title;

  @override
  ConsumerState<InAppWebViewScreen> createState() => _InAppWebViewScreenState();
}

class _InAppWebViewScreenState extends ConsumerState<InAppWebViewScreen> {
  late final WebViewController _controller;
  final WebViewCookieManager _cookieManager = WebViewCookieManager();

  static const _cookieName = 'token';
  String? _lastLoadedWithHeadersUrl;

  String _stripBearer(String s) =>
      s.trim().replaceFirst(RegExp(r'^Bearer\s+', caseSensitive: false), '');

  Map<String, String> _buildHeaders(String token) {
    if (token.isEmpty) return {};
    return {
      'Authorization': 'Bearer $token',
      'Cookie': '$_cookieName=${_stripBearer(token)}',
    };
  }

  Future<void> _setCookies(String host, String value) async {
    if (value.isEmpty || host.isEmpty) return;
    await _cookieManager.setCookie(
      WebViewCookie(name: _cookieName, value: value, domain: host, path: '/'),
    );
    if (host.endsWith('.tongkhobds.com')) {
      await _cookieManager.setCookie(
        WebViewCookie(
          name: _cookieName,
          value: value,
          domain: '.tongkhobds.com',
          path: '/',
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    final token = (ref.read(authControllerProvider.notifier).currentToken ?? '')
        .trim();
    final headers = _buildHeaders(token);
    final cookieToken = _stripBearer(token);
    _lastLoadedWithHeadersUrl = widget.url;

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) async {
            final host = Uri.tryParse(request.url)?.host ?? '';
            await _setCookies(host, cookieToken);
            if (headers.isEmpty) return NavigationDecision.navigate;
            // Re-issue main-frame loads with the auth header so deep links and
            // redirects stay authenticated.
            if (request.isMainFrame &&
                request.url != _lastLoadedWithHeadersUrl) {
              _lastLoadedWithHeadersUrl = request.url;
              await _controller.loadRequest(
                Uri.parse(request.url),
                headers: headers,
              );
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageFinished: (_) => _hideWebChrome(),
        ),
      )
      // Start each session clean so stale cache/localStorage don't leak.
      ..clearCache()
      ..clearLocalStorage();

    _initCookiesAndLoad(cookieToken, headers);
  }

  /// Hides the website's own header/breadcrumb/footer so embedded pages render
  /// as clean in-app content (v1 `InAppWebViewPage` parity).
  Future<void> _hideWebChrome() async {
    try {
      await _controller.runJavaScript('''
        (function() {
          const interval = setInterval(() => {
            const header = document.getElementById('header-main');
            if (header) header.style.display = 'none';
            const breadCrumb = document.querySelector('.flat-title');
            if (breadCrumb) breadCrumb.style.display = 'none';
            const footer = document.getElementById('footer');
            if (footer) footer.style.display = 'none';
            if (header || breadCrumb || footer) clearInterval(interval);
          }, 300);
        })();
      ''');
    } catch (_) {}
  }

  /// Back inside the webview history first; only pop the route when there's no
  /// page to go back to (v1 `WebViewPage._onWillPop` parity).
  Future<void> _handlePop() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
    } else if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _initCookiesAndLoad(
    String cookieToken,
    Map<String, String> headers,
  ) async {
    await _cookieManager.clearCookies();
    final host = Uri.tryParse(widget.url)?.host ?? '';
    await _setCookies(host, cookieToken);
    await _controller.loadRequest(Uri.parse(widget.url), headers: headers);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _handlePop();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: WebViewWidget(controller: _controller),
      ),
    );
  }
}
