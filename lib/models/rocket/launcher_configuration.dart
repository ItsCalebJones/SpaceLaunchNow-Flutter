import 'package:spacelaunchnow_flutter/models/agency.dart';

class LauncherConfiguration {
  final int id;
  final String image;
  final Agency launchServiceProvider;

  LauncherConfiguration({this.id, this.image, this.launchServiceProvider});

  factory LauncherConfiguration.fromJson(Map<String, dynamic> json) {
    var image = json['image_url'];
    if (image == null) {
      image = "https:\/\/s3.amazonaws.com\/launchlibrary\/RocketImages\/placeholder_1920.png";
    }
    return LauncherConfiguration(
        id: json['id'],
        image: image,
        launchServiceProvider: new Agency.fromJson(json['launch_service_provider'])
    );
  }
}
