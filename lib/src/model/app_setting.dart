import 'dart:io' show Platform;

import 'package:youth_app/src/utils/constant.dart';

class AppSetting {
  String appversion;
  String iosAppversion;
  bool isLuckyDrawActive;
  String akram_youth_url;
  String reg_url;
  String get version => Platform.isIOS ? iosAppversion : appversion;

  AppSetting({this.appversion, this.iosAppversion, this.isLuckyDrawActive, this.akram_youth_url, this.reg_url});

  AppSetting.fromJson(Map<String, dynamic> json) {
    if (json['appversion'] != null) appversion = json['appversion'];
    if (json['ios_appversion'] != null) iosAppversion = json['ios_appversion'];
    isLuckyDrawActive = json['is_luckydraw_active'] ?? false;
    akram_youth_url = json['akram_youth_url'] ?? akramYouthURL;
    reg_url = json['reg_url'] ?? regURL;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appversion'] = this.appversion;
    data['ios_appversion'] = this.iosAppversion;
    data['is_luckydraw_active'] = this.isLuckyDrawActive;
    data['akram_youth_url'] = this.akram_youth_url;
    data['reg_url'] = reg_url;
    return data;
  }
}
