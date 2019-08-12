import 'package:flutter/material.dart';
import 'package:spacelaunchnow_flutter/models/launch.dart';
import 'package:spacelaunchnow_flutter/models/mission.dart';

class MissionShowcase extends StatelessWidget {
  MissionShowcase(this.launch);

  final Launch launch;

  Widget _buildOrbit(TextTheme textTheme) {
    var orbit = "Unknown Orbit";
    if (launch.mission.orbit != null) {
      orbit = launch.mission.orbit;
    }
    return new Row(
      children: <Widget>[
        new Text(
          "Orbit:",
          style: textTheme.subtitle.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        new Expanded(
          child: new Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: new Text(
              orbit,
              maxLines: 2,
              style: textTheme.subhead,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMissionType(TextTheme textTheme) {
    return new Row(
      children: <Widget>[
        new Text(
          "Type:",
          style: textTheme.subtitle.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        new Expanded(
          child: new Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: new Text(
              launch.mission.typeName,
              maxLines: 2,
              style: textTheme.subhead,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme
        .of(context)
        .textTheme;
    var widgets = new List<Widget>();
    Mission mission = launch.mission;
    widgets.add(Padding(
      padding: const EdgeInsets.only(left: 8.0, right:8.0, top:16.0, bottom: 8.0),
      child: new Text(
        "Mission Details",
        textAlign: TextAlign.left,
        style: Theme
            .of(context)
            .textTheme
            .headline
            .copyWith(fontWeight: FontWeight.bold, fontSize: 30),
      ),
    ));
    if (launch.infographic != null) {
      widgets.add(new Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: new InkWell(
          child: new Center(
            child: new Image.network(launch.infographic),
          ),
        ),
      ));
      widgets.add(new Text(
        "Credit @geoffdbarrett",
        textAlign: TextAlign.center,
        style: Theme
            .of(context)
            .textTheme
            .caption,
      ));
    }
    if (mission != null) {
      String typeName = launch.mission.typeName;
      String missionName = launch.mission.name;
      String missionDescription = launch.mission.description;
      widgets.add(new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new SingleChildScrollView(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(
                    top: 4.0, left: 0.0, right: 0.0, bottom: 2.0),
                child: _buildMissionType(textTheme),
              ),
              new Padding(
                padding: const EdgeInsets.only(
                    top: 4.0, left: 0.0, right: 0.0, bottom: 2.0),
                child: _buildOrbit(textTheme),
              ),
              new Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: new Text(
                  "$missionDescription",
                  style: textTheme.body1.copyWith(),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      ));
    } else {
      widgets.add(new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Column(
          children: <Widget>[
            new Text(
              launch.name,
              style: textTheme.title.copyWith(),
            ),
            new Text(
              "Type: Unknown",
              style: textTheme.subtitle.copyWith(),
              textAlign: TextAlign.center,
            ),
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
}
