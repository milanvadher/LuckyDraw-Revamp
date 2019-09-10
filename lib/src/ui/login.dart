import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:youth_app/src/model/user.dart';
import 'package:youth_app/src/repository/repository.dart';
import 'package:youth_app/src/ui/home.dart';
import 'package:youth_app/src/ui/register.dart';
import 'package:youth_app/src/utils/cachedata.dart';
import 'package:youth_app/src/utils/common_widget.dart';
import 'package:youth_app/src/utils/firebase_notification.dart';
import 'package:youth_app/src/utils/loading.dart';
import 'package:youth_app/src/utils/validation.dart';
import 'package:rxdart/rxdart.dart';

class LoginPage extends StatefulWidget {
  final Function onLogin;

  const LoginPage({Key key, this.onLogin}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final PublishSubject<bool> autoValidate = PublishSubject<bool>();
  final loginFormKey = GlobalKey<FormState>();
  String mobileNo, password;
  Repository repository = Repository();

  Future<void> saveFirebaseToken(String token) async {
    try {
      User user = await repository.saveUserData(
        points: CacheData.userInfo.points,
        questionState: CacheData.userInfo.questionState,
        firebaseToken: token,
      );
      CacheData.userInfo = user;
    } catch (e) {
      Loading.hide(context);
    }
  }

  void login() async {
    if (loginFormKey.currentState.validate()) {
      try {
        Loading.show(context);
        loginFormKey.currentState.save();
        User user = await repository.login(
          mobileNo: mobileNo,
          password: password,
        );
        CacheData.userInfo = user;
        String token = await FirebaseNotification.setupNotification();
        if (token != null) {
          await saveFirebaseToken(token);
        }
        Loading.hide(context);
        widget.onLogin();
        /*Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );*/
      } catch (e) {
        print('e');
        print(e);
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

  Widget loginForm() {
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
                padding: EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    filled: true,
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
                child: TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Password',
                    hintText: 'Enter your Password',
                    prefixIcon: Icon(Icons.security),
                  ),
                  validator: Validation.password,
                  onSaved: (value) {
                    password = value;
                  },
                  obscureText: true,
                  keyboardType: TextInputType.text,
                ),
              ),
              Container(
                child: ButtonBar(
                  alignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      child: Text('Forgot Password ?'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(
                              isResetPassword: true,
                            ),
                          ),
                        );
                      },
                    ),
                    RaisedButton(
                      onPressed: () {
                        login();
                      },
                      child: Text('Login'),
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
              title: 'Login',
            ),
            loginForm(),
            Container(
              //padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('New User ?\n'),
                  OutlineButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(),
                        ),
                      );
                    },
                    child: Text('Register'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
