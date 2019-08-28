import 'package:lucky_draw_revamp/src/model/app_setting.dart';
import 'package:lucky_draw_revamp/src/repository/app_api.dart';

class AppSettingApiProvider {
  Future<AppSetting> getAppSettings() async {
    return await AppApi.getApiWithParseRes(
      fromJson: (json) => AppSetting.fromJson(json),
      apiEndPoint: 'appSettings',
    );
  }
}
