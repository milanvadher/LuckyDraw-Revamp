import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lucky_draw_revamp/src/repository/repository.dart';
import 'package:lucky_draw_revamp/src/ui/edit_profile.dart';
import 'package:lucky_draw_revamp/src/ui/home.dart';
import 'package:lucky_draw_revamp/src/utils/validation.dart';
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
                  : HomePage();
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
                  maxLength: 10,
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
      appBar: AppBar(
        centerTitle: true,
        title: Text('Verify'),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
              child: Icon(
                Icons.confirmation_number,
                size: 100,
                color: Colors.deepOrangeAccent,
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
              child: Text(
                'Lucky Draw',
                style: Theme.of(context).textTheme.title,
              ),
            ),
            otpForm(),
          ],
        ),
      ),
    );
  }
}
