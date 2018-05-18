import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spacelaunchnow_flutter/util/countdown_helper.dart';

class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    var theme = Theme.of(context);
    var textThemeDigits = theme.textTheme.title.copyWith(color: Colors.white, fontSize: 48.0);
    var textThemeDivider = theme.textTheme.subhead.copyWith(color: Colors.white, fontSize: 36.0);
    var textThemeDescription = theme.textTheme.caption.copyWith(color: Colors.white70);
    Duration duration = new Duration(seconds: animation.value);
    PrettyDuration prettyDuration = new PrettyDuration(duration);
    return new Container(
      padding: new EdgeInsets.only(left: 12.0, right: 12.0, top: 8.0, bottom: 8.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Column(
            children: <Widget>[ new Text(prettyDuration.days, style: textThemeDigits),
            new Text("DAYS", style: textThemeDescription)]
          ),
          new Text(":", style: textThemeDivider),
          new Column(
              children: <Widget>[ new Text(prettyDuration.hours, style: textThemeDigits),
              new Text("HOURS", style: textThemeDescription)]
          ),
          new Text(":", style: textThemeDivider),
          new Column(
              children: <Widget>[ new Text(prettyDuration.minutes, style: textThemeDigits),
              new Text("MINUTES",style: textThemeDescription)]
          ),
          new Text(":", style: textThemeDivider),
          new Column(
              children: <Widget>[ new Text(prettyDuration.seconds, style: textThemeDigits),
              new Text("SECONDS", style: textThemeDescription)]
          ),
        ],
      ),
    );
  }
}
