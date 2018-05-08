import 'package:spacelaunchnow_flutter/models/pad.dart';

class Location {
  final int id;
  final String name;
  final String countryCode;
  final String infoURL;
  final String wikiURL;
  final List<Pad> pads;

  Location({this.id, this.name,  this.countryCode,  this.infoURL, this.wikiURL, this.pads});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      countryCode: json['countryCode'],
      infoURL: json['infoURL'],
      wikiURL: json['wikiURL'],
      pads: new List<Pad>.from(json['pads'].map((location) => new Pad.fromJson(location))),
    );
  }
}