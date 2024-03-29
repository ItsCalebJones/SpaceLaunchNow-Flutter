import 'package:flutter/material.dart';
import 'package:spacelaunchnow_flutter/models/launch/detailed/launch.dart';
import 'package:spacelaunchnow_flutter/models/mission.dart';
import 'package:spacelaunchnow_flutter/util/url_helper.dart';

class MissionShowcase extends StatelessWidget {
  const MissionShowcase(this._launch, {super.key});

  final Launch? _launch;

  Widget _buildOrbit(TextTheme textTheme) {
    String? orbit = "Unknown Orbit";
    if (_launch!.mission!.orbit != null) {
      orbit = _launch!.mission!.orbit!.name;
    }
    return Row(
      children: <Widget>[
        Text(
          "Orbit:",
          style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            orbit!,
            maxLines: 2,
            style: textTheme.bodyLarge,
            overflow: TextOverflow.fade,
          ),
        ),
      ],
    );
  }

  Widget _buildMissionType(TextTheme textTheme) {
    return Row(
      children: <Widget>[
        Text(
          "Type:",
          style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.start,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            _launch!.mission!.typeName!,
            maxLines: 2,
            style: textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var widgets = <Widget>[];
    Mission? mission = _launch!.mission;
    widgets.add(Padding(
      padding:
          const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0, bottom: 0.0),
      child: Text(
        "Mission Details",
        textAlign: TextAlign.left,
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(fontWeight: FontWeight.bold, fontSize: 30),
      ),
    ));
    if (mission != null) {
      String? missionDescription = _launch!.mission!.description;
      widgets.add(Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Text(
                  mission.name!,
                  style: textTheme.titleLarge,
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 4.0, left: 0.0, right: 0.0, bottom: 2.0),
                child: _buildMissionType(textTheme),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 4.0, left: 0.0, right: 0.0, bottom: 2.0),
                child: _buildOrbit(textTheme),
              ),
              _getInfographic(textTheme),
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Text(
                  "$missionDescription",
                  style: textTheme.bodyLarge!.copyWith(),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      ));
    } else {
      widgets.add(Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _launch!.name!,
              style: textTheme.titleLarge!.copyWith(),
            ),
            Text(
              "Type: Unknown",
              style: textTheme.titleMedium!.copyWith(),
            ),
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

  _getInfographic(TextTheme textTheme) {
    if (_launch!.infographic != null) {
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: InkWell(
              onTap: () {
                openUrl("https://www.patreon.com/geoffbarrett");
              },
              child: Center(
                child: Image.network(_launch!.infographic!),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Credit @geoffdbarrett",
              textAlign: TextAlign.center,
              style: textTheme.bodySmall,
            ),
          )
        ],
      );
    } else {
      return Container();
    }
  }
}
