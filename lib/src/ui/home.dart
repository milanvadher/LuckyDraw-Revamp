import 'package:flutter/material.dart';
import 'package:lucky_draw_revamp/src/ui/login.dart';
import 'package:lucky_draw_revamp/src/utils/cachedata.dart';
import 'package:lucky_draw_revamp/src/utils/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(5),
        children: <Widget>[
          ListTile(
            title: Text('${CacheData.userInfo?.username}'),
            subtitle: Text('${CacheData.userInfo?.contactNumber}'),
            leading: CircleAvatar(
              child: Icon(
                Icons.person_outline,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.power_settings_new),
              onPressed: () async {
                Loading.show(context);
                SharedPreferences pref = await SharedPreferences.getInstance();
                await pref.clear();
                Loading.hide(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
