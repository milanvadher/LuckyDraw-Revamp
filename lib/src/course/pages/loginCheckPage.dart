import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youth_app/src/course/pages/course/course_list.dart';
import 'package:youth_app/src/course/services/course_service.dart';
import 'package:youth_app/src/model/user_state.dart';
import 'package:youth_app/src/repository/repository.dart';
import 'package:youth_app/src/ui/login.dart';
import 'package:youth_app/src/utils/cachedata.dart';
import 'package:youth_app/src/utils/config.dart';
import 'package:youth_app/src/utils/loading.dart';

class CourseLoginCheckPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CourseLoginCheckPageState();
  }
}

class CourseLoginCheckPageState extends State<CourseLoginCheckPage> {
  PublishSubject<bool> isLogIn = PublishSubject<bool>();
  Repository repository = Repository();
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
              ? CourseListPage() // Category number of GnaniPurush quiz = 2
              : LoginPage(onLogin: onLogin);
        },
      ),
    );
  }

  void onLogin() {
    isLogIn.sink.add(true);
  }

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
    String csrf = await getCsrfToken();
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool isSet = await pref.setString("csrf", csrf);
    print(isSet);
    isLogIn.sink.add(isLogin);
    print('IsLOGIN $isLogin');
  }

  getCsrfToken() async {
    String csrfToken = await CourseService().getCsrfToken();
    print("CSRF--------------");
    print(csrfToken);
    return csrfToken;
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
}
