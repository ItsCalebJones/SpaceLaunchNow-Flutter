import 'package:flutter/material.dart';
import 'package:spacelaunchnow_flutter/models/launch.dart';
import 'articles_showcase.dart';
import 'portfolio_showcase.dart';
import 'skills_showcase.dart';

class LaunchShowcase extends StatefulWidget {
  LaunchShowcase(this.launch);

  final Launch launch;

  @override
  _LaunchShowcaseState createState() => new _LaunchShowcaseState(launch);
}

class _LaunchShowcaseState extends State<LaunchShowcase>
    with TickerProviderStateMixin {
  List<Tab> _tabs;
  List<Widget> _pages;
  TabController _controller;

  _LaunchShowcaseState(this.launch);

  final Launch launch;

  @override
  void initState() {
    super.initState();
    _tabs = [
      new Tab(text: 'Details'),
      new Tab(text: 'Mission'),
      new Tab(text: 'Agencies'),
    ];
    _pages = [
      new PortfolioShowcase(launch),
      new SkillsShowcase(),
      new ArticlesShowcase(),
    ];
    _controller = new TabController(
      length: _tabs.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          new TabBar(
            controller: _controller,
            tabs: _tabs,
            indicatorColor: Colors.white,
          ),
          new SizedBox.fromSize(
            size: const Size.fromHeight(300.0),
            child: new TabBarView(
              controller: _controller,
              children: _pages,
            ),
          ),
        ],
      ),
    );
  }
}
