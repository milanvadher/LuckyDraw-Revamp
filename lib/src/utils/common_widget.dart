import 'package:flutter/material.dart';
import 'package:youth_app/src/utils/common_function.dart';
import 'package:youth_app/src/utils/constant.dart';

class CommonWidget {
  static Widget authTopPortion({
    @required BuildContext context,
    @required String title,
  }) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Center(
            child: Text(
              '$title',
              style: Theme.of(context).textTheme.headline,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
          child: Hero(
            tag: 'lucky_draw',
            child: Image.asset(
              CommonFunction.getLuckyDrawLogo(),
              height: 150,
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(10, 5, 10, 30),
          child: Text(
            'LUCKY DRAW',
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ],
    );
  }

  static Widget settingsTitle({
    @required BuildContext context,
    @required String title,
  }) {
    return Container(
      child: Text(
        '$title',
        style: Theme.of(context).textTheme.subtitle,
        /*style: Theme.of(context).textTheme.subtitle.copyWith(
              color: Colors.black,
            ),*/
      ),
      padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
    );
  }

  static Widget displayNoData({
    @required BuildContext context,
    String msg = 'No Data Available',
  }) {
    return ListView(
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - 120,
          ),
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(25),
                  child: Image.asset(
                    'images/chilling.png',
                    height: 120,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    '$msg',
                    style: Theme.of(context).textTheme.title,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Widget displayError({
    @required BuildContext context,
    error,
  }) {
    return ListView(
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - 120,
          ),
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(25),
                  child: Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Colors.redAccent,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    '${error ?? defaultError}',
                    style: Theme.of(context).textTheme.title,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Widget progressIndicator() {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
      ),
    );
  }

  static displayDialog({
    @required BuildContext context,
    @required String title,
    @required String msg,
    AlertDialog Function() builder,
  }) {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: new Text('Okay'),
            ),
          ],
        );
      },
    );
  }

  static confirmDialog({
    @required BuildContext context,
    String title,
    String msg,
    AlertDialog Function() builder,
  }) async {
    return await showDialog(
          context: context,
          builder: (_) {
            return new AlertDialog(
              title: new Text(title ?? 'Are you sure ?'),
              content: new Text(msg ?? 'Do you want to do this action ?'),
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
            );
          },
        ) ??
        false;
  }
}
