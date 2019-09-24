import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youth_app/src/utils/common_widget.dart';

class AppWebView extends StatefulWidget {
  final String url;

  const AppWebView({Key key, this.url}) : super(key: key);

  @override
  _AppWebViewState createState() => _AppWebViewState();
}

class _AppWebViewState extends State<AppWebView> with AutomaticKeepAliveClientMixin<AppWebView> {
  InAppWebViewController webView;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  String url = "";
  double progress = 0;

  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    webView.reload();
    return completer.future.then<void>((_) {
      _scaffoldKey.currentState?.showSnackBar(SnackBar(
        content: const Text('Refresh complete'),
        action: SnackBarAction(
          label: 'RETRY',
          onPressed: () {
            _refreshIndicatorKey.currentState.show();
          },
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    url = widget.url;
    return WillPopScope(
      onWillPop: () async {
        if (webView != null) {
          webView.goBack();
        }
        return false;
      },
      child: Scaffold(
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          child: Scrollbar(
            child: Container(
                child: Column(children: <Widget>[
              progress < 1 ? Container(padding: EdgeInsets.all(5), child: LinearProgressIndicator(backgroundColor: Colors.grey,value: progress)) : Container(),
              Expanded(
                child: Container(
                  child: InAppWebView(
                    initialUrl: url,
                    onWebViewCreated: (InAppWebViewController controller) {
                      webView = controller;
                    },
                    onProgressChanged: (InAppWebViewController controller, int progress) {
                      setState(() {
                        this.progress = progress / 100;
                      });
                    },
                    onLoadStart: (InAppWebViewController controller, String url) {
                      print("started $url");
                      setState(() {
                        this.url = url;
                      });
                    },
                    shouldOverrideUrlLoading: (InAppWebViewController controller, String url) {
                      controller.loadUrl(url);
                    },
                  ),
                ),
              ),
            ])),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.open_in_browser),
          onPressed: _launchURL,
          tooltip: 'Lauch in browser',
          heroTag: Random().nextDouble().toString(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  //@override
  Widget build1(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.open_in_browser),
        onPressed: _launchURL,
        tooltip: 'Lauch in browser',
        heroTag: Random().nextDouble().toString(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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

  _launchURL() async {
    if (await canLaunch(widget.url)) {
      await launch(widget.url);
    } else {
      CommonWidget.displayDialog(context: context, title: 'Can\'t launch', msg: '${widget.url} cant launch');
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
