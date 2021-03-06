import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import 'package:youth_app/src/ui/about.dart';
import 'package:youth_app/src/ui/luckydraw/start_page.dart';
import 'package:youth_app/src/ui/youth_website.dart';
import 'package:youth_app/src/ui_utils/scrollable_tabs.dart';
import 'package:youth_app/src/utils/app_settings.dart';
import 'package:youth_app/src/utils/appsharedprefutil.dart';
import 'package:youth_app/src/utils/cachedata.dart';
import 'package:youth_app/src/utils/common_function.dart';
import 'package:youth_app/src/utils/constant.dart';
import 'package:youth_app/src/utils/webview/my_chrome_safari_browser.dart';

class AppMainPage extends StatefulWidget {
  @override
  _AppMainPageState createState() => _AppMainPageState();
}

class _AppMainPageState extends State<AppMainPage> {
  /*goToLuckyDraw() async {
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
  }*/

  checkAppUpdate() async {
    bool result = await AppSettings.isUpdateAvailable;
    if (result != null && result) {
      AppSettings.showUpdateDialog(context: context);
    }
  }

  @override
  void initState() {
    checkAppUpdate();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final ChromeSafariBrowser chromeSafariBrowser = new MyChromeSafariBrowser(new InAppBrowser());

  @override
  Widget build(BuildContext context) {
    String akramURL = akramYouthURL;
    if (CacheData.appSetting != null && !CommonFunction.isNullOrEmpty(CacheData.appSetting.akramYouthURL))
      akramURL = CacheData.appSetting.akramYouthURL;
    String registrationURL = regURL;
    if (CacheData.appSetting != null && !CommonFunction.isNullOrEmpty(CacheData.appSetting.regURL))
      registrationURL = CacheData.appSetting.regURL;

    void onTabTap(int index) async {
      int akramYouthIndex = 1;
      if (CacheData.isLuckyDrawActive) {
        akramYouthIndex = 2;
      }
      if (index == akramYouthIndex) {
        if (!await AppSharedPrefUtil.isAVDownloaded()) {
          chromeSafariBrowser.open(akramURL);
        }
      }
    }

    return ScrollableTabs(
      withDrawer: true,
      tabsDemoStyle: TabsStyle.iconsAndText,
      onTap: onTabTap,
      page: [
        CacheData.isLuckyDrawActive
            ? TabPage(
                text: 'Lucky Draw',
                content: LuckyDrawStartPage(),
                icon: ImageIcon(AssetImage(CommonFunction.getLuckyDrawLogo())),
              )
            : null,
        TabPage(
          text: 'WebSite',
          content: AppWebView(url: youthWebsiteURL),
          icon: ImageIcon(AssetImage('images/youth_logo.png')),
        ),
        TabPage(
          text: 'Akram Youth',
          content: AppWebView(url: akramURL),
          icon: ImageIcon(AssetImage('images/akram_youth.png')),
        ),
        TabPage(
          text: 'Registration',
          content: AppWebView(url: registrationURL),
          icon: ImageIcon(AssetImage('images/registration_icon.png')),
        ),
        TabPage(text: 'About', content: About(), icon: Icon(Icons.info_outline) //ImageIcon(AssetImage('images/youth_logo.png')),
            ),
      ],
    );
  }

/*Widget buildWebView(String url) {
    return WebView(
      initialUrl: '$akramYouthURL',
      javascriptMode: JavascriptMode.unrestricted,
      initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
    );
  }*/
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

/*Widget selectionCard({
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
}*/
