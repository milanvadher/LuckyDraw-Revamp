import 'dart:io' show Platform;

import 'package:youth_app/src/utils/constant.dart' as Constant;
import 'package:json_annotation/json_annotation.dart';

part 'app_setting.g.dart';

@JsonSerializable()
class AppSetting {
  @JsonKey(name: 'appversion')
  String appVersion;
  @JsonKey(name: 'ios_appversion')
  String iosAppVersion;
  @JsonKey(name: 'is_luckydraw_active', defaultValue: false)
  bool isLuckyDrawActive;
  @JsonKey(name: 'akram_youth_url', defaultValue: Constant.akramYouthURL)
  String akramYouthURL;
  @JsonKey(name: 'reg_url', defaultValue: Constant.regURL)
  String regURL;
  String get version => Platform.isIOS ? iosAppVersion : appVersion;

  AppSetting();

  factory AppSetting.fromJson(Map<String, dynamic> json) => _$AppSettingFromJson(json);
  Map<String, dynamic> toJson() => _$AppSettingToJson(this);
}
