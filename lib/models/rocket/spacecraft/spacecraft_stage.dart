import 'package:logger/logger.dart';

import 'crew.dart';
import 'spacecraft.dart';

class SpacecraftStage {
  final int? id;
  final String? destination;
  final Iterable<Crew>? launchCrew;
  final Iterable<Crew>? onboardCrew;
  final Iterable<Crew>? landingCrew;
  final Spacecraft? spacecraft;

  SpacecraftStage(
      {this.id,
      this.destination,
      this.launchCrew,
      this.landingCrew,
      this.onboardCrew,
      this.spacecraft});

  factory SpacecraftStage.fromJson(Map<String, dynamic> json) {
    var logger = Logger();

    return SpacecraftStage(
        id: json['id'],
        destination: json['destination'],
        launchCrew: List<Crew>.from(
            json['launch_crew'].map((crew) => Crew.fromJson(crew))),
        onboardCrew: List<Crew>.from(
            json['onboard_crew'].map((crew) => Crew.fromJson(crew))),
        landingCrew: List<Crew>.from(
            json['landing_crew'].map((crew) => Crew.fromJson(crew))),
        spacecraft: Spacecraft.fromJson(json['spacecraft']));
  }
}
