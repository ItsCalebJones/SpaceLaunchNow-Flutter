import 'package:spacelaunchnow_flutter/models/agency.dart';
import 'package:spacelaunchnow_flutter/models/location.dart';
import 'package:spacelaunchnow_flutter/models/rocket.dart';

class Launch {
  final int id;
  final String name;
  final DateTime windowStart;
  final DateTime windowEnd;
  final DateTime net;
//  final List<String> vidURLs;
  final int probability;
  final int status;
  final Agency launchServiceProvider;
  final Rocket rocket;
  final Location location;

  Launch({this.id, this.name, this.status, this.windowStart, this.windowEnd,
    this.net,  this.probability, this.launchServiceProvider,
    this.rocket, this.location});

  factory Launch.fromJson(Map<String, dynamic> json) {
    return new Launch(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      windowStart: DateTime.parse(json['isostart']),
      windowEnd: DateTime.parse(json['isoend']),
      net: DateTime.parse(json['isonet']),
//      vidURLs: new List<String>.from(json['launches']),
      probability: json['probability'],
      launchServiceProvider: new Agency.fromJson(json['lsp']),
      rocket: new Rocket.fromJson(json['rocket']),
      location: new Location.fromJson(json['location']),
    );
  }
}