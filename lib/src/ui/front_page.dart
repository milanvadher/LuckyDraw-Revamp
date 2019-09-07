import 'package:flutter/material.dart';
import 'package:youth_app/src/bloc/bloc.dart';
import 'package:youth_app/src/model/coupon.dart';
import 'package:youth_app/src/ui/pikachar.dart';

class FrontPage extends StatefulWidget {
  @override
  _FrontPageState createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  Widget couponDetailItem({
    @required String title,
    @required String value,
    double fontSize,
  }) {
    return Column(
      children: <Widget>[
        Divider(height: 0),
        ListTile(
          dense: true,
          title: Text(
            '$title',
            style: Theme.of(context).textTheme.subhead.copyWith(
                  fontSize: (fontSize != null ? fontSize - 4 : fontSize) ?? 16,
                ),
          ),
          trailing: Text(
            '$value',
            style: Theme.of(context).textTheme.title.copyWith(
                  fontSize: fontSize ?? 20,
                ),
            textAlign: TextAlign.end,
          ),
        ),
        Divider(height: 0),
      ],
    );
  }

  @override
  void initState() {
    bloc.getUserCoupon();
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(40, 0, 40, 10),
            child: Hero(
              tag: 'lucky_draw',
              child: Image.asset(
                'images/logo.png',
                height: 150,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
            child: Text(
              'LUCKY DRAW',
              style: Theme.of(context).textTheme.title,
            ),
          ),
          MaterialButton(
            color: Theme.of(context).primaryColor,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Pikachar(),
                ),
              );
              bloc.getUserCoupon();
            },
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Icon(Icons.play_arrow),
                ),
                Text(
                  'Play Pikachar',
                  style: Theme.of(context).textTheme.title.copyWith(
                        color: Colors.black,
                      ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: StreamBuilder(
              stream: bloc.couponsList,
              builder: (BuildContext context, AsyncSnapshot<Coupon> snapshot) {
                return Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Center(
                          child: Text(
                            '🎟 Your Coupons Details 🎟',
                            style: Theme.of(context).textTheme.title,
                          ),
                        ),
                      ),
                      snapshot.hasData
                          ? Container(
                              child: Column(
                                children: <Widget>[
                                  couponDetailItem(
                                    title: 'Used Coupons :',
                                    value:
                                        '🎫 ${snapshot.data.ticketMapping.length}',
                                  ),
                                  couponDetailItem(
                                    title: 'Unused Coupons :',
                                    value:
                                        '🎫 ${snapshot.data.earnedTickets.length}',
                                  ),
                                  couponDetailItem(
                                    title: 'Total Coupons :',
                                    value:
                                        '🎟 ${snapshot.data.earnedTickets.length + snapshot.data.ticketMapping.length}',
                                    fontSize: 24.0,
                                  ),
                                ],
                              ),
                            )
                          : ConstrainedBox(
                              constraints: BoxConstraints(minHeight: 145),
                              child: Container(
                                height: 145,
                                child: Center(
                                  child: !snapshot.hasError
                                      ? CircularProgressIndicator(
                                          strokeWidth: 2,
                                        )
                                      : Container(
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                '${snapshot.error}',
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .title,
                                              ),
                                              RaisedButton(
                                                onPressed: () {
                                                  bloc.dispose();
                                                  bloc.getUserCoupon();
                                                },
                                                child: Text('Try Again'),
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                              ),
                            )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
