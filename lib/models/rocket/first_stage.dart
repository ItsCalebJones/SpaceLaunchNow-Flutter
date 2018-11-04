import 'package:spacelaunchnow_flutter/models/rocket/landing.dart';
import 'package:spacelaunchnow_flutter/models/rocket/launcher.dart';

class FirstStage {
  final String type;
  final bool reused;
  final int flightNumber;
  final Launcher launcher;
  final Landing landing;

  FirstStage(
      {this.type, this.reused, this.flightNumber, this.launcher, this.landing});

  factory FirstStage.fromJson(Map<String, dynamic> json) {
    return FirstStage(
      type: json['type'],
      reused: json['reused'],
      flightNumber: json['launcher_flight_number'],
      launcher: new Launcher.fromJson(json['launcher']),
      landing: new Landing.fromJson(json['landing']),
    );
  }
}
