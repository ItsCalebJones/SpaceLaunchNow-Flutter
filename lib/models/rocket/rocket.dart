import 'package:spacelaunchnow_flutter/models/rocket/first_stage.dart';
import 'package:spacelaunchnow_flutter/models/rocket/launcher_configuration.dart';
import 'package:spacelaunchnow_flutter/models/rocket/spacecraft/spacecraft_stage.dart';

class Rocket {
  final int? id;
  final LauncherConfiguration? configuration;
  final List<FirstStage>? firstStages;
  final SpacecraftStage? spacecraftStage;

  Rocket({this.id, this.configuration, this.firstStages, this.spacecraftStage});

  factory Rocket.fromJson(Map<String, dynamic> json) {
    print("Rocket");
    print(json);
    List<FirstStage> _firstStages = <FirstStage>[];
    var firstStageJson = json['updates'];
    if (firstStageJson != null) {
      _firstStages.addAll(
          firstStageJson.map((firstStage) => FirstStage.fromJson(firstStage)));
    }

    var spacecraftStageJson = json['spacecraft_stage'];
    SpacecraftStage? _spacecraftStage;
    if (spacecraftStageJson != null) {
      _spacecraftStage = SpacecraftStage.fromJson(spacecraftStageJson);
    }

    return Rocket(
        id: json['id'],
        configuration: LauncherConfiguration.fromJson(json['configuration']),
        firstStages: _firstStages,
        spacecraftStage: _spacecraftStage);
  }
}
