import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:youth_app/src/ui/main_page_revamp.dart';
import 'package:youth_app/src/ui/no_internet.dart';
import 'package:youth_app/src/utils/app_settings.dart';
import 'package:youth_app/src/utils/common_widget.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StreamSubscription<ConnectivityResult> subscription;
  static bool isConnectivityFirst = true;

  Future<bool> checkConnectivity() async {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      if (!isConnectivityFirst) {
        if (connectivityResult != ConnectivityResult.none) {
          processAhead();
        }
      }
      isConnectivityFirst = false;
    });
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
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
    super.dispose();
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
    await AppSettings.getAppSettings();
    Navigator.pushAndRemoveUntil(
      context,
      // MaterialPageRoute(builder: (context) => AppMainPage()),
      MaterialPageRoute(builder: (context) => MainPageRevamp()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 30),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: Image(
                        image: AssetImage('images/youth_logo.png'),
                        height: 120,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 10),
              child: Center(
                child: CommonWidget.progressIndicator(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 25),
              child: Text(
                'Today\'s Youth',
                style: Theme.of(context).textTheme.headline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
