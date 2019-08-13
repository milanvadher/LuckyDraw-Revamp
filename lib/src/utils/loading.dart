import 'package:flutter/material.dart';

class Loading {
  // Show Loading
  static show(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        barrierDismissible: false,
        transitionDuration: Duration(milliseconds: 10),
        barrierColor: Colors.black54,
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            ),
          );
        },
      ),
    );
  }

  // Hide Loading
  static hide(BuildContext context) {
    Navigator.pop(context);
  }
}
