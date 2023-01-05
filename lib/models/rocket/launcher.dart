import 'package:spacelaunchnow_flutter/models/rocket/launcher_configuration.dart';

class Launcher {
  final int? id;
  final String? details;
  final bool? flightProven;
  final String? serialNumber;
  final String? status;
  final int? previousFlights;
  final String? image;
  final LauncherConfiguration? launcherConfiguration;

  Launcher(
      {this.id,
      this.details,
      this.flightProven,
      this.serialNumber,
      this.status,
      this.previousFlights,
      this.image,
      this.launcherConfiguration});

  factory Launcher.fromJson(Map<String, dynamic> json) {
    var launcherConfigJson = json['launcher_config'];
    LauncherConfiguration? launcherConfig;
    if (launcherConfigJson != null) {
      launcherConfig = LauncherConfiguration.fromJson(launcherConfigJson);
    }

    return Launcher(
      id: json['id'],
      details: json['details'],
      flightProven: json['flight_proven'],
      serialNumber: json['serial_number'],
      status: json['status'],
      previousFlights: json['previous_flights'],
      image: json['image_url'],
      launcherConfiguration: launcherConfig,
    );
  }
}
