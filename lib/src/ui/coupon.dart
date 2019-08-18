import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lucky_draw_revamp/src/bloc/bloc.dart';
import 'package:lucky_draw_revamp/src/model/coupon.dart';
import 'package:lucky_draw_revamp/src/repository/repository.dart';
import 'package:lucky_draw_revamp/src/ui/assign_coupon.dart';
import 'package:lucky_draw_revamp/src/utils/common_widget.dart';
import 'package:lucky_draw_revamp/src/utils/constant.dart';
import 'package:lucky_draw_revamp/src/utils/loading.dart';

class CouponPage extends StatefulWidget {
  @override
  _CouponPageState createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {
  Repository repository = Repository();

  assignCoupon(int coupon) async {
    List<int> assignDate = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return AssignCoupon(coupon: coupon);
        },
        fullscreenDialog: true,
      ),
    );
    if (assignDate != null) {
      try {
        Loading.show(context);
        await repository.assignCoupon(coupon: coupon, date: assignDate);
        bloc.getUserCoupon();
        Loading.hide(context);
      } catch (e) {
        Loading.hide(context);
        Fluttertoast.showToast(
          msg: '$e',
          backgroundColor: Colors.red,
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_LONG,
        );
      }
    }
  }

  @override
  void initState() {
    bloc.getUserCoupon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Coupons'),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: bloc.couponsList,
          builder: (BuildContext context, AsyncSnapshot<Coupon> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Your Earned Coupons:',
                      style: Theme.of(context).textTheme.subtitle.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ),
                  Column(
                    children: snapshot.data.earnedTickets.map((coupon) {
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.confirmation_number),
                          ),
                          title: Text(
                            '🎫 Coupon - $coupon',
                            style: Theme.of(context).textTheme.title,
                          ),
                          trailing: OutlineButton(
                            textColor: Theme.of(context).primaryColor,
                            onPressed: () {
                              print('Assign Coupon $coupon');
                              assignCoupon(coupon);
                            },
                            child: Text('Assign'),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  ListTile(
                    title: Text(
                      'Assigned Coupons:',
                      style: Theme.of(context).textTheme.subtitle.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ),
                  Column(
                    children: snapshot.data.ticketMapping.map((coupon) {
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.confirmation_number),
                          ),
                          title: Text(
                            '🎫 Coupon - ${coupon.ticketNo}',
                            style: Theme.of(context).textTheme.title,
                          ),
                          subtitle: Text(
                              '📅 ${couponDateFormat.format(DateTime.parse(coupon.assignDate))}'),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            }
            if (snapshot.hasError) {
              return CommonWidget.displayError(
                context: context,
                error: snapshot.error,
              );
            }
            return CommonWidget.progressIndicator();
          },
        ),
      ),
    );
  }
}
