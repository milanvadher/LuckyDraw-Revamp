import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:youth_app/src/repository/repository.dart';
import 'package:youth_app/src/ui/edit_profile.dart';
import 'package:youth_app/src/ui/reset_password.dart';
import 'package:youth_app/src/utils/common_widget.dart';
import 'package:youth_app/src/utils/validation.dart';
import 'package:rxdart/rxdart.dart';

class OTPVerifyPage extends StatefulWidget {
  final int otp;
  final bool isNewUser;
  final String mobileNo;

  const OTPVerifyPage({
    Key key,
    @required this.otp,
    @required this.isNewUser,
    @required this.mobileNo,
  }) : super(key: key);

  @override
  _OTPVerifyPageState createState() => _OTPVerifyPageState();
}

class _OTPVerifyPageState extends State<OTPVerifyPage> {
  final PublishSubject<bool> autoValidate = PublishSubject<bool>();
  final registerFormKey = GlobalKey<FormState>();
  String otp;
  Repository repository = Repository();

  void verifyOtp() async {
    if (registerFormKey.currentState.validate()) {
      registerFormKey.currentState.save();
      if (widget.otp == int.parse(otp)) {
        Fluttertoast.showToast(
          msg: 'OTP is Verified',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
        );
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return widget.isNewUser
                  ? EditProfilePage(
                      mobileNo: widget.mobileNo,
                    )
                  : ResetPassword(
                      mobileNo: widget.mobileNo,
                    );
            },
          ),
        );
      } else {
        Fluttertoast.showToast(
          msg: 'OTP Does not match',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
        );
      }
    } else {
      autoValidate.sink.add(true);
    }
  }

  Widget otpForm() {
    return StreamBuilder(
      initialData: false,
      stream: autoValidate,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return Form(
          key: registerFormKey,
          autovalidate: snapshot.data,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'OTP',
                    hintText: 'Enter OTP',
                    prefixIcon: Icon(Icons.vpn_key),
                  ),
                  validator: Validation.otp,
                  onSaved: (value) {
                    otp = value;
                  },
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                ),
              ),
              Container(
                child: ButtonBar(
                  alignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        verifyOtp();
                      },
                      child: Text('Verify'),
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
              title: 'Verify OTP',
            ),
            otpForm(),
          ],
        ),
      ),
    );
  }
}
