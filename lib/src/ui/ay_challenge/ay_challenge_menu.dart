import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../youth_website.dart';

class AyChallenge extends StatelessWidget {
  static const int IN_APP = 0;
  static const int IN_BROWSER = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AY challenge"),
      ),
      body: _ayMenu(context),
    );
  }

  _ayMenu(context) {
    double _iconSize = 35;
    return ListView(
      children: <Widget>[
        _ayMenuButton(
          "About Akram Challenge",
          Icon(
            FontAwesomeIcons.info,
            size: 0, // TO HIDE THE ICON
          ),
          Colors.transparent,
          [
            Color(0xff405de6),
            Color(0xff5851db),
          ],
          "https://youth.dadabhagwan.org/youth-in-action/akramchallenge/",
          IN_APP,
          context,
        ),
        Container(
          padding: EdgeInsets.all(12),
            child: Text(
          "Watch Akram Challenge videos on",
          style: TextStyle(fontSize: 30),textAlign: TextAlign.center,
        )),
        _ayMenuButton(
          "Youtube",
          Icon(
            FontAwesomeIcons.youtube,
            size: _iconSize,
          ),
          Colors.red.shade300,
          [Colors.redAccent.shade400, Colors.red.shade400],
          "https://m.youtube.com/results?search_query=%23Jagatkalyanbhavna",
          IN_BROWSER,
          context,
        ),
        _ayMenuButton(
          "Facebook",
          Icon(
            FontAwesomeIcons.facebook,
            size: _iconSize,
          ),
          Colors.transparent,
          [
            Color(0xff02386E),
            Color(0xff00498D),
            Color(0xff0052A2),
          ],
          "https://www.facebook.com/hashtag/jagatkalyanbhavna",
          IN_BROWSER,
          context,
        ),
        _ayMenuButton(
          "Instagram",
          Icon(
            FontAwesomeIcons.instagram,
            size: _iconSize,
          ),
          Colors.transparent,
          [
            Color(0xff405de6),
            Color(0xff5851db),
            Color(0xff833ab4),
            Color(0xffc13584),
            Color(0xffe1306c),
            Color(0xfffd1d1d),
            Color(0xfff77737),
            Color(0xfffcaf45),
            Color(0xffffdc80),
          ],
          "https://www.instagram.com/explore/tags/jagatkalyanbhavna/",
          IN_BROWSER,
          context,
        ),
        _ayMenuButton(
          "Twitter",
          Icon(
            FontAwesomeIcons.twitter,
            size: _iconSize,
          ),
          Colors.lightBlue.shade300,
          [Colors.lightBlue, Colors.blue.shade700],
          "https://www.twitter.com/search?q=%23jagatkalyanbhavna",
          IN_BROWSER,
          context,
        )
      ],
    );
  }

  _openUrl(String url, int openMode, BuildContext context) async {
    if (openMode == IN_BROWSER) {
      if (await canLaunch(url)) {
        launch(url);
      }
    } else if (openMode == IN_APP) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AppWebView(
            url: url,
            title: 'Akram Challenge',
          ),
        ),
      );
    }
  }

  _ayMenuButton(
      String title,
      Icon icon,
      Color color,
      List<Color> gradientColors,
      String url,
      int openMode,
      BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: new BoxDecoration(
          border: new Border.all(color: color),
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment(-1.0, -4.0),
            end: Alignment(1.0, 4.0),
          )),
      child: InkWell(
        onTap: () {
          _openUrl(url, openMode, context);
        },
        child: Center(
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 80,
                  padding: EdgeInsets.only(
                    left: 20,
                  ),
                  child: icon,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 80,
                  child: Center(
                    child: Text(
                      '$title',
                      style: Theme.of(context).textTheme.headline,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
