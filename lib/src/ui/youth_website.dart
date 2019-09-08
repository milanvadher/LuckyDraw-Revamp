import 'package:flutter/material.dart';
import 'package:youth_app/src/utils/app_settings.dart';
import 'package:youth_app/src/utils/common_function.dart';
import 'package:youth_app/src/utils/constant.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YouthWebsite extends StatelessWidget {
  checkAppUpdate(BuildContext context) async {
    bool result = await AppSettings.isUpdateAvailable;
    if (result) {
      AppSettings.showUpdateDialog(context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    checkAppUpdate(context);
    return WillPopScope(
      onWillPop: () {
        return CommonFunction.onWillPop(
          context: context,
          msg: 'Do you want to exit Youth Website ?',
        );
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Container(
            padding: EdgeInsets.all(10),
            child: Hero(
              tag: 'youth_website',
              child: Image(
                image: AssetImage('images/youth_logo.png'),
              ),
            ),
          ),
          titleSpacing: 2,
          title: Text('Youth Website'),
          actions: <Widget>[
            IconButton(
              tooltip: 'Exit',
              onPressed: () async {
                bool result = await CommonFunction.onWillPop(
                  context: context,
                  msg: 'Do you want to exit Youth Website',
                );
                if (result) {
                  Navigator.pop(context);
                }
              },
              icon: Icon(Icons.exit_to_app),
            )
          ],
        ),
        body: WebView(
          initialUrl: '$youthWebsiteURL',
          javascriptMode: JavascriptMode.unrestricted,
          initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
        ),
      ),
    );
  }
}
