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
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          return new ScaleTransition(
            scale: new Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Interval(
                  0.00,
                  0.50,
                  curve: Curves.linear,
                ),
              ),
            ),
            child: ScaleTransition(
              scale: Tween<double>(
                begin: 1.5,
                end: 1.0,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Interval(
                    0.50,
                    1.00,
                    curve: Curves.linear,
                  ),
                ),
              ),
              child: child,
            ),
          );
        },
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return Scaffold(
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
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: screenHeight / 2,
                          ),
                          child: Center(
                            child: selectionCard(
                              context: context,
                              icon: Icons.outlined_flag,
                              requiredPoint: '500',
                              returnValue: true,
                              screenHeight: screenHeight,
                              title: 'Reveal Full Answer',
                              color: Colors.greenAccent,
                            ),
                          ),
                        ),
                        Divider(
                          height: 0,
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: screenHeight / 2,
                          ),
                          child: Center(
                            child: selectionCard(
                              context: context,
                              icon: Icons.camera,
                              requiredPoint: '50',
                              returnValue: false,
                              screenHeight: screenHeight,
                              title: 'Reveal One Character',
                              color: Colors.redAccent,
                            ),
                          ),
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

  static Widget selectionCard({
    @required BuildContext context,
    @required double screenHeight,
    @required IconData icon,
    @required String title,
    @required String requiredPoint,
    @required bool returnValue,
    Color color,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 250,
        minWidth: 280,
      ),
      child: Card(
        margin: EdgeInsets.all(12),
        child: InkWell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
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
                  style: Theme.of(context).textTheme.headline,
                  /*style: Theme.of(context).textTheme.headline.copyWith(
                        color: Colors.white,
                      ),*/
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
              ),
            ],
          ),
          onTap: () {
            Navigator.pop(context, returnValue);
          },
        ),
      ),
    );
  }
}
