import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lucky_draw_revamp/src/model/user.dart';
import 'package:lucky_draw_revamp/src/repository/repository.dart';
import 'package:lucky_draw_revamp/src/ui/home.dart';
import 'package:lucky_draw_revamp/src/utils/cachedata.dart';
import 'package:lucky_draw_revamp/src/utils/loading.dart';
import 'package:lucky_draw_revamp/src/utils/validation.dart';
import 'package:rxdart/rxdart.dart';

class EditProfilePage extends StatefulWidget {
  final String mobileNo;

  const EditProfilePage({Key key, @required this.mobileNo}) : super(key: key);
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final PublishSubject<bool> autoValidate = PublishSubject<bool>();
  final passwordController = TextEditingController();
  final registerFormKey = GlobalKey<FormState>();
  String username, password, verifyPassword;
  Repository repository = Repository();

  void register() async {
    if (registerFormKey.currentState.validate()) {
      try {
        Loading.show(context);
        registerFormKey.currentState.save();
        User user = await repository.register(
          mobileNo: widget.mobileNo,
          username: username,
          password: password,
        );
        CacheData.userInfo = user;
        Loading.hide(context);
        Navigator.pop(context);
        Navigator.pushReplacement(
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
                    labelText: 'Username',
                    hintText: 'Enter your Username',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: Validation.username,
                  onSaved: (value) {
                    username = value;
                  },
                  maxLength: 10,
                  keyboardType: TextInputType.text,
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 10),
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
                        register();
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
