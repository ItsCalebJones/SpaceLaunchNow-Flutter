import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:spacelaunchnow_flutter/models/launch.dart';
import 'package:spacelaunchnow_flutter/util/utils.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/footer/agencies_showcase.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/footer/location_showcase.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/footer/mission_showcase.dart';
import 'package:spacelaunchnow_flutter/views/widgets/countdown.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchDetailBodyWidget extends StatefulWidget {
  final Launch launch;

  LaunchDetailBodyWidget(this.launch);

  @override
  State createState() => new LaunchDetailBodyState(this.launch);
}

class LaunchDetailBodyState extends State<LaunchDetailBodyWidget> {
  LaunchDetailBodyState(
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
              new DateFormat.yMMMMEEEEd().add_Hms().format(mLaunch.net),
              maxLines: 2,
              style: textTheme.subhead.copyWith(color: Colors.white70),
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLandingInfo(TextTheme textTheme) {
    if (mLaunch.rocket.firstStages.length > 0) {
      bool landingAttempt = false;
      String landingLocation = "Landing: ";
      String landingSuccess = "";
      for (var i = 0; i < mLaunch.rocket.firstStages.length; i++) {
        final item = mLaunch.rocket.firstStages.elementAt(i);
        if (item.landing.attempt){
          landingAttempt = true;
        }
        if (landingLocation.length == 9) {
          landingLocation = landingLocation + item.landing.location.abbrev;
          if (item.landing.success == null){
            landingLocation = landingLocation;
          } else if (item.landing.success){
            landingLocation = landingLocation + " (Success)";
          } else if (!item.landing.success) {
            landingLocation = landingLocation + " (Failed)";
          }
        } else {
          landingLocation = landingLocation + ", " + item.landing.location.abbrev;
          if (item.landing.success == null){
            landingLocation = landingLocation;
          } else if (item.landing.success){
            landingLocation = landingLocation + " (Success)";
          } else if (!item.landing.success) {
            landingLocation = landingLocation + " (Failed)";
          }
        }
      }
      if (landingAttempt) {
        return new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Icon(
                  Icons.flight_land,
                  color: Colors.white,
                ),
                new Expanded(
                  child: new Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: new Text(
                      landingLocation,
                      maxLines: 2,
                      style: textTheme.subhead.copyWith(color: Colors.white70),
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      }
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

    String launchId = mLaunch.id;
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

    String status = Utils.getStatus(mLaunch.status.id);

    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 4.0, right: 4.0),
          child: new Chip(
            label: new Text(
              status,
              style: textTheme.title.copyWith(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        ),
        _buildCountDown(textTheme),
        _buildActionButtons(theme),
        new Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0),
          child: new Text(
            mLaunch.name,
            style: textTheme.headline.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        _buildAdWidget(),
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
              top: 2.0, left: 8.0, right: 8.0, bottom: 2.0),
          child: _buildLandingInfo(textTheme),
        ),
        new MissionShowcase(mLaunch),
        new Divider(
          color: Colors.white,
        ),
        new AgenciesShowcase(mLaunch),
        new Divider(
          color: Colors.white,
        ),
        new LocationShowcaseWidget(mLaunch),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContentCard(context);
  }

  Widget _buildAdWidget() {
    return Container(
      margin: EdgeInsets.all(4.0),
      child: new AdmobBanner(
          adUnitId: Utils.getBannerAdUnitId(),
          adSize: AdmobBannerSize.LEADERBOARD,
          listener: (AdmobAdEvent event, Map<String, dynamic> args) {
            switch (event) {
              case AdmobAdEvent.loaded:
                print('Admob banner loaded!');
                break;

              case AdmobAdEvent.opened:
                print('Admob banner opened!');
                break;

              case AdmobAdEvent.closed:
                print('Admob banner closed!');
                break;

              case AdmobAdEvent.failedToLoad:
                print(
                    'Admob banner failed to load. Error code: ${args['errorCode']} Message: ${args['error']}');
                break;
              case AdmobAdEvent.clicked:
                print('Admob banner clicked!');
                break;
              case AdmobAdEvent.impression:
                print('Admob banner impression!');
                break;
              case AdmobAdEvent.leftApplication:
                print('Admob banner left!');
                break;
              case AdmobAdEvent.completed:
                print('Admob banner completed!');
                break;
              case AdmobAdEvent.rewarded:
              // TODO: Handle this case.
                break;
              case AdmobAdEvent.started:
                print('Admob banner started!');
                break;
            }
          }
      ),
    );
  }
}
