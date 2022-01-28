import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spacelaunchnow_flutter/models/launch/detailed/launch.dart';
import 'package:spacelaunchnow_flutter/models/rocket/spacecraft/crew.dart';
import 'package:spacelaunchnow_flutter/models/rocket/first_stage.dart';
import 'package:spacelaunchnow_flutter/models/rocket/spacecraft/spacecraft_stage.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../launch_detail_page.dart';

class VehicleShowcase extends StatefulWidget {
  final Launch? _launch;
  final AppConfiguration _configuration;

  VehicleShowcase(this._launch, this._configuration);

  @override
  State createState() => new VehicleShowcaseState(this._launch);
}

class VehicleShowcaseState extends State<VehicleShowcase> {
  VehicleShowcaseState(this._launch);

  final Launch? _launch;

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
    String? url = "https://spacelaunchnow-prod-east.nyc3.digitaloceanspaces.com/static/home/img/placeholder.jpg";
    if (_launch!.rocket!.configuration!.image != null &&
        _launch!.rocket!.configuration!.image!.length > 0) {
      url = _launch!.rocket!.configuration!.image;
    } else if (_launch!.rocket!.configuration!.manufacturer!.imageURL != null &&
        _launch!.rocket!.configuration!.manufacturer!.imageURL!.length > 0) {
      url = _launch!.rocket!.configuration!.manufacturer!.imageURL;
    }

