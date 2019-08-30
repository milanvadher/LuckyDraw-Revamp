import 'package:flutter/material.dart';
import 'package:lucky_draw_revamp/src/utils/common_function.dart';
import 'package:lucky_draw_revamp/src/utils/constant.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YouthWebsite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return CommonFunction.onWillPop(
          context: context,
          msg: 'Do you want to exit Youth Website',
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
        ),
      ),
    );
  }
}
