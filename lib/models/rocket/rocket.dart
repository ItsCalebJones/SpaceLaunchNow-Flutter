import 'package:logger/logger.dart';
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
    var logger = Logger();

    logger.d("Rocket");
    logger.d(json);
    List<FirstStage> firstStages = <FirstStage>[];
    var firstStageJson = json['updates'];
    if (firstStageJson != null) {
      firstStages.addAll(
          firstStageJson.map((firstStage) => FirstStage.fromJson(firstStage)));
    }

    var spacecraftStageJson = json['spacecraft_stage'];
    SpacecraftStage? spacecraftStage;
    if (spacecraftStageJson != null) {
      spacecraftStage = SpacecraftStage.fromJson(spacecraftStageJson);
    }

    return Rocket(
        id: json['id'],
        configuration: LauncherConfiguration.fromJson(json['configuration']),
        firstStages: firstStages,
        spacecraftStage: spacecraftStage);
  }
}
