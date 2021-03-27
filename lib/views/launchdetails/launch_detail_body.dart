import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:spacelaunchnow_flutter/models/launch/detailed/launch.dart';
import 'package:spacelaunchnow_flutter/models/news.dart';
import 'package:spacelaunchnow_flutter/util/ads.dart';
import 'package:spacelaunchnow_flutter/util/utils.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/footer/agencies_showcase.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/footer/location_showcase.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/footer/mission_showcase.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:spacelaunchnow_flutter/views/widgets/countdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:spacelaunchnow_flutter/views/widgets/updates.dart';

import 'footer/vehicle_showcase.dart';

class LaunchDetailBodyWidget extends StatefulWidget {
  final Launch launch;
  final AppConfiguration _configuration;
  final List<News> news;

  LaunchDetailBodyWidget(this.launch, this._configuration, this.news);

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
        ),
        new Expanded(
          child: new Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: new Text(
              mLaunch.pad.location.name,
              maxLines: 2,
              style: textTheme.subhead,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusInfo(TextTheme textTheme) {
    var icon = Icons.event;

    if (mLaunch.status.id == 1) {
      icon = Icons.thumb_up;
    } else if (mLaunch.status.id == 2) {
      icon = Icons.thumb_down;
    } else if (mLaunch.status.id == 3) {
      icon = Icons.check;
    } else if (mLaunch.status.id == 4) {
      icon = Icons.close;
    } else if (mLaunch.status.id == 5) {
      icon = Icons.pause;
    } else if (mLaunch.status.id == 6) {
      icon = Icons.flight_takeoff;
    } else if (mLaunch.status.id == 7) {
      icon = Icons.close;
    }

    return new Row(
      children: <Widget>[
        new Icon(icon),
        new Expanded(
          child: new Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: new Text(
              Utils.getStatus(mLaunch.status.id),
              maxLines: 2,
              style: textTheme.subhead,
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
        ),
        new Expanded(
          child: new Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: new Text(
              new DateFormat("h:mm a 'on' EEEE, MMMM d, yyyy")
                  .format(mLaunch.net.toLocal()),
              maxLines: 2,
              style: textTheme.subhead,
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
        if (item.landing != null && item.landing.attempt) {
          landingAttempt = true;
          if (item.landing.location != null) {
            if (landingLocation.length == 9) {
              landingLocation = landingLocation + item.landing.location.abbrev;
              if (item.landing.success == null) {
                landingLocation = landingLocation;
              } else if (item.landing.success) {
                landingLocation = landingLocation + " (Success)";
              } else if (!item.landing.success) {
                landingLocation = landingLocation + " (Failed)";
              }
            } else {
              landingLocation =
                  landingLocation + ", " + item.landing.location.abbrev;
              if (item.landing.success == null) {
                landingLocation = landingLocation;
              } else if (item.landing.success) {
                landingLocation = landingLocation + " (Success)";
              } else if (!item.landing.success) {
                landingLocation = landingLocation + " (Failed)";
              }
            }
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
                ),
                new Expanded(
                  child: new Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: new Text(
                      landingLocation,
                      maxLines: 2,
                      style: textTheme.subhead,
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



  _openUrl(String url) async {
    Uri _url = Uri.tryParse(url);
    if (_url != null && _url.host.contains("youtube.com") && Platform.isIOS) {
      final String _finalUrl = _url.host + _url.path + "?" + _url.query;
      if (await canLaunch('youtube://$_finalUrl')) {
        await launch('youtube://$_finalUrl', forceSafariVC: false);
      }
    } else {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  Widget _buildActionButtons(ThemeData theme) {
    List<Widget> materialButtons = [];

//    if (mLaunch.vidURL != null) {
//      materialButtons.add(new Padding(
//          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, right: 8.0),
//          child: new IconButton(
//            icon: Icon(Icons.live_tv),
//            tooltip: 'Watch',
//            onPressed: () {
//              share(mLaunch.vidURL);
//            }, //
//          )));
//    }
//    if (mLaunch.vidURL != null) {
//      materialButtons.add(new CupertinoButton(
//        onPressed: () {
//          _launchURL(mLaunch.vidURL);
//        },
//        child: new Text('Watch'),
//      ));
//    }

    if (mLaunch.vidURLs != null && mLaunch.vidURLs.length > 0) {
      materialButtons.add(new Row(
        children: <Widget>[
          new Icon(Icons.live_tv),
          new Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: new CupertinoButton(
              onPressed: () {
                _openUrl(mLaunch.vidURLs.first.url);
              },
              child: new Text('Watch'),
            ),
          ),
        ],
      ));
    }

    if (mLaunch.slug != null) {
      materialButtons.add(new Row(
        children: <Widget>[
          new Icon(Icons.share),
          new Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: new CupertinoButton(
              onPressed: () {
                share("https://spacelaunchnow.me/launch/" + mLaunch.slug);
              },
              child: new Text(
                'Share',
              ),
            ),
          ),
        ],
      ));
    }

    return new Padding(
      padding:
          const EdgeInsets.only(top: 0.0, left: 8.0, right: 8.0, bottom: 0.0),
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

  Widget _buildSpace() {
    if (Ads.isBannerShowing()) {
      return new SizedBox(height: 50);
    } else {
      return new SizedBox(height: 0);
    }
  }

  Widget _buildContentCard(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    String status = Utils.getStatus(mLaunch.status.id);

    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
          child: new Text(
            mLaunch.name,
            style: textTheme.headline
                .copyWith(fontWeight: FontWeight.bold, fontSize: 30),
            textAlign: TextAlign.start,
          ),
        ),
        _buildCountDown(textTheme),
        new Padding(
          padding: const EdgeInsets.only(
              top: 4.0, left: 8.0, right: 8.0, bottom: 2.0),
          child: _buildStatusInfo(textTheme),
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
              top: 2.0, left: 8.0, right: 8.0, bottom: 2.0),
          child: _buildLandingInfo(textTheme),
        ),
        _buildActionButtons(theme),
        new MissionShowcase(mLaunch),
        buildUpdates(mLaunch.updates, context, "https://spacelaunchnow.me/launch/" + mLaunch.slug + "#updates"),
        _buildNews(),
        new VehicleShowcase(mLaunch, widget._configuration),
        new AgenciesShowcase(mLaunch),
        new LocationShowcaseWidget(mLaunch),
        _buildSpace(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContentCard(context);
  }

  Widget _buildNews() {
    if (widget.news.isNotEmpty) {
      List<Widget> widgets = new List<Widget>();
      widgets.add(
        new Text(
          "Related News",
          textAlign: TextAlign.left,
          style: Theme.of(context)
              .textTheme
              .headline
              .copyWith(fontWeight: FontWeight.bold, fontSize: 26),
        ),
      );
      List<News> _news = [];
      if (widget.news.length >= 6) {
        _news = widget.news.sublist(0, 5);
      } else {
        _news = widget.news;
      }
      for (News news in _news) {
        widgets.add(
            Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                    child: new ListTile(
                      onTap: () => _openUrl(news.url),
                      leading: new CircleAvatar(
                        backgroundImage:
                        new CachedNetworkImageProvider(news.featureImage),
                      ),
                      title: new Text(news.title,
                          style: Theme.of(context)
                              .textTheme
                              .subhead
                              .copyWith(fontSize: 15.0)),
                      subtitle: new Text(news.newsSiteLong),
                    )
                )
            )
        );
      }
      if (widget.news.length >= 6) {
        widgets.add(
          Center(
            child: new CupertinoButton(
              color: Theme.of(context).accentColor,
                child: Text("Read More"),
                onPressed: () {
                  _openUrl("https://spacelaunchnow.me/launch/" + mLaunch.slug+ "#related-news");
                }),
          ),
        );
      }
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: widgets,
        ),
      );
    } else {
      return new SizedBox(height: 0);
    }
  }
}
