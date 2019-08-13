import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:spacelaunchnow_flutter/models/launch.dart';
import 'package:spacelaunchnow_flutter/models/rocket/first_stage.dart';
import 'package:spacelaunchnow_flutter/util/ads.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:url_launcher/url_launcher.dart';

import '../launch_detail_page.dart';

class VehicleShowcase extends StatefulWidget {
  final Launch _launch;
  final AppConfiguration _configuration;

  VehicleShowcase(this._launch, this._configuration);

  @override
  State createState() => new VehicleShowcaseState(this._launch);
}

class VehicleShowcaseState extends State<VehicleShowcase> {
  VehicleShowcaseState(this._launch);

  final Launch _launch;

  @override
  void initState() {}

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildAvatar(ThemeData theme) {
    if (_launch.rocket.configuration.image != null) {
      return Row(
        children: <Widget>[
          new Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 4.0, top: 8.0, bottom: 4.0),
              child: new Container(
                width: 125.0,
                height: 125.0,
                padding: const EdgeInsets.all(2.0),
                // borde width
                decoration: new BoxDecoration(
                  color: Theme.of(context).highlightColor, // border color
                  shape: BoxShape.circle,
                ),
                child: new CircleAvatar(
                  foregroundColor: Colors.white,
                  backgroundImage:
                      new NetworkImage(_launch.rocket.configuration.image),
                  radius: 50.0,
                  backgroundColor: Colors.white,
                ),
              )),
          Flexible(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: new Text(
                    _launch.rocket.configuration.fullName ?? "",
                    style: theme.textTheme.title,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: new Text(
                    _launch.rocket.configuration.manufacturer.name ?? "",
                    style: theme.textTheme.subhead,
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                    softWrap: true,
                  ),
                ),
              ],
            ),
          )
        ],
      );
    } else
      return new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: new Text(
                _launch.rocket.configuration.fullName ?? "",
                style: theme.textTheme.title,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                _launch.rocket.configuration.manufacturer.name ?? "",
                style: theme.textTheme.subhead,
                textAlign: TextAlign.center,
              ),
            ),
          ]);
  }

  Widget _buildStats(ThemeData theme) {
    var vehicle = _launch.rocket.configuration.fullName ?? "Vehicle";
    var leo = "";
    if (_launch.rocket.configuration.leoCapacity != null) {
      leo = _launch.rocket.configuration.leoCapacity.toString() + "kg";
    } else {
      leo = "N/A";
    }

    var gto = "";
    if (_launch.rocket.configuration.geoCapacity != null) {
      gto = _launch.rocket.configuration.geoCapacity.toString() + "kg";
    } else {
      gto = "N/A";
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            "$vehicle Stats",
            style:
                theme.textTheme.headline.copyWith(fontWeight: FontWeight.bold),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Text(
                        "Successful:",
                        style: theme.textTheme.subhead
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new Text(
                          _launch.rocket.configuration.successfulLaunches
                                  .toString() ??
                              "",
                          maxLines: 1,
                          style: theme.textTheme.subhead,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      new Text(
                        "Failed:",
                        style: theme.textTheme.subhead
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new Text(
                          _launch.rocket.configuration.failedLaunches
                                  .toString() ??
                              "",
                          maxLines: 1,
                          style: theme.textTheme.subhead,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      new Text(
                        "Min Stage:",
                        style: theme.textTheme.subhead
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new Text(
                          _launch.rocket.configuration.minStage.toString() ??
                              "",
                          maxLines: 1,
                          style: theme.textTheme.subhead,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      new Text(
                        "Length:",
                        style: theme.textTheme.subhead
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new Text(
                          _launch.rocket.configuration.length.toString() +
                                  "m" ??
                              "" + "m",
                          maxLines: 1,
                          style: theme.textTheme.subhead,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      new Text(
                        "Mass:",
                        style: theme.textTheme.subhead
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new Text(
                          _launch.rocket.configuration.launchMass.toString() +
                                  "T" ??
                              "",
                          maxLines: 1,
                          style: theme.textTheme.subhead,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      new Text(
                        "LEO:",
                        style: theme.textTheme.subhead
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new Text(
                          leo,
                          maxLines: 1,
                          style: theme.textTheme.subhead,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Text(
                        "Consecutive:",
                        style: theme.textTheme.subhead
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new Text(
                          _launch.rocket.configuration
                                  .consecutiveSuccessfulLaunches
                                  .toString() ??
                              "",
                          maxLines: 1,
                          style: theme.textTheme.subhead,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      new Text(
                        "Pending:",
                        style: theme.textTheme.subhead
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new Text(
                          _launch.rocket.configuration.pendingLaunches
                                  .toString() ??
                              "",
                          maxLines: 1,
                          style: theme.textTheme.subhead,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      new Text(
                        "Max Stage:",
                        style: theme.textTheme.subhead
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new Text(
                          _launch.rocket.configuration.maxStage.toString() ??
                              "",
                          maxLines: 1,
                          style: theme.textTheme.subhead,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      new Text(
                        "Diameter:",
                        style: theme.textTheme.subhead
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new Text(
                          _launch.rocket.configuration.diameter.toString() +
                                  "m" ??
                              "",
                          maxLines: 1,
                          style: theme.textTheme.subhead,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      new Text(
                        "Thrust:",
                        style: theme.textTheme.subhead
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new Text(
                          _launch.rocket.configuration.thrust.toString() +
                                  "kn" ??
                              "",
                          maxLines: 1,
                          style: theme.textTheme.subhead,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      new Text(
                        "GEO:",
                        style: theme.textTheme.subhead
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new Text(
                          gto,
                          maxLines: 1,
                          style: theme.textTheme.subhead,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    List<Widget> materialButtons = [];

    if (_launch.rocket.configuration.infoUrl != null) {
      materialButtons.add(new CupertinoButton(
        onPressed: () {
          _launchURL(_launch.rocket.configuration.infoUrl);
        },
        child: new Text('Website'),
      ));
    }

    if (_launch.rocket.configuration.wikiUrl != null) {
      materialButtons.add(new CupertinoButton(
        onPressed: () {
          _launchURL(_launch.rocket.configuration.wikiUrl);
        },
        child: new Text('Wiki'),
      ));
    }

    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: materialButtons,
      ),
    );
  }

  Widget _buildDescription(ThemeData theme) {
    return new Padding(
      padding:
          const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
      child: new Text(
        _launch.rocket.configuration.description ?? "",
        style: theme.textTheme.body1,
        textAlign: TextAlign.start,
      ),
    );
  }

  void _navigateToLaunchDetails({String launchId}) {
    Ads.hideBannerAd();
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (c) {
          return new LaunchDetailPage(widget._configuration, launch: null,
            launchId: launchId,);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
          child: new Text(
            "Launch Vehicle",
            textAlign: TextAlign.left,
            style: Theme.of(context)
                .textTheme
                .headline
                .copyWith(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
        _buildAvatar(theme),
        _buildDescription(theme),
        _buildActionButtons(theme),
        _buildStats(theme),
        _buildLauncher(theme),
      ],
    );
  }

  _buildLauncher(ThemeData theme) {
    List<Widget> widgets = new List<Widget>();
    if (_launch.rocket.firstStages.length > 0) {
      for (var booster in _launch.rocket.firstStages) {
        var title = booster.type + " - " + booster.launcher.serialNumber;
        var status = booster.launcher.status.substring(0, 1).toUpperCase() +
            booster.launcher.status.substring(1).toLowerCase();
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: theme.textTheme.headline
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              new Row(
                children: <Widget>[
                  new Text(
                    "Status:",
                    style: theme.textTheme.subhead
                        .copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: new Text(
                      status,
                      maxLines: 1,
                      style: theme.textTheme.subhead,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ],
              ),
              new Row(
                children: <Widget>[
                  new Text(
                    "Flight:",
                    style: theme.textTheme.subhead
                        .copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: new Text(
                      booster.flightNumber.toString(),
                      maxLines: 1,
                      style: theme.textTheme.subhead,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ],
              ),
              new Row(
                children: <Widget>[
                  new Text(
                    "Turnaround Time:",
                    style: theme.textTheme.subhead
                        .copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: new Text(
                      booster.turnAround.toString() + " Days",
                      maxLines: 1,
                      style: theme.textTheme.subhead,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ],
              ),
              new Column(mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildLanding(theme, booster)),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: new Text(booster.launcher.details),
              ),
              Align(
                alignment: Alignment.center,
                child: new Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: new CupertinoButton(
                    color: Colors.blue,
                    child: Text("Previous Flight"),
                    onPressed: () {_navigateToLaunchDetails(launchId: booster.previousFlightUUID);}
                  ),
                ),
              ),
            ],
          ),
        ));
      }
    }
    return new Column(
      children: widgets,
    );
  }

  _buildLanding(ThemeData theme, FirstStage booster) {
    List<Widget> widgets = new List<Widget>();
    if (booster.landing != null &&
        booster.landing.attempt != null &&
        booster.landing.attempt
    ) {
      widgets.add(Text("Landing",
        style: theme.textTheme.headline
            .copyWith(fontWeight: FontWeight.bold),));
      widgets.add(Text(booster.landing.type.name?? ""));
      widgets.add(Text(booster.landing.location.name?? ""));
    }
    return widgets;
  }
}
