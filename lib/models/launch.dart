import 'dart:convert';

import 'package:spacelaunchnow_flutter/models/location.dart';
import 'package:spacelaunchnow_flutter/models/mission.dart';
import 'package:spacelaunchnow_flutter/models/pad.dart';
import 'package:spacelaunchnow_flutter/models/rocket/rocket.dart';
import 'package:spacelaunchnow_flutter/models/status.dart';

class Launch {
  final String id;
  final String name;
  final DateTime windowStart;
  final DateTime windowEnd;
  final DateTime net;
  final int probability;
  final Status status;
  final Rocket rocket;
  final Pad pad;
  final Mission mission;
  final String vidURL;
  const Launch({this.id, this.name, this.status, this.windowStart, this.windowEnd,
    this.net,  this.probability, this.rocket, this.pad, this.mission, this.vidURL});

  static List<Launch> allFromResponse(String response) {
    var decodedJson = json.decode(response).cast<String, dynamic>();

    return decodedJson['results']
        .cast<Map<String, dynamic>>()
        .map((obj) => Launch.fromJson(obj))
        .toList()
        .cast<Launch>();
  }

  static Launch fromResponse(String response) {
    var decodedJson = json.decode(response).cast<String, dynamic>();
    return Launch.fromJson(decodedJson);
  }

  factory Launch.fromJson(Map<String, dynamic> json) {
    print (json);
    String vidURL;
    if (json['vidURLs'].length > 0){
      vidURL = json['vidURLs'][0];
    }
    var mission;
    if (json['mission'] != null){
      mission = new Mission.fromJson(json['mission']);
    }

    return new Launch(
      id: json['id'],
      name: json['name'],
      status: new Status.fromJson(json['status']),
      windowStart: DateTime.parse(json['window_start']),
      windowEnd: DateTime.parse(json['window_end']),
      net: DateTime.parse(json['net']),
      probability: json['probability'],
      rocket: new Rocket.fromJson(json['rocket']),
      pad: new Pad.fromJson(json['pad']),
      mission: mission,
      vidURL: vidURL,
    );
  }
}