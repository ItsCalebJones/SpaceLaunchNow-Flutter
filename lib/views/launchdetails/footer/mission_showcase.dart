import 'package:flutter/material.dart';
import 'package:spacelaunchnow_flutter/models/launch.dart';
import 'package:spacelaunchnow_flutter/models/mission.dart';
import 'package:spacelaunchnow_flutter/models/payload.dart';

class MissionShowcase extends StatelessWidget {
  MissionShowcase(this.launch);

  final Launch launch;

  _buildPayloads(TextTheme textTheme) {
    List<Widget> payloads = [];
    if (launch.mission.payloads != null && launch.mission.payloads.length > 0) {
      payloads.add(new Text(
        "Payloads",
        style: textTheme.title.copyWith(color: Colors.white),
        textAlign: TextAlign.center,
      ));
      for (Payload payload in launch.mission.payloads) {
        payloads.addAll(
          <Widget>[
            new Text(
              payload.name,
              style: textTheme.subhead.copyWith(color: Colors.white),
              textAlign: TextAlign.left,
            ),
            new Text(
              "Description currently unavailable.",
              style: textTheme.body1.copyWith(color: Colors.white),
              textAlign: TextAlign.left,
            ),
            new Text(
              "Weight: Unknown",
              style: textTheme.body1.copyWith(color: Colors.white),
              textAlign: TextAlign.left,
            ),
            new Text(
              "Size: Unknown",
              style: textTheme.body1.copyWith(color: Colors.white),
              textAlign: TextAlign.left,
            )
          ],
        );
      }
      return new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: payloads,
      );
    } else {
      return new Text("No Payload data available.",
          style: textTheme.title.copyWith(color: Colors.white));
    }
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Text(
                "$missionName",
                style: textTheme.title.copyWith(color: Colors.white),
              ),
              new Text(
                "Type: $typeName",
                style: textTheme.title.copyWith(color: Colors.white),
                textAlign: TextAlign.left,
              ),
              new Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: new Text(
                  "$missionDescription",
                  style: textTheme.body1.copyWith(color: Colors.white),
                  textAlign: TextAlign.left,
                ),
              ),
              _buildPayloads(textTheme),
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
              textAlign: TextAlign.left,
            ),
          ],
        ),
      );
    }
  }
}
