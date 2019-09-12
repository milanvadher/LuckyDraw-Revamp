import 'package:flutter/material.dart';
import 'package:youth_app/src/app.dart';
import 'package:youth_app/src/ui/about.dart';
import 'package:youth_app/src/ui/coupon.dart';
import 'package:youth_app/src/ui/profile.dart';
import 'package:youth_app/src/utils/cachedata.dart';
import 'package:youth_app/src/utils/common_function.dart';
import 'package:youth_app/src/utils/common_widget.dart';
import 'package:youth_app/src/utils/config.dart';

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
    bool isUsername = false,
    bool isThreeLine = false,
    bool isYouthWebsite = false,
  }) {
    return Column(
      children: <Widget>[
        Divider(height: 0),
        MaterialButton(
          padding: EdgeInsets.all(0),
          onPressed: () {},
          child: ListTile(
            isThreeLine: isThreeLine,
            onTap: onTap,
            leading: CircleAvatar(
              child: isUsername
                  ? Text(
                      '${CacheData.userInfo?.username[0].toUpperCase()}',
                      style: Theme.of(context).textTheme.headline.copyWith(
                            color: Colors.black,
                          ),
                    )
                  : !isYouthWebsite
                      ? Icon(
                          icon,
                        )
                      : Hero(
                          tag: 'youth_website',
                          child: Image(
                            image: AssetImage('images/youth_logo.png'),
                          ),
                        ),
            ),
            title: Text(
              '$title',
              /*style: TextStyle(
                color: Colors.black,
              ),*/
            ),
            subtitle: Text(
              '$description',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SafeArea(
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
                  color: CacheData.isDarkTheme ? Theme.of(context).primaryColor : Colors.black,
                ),
                onPressed: navigateToProfile,
              ),
              isUsername: true,
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
                    //activeColor: Colors.black54,
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
            // Youth Website
            /*settingItem(
              title: 'Youth Website',
              description: 'Spiritual guidance for our everyday challenges',
              isThreeLine: true,
              icon: Icons.ac_unit,
              isYouthWebsite: true,
              onTap: () {
                CommonFunction.openYouthWebsite(context: context);
              },
            ),*/
          ],
        ),
      ),
    );
  }
}
