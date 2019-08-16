import 'package:flutter/material.dart';
import 'package:lucky_draw_revamp/src/app.dart';
import 'package:lucky_draw_revamp/src/ui/about.dart';
import 'package:lucky_draw_revamp/src/ui/profile.dart';
import 'package:lucky_draw_revamp/src/utils/cachedata.dart';
import 'package:lucky_draw_revamp/src/utils/common_widget.dart';
import 'package:lucky_draw_revamp/src/utils/config.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
          Divider(height: 0),
          ListTile(
            title: Text('${CacheData.userInfo?.username}'),
            subtitle: Text('${CacheData.userInfo?.contactNumber}'),
            leading: CircleAvatar(
              backgroundColor: Colors.black54,
              child: Icon(
                Icons.person_outline,
                color: Colors.white,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profile(),
                  ),
                );
              },
            ),
          ),
          Divider(height: 0),
          CommonWidget.settingsTitle(context: context, title: 'Settings'),
          Divider(height: 0),
          MaterialButton(
            padding: EdgeInsets.all(0),
            onPressed: () {},
            child: ListTile(
              onTap: () async {
                await Config.changeTheme(isDarkTheme: !CacheData.isDarkTheme);
              },
              leading: CircleAvatar(
                backgroundColor: Colors.black54,
                child: Icon(
                  Icons.brightness_6,
                  color: Colors.white,
                ),
              ),
              title: Text('Dark Theme'),
              subtitle: Text('Change app theme'),
              trailing: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.transparent,
                child: StreamBuilder(
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
            ),
          ),
          Divider(height: 0),
          MaterialButton(
            padding: EdgeInsets.all(0),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => About(),
                ),
              );
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.black54,
                child: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
              ),
              title: Text('About'),
              subtitle: Text('Know more about App OR Send bug report'),
            ),
          ),
          Divider(height: 0),
        ],
      ),
    );
  }
}
