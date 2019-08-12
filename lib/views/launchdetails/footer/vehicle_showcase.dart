import 'dart:async';

import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:spacelaunchnow_flutter/models/launch.dart';
import 'package:url_launcher/url_launcher.dart';

class VehicleShowcase extends StatefulWidget {
  final Launch _launch;

  VehicleShowcase(this._launch);

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
          new Column(
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
                  softWrap: false,
                ),
              ),
            ],
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
    if (_launch.rocket.configuration.leoCapacity != null){
      leo = _launch.rocket.configuration.leoCapacity.toString() + "kg";
    } else {
      leo = "N/A";
    }

    var gto = "";
    if (_launch.rocket.configuration.geoCapacity != null){
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
                ],
              )
            ],
          ),
          new Divider(),
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
                        "Min Stage:",
                        style: theme.textTheme.subhead
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new Text(
                          _launch.rocket.configuration.minStage
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
                        "Length:",
                        style: theme.textTheme.subhead
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new Text(
                          _launch.rocket.configuration.length
                              .toString() + "m" ??
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
                          _launch.rocket.configuration.launchMass
                              .toString() + "T" ??
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
                        child: new Text(leo,
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
                        "Max Stage:",
                        style: theme.textTheme.subhead
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new Text(
                          _launch.rocket.configuration
                              .maxStage
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
                        "Diameter:",
                        style: theme.textTheme.subhead
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new Text(
                          _launch.rocket.configuration.diameter
                              .toString() + "m" ??
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
                          _launch.rocket.configuration.thrust
                              .toString() + "kn" ??
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
                        child: new Text(gto,
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
      materialButtons.add(new MaterialButton(
        elevation: 2.0,
        minWidth: 130.0,
        color: Colors.blue,
        textColor: Colors.white,
        onPressed: () {
          _launchURL(_launch.rocket.configuration.infoUrl);
        },
        child: new Text('Website'),
      ));
    }

    if (_launch.rocket.configuration.wikiUrl != null) {
      materialButtons.add(new MaterialButton(
        elevation: 2.0,
        minWidth: 130.0,
        color: Colors.redAccent,
        textColor: Colors.white,
        onPressed: () {
          _launchURL(_launch.rocket.configuration.wikiUrl);
        },
        child: new Text('Wiki'),
      ));
    }

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

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildAvatar(theme),
        _buildActionButtons(theme),
        _buildDescription(theme),
        _buildStats(theme),
      ],
    );
  }
}
