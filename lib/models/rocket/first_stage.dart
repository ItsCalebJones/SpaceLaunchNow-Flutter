import 'package:spacelaunchnow_flutter/models/rocket/landing.dart';
import 'package:spacelaunchnow_flutter/models/rocket/launcher.dart';

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
      {this.type,
      this.reused,
      this.flightNumber,
      this.launcher,
      this.landing,
      this.previousFlight,
      this.turnAround,
      this.previousFlightUUID});

  factory FirstStage.fromJson(Map<String, dynamic> json) {
    var landingJson = json['landing'];
    Landing? _landing;
    if (landingJson != null) {
      _landing = Landing.fromJson(landingJson);
    }

    var launcherJson = json['launcher'];
    Launcher? _launcher;
    if (launcherJson != null) {
      _launcher = Launcher.fromJson(launcherJson);
    }

    String? launch;
    String? previousFlightUUID;
    if (json['previous_flight'] != null) {
      launch = json['previous_flight']['name'];
      previousFlightUUID = json['previous_flight']['id'];
    }

    return FirstStage(
        type: json['type'],
        reused: json['reused'],
        flightNumber: json['launcher_flight_number'],
        launcher: _launcher,
        landing: _landing,
        turnAround: json['turn_around_time_days'],
        previousFlight: launch,
        previousFlightUUID: previousFlightUUID);
  }
}
