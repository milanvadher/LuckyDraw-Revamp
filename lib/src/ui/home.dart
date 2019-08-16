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

  Widget backPage() {
    return ListView(
      padding: EdgeInsets.all(10),
      children: List.generate(10, (int index) {
        return ListTile(
          onTap: () {
            print('$index');
          },
          title: Text('Index ${index + 1}'),
          subtitle: Text('Description ${index + 1}'),
        );
      }).toList(),
    );
  }

  Widget frontPage() {
    return ListView(
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
                    child: Text("Title"),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
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
    );
  }
}
