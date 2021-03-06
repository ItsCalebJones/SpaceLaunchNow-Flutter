import 'package:spacelaunchnow_flutter/models/landing/landing_location.dart';
import 'package:spacelaunchnow_flutter/models/landing/landing_type.dart';

class Landing {
  final String description;
  final bool attempt;
  final bool success;
  final LandingLocation location;
  final LandingType type;

  Landing({this.description, this.attempt, this.success, this.location, this.type});

  factory Landing.fromJson(Map<String, dynamic> json) {
    var location;
    if (json['location'] != null) {
      location = new LandingLocation.fromJson(json['location']);
    }

    var type;
    if (json['type'] != null) {
      type = new LandingType.fromJson(json['type']);
    }
    return Landing(
      description: json['description'],
      attempt: json['attempt'],
      success: json['success'],
      location: location,
      type: type,
    );
  }
}
