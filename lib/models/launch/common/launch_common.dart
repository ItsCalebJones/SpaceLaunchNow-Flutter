import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spacelaunchnow_flutter/models/agency_mini.dart';
import 'package:spacelaunchnow_flutter/models/launch/common/rocket_common.dart';
import 'package:spacelaunchnow_flutter/models/mission.dart';
import 'package:spacelaunchnow_flutter/models/pad.dart';
import 'package:spacelaunchnow_flutter/models/status.dart';

class LaunchCommon {
  final String? id;
  final String? name;
  final String? infographic;
  final String? image;
  final String? slug;
  final DateTime? windowStart;
  final DateTime? windowEnd;
  final DateTime? net;
  final int? probability;
  final Status? status;
  final RocketCommon? rocket;
  final AgencyMini? launchServiceProvider;
  final Pad? pad;
  final Mission? mission;

  const LaunchCommon(
      {this.id,
      this.name,
      this.status,
      this.windowStart,
      this.windowEnd,
      this.net,
      this.probability,
      this.rocket,
      this.pad,
      this.mission,
      this.launchServiceProvider,
      this.image,
      this.infographic,
      this.slug});

  static List<LaunchCommon>? allFromResponse(http.Response response) {
    var decodedJson =
        json.decode(utf8.decode(response.bodyBytes)).cast<String, dynamic>();

    return decodedJson['results']
        .cast<Map<String, dynamic>>()
        .map((obj) => LaunchCommon.fromJson(obj))
        .toList()
        .cast<LaunchCommon>();
  }

  static LaunchCommon fromResponse(http.Response response) {
    var decodedJson =
        json.decode(utf8.decode(response.bodyBytes)).cast<String, dynamic>();
    return LaunchCommon.fromJson(decodedJson);
  }

  factory LaunchCommon.fromJson(Map<String, dynamic> json) {
    var missionJson = json['mission'];
    Mission? mission;
    if (missionJson != null) {
      mission = Mission.fromJson(missionJson);
    }

    return LaunchCommon(
      id: json['id'],
      name: json['name'],
      infographic: json['infographic'],
      image: json['image'],
      slug: json['slug'],
      status: Status.fromJson(json['status']),
      windowStart: DateTime.parse(json['window_start']),
      windowEnd: DateTime.parse(json['window_end']),
      net: DateTime.parse(json['net']),
      probability: json['probability'],
      launchServiceProvider:
          AgencyMini.fromJson(json['launch_service_provider']),
      rocket: RocketCommon.fromJson(json['rocket']),
      pad: Pad.fromJson(json['pad']),
      mission: mission,
    );
  }
}
