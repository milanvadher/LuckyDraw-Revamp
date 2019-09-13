import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:youth_app/src/bloc/bloc.dart';
import 'package:youth_app/src/model/coupon.dart';
import 'package:youth_app/src/repository/repository.dart';
import 'package:youth_app/src/ui/assign_coupon.dart';
import 'package:youth_app/src/utils/common_widget.dart';
import 'package:youth_app/src/utils/loading.dart';

class CouponPage extends StatefulWidget {
  @override
  _CouponPageState createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {
  Repository repository = Repository();

  void assignCoupon(int coupon) async {
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
        await bloc.getUserCoupon();
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
              if (snapshot.data.earnedTickets.length > 0 ||
                  snapshot.data.ticketMapping.length > 0) {
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
                              '🎫 Coupon No.- $coupon',
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
                              '🎫 Coupon No. -  ${coupon.ticketNo}',
                              style: Theme.of(context).textTheme.title,
                            ),
                            subtitle: Text(
                                //'📅 ${coupon.assignDate.replaceRange(coupon.assignDate.length - 7, coupon.assignDate.length, '')}'),
                                '📅 ${getAssignDate(coupon)}'),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                );
              }
              return CommonWidget.displayNoData(
                context: context,
                msg:
                    'No Coupons Available\nYou can earn coupon by solving question',
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

  String getAssignDate(TicketMapping coupon) {
    String assignDate = coupon.assignDateStr.replaceAll(':00+05:30', '');
    try {
      DateFormat outputFormat = DateFormat('dd-MM-yyyy hh:mm a');
      DateFormat inputFormat = DateFormat('yyyy-MM-dd hh:mm');
      assignDate = outputFormat.format(inputFormat.parse(assignDate));
    } catch(e,s) {
      print(s);
    }
    return assignDate;
  }
}
