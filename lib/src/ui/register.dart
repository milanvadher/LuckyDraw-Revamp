import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lucky_draw_revamp/src/repository/repository.dart';
import 'package:lucky_draw_revamp/src/ui/home.dart';
import 'package:lucky_draw_revamp/src/utils/loading.dart';
import 'package:lucky_draw_revamp/src/utils/validation.dart';
import 'package:rxdart/rxdart.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final PublishSubject<bool> autoValidate = PublishSubject<bool>();
  final registerFormKey = GlobalKey<FormState>();
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
    if (registerFormKey.currentState.validate()) {
      try {
        Loading.show(context);
        registerFormKey.currentState.save();
        await repository.sendOtp(mobileNo: mobileNo, otp: generateOtp());
        Loading.hide(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
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
          key: registerFormKey,
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
                      child: Text('Register'),
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
        title: Text('Register'),
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
            registerForm(),
          ],
        ),
      ),
    );
  }
}
