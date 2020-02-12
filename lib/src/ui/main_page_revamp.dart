import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:youth_app/src/ui/about.dart';
import 'package:youth_app/src/ui/ay_quiz/start_page.dart';
import 'package:youth_app/src/utils/app_settings.dart';
import 'package:youth_app/src/utils/cachedata.dart';
import 'package:youth_app/src/utils/common_function.dart';
import '../utils/constant.dart';
import 'youth_website.dart';

class MainPageRevamp extends StatefulWidget {
  @override
  _MainPageRevampState createState() => _MainPageRevampState();
}

class _MainPageRevampState extends State<MainPageRevamp> {
  checkAppUpdate() async {
    bool result = await AppSettings.isUpdateAvailable;
    if (result != null && result) {
      AppSettings.showUpdateDialog(context: context);
    }
  }

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
  void initState() {
    checkAppUpdate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String akramURL = akramYouthURL;
    if (CacheData.appSetting != null && !CommonFunction.isNullOrEmpty(CacheData.appSetting.akramYouthURL))
      akramURL = CacheData.appSetting.akramYouthURL;
    String registrationURL = regURL;
    // if (CacheData.appSetting != null && !CommonFunction.isNullOrEmpty(CacheData.appSetting.regURL))
    //   registrationURL = CacheData.appSetting.regURL;
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
              title: 'Power of 9',
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
                          AppWebView(url: akramURL, title: 'Akram Youth')),
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
                print('REG LINK ==>');
                print(registrationURL);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AppWebView(url: registrationURL, title: 'Registration')),
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
