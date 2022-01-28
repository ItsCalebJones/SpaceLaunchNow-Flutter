import 'package:spacelaunchnow_flutter/models/agency.dart';

class LauncherConfiguration {
  final int? id;
  final String? name;
  final String? description;
  final String? family;
  final String? fullName;
  final String? variant;
  final String? image;
  final Agency? manufacturer;
  final int? minStage;
  final int? maxStage;
  final num? length;
  final num? diameter;
  final int? launchMass;
  final int? geoCapacity;
  final int? leoCapacity;
  final int? thrust;
  final int? totalLaunchCount;
  final int? consecutiveSuccessfulLaunches;
  final int? successfulLaunches;
  final int? failedLaunches;
  final int? pendingLaunches;
  final String? infoUrl;
  final String? wikiUrl;

  LauncherConfiguration(
      {this.name,
      this.description,
      this.family,
      this.fullName,
      this.variant,
      this.minStage,
      this.maxStage,
      this.length,
      this.diameter,
      this.launchMass,
      this.geoCapacity,
      this.leoCapacity,
      this.thrust,
      this.infoUrl,
      this.wikiUrl,
      this.id,
      this.image,
      this.manufacturer,
      this.consecutiveSuccessfulLaunches,
      this.totalLaunchCount,
      this.successfulLaunches,
      this.failedLaunches,
      this.pendingLaunches});

  factory LauncherConfiguration.fromJson(Map<String, dynamic> json) {
    var image = json['image_url'];
    if (image == null) {
      image =
          "";
    }
    print(json);

    return LauncherConfiguration(
      id: json['id'],
      image: image,
      manufacturer: new Agency.fromJson(json['manufacturer']),
      name: json['name'],
      description: json['description'],
      family: json['family'],
      fullName: json['full_name'],
      variant: json['variant'],
      minStage: json['min_stage'],
      maxStage: json['max_stage'],
      length: json['length'],
      diameter: json['diameter'],
      launchMass: json['launch_mass'],
      geoCapacity: json['geo_capacity'],
      leoCapacity: json['leo_capacity'],
      thrust: json['to_thrust'],
      infoUrl: json['info_url'],
      wikiUrl: json['wiki_url'],
      consecutiveSuccessfulLaunches: json['consecutive_successful_launches'],
      totalLaunchCount: json['total_launch_count'],
      successfulLaunches: json['successful_launches'],
      failedLaunches: json['failed_launches'],
      pendingLaunches: json['pending_launches'],
    );
  }
}
