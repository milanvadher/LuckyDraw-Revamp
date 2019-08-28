import 'dart:io' show Platform;

class AppSetting {
  String appversion;
  String iosAppversion;
  bool isLuckyDrawActive;
  String get version => Platform.isIOS ? iosAppversion : appversion;

  AppSetting({this.appversion, this.iosAppversion, this.isLuckyDrawActive});

  AppSetting.fromJson(Map<String, dynamic> json) {
    if (json['appversion'] != null) appversion = json['appversion'];
    if (json['ios_appversion'] != null) iosAppversion = json['ios_appversion'];
    isLuckyDrawActive = json['is_luckydraw_active'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appversion'] = this.appversion;
    data['ios_appversion'] = this.iosAppversion;
    data['is_luckydraw_active'] = this.isLuckyDrawActive;
    return data;
  }
}
