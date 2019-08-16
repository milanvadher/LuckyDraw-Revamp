import 'package:flutter/material.dart';

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
}
