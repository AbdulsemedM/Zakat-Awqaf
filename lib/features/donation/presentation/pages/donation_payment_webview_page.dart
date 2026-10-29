import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

/// The card gateway's hosted payment page. Loads and navigates to `https`
/// pages only (any host: 3-D Secure sends the payer to their bank's page),
/// refuses TLS errors, and clears cookies, cache and storage on close so the
/// card session doesn't outlive the page.
class DonationPaymentWebViewPage extends StatefulWidget {
  const DonationPaymentWebViewPage({
    required this.url,
    required this.title,
    super.key,
  });

  final Uri url;
  final String title;

  @override
  State<DonationPaymentWebViewPage> createState() =>
      _DonationPaymentWebViewPageState();
}

class _DonationPaymentWebViewPageState
    extends State<DonationPaymentWebViewPage> {
  late final WebViewController _controller;

  static bool _allowed(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    // about:blank is used for empty frames.
    return (uri.scheme == 'https' && uri.host.isNotEmpty) ||
        url == 'about:blank';
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) => _allowed(request.url)
              ? NavigationDecision.navigate
              : NavigationDecision.prevent,
          onSslAuthError: (error) => error.cancel(),
        ),
      );
    final platform = _controller.platform;
    if (platform is AndroidWebViewController) {
      platform
        ..setAllowFileAccess(false)
        ..setAllowContentAccess(false)
        ..setGeolocationEnabled(false)
        ..setMixedContentMode(MixedContentMode.neverAllow);
    }
    if (_allowed(widget.url.toString()) && widget.url.scheme == 'https') {
      _controller.loadRequest(widget.url);
    }
  }

  @override
  void dispose() {
    _controller
      ..clearCache()
      ..clearLocalStorage();
    WebViewCookieManager().clearCookies();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: WebViewWidget(controller: _controller),
    );
  }
}
