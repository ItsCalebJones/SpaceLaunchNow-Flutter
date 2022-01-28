import 'package:spacelaunchnow_flutter/models/location.dart';

class Pad {
  final int id;
  final String name;
  final String infoURL;
  final String wikiURL;
  final String mapURL;
  final String mapImage;
  final num latitude;
  final num longitude;
  final Location location;

  Pad({this.id, this.name, this.infoURL, this.wikiURL, this.mapURL,
    this.latitude, this.longitude, this.location, this.mapImage});

  factory Pad.fromJson(Map<String, dynamic> json) {
    print(json);
    return new Pad(
      id: json['id'],
      name: json['name'],
      infoURL: json['info_url'],
      wikiURL: json['wiki_url'],
      mapURL: json['map_url'],
      mapImage: json['map_image'],
      latitude: num.parse(json['latitude']),
      longitude: num.parse(json['longitude']),
      location: new Location.fromJson(json['location'])
    );
  }
}