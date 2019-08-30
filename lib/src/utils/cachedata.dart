import 'package:lucky_draw_revamp/src/model/app_setting.dart';
import 'package:lucky_draw_revamp/src/model/user.dart';

class CacheData {
  static User userInfo;
  static bool isDarkTheme;
  static AppSetting appSetting;

  static bool get isLuckyDrawActive {
    if (appSetting != null) {
      return appSetting.isLuckyDrawActive;
    }
    return false;
  }
}
