import 'package:flutter/material.dart';
import 'package:lucky_draw_revamp/src/ui/login.dart';

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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: ListView(
        padding: EdgeInsets.all(5),
        children: <Widget>[
          Text('Home Page Content'),
          Icon(Icons.today),
          ListTile(
            title: Text('Title'),
            subtitle: Text('Subtitle'),
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.person_outline,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ),
          Container(
            child: ButtonBar(
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                  child: Text('LogOut'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
