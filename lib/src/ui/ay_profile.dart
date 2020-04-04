import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youth_app/src/ui/main_page_revamp.dart';
import 'package:youth_app/src/utils/cachedata.dart';
import 'package:youth_app/src/utils/constant.dart';
import 'package:youth_app/src/utils/loading.dart';
import 'package:youth_app/src/utils/points.dart';

class AYProfile extends StatefulWidget {
  int categoryNumber;
  AYProfile(this.categoryNumber);
  @override
  _AYProfileState createState() => _AYProfileState();
}

class _AYProfileState extends State<AYProfile> with TickerProviderStateMixin {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    Point.updatePoint();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget userAvatar = Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.center,
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 52,
            backgroundColor: Colors.blueGrey,
            child: CircleAvatar(
              radius: 50,
              child: Hero(
                tag: 'profile',
                child: Icon(
                  Icons.account_circle,
                  size: 75,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Widget userPoints = Container(
      alignment: Alignment.center,
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Point.display(widget.categoryNumber),
          ],
        ),
      ),
    );

    Widget buildTitleAndData({
      @required String title,
      @required String data,
      @required IconData icon,
    }) {
      return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Icon(
            icon,
            color: Theme.of(context).accentColor,
          ),
        ),
        title: Text(
          '$title',
        ),
        subtitle: Text(
          '$data',
          style: Theme.of(context).textTheme.title,
          textAlign: TextAlign.left,
        ),
      );
    }

    Widget profileData = Container(
      child: Column(
        children: <Widget>[
          Divider(height: 0),
          buildTitleAndData(
            title: 'Username',
            data: CacheData.userInfo?.username,
            icon: Icons.person,
          ),
          Divider(height: 0),
          buildTitleAndData(
            title: 'Contact No.',
            data: CacheData.userInfo?.contactNumber,
            icon: Icons.email,
          ),
          Divider(height: 0),
        ],
      ),
    );

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
              await pref.remove('userRole');
              await pref.remove('firebaseToken');
              await _fcm.deleteInstanceID();
              Loading.hide(context);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MainPageRevamp(),
                ),
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            userAvatar,
            userPoints,
            // Container(
            //   alignment: Alignment.center,
            //   child: Point.display(),
            // ),
            profileData,
          ],
        ),
      ),
    );
  }
}
