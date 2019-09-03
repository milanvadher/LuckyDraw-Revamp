import 'package:flutter/material.dart';
import 'package:lucky_draw_revamp/src/ui/home.dart';
import 'package:lucky_draw_revamp/src/ui/login.dart';
import 'package:lucky_draw_revamp/src/utils/common_function.dart';
import 'package:lucky_draw_revamp/src/utils/config.dart';
import 'package:lucky_draw_revamp/src/utils/loading.dart';

class AppSelection extends StatefulWidget {
  @override
  _AppSelectionState createState() => _AppSelectionState();
}

class _AppSelectionState extends State<AppSelection> {
  goToLuckyDraw() async {
    Loading.show(context);
    Widget homepage = LoginPage();
    bool isLogin = await Config.isLogin();
    print('IsLOGIN $isLogin');
    if (isLogin) {
      homepage = HomePage();
    }
    Loading.hide(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => homepage,
      ),
    );
  }

  navigateToYouthWebsite() {
    CommonFunction.openYouthWebsite(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return CommonFunction.onWillPop(context: context);
      },
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(10),
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 25,
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      selectionCard(
                        context: context,
                        image: Hero(
                          tag: 'lucky_draw',
                          child: Image(
                            image: AssetImage('images/logo.png'),
                          ),
                        ),
                        title: 'LuckyDraw',
                        onTap: goToLuckyDraw,
                      ),
                      Divider(),
                      selectionCard(
                        context: context,
                        image: Hero(
                          tag: 'youth_website',
                          child: Image(
                            image: AssetImage('images/youth_logo.png'),
                          ),
                        ),
                        title: 'Youth Website',
                        onTap: navigateToYouthWebsite,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget selectionCard({
  @required BuildContext context,
  @required Widget image,
  @required String title,
  @required Function onTap,
}) {
  return ConstrainedBox(
    constraints: BoxConstraints(
      minHeight: 225,
      minWidth: 225,
    ),
    child: Card(
      margin: EdgeInsets.all(12),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 70,
              width: 70,
              child: image,
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline,
              ),
            )
          ],
        ),
      ),
    ),
  );
}
