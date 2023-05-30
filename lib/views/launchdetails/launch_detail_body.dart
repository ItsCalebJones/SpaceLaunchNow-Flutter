import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spacelaunchnow_flutter/models/launch/detailed/launch.dart';
import 'package:spacelaunchnow_flutter/models/news.dart';
import 'package:spacelaunchnow_flutter/util/date_formatter.dart';
import 'package:spacelaunchnow_flutter/util/url_helper.dart';
import 'package:spacelaunchnow_flutter/util/utils.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/footer/agencies_showcase.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/footer/location_showcase.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/footer/mission_showcase.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:spacelaunchnow_flutter/views/widgets/ads/ad_widget.dart';
import 'package:spacelaunchnow_flutter/views/widgets/countdown.dart';
import 'package:spacelaunchnow_flutter/views/widgets/updates.dart';

import 'footer/vehicle_showcase.dart';

class LaunchDetailBodyWidget extends StatefulWidget {
  final Launch? launch;
  final AppConfiguration _configuration;
  final List<News> news;

  const LaunchDetailBodyWidget(this.launch, this._configuration, this.news, {Key? key}) : super(key: key);

  @override
  State createState() => LaunchDetailBodyState(launch);
}

class LaunchDetailBodyState extends State<LaunchDetailBodyWidget> {
  LaunchDetailBodyState(
    this.mLaunch,
  );

