import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youth_app/src/ui_utils/scrollable_tabs.dart';
import 'package:youth_app/src/utils/app_file_utils.dart';
import 'package:youth_app/src/utils/common_function.dart';
import 'package:youth_app/src/utils/common_widget.dart';
import 'package:youth_app/src/utils/constant.dart';


class AppWebView extends StatefulWidget {
  final String url;
  final Function(bool) showAppBar;
  const AppWebView({Key key, this.url, this.showAppBar}) : super(key: key);

  @override
  _AppWebViewState createState() => _AppWebViewState();
}

class _AppWebViewState extends State<AppWebView> with AutomaticKeepAliveClientMixin<AppWebView> {
  InAppWebViewController webView;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  String url = "";
  double progress = 0;
  PublishSubject<bool> showRefreshBtn = PublishSubject<bool>();
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
  void initState() {
    super.initState();
    url = widget.url;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    url = widget.url;
  }

  @override
  void dispose() {
    super.dispose();
    showRefreshBtn.close();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //url = widget.url;
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
              progress < 1
                  ? Container(
                      padding: EdgeInsets.all(5), child: LinearProgressIndicator(backgroundColor: Colors.grey, value: progress))
                  : Container(),
              Expanded(
                child: Container(
                  child: InAppWebView(
                    /*initialOptions: {
                      "useOnLoadResource" : true
                    },*/
                    initialUrl: widget.url,
                    onWebViewCreated: (InAppWebViewController controller) {
                      webView = controller;
                    },
                    onLoadError: (InAppWebViewController controller, String url, int code, String message) {
                      print("onLoadError $url");
                      showRefreshBtn.sink.add(true);
                    },
                    onLoadResource:
                        (InAppWebViewController controller, WebResourceResponse response, WebResourceRequest request) {
                      showRefreshBtn.sink.add(false); // Needs to useOnLoadResource true
                    },
                    onProgressChanged: (InAppWebViewController controller, int progress) {
                      /*controller.getUrl().then((string) {
                        print("onProgressChanged $progress $string");
                      });*/
                      setState(() {
                        this.progress = progress / 100;
                      });
                    },
                    onScrollChanged: (InAppWebViewController controller, int x, int y) {
                      print('######## onScrollChanged $x $y');
                      if(bShowAppBar && y > 20) {
                        print('####### hide');
                        widget.showAppBar(false);
                      } else if (!bShowAppBar && y < 71) {
                        print('####### show');
                        widget.showAppBar(true);
                      }
                    },
                    onLoadStart: (InAppWebViewController controller, String url) {
                      print("started $url");
                      _checkForDownload(url);
                      setState(() {
                        this.url = url;
                      });
                    },
                    shouldOverrideUrlLoading: (InAppWebViewController controller, String url) {
                      print("shouldOverrideUrlLoading $url");
                      controller.loadUrl(url);
                    },
                  ),
                ),
              ),
            ])),
          ),
        ),
        floatingActionButton: Stack(
          children: <Widget>[
            StreamBuilder<bool>(
                stream: showRefreshBtn,
                builder: (context, snapshot) {
                  return snapshot.hasData && snapshot.data
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: buildReloadFab(),
                        )
                      : Container();
                }),
            Align(
              alignment: Alignment.bottomRight,
              child: buildLaunchFab(),
            ),
          ],
        ) /*AnimatedFloatingActionButton(
            fabButtons: <Widget>[
              buildReloadFab(),
              buildLaunchFab(),
            ],
            colorStartAnimation: Theme.of(context).primaryColor,
            colorEndAnimation: Theme.of(context).primaryColor,
            animatedIconData: AnimatedIcons.menu_close //To principal button
            )*/
        ,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Widget buildLaunchFab() {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(Icons.open_in_browser),
      onPressed: _launchURL,
      tooltip: 'Lauch in browser',
      heroTag: Random().nextDouble().toString(),
    );
  }

  Widget buildReloadFab() {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(Icons.refresh),
      onPressed: () {
        webView.reload();
      },
      tooltip: 'Reload',
      heroTag: Random().nextDouble().toString(),
    );
  }

  _checkForDownload(String url) {
    bool isFile = false;
    for (String ext in fileExtensions) {
      if (url.endsWith(ext)) {
        isFile = true;
        break;
      }
    }
    if (isFile) {
      _downloadFileFromURL(url);
    }
  }

  _downloadFileFromURL(String url) async {
    if (await AppFileUtils.checkPermission()) {
      String downloadDir = await AppFileUtils.getDownloadDir();
      final taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: downloadDir,
        showNotification: true,
        openFileFromNotification: true,
      );
      CommonFunction.alertDialog(
        context: context,
        title: 'Download Started',
        msg: 'File Download started. Download Location: $downloadDir.',
        type: 'info',
      );
    } else {
      CommonFunction.alertDialog(
        context: context,
        title: 'Permission required',
        msg: 'Please allow storage permission to download.',
        type: 'error',
      );
    }
  }

  _launchURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      CommonWidget.displayDialog(context: context, title: 'Can\'t launch', msg: '${url} cant launch');
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
