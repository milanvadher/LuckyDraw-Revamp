import 'package:youth_app/src/utils/constant.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

class AssignCoupon extends StatefulWidget {
  final int coupon;

  const AssignCoupon({Key key, @required this.coupon}) : super(key: key);
  @override
  _AssignCouponState createState() => _AssignCouponState();
}

class _AssignCouponState extends State<AssignCoupon> {
  PublishSubject<DateTime> selectedDate = PublishSubject<DateTime>();
  PublishSubject<TimeOfDay> selectedTime = PublishSubject<TimeOfDay>();
  DateTime userSelectedDate = fromDate;
  TimeOfDay userSelectedTime = slots[0];

  @override
  void initState() {
    selectedDate.sink.add(fromDate);
    selectedTime.sink.add(slots[0]);
    super.initState();
  }

  @override
  void dispose() {
    selectedDate.drain();
    selectedTime.drain();
    super.dispose();
  }

  String convertToTwoDigit(int number) {
    if (number.toString().length == 1) {
      return '0$number';
    }
    return '$number';
  }

  String dayPeriod(DayPeriod period) {
    if (period == DayPeriod.am) {
      return 'AM';
    }
    return 'PM';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        actions: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: RaisedButton(
              onPressed: () {
                print('Assign Date : $userSelectedDate Time $userSelectedTime');
                Navigator.pop(context, [
                  userSelectedDate.day,
                  userSelectedDate.month,
                  userSelectedDate.year,
                  userSelectedTime.hour,
                  userSelectedTime.minute,
                  0,
                  0,
                ]);
              },
              child: Text('Assign'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(12),
          children: <Widget>[
            ListTile(
              title: Text(
                'Coupon No. - ${widget.coupon} 🎫',
                style: Theme.of(context).textTheme.headline.copyWith(
                      fontSize: 30,
                      fontWeight: FontWeight.w100,
                    ),
              ),
              subtitle: Text('Assign coupon to Date and Slot'),
            ),
            Container(
              margin: EdgeInsets.only(top: 50, left: 10, right: 10, bottom: 20),
              child: StreamBuilder(
                initialData: fromDate,
                stream: selectedDate,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<DateTime> snapshot,
                ) {
                  return DateTimePicker(
                    labelText: 'Select Date',
                    selectedDate: snapshot.data,
                    selectDate: (DateTime date) {
                      print('Selected Date $date');
                      selectedDate.sink.add(date);
                      userSelectedDate = date;
                    },
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Select time',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                ),
                isEmpty: userSelectedTime == null,
                child: StreamBuilder(
                  stream: selectedTime,
                  initialData: slots[0],
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<TimeOfDay> snapshot,
                  ) {
                    return DropdownButton(
                      value: userSelectedTime,
                      underline: Container(
                        width: 0,
                        height: 0,
                      ),
                      isExpanded: true,
                      onChanged: (newValue) {
                        print(newValue);
                        selectedTime.sink.add(newValue);
                        userSelectedTime = newValue;
                      },
                      items: slots.map((value) {
                        return DropdownMenuItem<TimeOfDay>(
                          value: value,
                          child: Text(
                              '${convertToTwoDigit(value.hourOfPeriod)} : ${convertToTwoDigit(value.minute)} ${dayPeriod(value.period)}'),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DateTimePicker extends StatelessWidget {
  const DateTimePicker({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectDate,
  }) : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final ValueChanged<DateTime> selectDate;

  Future<Null> _selectDate(BuildContext context) async {
    final Brightness brightness = Theme.of(context).brightness;
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: fromDate,
      lastDate: endDate,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData(
            brightness: brightness == Brightness.dark
                ? Brightness.dark
                : Brightness.light,
            primarySwatch: Colors.orange,
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textStyle = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: InkWell(
            onTap: () {
              _selectDate(context);
            },
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: labelText,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    '${dateFormat.format(selectedDate)}',
                    style: textStyle.subhead,
                  ),
                  Icon(
                    Icons.calendar_today,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
