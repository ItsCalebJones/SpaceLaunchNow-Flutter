import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:spacelaunchnow_flutter/models/launch.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/footer/launch_detail_footer.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/header/launch_detail_header.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/launch_detail_body.dart';

class LaunchDetailPage extends StatefulWidget {

  LaunchDetailPage({this.launch, this.launchId, this.avatarTag});

  final Launch launch;
  final int launchId;
  final Object avatarTag;

  @override
  _LaunchDetailsPageState createState() => new _LaunchDetailsPageState();
}

class _LaunchDetailsPageState extends State<LaunchDetailPage>
    with TickerProviderStateMixin {
  AnimationController _controller;
  List<Launch> _launches = [];
  Launch launch;
  bool backEnabled;

  @override
  void initState() {
    super.initState();
    if (widget.launch != null) {
      launch = widget.launch;
      var until = launch.net.difference(new DateTime.now());
      _controller = new AnimationController(
        vsync: this,
        duration: new Duration(seconds: until.inSeconds),
      );
      _controller.forward();
      backEnabled = true;
    } else if (widget.launchId != null && widget.launchId != 0) {
      _loadLaunch(widget.launchId);
      backEnabled = true;
    } else {
      _loadNextLaunch();
      backEnabled = false;
    }
  }

  Future<void> _loadLaunch(int id) async {
    http.Response response =
        await http.get('https://launchlibrary.net/1.4/launch/' + id.toString());

    setState(() {
      _launches = Launch.allFromResponse(response.body);
      launch = _launches.first;
      var until = launch.net.difference(new DateTime.now());
      _controller = new AnimationController(
        vsync: this,
        duration: new Duration(seconds: until.inSeconds),
      );
      _controller.forward();
    });
  }

  Future<void> _loadNextLaunch() async {
  List<Launch> _nextLaunches;
    http.Response response =
        await http.get('https://launchlibrary.net/1.4/launch/next/1');

    _nextLaunches = Launch.allFromResponse(response.body);
    _loadLaunch(_nextLaunches.first.id);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.bottomLeft,
        colors: <Color>[
          const Color(0xFF2196F3),
          const Color(0xFFF44336),
        ],
      ),
    );

    if (launch == null) {
      content = new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      content = new Scaffold(
        body: new SingleChildScrollView(
          child: new Container(
            decoration: linearGradient,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new LaunchDetailHeader(
                  launch,
                  _controller,
                  launch.net.difference(new DateTime.now()).inSeconds,
                  avatarTag: widget.avatarTag,
                  backEnabled: backEnabled,
                ),
                new Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: new LaunchDetailBody(launch),
                ),
                new LaunchShowcase(launch),
              ],
            ),
          ),
        ),
      );
    }
    return content;
  }
}
