import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:youth_app/src/model/app_setting.dart';
import 'package:youth_app/src/model/version.dart';
import 'package:youth_app/src/repository/repository.dart';
import 'package:youth_app/src/utils/appsharedprefutil.dart';
import 'package:youth_app/src/utils/cachedata.dart';
import 'package:youth_app/src/utils/constant.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class AppSettings {
  static get appVersion async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static get appId async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }

  static Future<bool> get isUpdateAvailable async {
    if (CacheData.appSetting.version != null) {
      String appVersion = await AppSettings.appVersion;
      Version currentVersion = Version(version: appVersion);
      Version playStoreVersion = Version(version: CacheData.appSetting.version);
      if (playStoreVersion.compareTo(currentVersion) > 0) {
        return true;
      }
    }
    return false;
  }

  static Future<void> getAppSettings() async {
    try {
      Repository repository = Repository();
      AppSetting appSetting = await repository.getAppSettings();
      if(appSetting != null) {
        CacheData.appSetting = appSetting;
        bool isLuckyDrawActive = CacheData.isLuckyDrawActive;
        await AppSharedPrefUtil.saveIsLuckyDrawActive(isLuckyDrawActive);
      }
    } catch (e) {
      debugPrint('Error To Get AppSettings $e');
    }
  }

  static showUpdateDialog({BuildContext context}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text('A New Update is Available'),
            content: Text(
              'You need to update app to continue ... !!!',
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Update Now'),
                onPressed: () {
                  Platform.isIOS ? openAppStore() : openPlayStore();
                },
              )
            ],
          ),
        );
      },
    );
  }

  static openPlayStore() async {
    String appId = await AppSettings.appId;
    launch('$playStoreBaseURL$appId');
  }

  static openAppStore() {
    launch('https://itunes.apple.com/app/id1457589389');
  }
}
