import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spacelaunchnow_flutter/models/launch/detailed/launch.dart';
import 'package:spacelaunchnow_flutter/models/rocket/first_stage.dart';
import 'package:spacelaunchnow_flutter/models/rocket/spacecraft/crew.dart';
import 'package:spacelaunchnow_flutter/models/rocket/spacecraft/spacecraft_stage.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:spacelaunchnow_flutter/util/url_helper.dart';

import '../launch_detail_page.dart';

class VehicleShowcase extends StatefulWidget {
  final Launch? _launch;
  final AppConfiguration _configuration;

  const VehicleShowcase(this._launch, this._configuration, {Key? key}) : super(key: key);

  @override
  State createState() => VehicleShowcaseState(_launch);
}

class VehicleShowcaseState extends State<VehicleShowcase> {
  VehicleShowcaseState(this._launch);

  final Launch? _launch;

  @override
  void initState() {
    super.initState();
  }
  
  Widget _buildAvatar(ThemeData theme) {
    String? url =
        "https://spacelaunchnow-prod-east.nyc3.digitaloceanspaces.com/static/home/img/placeholder.jpg";
    if (_launch!.rocket!.configuration!.image != null &&
        _launch!.rocket!.configuration!.image!.isNotEmpty) {
      url = _launch!.rocket!.configuration!.image;
    } else if (_launch!.rocket!.configuration!.manufacturer!.imageURL != null &&
        _launch!.rocket!.configuration!.manufacturer!.imageURL!.isNotEmpty) {
      url = _launch!.rocket!.configuration!.manufacturer!.imageURL;
    }

    if (_launch!.rocket!.configuration!.image != null) {
      return Row(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 4.0, top: 8.0, bottom: 4.0),
              child: Container(
                width: 125.0,
                height: 125.0,
                padding: const EdgeInsets.all(2.0),
                // border width
                decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor, // border color
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  foregroundColor: Colors.white,
                  backgroundImage: NetworkImage(url!),
                  radius: 50.0,
                  backgroundColor: Colors.white,
                ),
              )),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Text(
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
    } else {
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
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
  }

