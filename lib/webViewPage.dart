import 'package:flutter/material.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
            useOnDownloadStart: true,
            allowUniversalAccessFromFileURLs: true,
            javaScriptCanOpenWindowsAutomatically: true,
            javaScriptEnabled: true,
            allowFileAccessFromFileURLs: true,
            useShouldOverrideUrlLoading: true,
          ),
          android: AndroidInAppWebViewOptions(supportMultipleWindows: true)),
      onWebViewCreated: (InAppWebViewController controller) {
        webView = controller;
      },
      shouldOverrideUrlLoading:
          (InAppWebViewController controller, NavigationAction request) async {
        var url = request.request.url.toString();

        if (["mailto", "whatsapp"].contains(request.request.url)) {
          if (await canLaunchUrl(request.request.url!)) {
            // Launch the App
            await launchUrlString(
              url,
            );
            // and cancel the request
            return NavigationActionPolicy.CANCEL;
          }
        }

        return NavigationActionPolicy.ALLOW;
      },
      onDownloadStartRequest: (InAppWebViewController controller,
          DownloadStartRequest startReq) async {
        // final taskId = await FlutterDownloader.enqueue(
        //   url: startReq.url.toString(),
        //   savedDir: (await getExternalStorageDirectory())!.path,
        //   showNotification:
        //       true, // show download progress in status bar (for Android)
        //   openFileFromNotification:
        //       true, // click on notification to open downloaded file (for Android)
        // );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.title),
        backgroundColor: Colors.blue.shade800,
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (webView != null) {
            webView.goBack();
          }
          return false;
        },
        child: myPlayer(URLRequest(url: Uri.parse(widget.url))),
      ),
    );
  }
}
