import 'package:flutter/material.dart';
import 'package:lucky_draw_revamp/src/ui/home.dart';
import 'package:lucky_draw_revamp/src/ui/login.dart';
import 'package:lucky_draw_revamp/src/utils/common_function.dart';
import 'package:lucky_draw_revamp/src/utils/config.dart';
import 'package:lucky_draw_revamp/src/utils/loading.dart';

class AppSelection extends StatefulWidget {
  @override
  _AppSelectionState createState() => _AppSelectionState();
}

class _AppSelectionState extends State<AppSelection> {
  goToLuckyDraw() async {
    Loading.show(context);
    bool isLogin = await Config.isLogin();
    Widget homepage = LoginPage();
    if (isLogin) {
      homepage = HomePage();
    }
    Loading.hide(context);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => homepage,
      ),
      (_) => false,
    );
  }

  navigateToYouthWebsite() {
    CommonFunction.openYouthWebsite();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height - 25;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenHeight - 25,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  createHint(
                    context: context,
                    icon: Icons.outlined_flag,
                    screenHeight: screenHeight,
                    title: 'Youth App',
                    color: Colors.greenAccent,
                    navigateTo: navigateToYouthWebsite,
                  ),
                  Divider(
                    height: 0,
                    color: Colors.white,
                  ),
                  createHint(
                    context: context,
                    icon: Icons.camera,
                    screenHeight: screenHeight,
                    title: 'LuckyDraw - JJ112',
                    color: Colors.redAccent,
                    navigateTo: goToLuckyDraw,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget createHint({
  @required BuildContext context,
  @required double screenHeight,
  @required IconData icon,
  @required String title,
  @required Function navigateTo,
  Color color,
}) {
  return InkWell(
    child: Container(
      height: screenHeight / 2,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            color: color ?? Colors.white,
            size: 70,
          ),
          Container(
            margin: EdgeInsets.only(top: 20, left: 15, right: 15),
            child: Text(
              '$title',
              style: Theme.of(context).textTheme.display1.copyWith(
                    color: Colors.white,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ),
    onTap: navigateTo,
  );
}
