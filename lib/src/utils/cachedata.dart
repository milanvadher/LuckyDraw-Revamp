import 'package:youth_app/src/model/app_setting.dart';
import 'package:youth_app/src/model/user.dart';
import 'package:youth_app/src/model/user_state.dart';

class CacheData {
  static User userInfo;
  static bool isDarkTheme;
  static AppSetting appSetting;
  static UserState userState;

  static bool get isLuckyDrawActive {
    if (appSetting != null) {
      return appSetting.isLuckyDrawActive;
    }
    return false;
  }
}
