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

class Subscription extends StatefulWidget {
  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription>
    with AutomaticKeepAliveClientMixin<Subscription> {
  bool isNumberSubscribed = false;
  bool isEmailSubscribed = false;
  String mobileNo = CacheData.userInfo?.contactNumber ?? null;
  String email;
  final loginFormKey = GlobalKey<FormState>();
  bool isLogIn = false;
  User user;
  String firebaseToken;
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
    getToken();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    firebaseToken = await pref.getString('firebaseToken');
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

  _submitSubscription() async {
    if (loginFormKey.currentState.validate()) {
      try {
        loginFormKey.currentState.save();
        SubscriptionModel subscribe = await repository.subscription(
            contactNumber: mobileNo,
            email: email,
            username: user.username,
            isEmail: isEmailSubscribed,
            isSMS: isNumberSubscribed,
            firebasetoken: firebaseToken);
        print(subscribe);
        Fluttertoast.showToast(
            msg: 'Thank You! we have successfully got your Subscription.',
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.greenAccent,
            textColor: Colors.black);
        Navigator.pop(context);
      } catch (error) {
        print(error);
        Fluttertoast.showToast(
            msg: 'Sorry! Something went wrong.',
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.greenAccent,
            textColor: Colors.black);
        Navigator.pop(context);
      }
    }
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
                    initialValue: user?.contactNumber ?? "",
                    maxLength: 10,
                    validator: Validation.mobileNo,
                    enabled: user?.contactNumber != null ? false : true,
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
        user?.contactNumber != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Your Mobile : ",
                    style: Theme.of(context).textTheme.body2,
                  ),
                  Text(
                    mobileNo,
                    style: Theme.of(context).textTheme.body2,
                  ),
                ],
              )
            : Container(),
        SizedBox(height: 40),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            customCheckbox("Suscribe me on SMS", isNumberSubscribed, (val) {
              setState(() {
                isNumberSubscribed = val;
              });
            }),
            customCheckbox("Suscribe me on EMAIL", isEmailSubscribed, (val) {
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
          isEmailSubscribed || isNumberSubscribed
              ? IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () {
                    _submitSubscription();
                  })
              : Container()
        ],
      ),
      body: _subscriptionBody(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
