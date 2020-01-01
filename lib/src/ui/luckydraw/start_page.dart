import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youth_app/src/ui/home.dart';
import 'package:youth_app/src/ui/login.dart';
import 'package:youth_app/src/utils/config.dart';

class LuckyDrawStartPage extends StatefulWidget {
  @override
  _LuckyDrawStartPageState createState() => _LuckyDrawStartPageState();
}

class _LuckyDrawStartPageState extends State<LuckyDrawStartPage> with AutomaticKeepAliveClientMixin<LuckyDrawStartPage> {
  PublishSubject<bool> isLogIn = PublishSubject<bool>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) {
      loadLoginStatus();
    });
  }

  loadLoginStatus() async {
    bool isLogin = await Config.isLogin();
    isLogIn.sink.add(isLogin);
    print('IsLOGIN $isLogin');
  }

  @override
  void dispose() {
    super.dispose();
    isLogIn.close();
  }

  @mustCallSuper
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: isLogIn,
          initialData: false,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            return snapshot.data ? HomePage() : LoginPage(onLogin: onLogin);
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
