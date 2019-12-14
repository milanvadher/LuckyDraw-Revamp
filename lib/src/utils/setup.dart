import 'package:shared_preferences/shared_preferences.dart';
import 'package:youth_app/src/utils/cachedata.dart';
import 'package:youth_app/src/utils/config.dart';

class Setup {
  Map<String, String> headers = {'content-type': 'application/json'};

  Future<bool> isLogin() async {
    await SharedPreferences.getInstance();
    bool isLogin = await Config.isLogin();
    return isLogin;
  }

  Future<String> getMhtId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(CacheData.userInfo.contactNumber);
  }

  appendTokenToHeader() async {
    headers['mht_id'] = await getMhtId();
    print(headers);
  }

  Future<Map<String, String>> getHeaders() async {
    if (await isLogin()) {
      await appendTokenToHeader();
    }
    return headers;
  }

  static String getOrdinalOfNumber(int n) {
    int j = n % 10;
    int k = n % 100;
    if (j == 1 && k != 11) {
      return "st";
    }
    if (j == 2 && k != 12) {
      return "nd";
    }
    if (j == 3 && k != 13) {
      return "rd";
    }
    return "th";
  }
}
