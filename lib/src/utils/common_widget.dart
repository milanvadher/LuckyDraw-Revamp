import 'package:flutter/material.dart';
import 'package:lucky_draw_revamp/src/utils/constant.dart';

class CommonWidget {
  static Widget authTopPortion({
    @required BuildContext context,
    @required String title,
  }) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: 10),
          child: Center(
            child: Text(
              '$title',
              style: Theme.of(context).textTheme.headline,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(40, 0, 40, 10),
          child: Image.asset(
            'images/logo.png',
            height: 120,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
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
        style: Theme.of(context).textTheme.subtitle.copyWith(
              color: Colors.black,
            ),
      ),
      padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
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
}
