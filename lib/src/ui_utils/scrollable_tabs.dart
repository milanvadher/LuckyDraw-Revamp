// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

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

  ScrollableTabs({Key key, this.page, this.tabsDemoStyle = TabsStyle.textOnly, this.title, this.actions}) : super(key: key);

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

class ScrollableTabsState extends State<ScrollableTabs> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _controller;
  ScrollableTabsState();

  @override
  void initState() {
    super.initState();
    widget.page = widget.page.where((page) => page != null).toList(growable: true);
    _controller = TabController(vsync: this, length: widget.page.length);
  }

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

  @override
  Widget build(BuildContext context) {
    widget.state = this;
    widget.page = widget.page.where((page) => page != null).toList(growable: true);
    return DefaultTabController(
      length: widget.page.length,
      child: Scaffold(
        appBar: AppBar(
          title: getTabBar(),
          //elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _controller,
          children: widget.page.map<Widget>((TabPage page) {
            return page.content;
          }).toList(),
        ),
      ),);
  }
/*  @override
  Widget build(BuildContext context) {
    widget.state = this;
    return DefaultTabController(
      length: widget.page.length,
      child: Scaffold(
        body: new NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
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

  Widget getTabBar() {
    return TabBar(
      controller: _controller,
      isScrollable: widget.page.length > 2 ? true : false,
      indicator: UnderlineTabIndicator(),
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
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
