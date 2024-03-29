import 'dart:convert';

import 'package:spacelaunchnow_flutter/models/date_precision.dart';
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
  final DatePrecision? netPrecision;

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
      this.netPrecision,
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
    var image = json['image'] ??
        "https://spacelaunchnow-prod-east.nyc3.digitaloceanspaces.com/static/home/img/placeholder.jpg";
    var netPrecisionJson = json['net_precision'];

    DatePrecision? netPrecision;
    if (netPrecisionJson != null) {
      netPrecision = DatePrecision.fromJson(netPrecisionJson);
    }

    return LaunchList(
      id: json['id'],
      name: json['name'],
      status: Status.fromJson(json['status']),
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
      netPrecision: netPrecision,
    );
  }
}
