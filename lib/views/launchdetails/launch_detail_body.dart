import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:spacelaunchnow_flutter/models/launch.dart';
import 'package:spacelaunchnow_flutter/views/widgets/countdown.dart';

class LaunchDetailBody extends StatelessWidget {
  LaunchDetailBody(this.launch,
      this.animationController,
      this.startValue);

  final Launch launch;
  final AnimationController animationController;
  final int startValue;

  Widget _buildLocationInfo(TextTheme textTheme) {
    return new Row(
      children: <Widget>[
        new Icon(
          Icons.place,
          color: Colors.white,
        ),
        new Expanded(
          child: new Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: new Text(
              launch.location.name,
              maxLines: 2,
              style: textTheme.subhead.copyWith(color: Colors.white70),
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      ],
    );
  }

  Widget _createCircleBadge(IconData iconData, Color color) {
    return new Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: new CircleAvatar(
        backgroundColor: color,
        child: new Icon(
          iconData,
          color: Colors.white,
          size: 16.0,
        ),
        radius: 16.0,
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return new Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: 16.0
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new MaterialButton(
            elevation: 2.0,
            minWidth: 160.0,
            color: Colors.redAccent,
            textColor: Colors.white,
            onPressed: () {

            },
            child: new Text('Watch Live'),
          ),
          new MaterialButton(
            elevation: 2.0,
            minWidth: 160.0,
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () {
              share('check out my website https://example.com');
            },
            child: new Text('Share'),
          ),
        ],
      ),
    );
  }

  Widget _buildCountDown(TextTheme textTheme) {
    if (startValue > 0) {
       return new Countdown(
          animation: new StepTween(
            begin: startValue,
            end: 0,
          ).animate(animationController),
        );
    } else {
      return new Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: new Text(launch.net.toLocal().toString())
      );
    }
  }

  Widget _buildContentCard(BuildContext context){
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var missionDescription = "Unknown";

    if (launch.missions.length > 0){
      missionDescription = launch.missions.first.description;
    }

    return new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Divider(
            indent: 8.0,
            color: Colors.white,
          ),
          _buildCountDown(textTheme),
          new Divider(
            indent: 8.0,
            color: Colors.white,
          ),
          new Padding(
            padding: const EdgeInsets.only(top:8.0, left: 8.0, right: 8.0),
            child: new Text(
              launch.name,
              style: textTheme.headline.copyWith(color: Colors.white),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0),
            child: _buildLocationInfo(textTheme),
          ),
          new Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 16.0),
            child: new Text(missionDescription,
              style:
              textTheme.body1.copyWith(fontSize: 16.0, color: Colors.white70),
            ),
          ),
          _buildActionButtons(theme),
        ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContentCard(context);
  }
}
