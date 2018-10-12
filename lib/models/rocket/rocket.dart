import 'package:spacelaunchnow_flutter/models/rocket/first_stage.dart';
import 'package:spacelaunchnow_flutter/models/rocket/launcher_configuration.dart';

class Rocket {
  final int id;
  final LauncherConfiguration configuration;
  final List<FirstStage> firstStages;

  Rocket({this.id, this.configuration, this.firstStages});

  factory Rocket.fromJson(Map<String, dynamic> json) {
    var firstStagesJson = json['first_stage'];
    List<FirstStage> listFirstStages = new List<FirstStage>.from(firstStagesJson);

    return Rocket(
        id: json['id'],
        configuration: new LauncherConfiguration.fromJson(json['configuration']),
        firstStages: listFirstStages
    );
  }
}