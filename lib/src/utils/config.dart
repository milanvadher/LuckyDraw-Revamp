import 'dart:convert';
import 'package:lucky_draw_revamp/src/model/user.dart';
import 'package:lucky_draw_revamp/src/utils/cachedata.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constant.dart';

class Config {
  static Future<bool> isLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    User user = User.fromJson(json.decode(pref.getString('$userDataKey')));
    if (user is User) {
      CacheData.userInfo = user;
      return true;
    }
    pref.clear();
    return false;
  }
}