  final Launch? mLaunch;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildLocationInfo(TextTheme textTheme) {
    return Row(
      children: <Widget>[
        const Icon(
          Icons.place,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              mLaunch!.pad!.location!.name!,
              maxLines: 2,
              style: textTheme.subtitle1,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusInfo(TextTheme textTheme) {
    var icon = Icons.event;

    if (mLaunch!.status!.id == 1) {
      icon = Icons.thumb_up;
    } else if (mLaunch!.status!.id == 2) {
      icon = Icons.thumb_down;
    } else if (mLaunch!.status!.id == 3) {
      icon = Icons.check;
    } else if (mLaunch!.status!.id == 4) {
      icon = Icons.close;
    } else if (mLaunch!.status!.id == 5) {
      icon = Icons.pause;
    } else if (mLaunch!.status!.id == 6) {
      icon = Icons.flight_takeoff;
    } else if (mLaunch!.status!.id == 7) {
      icon = Icons.close;
    }

    return Row(
      children: <Widget>[
        Icon(icon),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              Utils.getStatus(mLaunch!.status!.id),
              maxLines: 2,
              style: textTheme.subtitle1,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeInfo(TextTheme textTheme) {
    return Row(
      children: <Widget>[
        const Icon(
          Icons.timer,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              PrecisionFormattedDate.getPrecisionFormattedDate(
                widget.launch?.netPrecision?.id ?? 0,
                widget.launch!.net!),
              maxLines: 2,
              style: textTheme.subtitle1,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLandingInfo(TextTheme textTheme) {
    if (mLaunch!.rocket!.firstStages!.isNotEmpty) {
      bool landingAttempt = false;
      String landingLocation = "Landing: ";
      for (var i = 0; i < mLaunch!.rocket!.firstStages!.length; i++) {
        final item = mLaunch!.rocket!.firstStages!.elementAt(i);
        if (item.landing != null && item.landing!.attempt!) {
          landingAttempt = true;
          if (item.landing!.location != null) {
            if (landingLocation.length == 9) {
              landingLocation =
                  landingLocation + item.landing!.location!.abbrev!;
              if (item.landing!.success == null) {
                landingLocation = landingLocation;
              } else if (item.landing!.success!) {
                landingLocation = "$landingLocation (Success)";
              } else if (!item.landing!.success!) {
                landingLocation = "$landingLocation (Failed)";
              }
            } else {
              landingLocation =
                  "$landingLocation, ${item.landing!.location!.abbrev!}";
              if (item.landing!.success == null) {
                landingLocation = landingLocation;
              } else if (item.landing!.success!) {
                landingLocation = "$landingLocation (Success)";
              } else if (!item.landing!.success!) {
                landingLocation = "$landingLocation (Failed)";
              }
            }
          }
        }
      }
      if (landingAttempt) {
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                const Icon(
                  Icons.flight_land,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      landingLocation,
                      maxLines: 2,
                      style: textTheme.subtitle1,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      }
    }
    return Row();
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

    if (mLaunch!.vidURLs != null && mLaunch!.vidURLs!.isNotEmpty) {
      materialButtons.add(Row(
        children: <Widget>[
          const Icon(Icons.live_tv),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CupertinoButton(
              onPressed: () {
                openUrl(mLaunch!.vidURLs!.first.url!);
              },
              child: const Text('Watch'),
            ),
          ),
        ],
      ));
    }

    if (mLaunch!.slug != null) {
      materialButtons.add(Row(
        children: <Widget>[
          const Icon(Icons.share),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CupertinoButton(
              onPressed: () {
                Share.share(
                    "https://spacelaunchnow.me/launch/${mLaunch!.slug!}");
              },
              child: const Text(
                'Share',
              ),
            ),
          ),
        ],
      ));
    }

    return Padding(
      padding:
          const EdgeInsets.only(top: 0.0, left: 8.0, right: 8.0, bottom: 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: materialButtons,
      ),
    );
  }

  Widget _buildCountDown(TextTheme textTheme) {
    DateTime net = mLaunch!.net!;
    DateTime current = DateTime.now();
    var diff = net.difference(current);
    if (diff.inSeconds > 0) {
      return Countdown(mLaunch);
    } else {
      return const SizedBox(width: 0.0, height: 0.0);
    }
  }

  Widget _buildSpace() {
    return const SizedBox(height: 50);
  }

  Widget _buildContentCard(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
          child: Text(
            mLaunch!.name!,
            style: textTheme.headline5!
                .copyWith(fontWeight: FontWeight.bold, fontSize: 28),
            textAlign: TextAlign.start,
          ),
        ),
        _buildCountDown(textTheme),
        Padding(
          padding: const EdgeInsets.only(
              top: 4.0, left: 8.0, right: 8.0, bottom: 2.0),
          child: _buildStatusInfo(textTheme),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 4.0, left: 8.0, right: 8.0, bottom: 2.0),
          child: _buildLocationInfo(textTheme),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 2.0, left: 8.0, right: 8.0, bottom: 2.0),
          child: _buildTimeInfo(textTheme),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 2.0, left: 8.0, right: 8.0, bottom: 2.0),
          child: _buildLandingInfo(textTheme),
        ),
        _buildActionButtons(theme),
        const Center(child: ListAdWidget(AdSize.banner)),
        MissionShowcase(mLaunch),
        buildUpdates(mLaunch!.updates!, context,
            "https://spacelaunchnow.me/launch/${mLaunch!.slug!}#updates"),
        _buildNews(),
        VehicleShowcase(mLaunch, widget._configuration),
        const Center(child: ListAdWidget(AdSize.mediumRectangle)),
        AgenciesShowcase(mLaunch),
        LocationShowcaseWidget(mLaunch),
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
      List<Widget> widgets = <Widget>[];
      widgets.add(
        Text(
          "Related News",
          textAlign: TextAlign.left,
          style: Theme.of(context)
              .textTheme
              .headline4!
              .copyWith(fontWeight: FontWeight.bold, fontSize: 26),
        ),
      );
      List<News> news = [];
      if (widget.news.length >= 6) {
        news = widget.news.sublist(0, 5);
      } else {
        news = widget.news;
      }
      for (News news in news) {
        widgets.add(Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListTile(
              onTap: () => openUrl(news.url!),
              leading: CircleAvatar(
            backgroundImage:
                CachedNetworkImageProvider(news.featureImage!),
              ),
              title: Text(news.title!,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontSize: 15.0)),
              subtitle: Text(news.newsSiteLong!),
            )));
      }
      if (widget.news.length >= 6) {
        widgets.add(
          Center(
            child: CupertinoButton(
                color: Theme.of(context).colorScheme.secondary,
                child: const Text("Read More"),
                onPressed: () {
                  openUrl("https://spacelaunchnow.me/launch/${mLaunch!.slug!}#related-news");
                }),
          ),
        );
      }
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: widgets,
        ),
      );
    } else {
      return const SizedBox(height: 0);
    }
  }
}
