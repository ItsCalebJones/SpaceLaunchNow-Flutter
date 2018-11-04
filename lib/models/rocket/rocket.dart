import 'package:spacelaunchnow_flutter/models/rocket/first_stage.dart';
import 'package:spacelaunchnow_flutter/models/rocket/launcher_configuration.dart';

class Rocket {
  final int id;
  final LauncherConfiguration configuration;
  final Iterable<FirstStage> firstStages;

  Rocket({this.id, this.configuration, this.firstStages});

  factory Rocket.fromJson(Map<String, dynamic> json) {
    var firstStagesJson = json['first_stage'];
    final listFirstStages = (firstStagesJson as List).map((i) => new FirstStage.fromJson(i));
    for (final item in listFirstStages) {
      print(item.launcher.serialNumber);
    }

    return Rocket(
        id: json['id'],
        configuration: new LauncherConfiguration.fromJson(json['configuration']),
        firstStages: listFirstStages
    );
  }
}