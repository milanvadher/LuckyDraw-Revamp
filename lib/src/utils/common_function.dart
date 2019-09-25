import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:youth_app/src/ui/youth_website.dart';
import 'package:youth_app/src/utils/cachedata.dart';

class CommonFunction {
  static Future<bool> onWillPop({
    @required BuildContext context,
    String title,
    String msg,
  }) {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(title ?? 'Are you sure?'),
            content: new Text(msg ?? 'Do you want to exit an App ?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  static openYouthWebsite({@required BuildContext context}) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppWebView(),
      ),
    );
  }

  static String getLuckyDrawLogo() {
    return CacheData.isDarkTheme ? 'images/luckydraw_logo_white.png' : 'images/luckydraw_logo.png';
  }

  static bool isNullOrEmpty(String str) {
    return str == null || str.trim().isEmpty;
  }

  static void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
    );
  }
}
