import 'package:flutter/material.dart';
import 'package:youth_app/src/utils/cachedata.dart';
import 'package:rxdart/rxdart.dart';

class Point {
  static PublishSubject<int> points = PublishSubject<int>();

  static Widget display(int categoryNumber) {
    updatePoint(categoryNumber: categoryNumber);
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
                initialData: categoryNumber == 1
                    ? CacheData.userState?.totalscoreMonth ?? 0
                    : CacheData.userState?.totalscoreWeek ?? 0,
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

  static updatePoint({int categoryNumber=1}) {
    points.sink.add( categoryNumber == 1
        ? CacheData.userState?.totalscoreMonth
        : CacheData.userState?.totalscoreWeek);
  }

  static dispose() {
    points.drain();
    points.close();
  }
}
