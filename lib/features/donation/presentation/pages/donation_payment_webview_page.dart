import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

class _DonationPaymentWebViewPageState extends State<DonationPaymentWebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
