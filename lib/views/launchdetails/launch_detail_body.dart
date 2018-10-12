import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:spacelaunchnow_flutter/models/launch.dart';
import 'package:spacelaunchnow_flutter/views/widgets/countdown.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchDetailBody extends StatelessWidget {
  LaunchDetailBody(
    this.mLaunch,
  );

  final Launch mLaunch;

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
              mLaunch.pad.location.name,
              maxLines: 2,
              style: textTheme.subhead.copyWith(color: Colors.white70),
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeInfo(TextTheme textTheme) {
    return new Row(
      children: <Widget>[
        new Icon(
          Icons.timer,
          color: Colors.white,
        ),
        new Expanded(
          child: new Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: new Text(
              new DateFormat.yMMMMEEEEd().format(mLaunch.net),
              maxLines: 2,
              style: textTheme.subhead.copyWith(color: Colors.white70),
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherInfo(TextTheme textTheme) {
    if (mLaunch.probability != -1) {
      String probability =
          "Probability: " + mLaunch.probability.toString() + "%";
      return new Row(
        children: <Widget>[
          new Icon(
            Icons.cloud,
            color: Colors.white,
          ),
          new Expanded(
            child: new Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: new Text(
                probability,
                maxLines: 2,
                style: textTheme.subhead.copyWith(color: Colors.white70),
                overflow: TextOverflow.fade,
              ),
            ),
          ),
        ],
      );
    } else {
      return Row();
    }
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
    if (mLaunch.vidURL != null) {
      materialButtons.add(new MaterialButton(
        elevation: 2.0,
        minWidth: 130.0,
        color: Colors.redAccent,
        textColor: Colors.white,
        onPressed: () {
          _launchURL(mLaunch.vidURL);
        },
        child: new Text('Watch'),
      ));
    }

    String launchId = mLaunch.id.toString();
    materialButtons.add(new MaterialButton(
      elevation: 2.0,
      minWidth: 130.0,
      color: Colors.blue,
      textColor: Colors.white,
      onPressed: () {
        share("https://spacelaunchnow.me/launch/$launchId");
      },
      child: new Text('Share'),
    ));

    return new Padding(
      padding:
          const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0, bottom: 16.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: materialButtons,
      ),
    );
  }

  Widget _buildCountDown(TextTheme textTheme) {
    DateTime net = mLaunch.net;
    DateTime current = new DateTime.now();
    var diff = net.difference(current);
    if (diff.inSeconds > 0) {
      return new Countdown(mLaunch);
    } else {
      return new Container(width: 0.0, height: 0.0);
    }
  }

  Widget _buildContentCard(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    String status = mLaunch.status.name;

    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _buildCountDown(textTheme),
        _buildActionButtons(theme),
        new Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 2.0, right: 0.0),
          child: new Text(
            mLaunch.name,
            style: textTheme.headline.copyWith(color: Colors.white),
          ),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 2.0, right: 0.0),
          child: new Text(
            status,
            style: textTheme.title.copyWith(color: Colors.white70),
          ),
        ),
        new Padding(
          padding: const EdgeInsets.only(
              top: 4.0, left: 8.0, right: 8.0, bottom: 2.0),
          child: _buildLocationInfo(textTheme),
        ),
        new Padding(
          padding: const EdgeInsets.only(
              top: 2.0, left: 8.0, right: 8.0, bottom: 2.0),
          child: _buildTimeInfo(textTheme),
        ),
        new Padding(
          padding: const EdgeInsets.only(
              top: 2.0, left: 8.0, right: 8.0, bottom: 4.0),
          child: _buildWeatherInfo(textTheme),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContentCard(context);
  }
}
