import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spacelaunchnow_flutter/models/launch/detailed/launch.dart';
import 'package:spacelaunchnow_flutter/util/countdown_helper.dart';
import 'package:spacelaunchnow_flutter/util/utils.dart';

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
  final List<ValueChanged<ElapsedTime>> timerListeners =
      <ValueChanged<ElapsedTime>>[];
  final Stopwatch stopwatch = new Stopwatch();
  final int timerMillisecondsRefreshRate = 1000;
}

class Countdown extends StatefulWidget {
  Countdown(this.launch);

  final Launch launch;
  final Dependencies dependencies = new Dependencies();

  CountdownState createState() =>
      new CountdownState(dependencies: dependencies, launch: launch);
}

class CountdownState extends State<Countdown> {
  CountdownState({this.dependencies, this.launch});

  final Launch launch;
  final Dependencies dependencies;
  Timer timer;
  int milliseconds;
  int minutes = 0;
  int seconds = 0;

  @override
  void initState() {
    timer = new Timer.periodic(
        new Duration(milliseconds: dependencies.timerMillisecondsRefreshRate),
        callback);
    dependencies.timerListeners.add(onTick);
    if (launch.status.id == 1) {
      dependencies.stopwatch.start();
    }
    super.initState();
  }

  @override
  void dispose() {
    dependencies.stopwatch.stop();
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.minutes != minutes || elapsed.seconds != seconds) {
      if (mounted) {
        setState(() {
          minutes = elapsed.minutes;
          seconds = elapsed.seconds;
        });
      }
    }
  }

  void callback(Timer timer) {
    if (milliseconds != dependencies.stopwatch.elapsedMilliseconds) {
      milliseconds = dependencies.stopwatch.elapsedMilliseconds;
      final int hundreds = (milliseconds / 10).truncate();
      final int seconds = (hundreds / 100).truncate();
      final int minutes = (seconds / 60).truncate();
      final ElapsedTime elapsedTime = new ElapsedTime(
        hundreds: hundreds,
        seconds: seconds,
        minutes: minutes,
      );
      for (final listener in dependencies.timerListeners) {
        listener(elapsedTime);
      }
    }
  }


  @override
  build(BuildContext context) {
    var theme = Theme.of(context);
    var textThemeDigits = theme.textTheme.title.copyWith(fontSize: 46.0);
    var textThemeDivider = theme.textTheme.subhead.copyWith(fontSize: 34.0);
    var textThemeDescription = theme.textTheme.caption;
    Duration duration = new Duration(
        seconds: launch.net.difference(new DateTime.now()).inSeconds);
    PrettyDuration prettyDuration = new PrettyDuration(duration);
    String status = Utils.getStatus(launch.status.id);
    Color color;
    var days = prettyDuration.days;
    var hours = prettyDuration.hours;
    var minutes = prettyDuration.minutes;
    var seconds = prettyDuration.seconds;

    if (launch.status.id == 1) {
      color = Colors.green[600];
    } else if (launch.status.id == 2) {
      color = Colors.red[500];
      days = "--";
      hours = "--";
      minutes = "--";
      seconds = "--";

    } else if (launch.status.id == 3) {
      color = Colors.green[800];
      days = "00";
      hours = "00";
      minutes = "00";
      seconds = "00";
    } else if (launch.status.id == 4) {
      color = Colors.red[700];
      days = "--";
      hours = "--";
      minutes = "--";
      seconds = "--";
    } else if (launch.status.id == 5) {
      color = Colors.orange[500];
      days = "--";
      hours = "--";
      minutes = "--";
      seconds = "--";
    } else if (launch.status.id == 6) {
      color = Colors.blue[500];
      days = "00";
      hours = "00";
      minutes = "00";
      seconds = "00";
    } else if (launch.status.id == 7) {
      color = Colors.blueGrey[500];
      days = "00";
      hours = "00";
      minutes = "00";
      seconds = "00";
    }
    return new Container(
      padding:
          new EdgeInsets.only(left: 6.0, right: 6.0, top: 2.0, bottom: 0.0),
      child: new Column(
        children: <Widget>[
          new Stack(
            children: <Widget>[
              // Max Size
              Positioned.fill(
                child: Align(
                    alignment: Alignment.centerRight,
                    child: new Divider(),
                ),
              ),
              Center(
                child: new Chip(
                  label: new Text(
                    status,
                    style: theme.textTheme.title.copyWith(color: Colors.white),
                  ),
                  backgroundColor: color,
                ),
              ),
            ],
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Column(children: <Widget>[
                new Text(days, style: textThemeDigits),
                new Text("DAYS", style: textThemeDescription)
              ]),
              new Text(":", style: textThemeDivider),
              new Column(children: <Widget>[
                new Text(hours, style: textThemeDigits),
                new Text("HOURS", style: textThemeDescription)
              ]),
              new Text(":", style: textThemeDivider),
              new Column(children: <Widget>[
                new Text(minutes, style: textThemeDigits),
                new Text("MINUTES", style: textThemeDescription)
              ]),
              new Text(":", style: textThemeDivider),
              new Column(children: <Widget>[
                new Text(seconds, style: textThemeDigits),
                new Text("SECONDS", style: textThemeDescription)
              ]),
            ],
          ),
          new Divider(),
        ],
      ),
    );
  }
}
