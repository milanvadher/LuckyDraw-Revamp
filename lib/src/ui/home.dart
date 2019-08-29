import 'package:flutter/material.dart';
import 'package:lucky_draw_revamp/src/ui/front_page.dart';
import 'package:lucky_draw_revamp/src/ui/settings.dart';
import 'package:lucky_draw_revamp/src/utils/app_settings.dart';
import 'package:lucky_draw_revamp/src/utils/common_function.dart';

class HomePage extends StatefulWidget {
  final bool isUpdateAvailable;

  const HomePage({Key key, this.isUpdateAvailable}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  static const PANEL_HEADER_HEIGHT = 32.0;

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
            child: Settings(),
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
                    child: FrontPage(),
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
    if (widget.isUpdateAvailable) {
      AppSettings.showUpdateDialog(context: context);
    }
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
      onWillPop: () {
        return CommonFunction.onWillPop(context: context);
      },
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
