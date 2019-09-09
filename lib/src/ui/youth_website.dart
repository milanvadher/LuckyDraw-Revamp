import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youth_app/src/utils/constant.dart';

class AppWebView extends StatefulWidget {
  final String url;

  const AppWebView({Key key, this.url}) : super(key: key);

  @override
  _AppWebViewState createState() => _AppWebViewState();
}

class _AppWebViewState extends State<AppWebView> with AutomaticKeepAliveClientMixin<AppWebView> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: '$youthWebsiteURL',
      javascriptMode: JavascriptMode.unrestricted,
      initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
      onWebViewCreated: (WebViewController webViewController) {
        _controller.complete(webViewController);
      },
      onPageFinished: (String url) {
        print('Page finished loading: $url');
      },
    );
    /*return WillPopScope(
      onWillPop: () {
        return CommonFunction.onWillPop(
          context: context,
          msg: 'Do you want to exit Youth Website ?',
        );
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Container(
            padding: EdgeInsets.all(10),
            child: Hero(
              tag: 'youth_website',
              child: Image(
                image: AssetImage('images/youth_logo.png'),
              ),
            ),
          ),
          titleSpacing: 2,
          title: Text('Youth Website'),
          actions: <Widget>[
            IconButton(
              tooltip: 'Exit',
              onPressed: () async {
                bool result = await CommonFunction.onWillPop(
                  context: context,
                  msg: 'Do you want to exit Youth Website',
                );
                if (result) {
                  Navigator.pop(context);
                }
              },
              icon: Icon(Icons.exit_to_app),
            )
          ],
        ),
        body: WebView(
          initialUrl: '$youthWebsiteURL',
          javascriptMode: JavascriptMode.unrestricted,
          initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
        ),
      ),
    );*/
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
