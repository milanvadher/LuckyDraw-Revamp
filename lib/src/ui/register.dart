import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:youth_app/src/repository/repository.dart';
import 'package:youth_app/src/ui/verify_otp.dart';
import 'package:youth_app/src/utils/common_widget.dart';
import 'package:youth_app/src/utils/loading.dart';
import 'package:youth_app/src/utils/validation.dart';
import 'package:rxdart/rxdart.dart';

class RegisterPage extends StatefulWidget {
  final bool isResetPassword;

  const RegisterPage({Key key, this.isResetPassword = false}) : super(key: key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final PublishSubject<bool> autoValidate = PublishSubject<bool>();
  final otpFormKey = GlobalKey<FormState>();
  String mobileNo;
  Repository repository = Repository();

  int generateOtp() {
    var rnd = Random();
    var next = rnd.nextDouble() * 1000000;
    while (next < 100000) {
      next *= 10;
    }
    return next.toInt();
  }

  void sendOtp() async {
    if (otpFormKey.currentState.validate()) {
      try {
        Loading.show(context);
        otpFormKey.currentState.save();
        int otp = generateOtp();
        bool isNewUser = await repository.sendOtp(mobileNo: mobileNo, otp: otp);
        print('isNewUser $isNewUser');
        Loading.hide(context);
        Fluttertoast.showToast(
          msg: 'OTP is Send to $mobileNo',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OTPVerifyPage(
              mobileNo: mobileNo,
              otp: otp,
              isNewUser: isNewUser,
            ),
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

  Widget registerForm() {
    return StreamBuilder(
      initialData: false,
      stream: autoValidate,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return Form(
          key: otpFormKey,
          autovalidate: snapshot.data,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    hintText: 'Enter your Mobile Number',
                    prefixIcon: Icon(Icons.call),
                  ),
                  validator: Validation.mobileNo,
                  onSaved: (value) {
                    mobileNo = value;
                  },
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                ),
              ),
              Container(
                child: ButtonBar(
                  alignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        sendOtp();
                      },
                      child: Text('Get OTP'),
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
            Container(padding: EdgeInsets.only(top: 30)),
            CommonWidget.authTopPortion(
              context: context,
              title: widget.isResetPassword ? 'Forgot Password' : 'Register',
            ),
            registerForm(),
          ],
        ),
      ),
    );
  }
}
