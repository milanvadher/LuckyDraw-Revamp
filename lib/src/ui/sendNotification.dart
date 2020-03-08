import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youth_app/src/model/subscription.dart';
import 'package:youth_app/src/model/user.dart';
import 'package:youth_app/src/model/user_state.dart';
import 'package:youth_app/src/repository/repository.dart';
import 'package:youth_app/src/ui/level.dart';
import 'package:youth_app/src/ui/login.dart';
import 'package:youth_app/src/utils/cachedata.dart';
import 'package:youth_app/src/utils/config.dart';
import 'package:youth_app/src/utils/loading.dart';
import 'package:youth_app/src/utils/validation.dart';

// import '../../repository/repository.dart';
// import '../../utils/cachedata.dart';
// import '../../utils/loading.dart';

class SendNotification extends StatefulWidget {
  @override
  _SendNotificationState createState() => _SendNotificationState();
}

class _SendNotificationState extends State<SendNotification>
    with AutomaticKeepAliveClientMixin<SendNotification> {
  String notificationtext;
  final notificationFormKey = GlobalKey<FormState>();
  bool isNotificationText = false;
  User user;
  Repository repository = Repository();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _submitNotificationForm() {
    if (notificationFormKey.currentState.validate()) {
      notificationFormKey.currentState.save();
      Fluttertoast.showToast(
          msg: 'Notification is Successgully send to Users !',
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.greenAccent,
          textColor: Colors.black);
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
          msg: 'Please Fill the Text Area with Valid data !!!',
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.black);
          Navigator.pop(context);
    }
  }

  _sendNotificationForm() {
    return Form(
      key: notificationFormKey,
      autovalidate: true,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 15, left: 15, right: 15),
            child: TextFormField(
              decoration: InputDecoration(
                filled: true,
                labelText: 'Custom Notification',
                hintText: 'Enter your Notification text here ...',
                prefixIcon: Icon(Icons.textsms),
              ),
              minLines: 1,
              maxLines: 10,
              initialValue: notificationtext,
              validator: Validation.notificationtext,
              keyboardType: TextInputType.multiline,
            ),
          ),
        ],
      ),
    );
  }

  _sendNotificationBody() {
    return SafeArea(
      child: ListView(
        children: <Widget>[
          SizedBox(height: 40),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Please fill the form below to Send Custom Notification to the app users.",
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
            ],
          ),
          SizedBox(height: 40),
          _sendNotificationForm()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Custom Notification'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                _submitNotificationForm();
              })
        ],
      ),
      body: _sendNotificationBody(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
