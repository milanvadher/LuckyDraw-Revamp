import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youth_app/src/bloc/bloc.dart';
import 'package:youth_app/src/model/user.dart';
import 'package:youth_app/src/repository/repository.dart';
import 'package:youth_app/src/ui/about.dart';
import 'package:youth_app/src/ui/ay_quiz/start_page.dart';
import 'package:youth_app/src/ui/game.dart';
import 'package:youth_app/src/ui/login.dart';
import 'package:youth_app/src/ui/sendNotification.dart';
import 'package:youth_app/src/ui/subscription.dart';
import 'package:youth_app/src/utils/app_settings.dart';
import 'package:youth_app/src/utils/cachedata.dart';
import 'package:youth_app/src/utils/common_function.dart';
import 'package:youth_app/src/utils/config.dart';
import 'package:youth_app/src/utils/firebase_notification.dart';
import 'package:youth_app/src/utils/loading.dart';
import '../utils/constant.dart';
import 'youth_website.dart';

class MainPageRevamp extends StatefulWidget {
  @override
  _MainPageRevampState createState() => _MainPageRevampState();
}

class _MainPageRevampState extends State<MainPageRevamp> {
  double radientVal = 100;
  PublishSubject<Color> isTransforming = PublishSubject<Color>();
  // PublishSubject<bool> showSubscribtion = PublishSubject<bool>();
  Color defalutColors = Color.fromRGBO(150, 200, 255, 1);
  PersistentBottomSheetController _bottomController;
  Repository repository = Repository();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isNumberSubscribed = false;
  bool isEmailSubscribed = false;
  Timer periodicTimer;
  User userData;
  int userRole;

  checkAppUpdate() async {
    bool result = await AppSettings.isUpdateAvailable;
    // if (result != null && result) {
    //   AppSettings.showUpdateDialog(context: context);
    // }
  }

  onClickMenu(String text) {
    Fluttertoast.showToast(
      msg: text,
    );
  }

  Widget createMenu({
    @required Color color,
    @required String title,
    Function onClick,
    Widget icon,
  }) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: new BoxDecoration(
        border: new Border.all(color: color),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          onClick == null
              ? onClickMenu('$title is Not implemented')
              : onClick();
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 80,
                padding: EdgeInsets.only(bottom: 10),
                child: icon,
              ),
              Text(
                '$title',
                style: Theme.of(context).textTheme.headline,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    checkAppUpdate();
    // showSubscribtion.sink.add(false);
    isTransforming.sink.add(defalutColors);
    getToken();
    getUserRole();
    super.initState();
  }

  getUserRole() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userRole = pref.getInt('userRole');
    });
  }

  getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String firebaseToken = pref.getString('firebaseToken');
    if (firebaseToken == null) {
      String token = await FirebaseNotification.setupNotification();
      await pref.setString('firebaseToken', token);
      CacheData.firebaseToken = token;
    }
  }

  gradientRotationInterval(val) {
    periodicTimer = Timer.periodic((Duration(seconds: 3)), (value) {
      isTransforming.sink.add(Color.fromRGBO(
          val.red > 200 ? 100 : val.red + 5,
          val.green < 100 ? 255 : val.green - 10,
          val.blue > 255 ? 50 : val.blue + 8,
          1));
    });
  }

  @override
  Widget build(BuildContext context) {
    String akramURL = akramYouthURL;
    if (CacheData.appSetting != null &&
        !CommonFunction.isNullOrEmpty(CacheData.appSetting.akramYouthURL))
      akramURL = CacheData.appSetting.akramYouthURL;
    String registrationURL = regURL;
    // if (CacheData.appSetting != null && !CommonFunction.isNullOrEmpty(CacheData.appSetting.regURL))
    //   registrationURL = CacheData.appSetting.regURL;
    return Scaffold(
      appBar: AppBar(
        title: Text('Today\'s Youth'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(5),
          children: <Widget>[
            createMenu(
              color: Colors.deepOrangeAccent,
              title: 'Power of 9',
              onClick: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AYQuizStartPage(),
                  ),
                );
                getUserRole();
              },
              icon: Icon(
                Icons.gamepad,
                size: 60,
                color: Colors.deepOrangeAccent,
              ),
            ),
            createMenu(
              color: Colors.amber.shade700,
              title: 'Website',
              icon: ImageIcon(
                AssetImage('images/youth_logo.png'),
                size: 60,
                color: Colors.amber.shade700,
              ),
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppWebView(
                      url: youthWebsiteURL,
                      title: 'Website',
                    ),
                  ),
                );
              },
            ),
            createMenu(
              color: Colors.lightBlue.shade300,
              title: 'Akram Youth',
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AppWebView(url: akramURL, title: 'Akram Youth')),
                );
              },
              icon: ImageIcon(
                AssetImage('images/akram_youth.png'),
                size: 50,
                color: Colors.lightBlue.shade300,
              ),
            ),
            createMenu(
              color: Colors.teal.shade300,
              title: 'Registration',
              onClick: () {
                print('REG LINK ==>');
                print(registrationURL);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AppWebView(
                          url: registrationURL, title: 'Registration')),
                );
              },
              icon: ImageIcon(
                AssetImage('images/registration_icon.png'),
                size: 50,
                color: Colors.teal.shade300,
              ),
            ),
            createMenu(
              color: Colors.red.shade300,
              title: 'About',
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => About()),
                );
              },
              icon: Icon(
                Icons.info_outline,
                size: 50,
                color: Colors.red.shade300,
              ),
            ),
            userRole == 1
                ? createMenu(
                    color: Colors.amber.shade700,
                    title: 'Notification',
                    onClick: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SendNotification()),
                      );
                    },
                    icon: Icon(
                      Icons.notifications_active,
                      size: 50,
                      color: Colors.amber.shade700,
                    ),
                  )
                : Container(),
            // createMenu(
            //   color: Colors.amberAccent,
            //   title: 'Settings',
            //   onClick: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => Settings()),
            //     );
            //   },
            //   icon: Icon(
            //     Icons.settings,
            //     size: 50,
            //     color: Colors.amberAccent,
            //   ),
            // ),
          ],
        ),
      ),
      floatingActionButton: StreamBuilder(
          initialData: defalutColors,
          stream: isTransforming,
          builder: (BuildContext context, AsyncSnapshot<Color> snapshot) {
            // !showSubscribtion.shareValue().value &&
            // gradientRotationInterval(snapshot?.data ?? defalutColors);
            return FloatingActionButton.extended(
                icon: Icon(Icons.subscriptions),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Subscription(),
                        fullscreenDialog: true),
                  );
                  // _bottomSheet(context);
                  // showSubscribtion.sink.add(true);
                },
                backgroundColor: snapshot?.data,
                label: Text('Subscribe'));
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }

  void onLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Subscription(), fullscreenDialog: true),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    periodicTimer.cancel();
    isTransforming.drain();
    super.dispose();
  }
}
