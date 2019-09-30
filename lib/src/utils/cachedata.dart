import 'dart:io';

import 'package:youth_app/src/model/app_setting.dart';
import 'package:youth_app/src/model/user.dart';

class CacheData {
  static User userInfo;
  static bool isDarkTheme;
  static AppSetting appSetting;

  static bool get isLuckyDrawActive {
    if (appSetting != null) {
      if(Platform.isIOS)
        return appSetting.iosIsLuckyDrawActive;
      else
        return appSetting.isLuckyDrawActive;
    }
    return false;
  }
}
