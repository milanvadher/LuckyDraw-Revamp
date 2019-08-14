import 'dart:convert';
import 'package:lucky_draw_revamp/src/model/user.dart';
import 'package:lucky_draw_revamp/src/utils/cachedata.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constant.dart';

class Config {
  static Future<bool> isLogin() async {
    Object userString = await getObjectJson('$userDataKey');
    print('userString : $userString');
    if (userString != null) {
      User user = User.fromJson(userString);
      print('${user is User}');
      if (user is User) {
        CacheData.userInfo = user;
        return true;
      }
    }
    await clearStorage();
    return false;
  }

  static Future<dynamic> getObjectJson(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String objectString = pref.getString(key);
    if (objectString != null) {
      return json.decode(objectString);
    }
  }

  static Future<void> saveObjectJson(String key, Object object) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(key, json.encode(object));
  }

  static Future<void> clearStorage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
  }
}
