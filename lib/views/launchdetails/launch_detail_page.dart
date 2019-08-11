import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:spacelaunchnow_flutter/models/launch.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/header/launch_detail_header.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/launch_detail_body.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';


class ElapsedTime {
  final int hundreds;
  final int seconds;
  final int minutes;

  ElapsedTime({
    this.hundreds,
    this.seconds,
    this.minutes,
  });
}

class Dependencies {

  final List<ValueChanged<ElapsedTime>> timerListeners = <ValueChanged<ElapsedTime>>[];
  final Stopwatch stopwatch = new Stopwatch();
  final int timerMillisecondsRefreshRate = 30;
}

class LaunchDetailPage extends StatefulWidget {
  LaunchDetailPage(this._configuration,
      {this.launch, this.launchId, this.avatarTag});

  final AppConfiguration _configuration;
  final Launch launch;
  final String launchId;
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
  Timer timer;
  final int timerMillisecondsRefreshRate = 100;
  final Stopwatch stopwatch = new Stopwatch();

  @override
  void initState() {
    super.initState();
    if (widget.launch != null) {
      launch = widget.launch;
      setController();
      backEnabled = true;
    } else if (widget.launchId != null && widget.launchId != 0) {
      _loadLaunch(widget.launchId);
      backEnabled = true;
    } else {
      Launch mLaunch =
          PageStorage.of(context).readState(context, identifier: 'next_launch');
      if (mLaunch != null) {
        launch = mLaunch;
        setController();
      } else {
        _loadNextLaunch();
      }
      backEnabled = false;
    }
    timer = new Timer.periodic(new Duration(milliseconds: timerMillisecondsRefreshRate), callback);
  }

  void callback(Timer timer) {}

  Future<void> _loadLaunch(String id) async {
    setState(() {
      _launches = null;
      launch = null;
    });
    http.Response response =
        await http.get('https://spacelaunchnow.me/api/3.4.0/launch/' + id.toString() + '/?mode=detailed');

    setState(() {
      launch = Launch.fromResponse(response.body);
      setController();
    });
  }

  Future<void> _loadNextLaunch() async {
    List<Launch> _nextLaunches;
    http.Response response =
        await http.get('https://spacelaunchnow.me/api/3.4.0/launch/upcoming/?limit=1&mode=detailed');

    _nextLaunches = Launch.allFromResponse(response.body);
    PageStorage
        .of(context)
        .writeState(context, _nextLaunches.first, identifier: 'next_launch');
    setState(() {
      _launches = _nextLaunches;
      launch = _nextLaunches.first;
      setController();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    List<Color> colors = [];
    if (!widget._configuration.nightMode) {
      colors.addAll([Colors.blue[700], Colors.blueGrey[400]]);
    } else {
      colors.addAll([Colors.grey[800], Colors.blueGrey[700]]);
    }
    var linearGradient = new BoxDecoration(
      gradient: new LinearGradient(
        begin: FractionalOffset.topCenter,
        end: FractionalOffset.bottomCenter,
        colors: colors,
      ),
    );

    if (launch == null) {
      content = new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      content = new Scaffold(body: new LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return new SingleChildScrollView(
          child: new ConstrainedBox(
            constraints: new BoxConstraints(minHeight: constraints.maxHeight),
            child: new Container(
              decoration: linearGradient,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new LaunchDetailHeader(
                    launch,
                    loadLaunch: _loadLaunch,
                    avatarTag: widget.avatarTag,
                    backEnabled: backEnabled,
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: new LaunchDetailBodyWidget(
                      launch,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }));
    }
    return content;
  }

  void setController() {
    var until = launch.net.difference(new DateTime.now());
    if (until.inSeconds > 0) {
      _controller = new AnimationController(
        vsync: this,
        duration: new Duration(seconds: until.inSeconds),
      );
      _controller.forward();
    }
  }
}
