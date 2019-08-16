import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lucky_draw_revamp/src/utils/cachedata.dart';
import 'package:lucky_draw_revamp/src/utils/constant.dart';
import 'package:lucky_draw_revamp/src/utils/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Widget buildUserInfo({@required String title, @required String description}) {
    return ListTile(
      title: Text('$title'),
      subtitle: Text('$description'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              print('Edit Username');
            },
          ),
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () async {
              Loading.show(context);
              SharedPreferences pref = await SharedPreferences.getInstance();
              await pref.remove('$userDataKey');
              await _fcm.deleteInstanceID();
              Loading.hide(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
                (_) => false,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            buildUserInfo(
              title: 'Username',
              description: '${CacheData.userInfo?.username}',
            ),
            buildUserInfo(
              title: 'Mobile No.',
              description: '${CacheData.userInfo?.contactNumber}',
            ),
            buildUserInfo(
              title: 'Total Points',
              description: '${CacheData.userInfo?.points}',
            ),
            buildUserInfo(
              title: 'Solved Questions',
              description: '${CacheData.userInfo?.questionState} / 100',
            ),
          ],
        ),
      ),
    );
  }
}
