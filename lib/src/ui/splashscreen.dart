import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youth_app/src/ui/no_internet.dart';
import 'package:youth_app/src/utils/app_settings.dart';
import 'package:youth_app/src/utils/appsharedprefutil.dart';
import 'package:youth_app/src/utils/common_widget.dart';

import 'app_main_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  PublishSubject<bool> isLuckyDrawActive = PublishSubject<bool>();

  StreamSubscription<ConnectivityResult> subscription;
  static bool isConnectivityFirst = true;

  Future<bool> checkConnectivity() async {
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult connectivityResult) {
      if (!isConnectivityFirst) {
        if (connectivityResult != ConnectivityResult.none) {
          processAhead();
        }
      }
      isConnectivityFirst = false;
    });
    ConnectivityResult connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    isLuckyDrawActive.close();
    super.dispose();
  }

  initData() async {
    bool tmpisLuckyDrawActive = await AppSharedPrefUtil.isLuckyDrawActive();
    print ('isActive: $tmpisLuckyDrawActive');
    isLuckyDrawActive.sink.add(await AppSharedPrefUtil.isLuckyDrawActive());
    bool isNetworkConnected = await checkConnectivity();
    if (isNetworkConnected) {
      processAhead();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NoInternet()),
      );
    }
  }

  processAhead() async {
    await AppSettings.getAppSettings();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AppMainPage()),
      (_) => false,
    );
  }

  /*processAhead() async {
    await AppSettings.getAppSettings();
    if (CacheData.isLuckyDrawActive) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => AppSelection(),
        ),
        (_) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => AppWebView(),
        ),
        (_) => false,
      );
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<Object>(
            stream: isLuckyDrawActive,
            initialData: false,
            builder: (context, isLuckyDrawActiveData) {
              return Stack(
                children: <Widget>[
                  ListView(
                    children: <Widget>[
                      ConstrainedBox(
                        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - 25),
                        child: Container(
                          padding: EdgeInsets.only(bottom: 40),
                          child: Center(
                            child: Image.asset(
                              isLuckyDrawActiveData.data ? 'images/logo.png' : 'images/youth_logo.png',
                              //scale: 0.05,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ListView(
                    children: <Widget>[
                      ConstrainedBox(
                        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 300),
                              child: Text(
                                isLuckyDrawActiveData.data ? 'Lucky Draw': 'Today\'s Youth',
                                style: Theme.of(context).textTheme.display1,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Center(child: CommonWidget.progressIndicator()),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
      ),
    );
  }
}
