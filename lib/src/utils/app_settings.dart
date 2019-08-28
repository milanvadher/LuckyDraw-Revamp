import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lucky_draw_revamp/src/model/app_setting.dart';
import 'package:lucky_draw_revamp/src/model/version.dart';
import 'package:lucky_draw_revamp/src/repository/repository.dart';
import 'package:lucky_draw_revamp/src/utils/constant.dart';
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

  static checkForUpdate(BuildContext context) async {
    try {
      Repository repository = Repository();
      AppSetting appSetting = await repository.getAppSettings();
      if (appSetting.version != null) {
        String appVersion = await AppSettings.appVersion;
        Version currentVersion = Version(version: appVersion);
        Version playStoreVersion = Version(version: appSetting.version);
        if (playStoreVersion.compareTo(currentVersion) > 0) {
          showUpdateDialog(context: context);
        }
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: '$e',
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
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
            title: Text('New App Update Available'),
            content: Text(
              'New App Version is avaliable.\nYou need to update the app to continue ... !!',
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
