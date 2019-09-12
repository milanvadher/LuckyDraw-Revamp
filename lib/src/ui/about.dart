import 'package:flutter/material.dart';
import 'package:youth_app/src/utils/app_settings.dart';
import 'package:youth_app/src/utils/constant.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  PublishSubject<String> appVersion = PublishSubject<String>();

  getAppInfo() async {
    String appV = await AppSettings.appVersion;
    appVersion.sink.add(appV);
  }

  @override
  void initState() {
    getAppInfo();
    super.initState();
  }

  @override
  void dispose() {
    appVersion.drain();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text('About')),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            /*ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenHeight),
              child: */Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.only(bottom: 3),
                      child: Text(
                        'Lucky Draw',
                        style: Theme.of(context).textTheme.display1,
                      ),
                    ),
                    Container(
                      child: StreamBuilder(
                        initialData: '0',
                        stream: appVersion,
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<String> snapshot,
                        ) {
                          return Text(
                            'Version ${snapshot.data}',
                            style: Theme.of(context).textTheme.subhead,
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Image(
                        height: 150,
                        image: AssetImage('images/luckydraw_logo.png'),
                      ),
                    ),
                    Container(
                      child: Text(
                        '© 2019-2020 GNC',
                        style: Theme.of(context).textTheme.subhead,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(50, 50, 50, 10),
                      child: Text(
                        'For any query OR Send Bug Report to us with screenshots Email us',
                        style: Theme.of(context).textTheme.caption,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 2),
                      decoration: new BoxDecoration(
                        border: new Border(
                          bottom: new BorderSide(
                              style: BorderStyle.solid, color: Colors.lightBlue),
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          launch(
                              'mailto:$contactEmailId?subject=Bug Report of LuckyDraw',
                              forceSafariVC: false);
                        },
                        child: Text(
                          'to: $contactEmailId',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                //),
              ),
            )
          ],
        ),
      ),
    );
  }
}
