// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSetting _$AppSettingFromJson(Map<String, dynamic> json) {
  return AppSetting()
    ..appVersion = json['appversion'] as String
    ..iosAppVersion = json['ios_appversion'] as String
    ..isLuckyDrawActive = json['is_luckydraw_active'] as bool ?? false
    ..iosIsLuckyDrawActive = json['ios_is_luckydraw_active'] as bool ?? false
    ..akramYouthURL = json['akram_youth_url'] as String ??
        'https://youth.dadabhagwan.org/gallery/akram-youth/#app/'
    ..regURL = json['reg_url'] as String ?? 'http://gncevents.page.link/reg/';
}

Map<String, dynamic> _$AppSettingToJson(AppSetting instance) =>
    <String, dynamic>{
      'appversion': instance.appVersion,
      'ios_appversion': instance.iosAppVersion,
      'is_luckydraw_active': instance.isLuckyDrawActive,
      'ios_is_luckydraw_active': instance.iosIsLuckyDrawActive,
      'akram_youth_url': instance.akramYouthURL,
      'reg_url': instance.regURL,
    };
