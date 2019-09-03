import 'package:flutter/material.dart';

class Hint {
  static Future<bool> choose({
    @required BuildContext context,
  }) async {
    bool result;
    double screenHeight = MediaQuery.of(context).size.height - 25;
    result = await Navigator.of(context).push(
      PageRouteBuilder(
        barrierDismissible: false,
        transitionDuration: Duration(milliseconds: 500),
        barrierColor: Colors.black87,
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
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
                          requiredPoint: '500',
                          returnValue: true,
                          screenHeight: screenHeight,
                          title: 'Reveal Full Answer',
                          color: Colors.greenAccent,
                        ),
                        Divider(
                          height: 0,
                          color: Colors.white,
                        ),
                        createHint(
                          context: context,
                          icon: Icons.camera,
                          requiredPoint: '50',
                          returnValue: false,
                          screenHeight: screenHeight,
                          title: 'Reveal One Character',
                          color: Colors.redAccent,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
    return result;
  }

  static Widget createHint({
    @required BuildContext context,
    @required double screenHeight,
    @required IconData icon,
    @required String title,
    @required String requiredPoint,
    @required bool returnValue,
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
                style: Theme.of(context).textTheme.headline.copyWith(
                      color: Colors.white,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Text(
                '-$requiredPoint',
                style: Theme.of(context).textTheme.display1.copyWith(
                      color: Colors.grey.shade300,
                    ),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.pop(context, returnValue);
      },
    );
  }
}
