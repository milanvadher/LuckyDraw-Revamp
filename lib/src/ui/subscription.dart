import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';
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

class Subscription extends StatefulWidget {
  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription>
    with AutomaticKeepAliveClientMixin<Subscription> {
  bool isNumberSubscribed = false;
  bool isEmailSubscribed = false;
  String mobileNo, email;
  final loginFormKey = GlobalKey<FormState>();
  bool isLogIn = false;
  User user;
  Repository repository = Repository();

  loadLoginStatus() async {
    bool isLogin = await Config.isLogin();
    user = isLogin ? CacheData.userInfo : null;
  }

  loadUserState() async {
    try {
      Loading.show(context);
      UserState userState = await repository.loadUserState(
          mobileNo: CacheData.userInfo.contactNumber);
      CacheData.userState = userState;
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

  @override
  void initState() {
    getUserData();
    loadLoginStatus();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getUserData() {
    user = CacheData.userInfo;
  }

  customCheckbox(String text, bool value, final callBack) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Checkbox(
            value: value,
            onChanged: callBack,
            tristate: false,
            activeColor: Colors.orange,
            checkColor: Colors.purple,
          ),
        ),
        Text(text),
      ],
    );
  }

  customTextBox(
      String labelText,
      String hintText,
      String value,
      Icon icon,
      bool isDisplayed,
      String Function(String) validation,
      void Function(String) onChange,
      TextInputType type,
      int maxlength) {
    return Container(
      padding: EdgeInsets.only(bottom: 15, left: 15, right: 15),
      child: isDisplayed
          ? TextFormField(
              decoration: InputDecoration(
                filled: true,
                labelText: labelText,
                hintText: hintText,
                prefixIcon: icon,
              ),
              initialValue: value,
              maxLength: maxlength,
              validator: validation,
              onSaved: (value) => onChange(value),
              keyboardType: type,
            )
          : Container(),
    );
  }

  _submitSubscription() {
    loginFormKey.currentState.save();
    print(mobileNo);
    print(email);
  }

  _subscriptionForm() {
    return Form(
      key: loginFormKey,
      autovalidate: true,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 15, left: 15, right: 15),
            child: isNumberSubscribed
                ? TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Mobile Number',
                      hintText: 'Enter your Mobile Number',
                      prefixIcon: Icon(Icons.call),
                    ),
                    initialValue: user?.contactNumber ?? mobileNo,
                    maxLength: 10,
                    validator: Validation.mobileNo,
                    onSaved: (value) {
                      setState(() {
                        mobileNo = value;
                      });
                    },
                    keyboardType: TextInputType.phone,
                  )
                : Container(),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 15, left: 15, right: 15),
            child: isEmailSubscribed
                ? TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Email',
                      hintText: 'Enter your Email Address',
                      prefixIcon: Icon(Icons.mail),
                    ),
                    initialValue: email,
                    validator: Validation.email,
                    onSaved: (value) {
                      setState(() {
                        email = value;
                      });
                      email = value;
                    },
                    keyboardType: TextInputType.emailAddress,
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  _subscriptionBody() {
    return SafeArea(
        child: ListView(
      padding: EdgeInsets.all(10),
      addAutomaticKeepAlives: true,
      physics: ScrollPhysics(),
      // shrinkWrap: true,
      children: <Widget>[
        SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Subscribe Now !!!",
              style: Theme.of(context).textTheme.headline,
            ),
          ],
        ),
        SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            customCheckbox("Mobile Number", isNumberSubscribed, (val) {
              setState(() {
                isNumberSubscribed = val;
              });
            }),
            customCheckbox("Email Address", isEmailSubscribed, (val) {
              setState(() {
                isEmailSubscribed = val;
              });
            }),
          ],
        ),
        _subscriptionForm(),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                _submitSubscription();
              })
        ],
      ),
      body: _subscriptionBody(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