  Widget _buildStats(ThemeData theme) {
    var vehicle = _launch!.rocket!.configuration!.fullName ?? "Vehicle";
    var leo = "";
    if (_launch!.rocket!.configuration!.leoCapacity != null) {
      leo = "${_launch!.rocket!.configuration!.leoCapacity}kg";
    } else {
      leo = "N/A";
    }

    var gto = "";
    if (_launch!.rocket!.configuration!.geoCapacity != null) {
      gto = "${_launch!.rocket!.configuration!.geoCapacity}kg";
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
      length = "${_launch!.rocket!.configuration!.length}m";
    }

    var launchMass = "";
    if (_launch!.rocket!.configuration!.launchMass != null) {
      launchMass = "${_launch!.rocket!.configuration!.launchMass} T";
    }

    var diameter = "";
    if (_launch!.rocket!.configuration!.diameter != null) {
      diameter = "${_launch!.rocket!.configuration!.diameter}m";
    }

    var thrust = "";
    if (_launch!.rocket!.configuration!.thrust != null) {
      thrust = "${_launch!.rocket!.configuration!.thrust} kn";
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "$vehicle Stats",
            style: theme.textTheme.headline6!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "Successful:",
                        style: theme.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          _launch!.rocket!.configuration!.successfulLaunches
                              .toString(),
                          maxLines: 1,
                          style: theme.textTheme.subtitle1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Failed:",
                        style: theme.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          _launch!.rocket!.configuration!.failedLaunches
                              .toString(),
                          maxLines: 1,
                          style: theme.textTheme.subtitle1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Min Stage:",
                        style: theme.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          minStage,
                          maxLines: 1,
                          style: theme.textTheme.subtitle1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Length:",
                        style: theme.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          length,
                          maxLines: 1,
                          style: theme.textTheme.subtitle1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Mass:",
                        style: theme.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          launchMass,
                          maxLines: 1,
                          style: theme.textTheme.subtitle1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "LEO:",
                        style: theme.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "Consecutive:",
                        style: theme.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          _launch!.rocket!.configuration!
                              .consecutiveSuccessfulLaunches
                              .toString(),
                          maxLines: 1,
                          style: theme.textTheme.subtitle1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Pending:",
                        style: theme.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          _launch!.rocket!.configuration!.pendingLaunches
                              .toString(),
                          maxLines: 1,
                          style: theme.textTheme.subtitle1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Max Stage:",
                        style: theme.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          maxStage,
                          maxLines: 1,
                          style: theme.textTheme.subtitle1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Diameter:",
                        style: theme.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          diameter,
                          maxLines: 1,
                          style: theme.textTheme.subtitle1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Thrust:",
                        style: theme.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          thrust,
                          maxLines: 1,
                          style: theme.textTheme.subtitle1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "GEO:",
                        style: theme.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
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
      materialButtons.add(IconButton(
        icon: const Icon(FontAwesomeIcons.desktop),
        onPressed: () {
          openUrl(_launch!.rocket!.configuration!.infoUrl!);
        },
        tooltip: "Website",
      ));
    }

    if (_launch!.rocket!.configuration!.wikiUrl != null) {
      materialButtons.add(IconButton(
        icon: const Icon(FontAwesomeIcons.wikipediaW),
        onPressed: () {
          openUrl(_launch!.rocket!.configuration!.wikiUrl!);
        },
        tooltip: "Website",
      ));
    }

    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: materialButtons,
      ),
    );
  }

  Widget _buildDescription(ThemeData theme) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
      child: Text(
        _launch!.rocket!.configuration!.description ?? "",
        style: theme.textTheme.bodyText1,
        textAlign: TextAlign.start,
      ),
    );
  }

  void _navigateToLaunchDetails({String? launchId}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) {
          return LaunchDetailPage(
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
          child: Text(
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
          child: Text(
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
    List<Widget> widgets = <Widget>[];
    if (_launch!.rocket!.firstStages!.isNotEmpty) {
      String booster;
      if (_launch!.rocket!.firstStages!.length > 1) {
        booster = "First Stage Boosters";
      } else {
        booster = "First Stage Booster";
      }
      widgets.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          booster,
          style:
              theme.textTheme.headline5!.copyWith(fontWeight: FontWeight.bold),
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
                child: Text(booster.launcher!.details!),
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildLanding(theme, booster)),
              _checkPrevious(booster),
            ],
          ),
        ));
      }
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  _buildLanding(ThemeData theme, FirstStage booster) {
    List<Widget> widgets = <Widget>[];
    if (booster.landing != null &&
        booster.landing!.attempt != null &&
        booster.landing!.attempt!) {
      widgets.add(Text(
        "Landing",
        style: theme.textTheme.headline4!.copyWith(fontWeight: FontWeight.bold),
      ));
      if (booster.landing!.success == null) {
        widgets.add(
          Row(
            children: <Widget>[
              const Icon(
                Icons.thumbs_up_down,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
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
          Row(
            children: <Widget>[
              const Icon(
                Icons.check_circle,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
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
          Row(
            children: <Widget>[
              const Icon(
                Icons.thumb_down,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
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
        widgets.add(Row(
          children: <Widget>[
            const Icon(
              Icons.error,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
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
        widgets.add(Row(
          children: <Widget>[
            const Icon(
              Icons.developer_board,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
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
        widgets.add(Row(
          children: <Widget>[
            const Icon(
              Icons.map,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
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
    List<Widget> widgets = <Widget>[];
    if (_launch!.rocket!.spacecraftStage != null) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
          child: Text(
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
            Row(
              children: <Widget>[
                Text(
                  "Destination:",
                  style: theme.textTheme.subtitle1!
                      .copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    _launch!.rocket!.spacecraftStage!.destination!,
                    maxLines: 1,
                    style: theme.textTheme.caption,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                  _launch!.rocket!.spacecraftStage!.spacecraft!.description!),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildCrew(theme, _launch!.rocket!.spacecraftStage!),
            )
          ],
        ),
      ));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  _buildCrew(ThemeData theme, SpacecraftStage spacecraftStage) {
    List<Widget> widgets = <Widget>[];
    if (spacecraftStage.launchCrew != null &&
        spacecraftStage.launchCrew!.isNotEmpty) {
      for (var crew in spacecraftStage.launchCrew!) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 0.0, right: 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildCrewAvatar(theme, crew),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 8.0, left: 0.0, right: 0.0),
                child: Text(
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
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: CupertinoButton(
              color: Theme.of(context).colorScheme.secondary,
              child: const Text("Previous Flight"),
              onPressed: () {
                _navigateToLaunchDetails(launchId: booster.previousFlightUUID);
              }),
        ),
      );
    } else {
      return Container();
    }
  }

  _buildBoosterAvatar(ThemeData theme, FirstStage booster) {
    var title = booster.launcher!.serialNumber;
    var status = booster.launcher!.status!.substring(0, 1).toUpperCase() +
        booster.launcher!.status!.substring(1).toLowerCase();
    var turnaroundTime = "N/A";
    if (booster.turnAround != null && booster.turnAround! > 0) {
      turnaroundTime = "${booster.turnAround} Days";
    }

    if (booster.launcher!.image != null) {
      return Row(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(
                  left: 0.0, right: 4.0, top: 8.0, bottom: 4.0),
              child: Container(
                width: 125.0,
                height: 125.0,
                padding: const EdgeInsets.all(2.0),
                // border width
                decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor, // border color
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  foregroundColor: Colors.white,
                  backgroundImage: NetworkImage(booster.launcher!.image!),
                  radius: 50.0,
                  backgroundColor: Colors.white,
                ),
              )),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title!,
                  style: theme.textTheme.headline5!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "Type:",
                      style: theme.textTheme.subtitle1!
                          .copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        booster.type!,
                        maxLines: 1,
                        style: theme.textTheme.caption,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "Status:",
                      style: theme.textTheme.subtitle1!
                          .copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        status,
                        maxLines: 1,
                        style: theme.textTheme.caption,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "Flight:",
                      style: theme.textTheme.subtitle1!
                          .copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        booster.flightNumber.toString(),
                        maxLines: 1,
                        style: theme.textTheme.caption,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "Turnaround:",
                      style: theme.textTheme.subtitle1!
                          .copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
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
    } else {
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title!,
              style: theme.textTheme.headline4!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Row(
              children: <Widget>[
                Text(
                  "Type:",
                  style: theme.textTheme.subtitle1!
                      .copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    booster.type!,
                    maxLines: 1,
                    style: theme.textTheme.caption,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  "Status:",
                  style: theme.textTheme.subtitle1!
                      .copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    status,
                    maxLines: 1,
                    style: theme.textTheme.caption,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  "Flight:",
                  style: theme.textTheme.subtitle1!
                      .copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    booster.flightNumber.toString(),
                    maxLines: 1,
                    style: theme.textTheme.caption,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  "Turnaround Time:",
                  style: theme.textTheme.subtitle1!
                      .copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
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
  }

  _buildCrewAvatar(ThemeData theme, Crew crew) {
    var title = crew.astronaut!.name;
    var subtitle = crew.role!.role;
    var nationality = crew.astronaut!.nationality;

    if (crew.astronaut!.profileImage != null) {
      return Row(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 4.0, top: 8.0, bottom: 4.0),
              child: Container(
                width: 125.0,
                height: 125.0,
                padding: const EdgeInsets.all(2.0),
                // border width
                decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor, // border color
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  foregroundColor: Colors.white,
                  backgroundImage: NetworkImage(crew.astronaut!.profileImage!),
                  radius: 50.0,
                  backgroundColor: Colors.white,
                ),
              )),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title!,
                  style: theme.textTheme.headline4!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    nationality!,
                    maxLines: 2,
                    style: theme.textTheme.caption,
                    overflow: TextOverflow.fade,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
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
    } else {
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title!,
              style: theme.textTheme.headline4!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                nationality!,
                maxLines: 2,
                style: theme.textTheme.caption,
                overflow: TextOverflow.fade,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                subtitle!,
                maxLines: 2,
                style: theme.textTheme.caption,
                overflow: TextOverflow.fade,
              ),
            ),
          ]);
    }
  }

  _buildSpacecraftAvatar(ThemeData theme, SpacecraftStage spacecraftStage) {
    var title = spacecraftStage.spacecraft!.name;

    var status = spacecraftStage.spacecraft!.status;

    if (spacecraftStage.spacecraft!.image != null) {
      return Row(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 4.0, top: 8.0, bottom: 4.0),
              child: Container(
                width: 125.0,
                height: 125.0,
                padding: const EdgeInsets.all(2.0),
                // border width
                decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor, // border color
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  foregroundColor: Colors.white,
                  backgroundImage:
                      NetworkImage(spacecraftStage.spacecraft!.image!),
                  radius: 50.0,
                  backgroundColor: Colors.white,
                ),
              )),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title!,
                  style: theme.textTheme.headline5!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "Status:",
                      style: theme.textTheme.subtitle1!
                          .copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
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
    } else {
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title!,
              style: theme.textTheme.headline4!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ]);
    }
  }

  Widget _buildCrewActionButtons(ThemeData theme, Crew crew) {
    List<Widget> materialButtons = [];

    if (crew.astronaut!.wikiUrl != null) {
      materialButtons.add(IconButton(
        icon: const Icon(FontAwesomeIcons.wikipediaW),
        onPressed: () {
          openUrl(crew.astronaut!.wikiUrl!);
        },
        tooltip: "Wiki",
      ));
    }

    if (crew.astronaut!.instagramUrl != null) {
      materialButtons.add(IconButton(
        icon: const Icon(FontAwesomeIcons.instagram),
        onPressed: () {
          openUrl(crew.astronaut!.instagramUrl!);
        },
        tooltip: "Wiki",
      ));
    }

    if (crew.astronaut!.twitterUrl != null) {
      materialButtons.add(IconButton(
        icon: const Icon(FontAwesomeIcons.twitter),
        onPressed: () {
          openUrl(crew.astronaut!.twitterUrl!);
        },
        tooltip: "Twitter",
      ));
    }
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: materialButtons,
      ),
    );
  }
}
