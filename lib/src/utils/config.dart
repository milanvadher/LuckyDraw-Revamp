import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:youth_app/src/app.dart';
import 'package:youth_app/src/model/user.dart';
import 'package:youth_app/src/utils/cachedata.dart';
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
    return false;
  }

  static Future<bool> isDarkMode() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool isDarkMode = pref.getBool('$darkModeKey') ?? false;
    return isDarkMode;
  }

  static Future<void> changeTheme({@required isDarkTheme}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    CacheData.isDarkTheme = isDarkTheme;
    await pref.setBool('$darkModeKey', isDarkTheme);
    isDarkThemeStream.sink.add(isDarkTheme);
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