    if (_launch!.rocket!.configuration!.image != null) {
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
                  backgroundImage: new NetworkImage(url!),
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
                    _launch!.rocket!.configuration!.manufacturer!.name ?? "",
                    style: theme.textTheme.subtitle1,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
                _buildActionButtons(theme)
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
                _launch!.rocket!.configuration!.fullName ?? "",
                style: theme.textTheme.headline5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                _launch!.rocket!.configuration!.manufacturer!.name ?? "",
                style: theme.textTheme.subtitle1,
                textAlign: TextAlign.center,
              ),
            ),
          ]);
  }

  Widget _buildStats(ThemeData theme) {
    var vehicle = _launch!.rocket!.configuration!.fullName ?? "Vehicle";
    var leo = "";
    if (_launch!.rocket!.configuration!.leoCapacity != null) {
      leo = _launch!.rocket!.configuration!.leoCapacity.toString() + "kg";
    } else {
      leo = "N/A";
    }

    var gto = "";
    if (_launch!.rocket!.configuration!.geoCapacity != null) {
      gto = _launch!.rocket!.configuration!.geoCapacity.toString() + "kg";
    } else {
      gto = "N/A";
    }

    var minStage = "";
    if (_launch!.rocket!.configuration!.minStage != null) {
      minStage = _launch!.rocket!.configuration!.minStage.toString();
    }

    var maxStage = "";
    if (_launch!.rocket!.configuration!.maxStage != null) {
      maxStage = _launch!.rocket!.configuration!.maxStage.toString();
    }

    var length = "";
    if (_launch!.rocket!.configuration!.length != null) {
      length = _launch!.rocket!.configuration!.length.toString() + "m";
    }

    var launchMass = "";
    if (_launch!.rocket!.configuration!.launchMass != null) {
      launchMass = _launch!.rocket!.configuration!.launchMass.toString() + " T";
    }

    var diameter = "";
    if (_launch!.rocket!.configuration!.diameter != null) {
      diameter = _launch!.rocket!.configuration!.diameter.toString() + "m";
    }

    var thrust = "";
    if (_launch!.rocket!.configuration!.thrust != null) {
      thrust = _launch!.rocket!.configuration!.thrust.toString() + " kn";
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
                theme.textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Text(
                        "Successful:",
                        style: theme.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new Text(
                          _launch!.rocket!.configuration!.successfulLaunches
                                  .toString() ??
                              "",
                          maxLines: 1,
                          style: theme.textTheme.subtitle1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      new Text(
                        "Failed:",
                        style: theme.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new Text(
                          _launch!.rocket!.configuration!.failedLaunches
                                  .toString() ??
                              "",
                          maxLines: 1,
                          style: theme.textTheme.subtitle1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      new Text(
                        "Min Stage:",
                        style: theme.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new Text(
                          minStage,
                          maxLines: 1,
                          style: theme.textTheme.subtitle1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      new Text(
                        "Length:",
                        style: theme.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new Text(
                          length,
                          maxLines: 1,
                          style: theme.textTheme.subtitle1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      new Text(
                        "Mass:",
                        style: theme.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new Text(
                          launchMass,
                          maxLines: 1,
                          style: theme.textTheme.subtitle1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      new Text(
                        "LEO:",
                        style: theme.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new Text(
                          leo,
                          maxLines: 1,
                          style: theme.textTheme.subtitle1,
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
                        style: theme.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new Text(
                          _launch!.rocket!.configuration!
                                  .consecutiveSuccessfulLaunches
                                  .toString() ??
                              "",
                          maxLines: 1,
                          style: theme.textTheme.subtitle1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      new Text(
                        "Pending:",
                        style: theme.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new Text(
                          _launch!.rocket!.configuration!.pendingLaunches
                                  .toString() ??
                              "",
                          maxLines: 1,
                          style: theme.textTheme.subtitle1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      new Text(
                        "Max Stage:",
                        style: theme.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new Text(
                          maxStage,
                          maxLines: 1,
                          style: theme.textTheme.subtitle1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      new Text(
                        "Diameter:",
                        style: theme.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new Text(
                          diameter,
                          maxLines: 1,
                          style: theme.textTheme.subtitle1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      new Text(
                        "Thrust:",
                        style: theme.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new Text(
                          thrust,
                          maxLines: 1,
                          style: theme.textTheme.subtitle1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      new Text(
                        "GEO:",
                        style: theme.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new Text(
                          gto,
                          maxLines: 1,
                          style: theme.textTheme.subtitle1,
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

    if (_launch!.rocket!.configuration!.infoUrl != null) {
      materialButtons.add(new IconButton(
        icon: Icon(FontAwesomeIcons.desktop),
        onPressed: () {
          _launchURL(_launch!.rocket!.configuration!.infoUrl!);
        },
        tooltip: "Website",
      ));
    }

    if (_launch!.rocket!.configuration!.wikiUrl != null) {
      materialButtons.add(new IconButton(
        icon: Icon(FontAwesomeIcons.wikipediaW),
        onPressed: () {
          _launchURL(_launch!.rocket!.configuration!.wikiUrl!);
        },
        tooltip: "Website",
      ));
    }

    return new Padding(
      padding: const EdgeInsets.all(0.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: materialButtons,
      ),
    );
  }

  Widget _buildDescription(ThemeData theme) {
    return new Padding(
      padding:
          const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
      child: new Text(
        _launch!.rocket!.configuration!.description ?? "",
        style: theme.textTheme.bodyText1,
        textAlign: TextAlign.start,
      ),
    );
  }

  void _navigateToLaunchDetails({String? launchId}) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (c) {
          return new LaunchDetailPage(
            widget._configuration,
            launch: null,
            launchId: launchId,
          );
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
                .headline4!
                .copyWith(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: new Text(
            _launch!.rocket!.configuration!.fullName ?? "",
            style: theme.textTheme.headline6,
          ),
        ),
        _buildAvatar(theme),
        _buildDescription(theme),
        _buildStats(theme),
        _buildLauncher(theme),
        _buildSpacecraft(theme),
      ],
    );
  }

  _buildLauncher(ThemeData theme) {
    List<Widget> widgets = new List<Widget>();
    if (_launch!.rocket!.firstStages!.length > 0) {
      var booster;
      if (_launch!.rocket!.firstStages!.length > 1) {
        booster = "First Stage Boosters";
      } else {
        booster = "First Stage Booster";
      }
      widgets.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          booster,
          style: theme.textTheme.headline5!.copyWith(fontWeight: FontWeight.bold),
        ),
      ));
      for (var booster in _launch!.rocket!.firstStages!) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildBoosterAvatar(theme, booster),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: new Text(booster.launcher!.details!),
              ),
              new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildLanding(theme, booster)),
              _checkPrevious(booster),
            ],
          ),
        ));
      }
    }
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  _buildLanding(ThemeData theme, FirstStage booster) {
    List<Widget> widgets = new List<Widget>();
    if (booster.landing != null &&
        booster.landing!.attempt != null &&
        booster.landing!.attempt!) {
      widgets.add(Text(
        "Landing",
        style: theme.textTheme.headline4!.copyWith(fontWeight: FontWeight.bold),
      ));
      if (booster.landing!.success == null) {
        widgets.add(
          new Row(
            children: <Widget>[
              new Icon(
                Icons.thumbs_up_down,
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: new Text(
                  "Pending",
                  maxLines: 1,
                  style: theme.textTheme.subtitle1,
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
        );
      } else if (booster.landing!.success!) {
        widgets.add(
          new Row(
            children: <Widget>[
              new Icon(
                Icons.check_circle,
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: new Text(
                  "Successful Landing",
                  maxLines: 1,
                  style: theme.textTheme.subtitle1,
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
        );
      } else if (!booster.landing!.success!) {
        widgets.add(
          new Row(
            children: <Widget>[
              new Icon(
                Icons.thumb_down,
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: new Text(
                  "Failed",
                  maxLines: 1,
                  style: theme.textTheme.subtitle1,
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
        );
      }
      if (!booster.landing!.attempt!) {
        widgets.add(new Row(
          children: <Widget>[
            new Icon(
              Icons.error,
            ),
            new Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: new Text(
                "No Landing",
                maxLines: 1,
                style: theme.textTheme.subtitle1,
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ));
      }
      if (booster.landing!.type != null) {
        widgets.add(new Row(
          children: <Widget>[
            new Icon(
              Icons.developer_board,
            ),
            new Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: new Text(
                booster.landing!.type!.name ?? "",
                maxLines: 1,
                style: theme.textTheme.subtitle1,
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ));
      }
      if (booster.landing!.location != null) {
        widgets.add(new Row(
          children: <Widget>[
            new Icon(
              Icons.map,
            ),
            new Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: new Text(
                booster.landing!.location!.name ?? "",
                maxLines: 1,
                style: theme.textTheme.subtitle1,
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ));
      }
    }
    return widgets;
  }

  _buildSpacecraft(ThemeData theme) {
    List<Widget> widgets = new List<Widget>();
    if (_launch!.rocket!.spacecraftStage != null) {
      widgets.add(
        new Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
          child: new Text(
            "Spacecraft",
            textAlign: TextAlign.left,
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
      );
      widgets.add(Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSpacecraftAvatar(theme, _launch!.rocket!.spacecraftStage!),
            new Row(
              children: <Widget>[
                new Text(
                  "Destination:",
                  style: theme.textTheme.subtitle1!
                      .copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: new Text(
                    _launch!.rocket!.spacecraftStage!.destination!,
                    maxLines: 1,
                    style: theme.textTheme.caption,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ],
            ),
            new Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: new Text(
                  _launch!.rocket!.spacecraftStage!.spacecraft!.description!),
            ),
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildCrew(theme, _launch!.rocket!.spacecraftStage!),
            )
          ],
        ),
      ));
    }
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  _buildCrew(ThemeData theme, SpacecraftStage spacecraftStage) {
    List<Widget> widgets = new List<Widget>();
    if (spacecraftStage.launchCrew != null &&
        spacecraftStage.launchCrew!.length > 0) {
      for (var crew in spacecraftStage.launchCrew!) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 0.0, right: 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildCrewAvatar(theme, crew),
              new Padding(
                padding:
                const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 0.0, right: 0.0),
                child: new Text(
                  crew.astronaut!.bio!,
                  style: theme.textTheme.bodyText1,
                  textAlign: TextAlign.start,
                ),
              )
            ],
          ),
        ));
      }
    }
    return widgets;
  }

  _checkPrevious(FirstStage booster) {
    if (booster.previousFlightUUID != null &&
        _launch!.id != booster.previousFlightUUID) {
      return Align(
        alignment: Alignment.center,
        child: new Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: new CupertinoButton(
              color: Theme.of(context).accentColor,
              child: Text("Previous Flight"),
              onPressed: () {
                _navigateToLaunchDetails(launchId: booster.previousFlightUUID);
              }),
        ),
      );
    } else {
      return new Container();
    }
  }

  _buildBoosterAvatar(ThemeData theme, FirstStage booster) {
    var title = booster.launcher!.serialNumber;
    var status = booster.launcher!.status!.substring(0, 1).toUpperCase() +
        booster.launcher!.status!.substring(1).toLowerCase();
    var turnaroundTime = "N/A";
    if (booster.turnAround != null && booster.turnAround! > 0) {
      turnaroundTime = booster.turnAround.toString() + " Days";
    }

    if (booster.launcher!.image != null) {
      return Row(
        children: <Widget>[
          new Padding(
              padding: const EdgeInsets.only(
                  left: 0.0, right: 4.0, top: 8.0, bottom: 4.0),
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
                  backgroundImage: new NetworkImage(booster.launcher!.image!),
                  radius: 50.0,
                  backgroundColor: Colors.white,
                ),
              )),
          Flexible(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title!,
                  style: theme.textTheme.headline5!.copyWith(fontWeight: FontWeight.bold),
                ),
                new Row(
                  children: <Widget>[
                    new Text(
                      "Type:",
                      style: theme.textTheme.subtitle1!
                          .copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: new Text(
                        booster.type!,
                        maxLines: 1,
                        style: theme.textTheme.caption,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Text(
                      "Status:",
                      style: theme.textTheme.subtitle1!
                          .copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: new Text(
                        status,
                        maxLines: 1,
                        style: theme.textTheme.caption,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Text(
                      "Flight:",
                      style: theme.textTheme.subtitle1!
                          .copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: new Text(
                        booster.flightNumber.toString(),
                        maxLines: 1,
                        style: theme.textTheme.caption,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Text(
                      "Turnaround:",
                      style: theme.textTheme.subtitle1!
                          .copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: new Text(
                        turnaroundTime,
                        maxLines: 1,
                        style: theme.textTheme.caption,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ],
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
            Text(
              title!,
              style: theme.textTheme.headline4!.copyWith(fontWeight: FontWeight.bold),
            ),
            new Row(
              children: <Widget>[
                new Text(
                  "Type:",
                  style: theme.textTheme.subtitle1!
                      .copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: new Text(
                    booster.type!,
                    maxLines: 1,
                    style: theme.textTheme.caption,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new Text(
                  "Status:",
                  style: theme.textTheme.subtitle1!
                      .copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: new Text(
                    status,
                    maxLines: 1,
                    style: theme.textTheme.caption,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new Text(
                  "Flight:",
                  style: theme.textTheme.subtitle1!
                      .copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: new Text(
                    booster.flightNumber.toString(),
                    maxLines: 1,
                    style: theme.textTheme.caption,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new Text(
                  "Turnaround Time:",
                  style: theme.textTheme.subtitle1!
                      .copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: new Text(
                    turnaroundTime,
                    maxLines: 1,
                    style: theme.textTheme.caption,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ],
            ),
          ]);
  }

  _buildCrewAvatar(ThemeData theme, Crew crew) {
    var title = crew.astronaut!.name;
    var subtitle = crew.role!.role;
    var nationality = crew.astronaut!.nationality;

    if (crew.astronaut!.profileImage != null) {
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
                      new NetworkImage(crew.astronaut!.profileImage!),
                  radius: 50.0,
                  backgroundColor: Colors.white,
                ),
              )),
          Flexible(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title!,
                  style: theme.textTheme.headline4!.copyWith(fontWeight: FontWeight.bold),
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: new Text(
                    nationality!,
                    maxLines: 2,
                    style: theme.textTheme.caption,
                    overflow: TextOverflow.fade,
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: new Text(
                    subtitle!,
                    maxLines: 2,
                    style: theme.textTheme.caption,
                    overflow: TextOverflow.fade,
                  ),
                ),
                _buildCrewActionButtons(theme, crew)
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
            Text(
              title!,
              style: theme.textTheme.headline4!.copyWith(fontWeight: FontWeight.bold),
            ),
            new Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: new Text(
                nationality!,
                maxLines: 2,
                style: theme.textTheme.caption,
                overflow: TextOverflow.fade,
              ),
            ),
            new Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: new Text(
                subtitle!,
                maxLines: 2,
                style: theme.textTheme.caption,
                overflow: TextOverflow.fade,
              ),
            ),
          ]);
  }

  _buildSpacecraftAvatar(ThemeData theme, SpacecraftStage spacecraftStage) {
    var title = spacecraftStage.spacecraft!.name;

    var status = spacecraftStage.spacecraft!.status;

    if (spacecraftStage.spacecraft!.image != null) {
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
                      new NetworkImage(spacecraftStage.spacecraft!.image!),
                  radius: 50.0,
                  backgroundColor: Colors.white,
                ),
              )),
          Flexible(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title!,
                  style: theme.textTheme.headline5!.copyWith(fontWeight: FontWeight.bold),
                ),
                new Row(
                  children: <Widget>[
                    new Text(
                      "Status:",
                      style: theme.textTheme.subtitle1!
                          .copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: new Text(
                        status!,
                        maxLines: 1,
                        style: theme.textTheme.caption,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ],
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
            Text(
              title!,
              style: theme.textTheme.headline4!.copyWith(fontWeight: FontWeight.bold),
            ),
          ]);
  }

  Widget _buildCrewActionButtons(ThemeData theme, Crew crew) {
    List<Widget> materialButtons = [];

    if (crew.astronaut!.wikiUrl != null) {
      materialButtons.add(new IconButton(
        icon: Icon(FontAwesomeIcons.wikipediaW),
        onPressed: () {
          _launchURL(crew.astronaut!.wikiUrl!);
        },
        tooltip: "Wiki",
      ));
    }

    if (crew.astronaut!.instagramUrl != null) {
      materialButtons.add(new IconButton(
        icon: Icon(FontAwesomeIcons.instagram),
        onPressed: () {
          _launchURL(crew.astronaut!.instagramUrl!);
        },
        tooltip: "Wiki",
      ));
    }

    if (crew.astronaut!.twitterUrl != null) {
      materialButtons.add(new IconButton(
        icon: Icon(FontAwesomeIcons.twitter),
        onPressed: () {
          _launchURL(crew.astronaut!.twitterUrl!);
        },
        tooltip: "Twitter",
      ));
    }
    return new Padding(
      padding: const EdgeInsets.all(0.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: materialButtons,
      ),
    );
  }
}
