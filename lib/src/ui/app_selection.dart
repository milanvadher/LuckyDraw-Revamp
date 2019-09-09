import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youth_app/src/ui/home.dart';
import 'package:youth_app/src/ui/login.dart';
import 'package:youth_app/src/ui/luckydraw/start_page.dart';
import 'package:youth_app/src/ui/youth_website.dart';
import 'package:youth_app/src/ui_utils/scrollable_tabs.dart';
import 'package:youth_app/src/utils/app_settings.dart';
import 'package:youth_app/src/utils/common_function.dart';
import 'package:youth_app/src/utils/config.dart';
import 'package:youth_app/src/utils/constant.dart';
import 'package:youth_app/src/utils/loading.dart';

class AppSelection extends StatefulWidget {
  @override
  _AppSelectionState createState() => _AppSelectionState();
}

class _AppSelectionState extends State<AppSelection> {
  goToLuckyDraw() async {
    Loading.show(context);
    Widget homepage = LoginPage();
    bool isLogin = await Config.isLogin();
    print('IsLOGIN $isLogin');
    if (isLogin) {
      homepage = HomePage();
    }
    Loading.hide(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => homepage,
      ),
    );
  }

  navigateToYouthWebsite() {
    CommonFunction.openYouthWebsite(context: context);
  }

  checkAppUpdate() async {
    bool result = await AppSettings.isUpdateAvailable;
    if (result) {
      AppSettings.showUpdateDialog(context: context);
    }
  }

  @override
  void initState() {
    checkAppUpdate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollableTabs(
      pages: [
        TabPage(text: 'Lucky Draw', content: LuckyDrawStartPage()),
        TabPage(text: 'Youth WebSite', content: AppWebView(url: youthWebsiteURL)),
        TabPage(text: 'Akram Youth', content: AppWebView(url: akramYouthURL)),
      ],
    );
  }

  Widget buildWebView(String url) {
    return WebView(
      initialUrl: '$akramYouthURL',
      javascriptMode: JavascriptMode.unrestricted,
      initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
    );
  }
}


/*
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height - 50;
    return WillPopScope(
      onWillPop: () {
        return CommonFunction.onWillPop(context: context);
      },
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(10),
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight,
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: screenHeight / 2,
                        ),
                        child: Center(
                          child: selectionCard(
                            context: context,
                            image: Hero(
                              tag: 'lucky_draw',
                              child: Image(
                                image: AssetImage('images/logo.png'),
                              ),
                            ),
                            title: 'LuckyDraw',
                            onTap: goToLuckyDraw,
                          ),
                        ),
                      ),
                      Divider(height: 0),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: screenHeight / 2,
                        ),
                        child: Center(
                          child: selectionCard(
                            context: context,
                            image: Hero(
                              tag: 'youth_website',
                              child: Image(
                                image: AssetImage('images/youth_logo.png'),
                              ),
                            ),
                            title: 'Youth Website',
                            onTap: navigateToYouthWebsite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/

Widget selectionCard({
  @required BuildContext context,
  @required Widget image,
  @required String title,
  @required Function onTap,
}) {
  return ConstrainedBox(
    constraints: BoxConstraints(
      minHeight: 225,
      minWidth: 225,
    ),
    child: Card(
      margin: EdgeInsets.all(12),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 70,
              width: 70,
              child: image,
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline,
              ),
            )
          ],
        ),
      ),
    ),
  );
}
