import 'package:spacelaunchnow_flutter/models/landing/landing_location.dart';
import 'package:spacelaunchnow_flutter/models/landing/landing_type.dart';

class Landing {
  final String? description;
  final bool? attempt;
  final bool? success;
  final LandingLocation? location;
  final LandingType? type;

  Landing(
      {this.description, this.attempt, this.success, this.location, this.type});

  factory Landing.fromJson(Map<String, dynamic> json) {
    var locationJson = json['location'];
    LandingLocation? location;
    if (locationJson != null) {
      location = LandingLocation.fromJson(locationJson);
    }

    var landingTypeJson = json['type'];
    LandingType? landingType;
    if (landingTypeJson != null) {
      landingType = LandingType.fromJson(landingTypeJson);
    }

    return Landing(
      description: json['description'],
      attempt: json['attempt'],
      success: json['success'],
      location: location,
      type: landingType,
    );
  }
}
