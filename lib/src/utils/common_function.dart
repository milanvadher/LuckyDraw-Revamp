import 'package:flutter/material.dart';
import 'package:youth_app/src/ui/youth_website.dart';

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
        builder: (context) => YouthWebsite(),
      ),
    );
  }
}
