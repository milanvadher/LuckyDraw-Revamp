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
    // return CacheData.isDarkTheme ? 'images/luckydraw_logo_white.png' : 'images/luckydraw_logo.png';
    return CacheData.isDarkTheme ? 'images/youth_logo.png' : 'images/youth_logo.png';
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

  static getOrdinalOfNumber(int rank) {
    
  }

  static alertDialog(
      {@required BuildContext context,
      String type = 'info', // 'success' || 'error'
      String title = '',
      @required String msg,
      bool showDoneButton = true,
      String doneButtonText = 'OK',
      String cancelButtonText = 'Cancel',
      Function doneButtonFn,
      bool barrierDismissible = true,
      bool showCancelButton = false,
      Function doneCancelFn,
      AlertDialog Function() builder,
      Widget widget,
      String errorHint,
      bool closeable = true}) {
    if (context != null) {
      String newTitle = title != null ? title : type == 'error' ? 'Error' : type == 'success' ? title : 'Success';
      showDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (_) {
          return WillPopScope(
              onWillPop: () async => closeable,
              child: AlertDialog(
                title: isNullOrEmpty(newTitle) ? null : Text(newTitle),
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                content: InkWell(
                  onLongPress: errorHint == null
                      ? () {}
                      : () {
                          alertDialog(context: context, msg: errorHint);
                        },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      widget != null ? widget : Container(),
                      SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          msg != null
                              ? msg
                              : type == 'error'
                                  ? "Looks like your lack of \n Imagination ! "
                                  : "Looks like today is your luckyday ... !!",
                          style: TextStyle(color: Theme.of(context).textTheme.caption.color),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            color: type == 'error' ? Colors.red : Colors.green[600],
                            child: Text(doneButtonText = doneButtonText ?? "OK"),
                            onPressed: doneButtonFn != null
                                ? doneButtonFn
                                : () {
                                    Navigator.pop(context);
                                  },
                          ),
                          showCancelButton ? SizedBox(width: 10) : new Container(),
                          showCancelButton
                              ? OutlineButton(
                                  child: Text(
                                    cancelButtonText ?? 'Cancel',
                                  ),
                                  onPressed: doneCancelFn != null
                                      ? doneCancelFn
                                      : () {
                                          Navigator.pop(context);
                                        },
                                )
                              : new Container(),
                        ],
                      ),
                    ],
                  ),
                ),
              ));
        },
      );
    }
  }
}
