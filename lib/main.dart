import 'package:flutter/material.dart';
import 'package:lucky_draw_revamp/src/ui/home.dart';
import 'package:lucky_draw_revamp/src/ui/login.dart';
import 'package:lucky_draw_revamp/src/utils/config.dart';
import 'src/app.dart';

void main() async {
  Widget homepage = LoginPage();
  bool isLogin = await Config.isLogin();
  if (isLogin) {
    homepage = HomePage();
  }
  runApp(MyApp(
    homepage: homepage,
  ));
}
