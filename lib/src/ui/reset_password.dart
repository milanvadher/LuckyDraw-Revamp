import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:youth_app/src/model/user.dart';
import 'package:youth_app/src/repository/repository.dart';
import 'package:youth_app/src/ui/main_page_revamp.dart';
import 'package:youth_app/src/utils/cachedata.dart';
import 'package:youth_app/src/utils/common_widget.dart';
import 'package:youth_app/src/utils/firebase_notification.dart';
import 'package:youth_app/src/utils/loading.dart';
import 'package:youth_app/src/utils/validation.dart';
import 'package:rxdart/rxdart.dart';

class ResetPassword extends StatefulWidget {
  final String mobileNo;

  const ResetPassword({Key key, @required this.mobileNo}) : super(key: key);
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final PublishSubject<bool> autoValidate = PublishSubject<bool>();
  final loginFormKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  String password, verifyPassword;
  Repository repository = Repository();

  void resetPassword() async {
    if (loginFormKey.currentState.validate()) {
      try {
        Loading.show(context);
        loginFormKey.currentState.save();
        User user = await repository.resetPassword(
          mobileNo: widget.mobileNo,
          password: password,
        );
        CacheData.userInfo = user;
        await FirebaseNotification.setupNotification();
        Loading.hide(context);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainPageRevamp(),
          ),
        );
      } catch (e) {
        Loading.hide(context);
        Fluttertoast.showToast(
          msg: '$e',
          backgroundColor: Colors.red,
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } else {
      autoValidate.sink.add(true);
    }
  }

  Widget resetPasswordForm() {
    return StreamBuilder(
      initialData: false,
      stream: autoValidate,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return Form(
          key: loginFormKey,
          autovalidate: snapshot.data,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your Password',
                    prefixIcon: Icon(Icons.security),
                  ),
                  controller: passwordController,
                  validator: Validation.password,
                  onSaved: (value) {
                    password = value;
                  },
                  obscureText: true,
                  keyboardType: TextInputType.text,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Verify Password',
                    hintText: 'Enter your Password',
                    prefixIcon: Icon(Icons.security),
                  ),
                  validator: (String value) {
                    return Validation.verifyPassword(
                      passwordController.text,
                      value,
                    );
                  },
                  onSaved: (value) {
                    verifyPassword = value;
                  },
                  obscureText: true,
                  keyboardType: TextInputType.text,
                ),
              ),
              Container(
                child: ButtonBar(
                  alignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        resetPassword();
                      },
                      child: Text('Update'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    autoValidate.drain();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[
            CommonWidget.authTopPortion(
              context: context,
              title: 'Reset Password',
            ),
            resetPasswordForm(),
          ],
        ),
      ),
    );
  }
}
