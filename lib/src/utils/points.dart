import 'package:flutter/material.dart';
import 'package:lucky_draw_revamp/src/utils/cachedata.dart';
import 'package:rxdart/rxdart.dart';

class Point {
  static PublishSubject<int> points = PublishSubject<int>();

  static Widget display() {
    updatePoint();
    return Container(
      margin: EdgeInsets.all(12),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          children: <Widget>[
            Container(
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.amber,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.amber.shade700,
                  child: Center(
                    child: Icon(
                      Icons.star,
                      size: 13,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
              child: StreamBuilder(
                stream: points,
                initialData: CacheData.userInfo?.points ?? 0,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  return Text(
                    '${snapshot.hasData ? snapshot.data : 0}',
                    style: Theme.of(context).textTheme.body2,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  static updatePoint() {
    points.sink.add(CacheData.userInfo?.points);
  }

  static dispose() {
    points.drain();
    points.close();
  }
}
