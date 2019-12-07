import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:youth_app/src/ui/about.dart';
import 'package:youth_app/src/ui/ay_quiz/start_page.dart';
import '../utils/constant.dart';
import 'youth_website.dart';

class MainPageRevamp extends StatefulWidget {
  @override
  _MainPageRevampState createState() => _MainPageRevampState();
}

class _MainPageRevampState extends State<MainPageRevamp> {
  onClickMenu(String text) {
    Fluttertoast.showToast(
      msg: text,
    );
  }

  Widget createMenu({
    @required Color color,
    @required String title,
    Function onClick,
    Widget icon,
  }) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: new BoxDecoration(
        border: new Border.all(color: color),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          onClick == null
              ? onClickMenu('$title is Not implemented')
              : onClick();
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 80,
                padding: EdgeInsets.only(bottom: 10),
                child: icon,
              ),
              Text(
                '$title',
                style: Theme.of(context).textTheme.headline,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Today\'s Youth'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(5),
          children: <Widget>[
            createMenu(
              color: Colors.deepOrangeAccent,
              title: 'AY Quiz',
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AYQuizStartPage(),
                  ),
                );
              },
              icon: Icon(
                Icons.gamepad,
                size: 60,
                color: Colors.deepOrangeAccent,
              ),
            ),
            createMenu(
              color: Colors.amber.shade700,
              title: 'Website',
              icon: ImageIcon(
                AssetImage('images/youth_logo.png'),
                size: 60,
                color: Colors.amber.shade700,
              ),
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppWebView(
                      url: youthWebsiteURL,
                      title: 'Website',
                    ),
                  ),
                );
              },
            ),
            createMenu(
              color: Colors.lightBlue.shade300,
              title: 'Akram Youth',
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AppWebView(url: akramYouthURL, title: 'Akram Youth')),
                );
              },
              icon: ImageIcon(
                AssetImage('images/akram_youth.png'),
                size: 50,
                color: Colors.lightBlue.shade300,
              ),
            ),
            createMenu(
              color: Colors.teal.shade300,
              title: 'Registration',
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AppWebView(url: regURL, title: 'Registration')),
                );
              },
              icon: ImageIcon(
                AssetImage('images/registration_icon.png'),
                size: 50,
                color: Colors.teal.shade300,
              ),
            ),
            createMenu(
              color: Colors.red.shade300,
              title: 'About',
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => About()),
                );
              },
              icon: Icon(
                Icons.info_outline,
                size: 50,
                color: Colors.red.shade300,
              ),
            ),
            // createMenu(
            //   color: Colors.amberAccent,
            //   title: 'Settings',
            //   onClick: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => Settings()),
            //     );
            //   },
            //   icon: Icon(
            //     Icons.settings,
            //     size: 50,
            //     color: Colors.amberAccent,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
