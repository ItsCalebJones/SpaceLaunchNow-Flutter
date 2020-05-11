import 'crew.dart';
import 'spacecraft.dart';

class SpacecraftStage {
  final int id;
  final String destination;
  final Iterable<Crew> launchCrew;
  final Iterable<Crew> onboardCrew;
  final Iterable<Crew> landingCrew;
  final Spacecraft spacecraft;

  SpacecraftStage({this.id, this.destination, this.launchCrew, this.landingCrew,
  this.onboardCrew, this.spacecraft});

  factory SpacecraftStage.fromJson(Map<String, dynamic> json) {
    return SpacecraftStage(
      id: json['id'],
      destination: json['destination'],
      launchCrew: new List<Crew>.from(json['launch_crew'].map((crew) => new Crew.fromJson(crew))),
      onboardCrew: new List<Crew>.from(json['onboard_crew'].map((crew) => new Crew.fromJson(crew))),
      landingCrew: new List<Crew>.from(json['landing_crew'].map((crew) => new Crew.fromJson(crew))),
      spacecraft: new Spacecraft.fromJson(json['spacecraft'])
    );
  }
}