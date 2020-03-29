import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youth_app/src/model/user_state.dart';
import 'package:youth_app/src/repository/repository.dart';
import 'package:youth_app/src/ui/ay_quiz/start_page.dart';
import 'package:youth_app/src/ui/gnani_purush/start_page.dart';
import 'package:youth_app/src/ui/login.dart';
import 'package:youth_app/src/utils/cachedata.dart';
import 'package:youth_app/src/utils/config.dart';
import 'package:youth_app/src/utils/loading.dart';

class SelectQuizPage extends StatefulWidget {
  @override
  _SelectQuizPageState createState() => _SelectQuizPageState();
}

class _SelectQuizPageState extends State<SelectQuizPage>
// with AutomaticKeepAliveClientMixin<SelectQuizPage>
{
  // PublishSubject<bool> isLogIn = PublishSubject<bool>();
  // Repository repository = Repository();

  @override
  void initState() {
    // Future.delayed(Duration.zero).then((_) {
    //   loadLoginStatus();
    // });
    super.initState();
  }

  // loadLoginStatus() async {
  //   bool isLoginCheck = await Config.isLogin();
  //   if (isLoginCheck) {
  //     await loadUserState();
  //   }
  //   isLogIn.sink.add(isLoginCheck);
  //   print('IsLOGIN $isLoginCheck');
  // }

  // loadUserState() async {
  //   try {
  //     Loading.show(context);
  //     UserState userState = await repository.loadUserState(
  //         mobileNo: CacheData.userInfo.contactNumber);
  //     CacheData.userState = userState;
  //     Loading.hide(context);
  //   } catch (e) {
  //     Loading.hide(context);
  //     Fluttertoast.showToast(
  //       msg: '$e',
  //       backgroundColor: Colors.red,
  //       gravity: ToastGravity.CENTER,
  //       toastLength: Toast.LENGTH_LONG,
  //     );
  //   }
  // }

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
        borderRadius: BorderRadius.circular(50),
      ),
      child: InkWell(
        onTap: () {
          onClick == null
              ? onClickMenu('$title is Not implemented')
              : onClick();
        },
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                // height: 200,
                // padding: EdgeInsets.only(bottom: 10),
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
  Widget build(BuildContext context) {
    return Container(
      child:
          // StreamBuilder(
          //   stream: isLogIn,
          //   builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          //     if (snapshot.data == null) {
          //       return Container();
          //     }
          //     return snapshot.data
          //         ?
          Scaffold(
        appBar: AppBar(
          title: Text('Select Quiz'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: GridView.count(
            crossAxisCount: 1,
            shrinkWrap: true,
            padding: EdgeInsets.all(5),
            children: <Widget>[
              createMenu(
                color: Colors.lightBlueAccent,
                title: 'Gnani Purush',
                onClick: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GnaniPurushStartPage(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.spa,
                  size: 100,
                  color: Colors.lightBlueAccent,
                ),
              ),
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
                },
                icon: Icon(
                  Icons.gamepad,
                  size: 100,
                  color: Colors.deepOrangeAccent,
                ),
              ),
            ],
          ),
        ),
        //   )
        // : LoginPage(onLogin: onLogin);
        // },
      ),
    );
  }

  // void onLogin() {
  //   isLogIn.sink.add(true);
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // isLogIn.close();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => null;
}
