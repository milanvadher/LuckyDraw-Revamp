import 'package:flutter/material.dart';
import 'package:youth_app/src/ui/splashscreen.dart';
import 'package:youth_app/src/utils/cachedata.dart';
import 'package:youth_app/src/utils/config.dart';
import 'src/app.dart';

void main() async {
  Widget homepage = SplashScreen();
  CacheData.isDarkTheme = await Config.isDarkMode();
  runApp(MyApp(
    homepage: homepage,
  ));
}
