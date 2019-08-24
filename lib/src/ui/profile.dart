import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lucky_draw_revamp/src/ui/edit_username.dart';
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

  editUsername() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUserName(),
      ),
    );
  }

  Widget viewUserInfo({
    @required String title,
    @required String value,
  }) {
    return Card(
      child: ListTile(
        title: Text('$title'),
        trailing: Text(
          '$value',
          style: Theme.of(context).textTheme.headline.copyWith(
                color: Theme.of(context).accentColor,
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: <Widget>[
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
          padding: EdgeInsets.all(10),
          children: <Widget>[
            // User Card
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(
                    '${CacheData.userInfo?.username[0].toUpperCase()}',
                    style: Theme.of(context).textTheme.headline.copyWith(
                          color: Colors.black,
                        ),
                  ),
                ),
                title: Text('${CacheData.userInfo?.username}'),
                subtitle: Text('${CacheData.userInfo?.contactNumber}'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: editUsername,
                ),
              ),
            ),
            viewUserInfo(
                title: 'Question Solved',
                value: '${CacheData.userInfo?.questionState}'),
            viewUserInfo(
                title: 'Total Points', value: '${CacheData.userInfo?.points}'),
          ],
        ),
      ),
    );
  }
}
