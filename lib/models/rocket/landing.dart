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
    LandingLocation? _location;
    if (locationJson != null) {
      _location = LandingLocation.fromJson(locationJson);
    }

    var landingTypeJson = json['type'];
    LandingType? _landingType;
    if (landingTypeJson != null) {
      _landingType = LandingType.fromJson(landingTypeJson);
    }

    return Landing(
      description: json['description'],
      attempt: json['attempt'],
      success: json['success'],
      location: _location,
      type: _landingType,
    );
  }
}
