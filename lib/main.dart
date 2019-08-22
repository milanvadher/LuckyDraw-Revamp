import 'package:flutter/material.dart';
import 'package:lucky_draw_revamp/src/ui/splashscreen.dart';
import 'package:lucky_draw_revamp/src/utils/cachedata.dart';
import 'package:lucky_draw_revamp/src/utils/config.dart';
import 'src/app.dart';

void main() async {
  CacheData.isDarkTheme = await Config.isDarkMode();
  runApp(MyApp(
    homepage: SplashScreen(),
  ));
}
