import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youth_app/src/model/user_state.dart';
import 'package:youth_app/src/ui/gnani_purush/level.dart';
import 'package:youth_app/src/ui/level.dart';
import 'package:youth_app/src/ui/login.dart';
import 'package:youth_app/src/utils/config.dart';

import '../../repository/repository.dart';
import '../../utils/cachedata.dart';
import '../../utils/loading.dart';

class GnaniPurushStartPage extends StatefulWidget {
  @override
  _GnaniPurushStartPageState createState() => _GnaniPurushStartPageState();
}

class _GnaniPurushStartPageState extends State<GnaniPurushStartPage>
    with AutomaticKeepAliveClientMixin<GnaniPurushStartPage> {
  PublishSubject<bool> isLogIn = PublishSubject<bool>();
  Repository repository = Repository();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) {
      loadLoginStatus();
    });
  }

  loadLoginStatus() async {
    bool isLogin = await Config.isLogin();
    if (isLogin) {
      await loadUserState();
    }
    isLogIn.sink.add(isLogin);
    print('IsLOGIN $isLogin');
  }

  loadUserState() async {
    try {
      Loading.show(context);
      UserState userState = await repository.loadUserState(
        mobileNo: CacheData.userInfo.contactNumber,
        category: 2,
      );
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
  void dispose() {
    super.dispose();
    isLogIn.close();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: isLogIn,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.data == null) {
            return Container();
          }
          return snapshot.data
              ? GnaniPurushLevel(2) // Category number of GnaniPurush quiz = 2
              : LoginPage(onLogin: onLogin);
        },
      ),
    );
  }

  void onLogin() {
    isLogIn.sink.add(true);
  }

  @override
  bool get wantKeepAlive => true;
}
