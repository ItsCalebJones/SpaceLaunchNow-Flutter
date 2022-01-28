import 'package:spacelaunchnow_flutter/models/rocket/first_stage.dart';
import 'package:spacelaunchnow_flutter/models/rocket/launcher_configuration.dart';
import 'package:spacelaunchnow_flutter/models/rocket/spacecraft/spacecraft_stage.dart';

class Rocket {
  final int? id;
  final LauncherConfiguration? configuration;
  final Iterable<FirstStage>? firstStages;
  final SpacecraftStage? spacecraftStage;

  Rocket({this.id, this.configuration, this.firstStages, this.spacecraftStage});

  factory Rocket.fromJson(Map<String, dynamic> json) {
    var firstStagesJson = json['launcher_stage'];
    final listFirstStages = (firstStagesJson as List).map((i) => new FirstStage.fromJson(i));
    for (final item in listFirstStages) {
      print(item.launcher!.serialNumber);
    }

    var spacecraftStage;
    if (json['spacecraft_stage'] != null){
      spacecraftStage = new SpacecraftStage.fromJson(json['spacecraft_stage']);
    }

    print("Parsing Rocket...");

    return Rocket(
        id: json['id'],
        configuration: new LauncherConfiguration.fromJson(json['configuration']),
        firstStages: listFirstStages,
        spacecraftStage: spacecraftStage
    );
  }
}