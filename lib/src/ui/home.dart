import 'package:flutter/material.dart';
import 'package:lucky_draw_revamp/src/ui/login.dart';
import 'package:lucky_draw_revamp/src/utils/cachedata.dart';
import 'package:lucky_draw_revamp/src/utils/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  static const PANEL_HEADER_HEIGHT = 32.0;

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App ?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget backPage() {
    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
      ),
      child: ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[
          ListTile(
            title: Text('${CacheData.userInfo?.username}'),
            subtitle: Text('${CacheData.userInfo?.contactNumber}'),
            leading: CircleAvatar(
              backgroundColor: Colors.black54,
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
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.black54,
              child: Icon(
                Icons.brightness_6,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            title: Text('Dark Theme'),
            subtitle: Text('Change app theme'),
            trailing: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.transparent,
              child: Switch(
                onChanged: (bool value) {
                  print(value);
                },
                value: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget frontPage() {
    return Container(
      child: ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(40, 0, 40, 10),
            child: Image.asset(
              'images/logo.png',
              height: 200,
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
            child: Text(
              'LUCKY DRAW',
              style: Theme.of(context).textTheme.title,
            ),
          ),
        ],
      ),
    );
  }

  Animation<RelativeRect> _getPanelAnimation(BoxConstraints constraints) {
    final double height = constraints.biggest.height;
    final double top = height - PANEL_HEADER_HEIGHT;
    final double bottom = -PANEL_HEADER_HEIGHT;
    return RelativeRectTween(
      begin: RelativeRect.fromLTRB(0.0, top, 0.0, bottom),
      end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  Widget buildStack(BuildContext context, BoxConstraints constraints) {
    final Animation<RelativeRect> animation = _getPanelAnimation(constraints);
    final ThemeData theme = Theme.of(context);
    return Container(
      color: theme.primaryColor,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: PANEL_HEADER_HEIGHT),
            child: backPage(),
          ),
          PositionedTransition(
            rect: animation,
            child: Material(
              borderRadius: const BorderRadius.only(
                topLeft: const Radius.circular(16.0),
                topRight: const Radius.circular(16.0),
              ),
              elevation: 12.0,
              child: Column(
                children: <Widget>[
                  Container(
                    height: PANEL_HEADER_HEIGHT,
                    // padding: EdgeInsets.only(left: 22),
                    alignment: Alignment.center,
                    child: Text("Home"),
                  ),
                  Expanded(
                    child: frontPage(),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool get _isPanelVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      value: 1,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Lucky Draw'),
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: AnimatedIcon(
                icon: AnimatedIcons.close_menu,
                progress: _controller.view,
              ),
              onPressed: () {
                _controller.fling(velocity: _isPanelVisible ? -1.0 : 1.0);
              },
            )
          ],
        ),
        body: LayoutBuilder(
          builder: buildStack,
        ),
      ),
    );
  }
}
