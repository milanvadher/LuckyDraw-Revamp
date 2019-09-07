import 'package:flutter/material.dart';
import 'package:youth_app/src/utils/common_widget.dart';

class NoInternet extends StatefulWidget {
  @override
  _NoInternetState createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: CommonWidget.displayError(
          context: context,
          error:
              'No Internet connection detected\n\nPlease connect Internet to Proceed ahead',
        ),
      ),
    );
  }
}
