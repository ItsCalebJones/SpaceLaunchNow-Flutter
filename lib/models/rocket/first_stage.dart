import 'package:spacelaunchnow_flutter/models/rocket/landing.dart';
import 'package:spacelaunchnow_flutter/models/rocket/launcher.dart';

import '../launch/detailed/launch.dart';

class FirstStage {
  final String? type;
  final int? turnAround;
  final bool? reused;
  final int? flightNumber;
  final Launcher? launcher;
  final Landing? landing;
  final String? previousFlight;
  final String? previousFlightUUID;

  FirstStage(
      {this.type, this.reused, this.flightNumber, this.launcher, this.landing,
      this.previousFlight, this.turnAround, this.previousFlightUUID});

  factory FirstStage.fromJson(Map<String, dynamic> json) {
    var landing;
    if (json['landing'] != null){
      landing = new Landing.fromJson(json['landing']);
    }

    var launcher;
    if (json['launcher'] != null){
      launcher = new Launcher.fromJson(json['launcher']);
    }

    var launch;
    var previousFlightUUID;
    if (json['previous_flight'] != null){
      launch = json['previous_flight']['name'];
      previousFlightUUID = json['previous_flight']['id'];
    }

    return FirstStage(
      type: json['type'],
      reused: json['reused'],
      flightNumber: json['launcher_flight_number'],
      launcher: launcher,
      landing: landing,
      turnAround: json['turn_around_time_days'],
      previousFlight: launch,
      previousFlightUUID: previousFlightUUID
    );
  }
}
