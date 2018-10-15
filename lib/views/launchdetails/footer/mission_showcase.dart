import 'package:flutter/material.dart';
import 'package:spacelaunchnow_flutter/models/launch.dart';
import 'package:spacelaunchnow_flutter/models/mission.dart';

class MissionShowcase extends StatelessWidget {
  MissionShowcase(this.launch);

  final Launch launch;

  _buildOrbit(TextTheme textTheme) {
    var orbit = "Unknown";
    if (launch.mission.orbit != null) {
      orbit = launch.mission.orbit;
    }
      return new Text(orbit,
          style: textTheme.subhead.copyWith(color: Colors.white));
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    Mission mission = launch.mission;
    if (mission != null) {
      String typeName = launch.mission.typeName;
      String missionName = launch.mission.name;
      String missionDescription = launch.mission.description;
      return new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new SingleChildScrollView(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Text(
                "$missionName",
                style: textTheme.title.copyWith(color: Colors.white),
              ),
              new Text(
                "Type: $typeName",
                style: textTheme.title.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              new Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: new Text(
                  "$missionDescription",
                  style: textTheme.body1.copyWith(color: Colors.white),
                  textAlign: TextAlign.left,
                ),
              ),
              new Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: new Text(
                  "Target Orbit",
                  style: textTheme.title.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              _buildOrbit(textTheme),
            ],
          ),
        ),
      );
    } else {
      return new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Column(
          children: <Widget>[
            new Text(
              launch.name,
              style: textTheme.title.copyWith(color: Colors.white),
            ),
            new Text(
              "Type: Unknown",
              style: textTheme.title.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
  }
}
