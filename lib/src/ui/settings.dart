import 'package:flutter/material.dart';
import 'package:lucky_draw_revamp/src/app.dart';
import 'package:lucky_draw_revamp/src/ui/about.dart';
import 'package:lucky_draw_revamp/src/ui/coupon.dart';
import 'package:lucky_draw_revamp/src/ui/profile.dart';
import 'package:lucky_draw_revamp/src/utils/cachedata.dart';
import 'package:lucky_draw_revamp/src/utils/common_widget.dart';
import 'package:lucky_draw_revamp/src/utils/config.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Widget settingItem({
    @required String title,
    @required String description,
    @required IconData icon,
    Widget trailingWidget,
    Function onTap,
  }) {
    return Column(
      children: <Widget>[
        Divider(height: 0),
        MaterialButton(
          padding: EdgeInsets.all(0),
          onPressed: () {},
          child: ListTile(
            onTap: onTap,
            leading: CircleAvatar(
              backgroundColor: Colors.black54,
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            title: Text('$title'),
            subtitle: Text('$description'),
            trailing: CircleAvatar(
              radius: trailingWidget != null ? 30 : 0,
              backgroundColor: Colors.transparent,
              child: trailingWidget ?? Container(),
            ),
          ),
        ),
        Divider(height: 0),
      ],
    );
  }

  void navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Profile(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black,
        accentColor: Colors.black,
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
      ),
      child: ListView(
        children: <Widget>[
          CommonWidget.settingsTitle(context: context, title: 'Profile'),
          // User Info
          settingItem(
            title: '${CacheData.userInfo?.username}',
            description: '${CacheData.userInfo?.contactNumber}',
            icon: Icons.person_outline,
            onTap: navigateToProfile,
            trailingWidget: IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.black,
              ),
              onPressed: navigateToProfile,
            ),
          ),
          // Coupons
          settingItem(
            title: 'Coupons',
            description: 'Assign and Un-Assign',
            icon: Icons.confirmation_number,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CouponPage(),
                ),
              );
            },
          ),
          CommonWidget.settingsTitle(context: context, title: 'Settings'),
          // APP Theme
          settingItem(
            title: 'Dark Theme',
            description: 'Change app theme',
            icon: Icons.brightness_6,
            onTap: () async {
              await Config.changeTheme(isDarkTheme: !CacheData.isDarkTheme);
            },
            trailingWidget: StreamBuilder(
              initialData: CacheData.isDarkTheme,
              stream: isDarkThemeStream,
              builder: (
                BuildContext context,
                AsyncSnapshot<bool> snapshot,
              ) {
                return Switch(
                  activeColor: Colors.black54,
                  onChanged: (bool value) async {
                    await Config.changeTheme(isDarkTheme: value);
                  },
                  value: snapshot.data,
                );
              },
            ),
          ),
          // About US
          settingItem(
            title: 'About',
            description: 'Know more about App OR Send bug report',
            icon: Icons.settings,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => About(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
