import 'package:flutter/material.dart';
import 'package:youth_app/src/utils/app_settings.dart';
import 'package:youth_app/src/utils/common_function.dart';
import 'package:youth_app/src/utils/constant.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  final bool forLuckyDraw;
  About({this.forLuckyDraw = false});
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
      appBar: widget.forLuckyDraw ? AppBar(title: Text('About')) : null,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenHeight - 50),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Image(
                        height: 150,
                        image: widget.forLuckyDraw
                            ? AssetImage(CommonFunction.getLuckyDrawLogo())
                            : AssetImage('images/youth_logo.png'),
                      ),
                    ),
                    widget.forLuckyDraw
                        ? Container(
                            child: Text(
                              '© 2019-2020 GNC',
                              style: Theme.of(context).textTheme.subhead,
                            ),
                          )
                        : Container(),
                    Container(
                      padding: EdgeInsets.only(top: 20, bottom: 3),
                      child: Text(
                        widget.forLuckyDraw ? 'Lucky Draw' : 'Today\'s  Youth',
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
                      padding: EdgeInsets.fromLTRB(50, 50, 50, 10),
                      child: Text(
                        'For any query OR To send Bug Report email us with screenshots',
                        style: Theme.of(context).textTheme.caption,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 2),
                      decoration: new BoxDecoration(
                        border: new Border(
                          bottom: new BorderSide(
                              style: BorderStyle.solid,
                              color: Colors.lightBlue),
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          launch(
                              widget.forLuckyDraw
                                  ? 'mailto:$contactEmailId?subject=Feedback/Bug Report of LuckyDraw'
                                  : 'mailto:$contactEmailId?subject=Feedback/Bug Report of Youth App',
                              forceSafariVC: false);
                        },
                        child: Text(
                          'to: $contactEmailId',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
