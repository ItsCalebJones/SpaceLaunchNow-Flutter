import 'package:spacelaunchnow_flutter/models/location.dart';

class Pad {
  final int id;
  final String name;
  final String infoURL;
  final String wikiURL;
  final String mapURL;
  final num latitude;
  final num longitude;
  final Location location;

  Pad({this.id, this.name, this.infoURL, this.wikiURL, this.mapURL,
    this.latitude, this.longitude, this.location});

  factory Pad.fromJson(Map<String, dynamic> json) {
    return new Pad(
      id: json['id'],
      name: json['name'],
      infoURL: json['infoURL'],
      wikiURL: json['wikiURL'],
      mapURL: json['mapURL'],
      latitude: num.parse(json['latitude']),
      longitude: num.parse(json['longitude']),
      location: new Location.fromJson(json['location'])
    );
  }
}