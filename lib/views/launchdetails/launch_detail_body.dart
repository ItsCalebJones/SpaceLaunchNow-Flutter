import 'package:flutter/material.dart';
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
        left: 16.0,
        right: 16.0,
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _createPillButton(
            'Watch Live',
            backgroundColor: Colors.redAccent,
          ),
          new DecoratedBox(
            decoration: new BoxDecoration(
              border: new Border.all(color: Colors.white30),
              borderRadius: new BorderRadius.circular(30.0),
            ),
            child: _createPillButton(
              'Share',
              textColor: Colors.white70,
            ),
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
          _buildCountDown(textTheme),
          _buildActionButtons(theme),
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
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: new Text(missionDescription,
              style:
              textTheme.body1.copyWith(fontSize: 16.0, color: Colors.white70),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: new Row(
              children: <Widget>[
                _createCircleBadge(Icons.beach_access, theme.accentColor),
                _createCircleBadge(Icons.cloud, Colors.white12),
                _createCircleBadge(Icons.shop, Colors.white12),
              ],
            ),
          ),
        ],
    );
  }

  Widget _createPillButton(String text, {
    Color backgroundColor = Colors.transparent,
    Color textColor = Colors.white70,
  }) {
    return new ClipRRect(
      borderRadius: new BorderRadius.circular(30.0),
      child: new MaterialButton(
        minWidth: 140.0,
        color: backgroundColor,
        textColor: textColor,
        onPressed: () {},
        child: new Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContentCard(context);
  }
}
