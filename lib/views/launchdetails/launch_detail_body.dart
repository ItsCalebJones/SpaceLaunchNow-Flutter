import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:spacelaunchnow_flutter/models/launch.dart';
import 'package:spacelaunchnow_flutter/views/widgets/countdown.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchDetailBody extends StatelessWidget {
  LaunchDetailBody(this.mLaunch,
      this.animationController,
      this.startValue,);

  final Launch mLaunch;
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
              mLaunch.location.name,
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

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildActionButtons(ThemeData theme) {
    List<Widget> materialButtons = [];
    materialButtons.add(
      new MaterialButton(
        elevation: 2.0,
        minWidth: 160.0,
        color: Colors.redAccent,
        textColor: Colors.white,
        onPressed: () {
          _launchURL(mLaunch.vidURL);
        },
        child: new Text('Watch'),
      )
    );

    if (mLaunch.vidURL != null){
      String launchId = mLaunch.id.toString();
      materialButtons.add(
          new MaterialButton(
            elevation: 2.0,
            minWidth: 160.0,
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () {
              share("https://spacelaunchnow.me/launch/$launchId");
            },
            child: new Text('Share'),
          )
      );
    }
    return new Padding(
      padding: const EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          bottom: 16.0
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: materialButtons,
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
          child: new Text(mLaunch.net.toLocal().toString())
      );
    }
  }

  Widget _buildContentCard(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var missionDescription = "Unknown";

    missionDescription = mLaunch.mission.description;

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
          padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
          child: new Text(
            mLaunch.name,
            style: textTheme.headline.copyWith(color: Colors.white),
          ),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0),
          child: _buildLocationInfo(textTheme),
        ),
        new Padding(
          padding: const EdgeInsets.only(
              top: 8.0, left: 8.0, right: 8.0, bottom: 16.0),
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
