import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewPage extends StatefulWidget {
  WebViewPage({Key? key, required this.url, required this.title})
      : super(key: key);

  final String url;
  final String title;

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late InAppWebViewController webView;
  late bool status;

  Widget myPlayer(URLRequest url) {
    return InAppWebView(
      initialUrlRequest: url,
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
            // debuggingEnabled: true,
            ),
      ),
      onWebViewCreated: (InAppWebViewController controller) {
        webView = controller;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue.shade800,
      ),
      body: myPlayer(URLRequest(url: Uri.parse(widget.url))),
    );
  }
}
