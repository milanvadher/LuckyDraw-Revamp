import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import 'package:youth_app/src/app.dart';
import 'package:youth_app/src/utils/cachedata.dart';
import 'package:youth_app/src/utils/config.dart';
import 'package:youth_app/src/utils/constant.dart';
import 'package:youth_app/src/utils/webview/app_chromeinbrowser.dart';

enum TabsStyle { iconsAndText, iconsOnly, textOnly }

class TabPage {
  const TabPage({this.content, this.icon, this.text});

  final Widget icon;
  final String text;
  final Widget content;
}

class ScrollableTabs extends StatefulWidget {
  List<TabPage> page;
  final TabsStyle tabsDemoStyle;
  final String title;
  final List<Widget> actions;
  final bool withDrawer;
  final Function(int) onTap;
  ScrollableTabs({Key key, this.page, this.tabsDemoStyle = TabsStyle.textOnly, this.title, this.actions, this.withDrawer = false, this.onTap})
      : super(key: key);

  int index() {
    return state._controller.index;
  }

  ScrollableTabsState state;

  @override
  ScrollableTabsState createState() {
    state = ScrollableTabsState();
    return state;
  }
}

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}



class ScrollableTabsState extends State<ScrollableTabs> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _controller;
  ScrollableTabsState();
  int _selectedDrawerIndex = 0;
  var primaryColor;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    widget.page = widget.page.where((page) => page != null).toList(growable: true);
    _controller = TabController(vsync: this, length: widget.page.length);
  }

  //final ChromeSafariBrowser browser = new MyChromeSafariBrowser(new InAppBrowser());
  final AppInappBrowser browser = new AppInappBrowser();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.state = this;
    widget.page = widget.page.where((page) => page != null).toList(growable: true);
  }

  _onSelectItem(int index) {
    _controller.index = index;
    setState(() {
      _selectedDrawerIndex = index;
      widget.onTap(index);
    });
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    widget.state = this;
    primaryColor = Theme.of(context).primaryColor;
    widget.page = widget.page.where((page) => page != null).toList(growable: true);
    bool displayDrawer = widget.withDrawer && widget.page.length > 3;
    var drawerItems = _buildDrawerItems();
    drawerItems.add(Ink(child: _buildDarkThemeWidget()));
    _buildDrawer() {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: primaryColor),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('images/youth_logo.png', width: 80, height: 80),
                    SizedBox(height: 15),
                    Text("Today's Youth", style: Theme.of(context).textTheme.title)
                  ],
                ),
              ),
            ),
            Column(children: drawerItems),
          ],
        ),
      );
    }

    return DefaultTabController(
      length: widget.page.length,
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: displayDrawer ? _buildDrawer() : null,
        appBar: AppBar(
          title: getTabBar(),
          //elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          actions: displayDrawer
              ? <Widget>[
                  IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      _scaffoldKey.currentState.openEndDrawer();
                    },
                  )
                ]
              : null,
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _controller,
          children: widget.page.map<Widget>((TabPage page) {
            return page.content;
          }).toList(),
        ),
      ),
    );
  }

  _buildDrawerItems() {
    var drawerItems = <Widget>[];
    var listTileColor = CacheData.isDarkTheme ? Colors.blue[700] : Colors.blue[100];
    for (var i = 0; i < widget.page.length; i++) {
      var d = widget.page[i];
      drawerItems.add(
        Ink(
          color: (i == _selectedDrawerIndex) ? listTileColor : null,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: primaryColor,
              child: d.icon,
              foregroundColor: Colors.black,
            ),
            title: Text(d.text),
            selected: i == _selectedDrawerIndex,
            onTap: () => _onSelectItem(i),
          ),
        ),
      );
    }
    return drawerItems;
  }
  _buildDarkThemeWidget() {
    return ListTile(
      leading: CircleAvatar(backgroundColor: primaryColor, child: Icon(Icons.brightness_6), foregroundColor: Colors.black),
      title: Text("Dark Theme"),
      onTap: () async {
        await Config.changeTheme(isDarkTheme: !CacheData.isDarkTheme);
      },
      trailing: StreamBuilder(
        initialData: CacheData.isDarkTheme,
        stream: isDarkThemeStream,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return Switch(
            onChanged: (bool value) async {
              await Config.changeTheme(isDarkTheme: value);
            },
            value: snapshot.data,
          );
        },
      ),
    );
  }

  Widget getTabBar() {
    return TabBar(
      controller: _controller,
      isScrollable: widget.page.length > 3 ? true : false,
      indicator: UnderlineTabIndicator(),
      onTap: widget.onTap,
      tabs: widget.page.map<Tab>((TabPage page) {
        assert(widget.tabsDemoStyle != null);
        switch (widget.tabsDemoStyle) {
          case TabsStyle.iconsAndText:
            return Tab(text: page.text, icon: page.icon);
          case TabsStyle.iconsOnly:
            return Tab(icon: page.icon);
          case TabsStyle.textOnly:
            return Tab(text: page.text);
        }
        return null;
      }).toList(),
    );
  }

  @override
  bool get wantKeepAlive => true;

/*  @override
  Widget build(BuildContext context) {
    widget.state = this;
    return DefaultTabController(
      length: widget.page.length,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: getTabBar(),
                floating: true,
                pinned: true,
                snap: true,
                automaticallyImplyLeading: false,
                titleSpacing: 0,
              ),
            ];
          },
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _controller,
            children: widget.page.map<Widget>((TabPage page) {
              return page.content;
            }).toList(),
          ),
        ),
      ),
    );
  }*/

}
