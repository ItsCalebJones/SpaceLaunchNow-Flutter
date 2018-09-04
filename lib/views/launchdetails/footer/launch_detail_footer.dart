import 'package:flutter/material.dart';
import 'package:spacelaunchnow_flutter/models/launch.dart';
import 'agencies_showcase.dart';
import 'location_showcase.dart';
import 'mission_showcase.dart';

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
      new Tab(text: 'Mission'),
      new Tab(text: 'Location'),
      new Tab(text: 'Agencies'),
    ];
    _pages = [
      new MissionShowcase(launch),
      new LocationShowcaseWidget(launch),
      new AgenciesShowcase(launch),
    ];
    _controller = new TabController(
      length: _tabs.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: new Column(
        children: <Widget>[
          new TabBar(
            controller: _controller,
            tabs: _tabs,
            indicatorColor: Colors.redAccent,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
          ),
          new SizedBox.fromSize(
            size: const Size.fromHeight(400.0),
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
