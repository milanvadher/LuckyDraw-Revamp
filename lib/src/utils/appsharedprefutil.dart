import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPrefUtil {
  static SharedPreferences _pref;
  static final DateFormat prefDateFormat = DateFormat('dd-MM-yyyy');
  static final DateFormat prefTimeFormat = DateFormat('dd-MM-yyyy hh:mm');

/*static final AppSharedPrefUtil _singleton = new AppSharedPrefUtil._internal();

  factory AppSharedPrefUtil() {
    SharedPreferences.getInstance().then((onValue) => this.pref = onValue);
    return _singleton;
  }

  AppSharedPrefUtil._internal()*/

  static Future<void> loadPref() async {
    if (_pref == null) _pref = await SharedPreferences.getInstance();
  }

  static Future<void> saveBoolean(String prefStr, bool isDone) async {
    await loadPref();
    _pref.setBool(prefStr, isDone);
  }

  static Future<bool> getBool(String prefStr, {bool defaultValue = false}) async {
    await loadPref();
    return _pref.getBool(prefStr) == null ? defaultValue : _pref.getBool(prefStr);
  }

  static Future<String> getString(String prefStr, {String defaultValue}) async {
    await loadPref();
    return _pref.getString(prefStr) == null ? defaultValue : _pref.getString(prefStr);
  }

  static Future<void> saveString(String prefStr, String value) async {
    await loadPref();
    _pref.setString(prefStr, value);
  }

  static Future<dynamic> getObjectJson(String key) async {
    String objectJson = await getString(key);
    if (objectJson != null) {
      return json.decode(objectJson);
    }
    return null;
  }

  static Future<void> saveObjectJson(String key, Object objectJson) async {
    await saveString(key, json.encode(objectJson));
  }

  static Future<void> saveDate(String prefName, DateTime date) async {
    if (date != null) await saveString(prefName, prefDateFormat.format(date));
  }

  static Future<DateTime> getDate(String prefName) async {
    String strDate = await getString(prefName);
    if (strDate != null) {
      return prefDateFormat.parse(strDate);
    }
    return null;
  }

  static Future<void> saveIsLuckyDrawActive(bool isLuckyDrawActive) async {
    await saveBoolean("is_lucky_draw_active", isLuckyDrawActive);
    print('saved isluckydraw $isLuckyDrawActive');
    print('got ${await AppSharedPrefUtil.isLuckyDrawActive()}');
  }

  static Future<bool> isLuckyDrawActive() async {
    return await getBool("is_lucky_draw_active", defaultValue: false);
  }
}
