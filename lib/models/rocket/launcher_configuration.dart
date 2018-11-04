import 'package:spacelaunchnow_flutter/models/agency.dart';

class LauncherConfiguration {
  final int id;
  final String name;
  final String description;
  final String family;
  final String fullName;
  final String variant;
  final String image;
  final Agency launchServiceProvider;
  final int minStage;
  final int maxStage;
  final num length;
  final num diameter;
  final int launchMass;
  final int geoCapacity;
  final int leoCapacity;
  final int thrust;
  final String infoUrl;
  final String wikiUrl;

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
      this.launchServiceProvider});

  factory LauncherConfiguration.fromJson(Map<String, dynamic> json) {
    var image = json['image_url'];
    if (image == null) {
      image =
          "https:\/\/s3.amazonaws.com\/launchlibrary\/RocketImages\/placeholder_1920.png";
    }
    return LauncherConfiguration(
      id: json['id'],
      image: image,
      launchServiceProvider:
          new Agency.fromJson(json['launch_service_provider']),
      name: json['name'],
      description: json['description'],
      family: json['family'],
      fullName: json['fullName'],
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
    );
  }
}
