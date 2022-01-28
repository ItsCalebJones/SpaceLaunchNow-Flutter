import 'dart:convert';

import 'package:spacelaunchnow_flutter/models/location.dart';
import 'package:spacelaunchnow_flutter/models/mission.dart';
import 'package:spacelaunchnow_flutter/models/pad.dart';
import 'package:spacelaunchnow_flutter/models/rocket/rocket.dart';
import 'package:spacelaunchnow_flutter/models/status.dart';

class LaunchList {
  final String? id;
  final String? name;
  final DateTime? windowStart;
  final DateTime? windowEnd;
  final DateTime? net;
  final Status? status;
  final String? image;
  final String? location;
  final String? mission;
  final String? missionType;
  final String? landing;
  final int? landingSuccess;
  final String? launcher;
  final String? orbit;
  final String? pad;

  const LaunchList(
      {this.id,
      this.name,
      this.status,
      this.windowStart,
      this.windowEnd,
      this.net,
      this.image,
      this.pad,
      this.location,
      this.mission,
      this.missionType,
      this.landing,
      this.landingSuccess,
      this.launcher,
      this.orbit});

  static List<LaunchList>? allFromResponse(String response) {
    var decodedJson = json.decode(response).cast<String, dynamic>();

    return decodedJson['results']
        .cast<Map<String, dynamic>>()
        .map((obj) => LaunchList.fromJson(obj))
        .toList()
        .cast<LaunchList>();
  }

  factory LaunchList.fromJson(Map<String, dynamic> json) {
    var image = json['image'];
    if (image == null) {
      image = "https://spacelaunchnow-prod-east.nyc3.digitaloceanspaces.com/static/home/img/placeholder.jpg";
    }

    return new LaunchList(
      id: json['id'],
      name: json['name'],
      status: new Status.fromJson(json['status']),
      windowStart: DateTime.parse(json['window_start']),
      windowEnd: DateTime.parse(json['window_end']),
      net: DateTime.parse(json['net']),
      image: image,
      location: json['location'],
      pad: json['pad'],
      mission: json['mission'],
      missionType: json['mission_type'],
      landing: json['landing'],
      landingSuccess: json['landing_success'],
      launcher: json['launcher'],
      orbit: json['orbit'],

    );
  }
}
