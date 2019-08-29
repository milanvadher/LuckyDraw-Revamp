import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucky_draw_revamp/src/ui/home.dart';
import 'package:lucky_draw_revamp/src/ui/login.dart';
import 'package:lucky_draw_revamp/src/ui/no_internet.dart';
import 'package:lucky_draw_revamp/src/utils/app_settings.dart';
import 'package:lucky_draw_revamp/src/utils/common_widget.dart';
import 'package:lucky_draw_revamp/src/utils/config.dart';
import 'package:connectivity/connectivity.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StreamSubscription<ConnectivityResult> subscription;

  Future<bool> checkConnectivity() async {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      if (connectivityResult != ConnectivityResult.none) {
        Navigator.pop(context);
        processAhead();
      }
    });
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return true;
  }

  initData() async {
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
    Widget homepage = LoginPage();
    bool isLogin = await Config.isLogin();
    if (isLogin) {
      bool isUpdateAvailable = await AppSettings.checkForUpdate(context);
      homepage = HomePage(
        isUpdateAvailable: isUpdateAvailable,
      );
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => homepage),
    );
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 25,
                  ),
                  child: Container(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Center(
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
              ],
            ),
            ListView(
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 25,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 400),
                        child: Text(
                          'LuckyDraw',
                          style: Theme.of(context).textTheme.display1,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Center(
                          child: CommonWidget.progressIndicator(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
