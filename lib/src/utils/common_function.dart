import 'package:flutter/material.dart';
import 'package:lucky_draw_revamp/src/utils/constant.dart';
import 'package:url_launcher/url_launcher.dart';

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

  static openYouthWebsite() async {
    if (await canLaunch('$youthWebsiteURL')) {
      launch('$youthWebsiteURL', forceWebView: true);
    }
  }
}
