import 'dart:convert';

import 'package:spacelaunchnow_flutter/models/agency_mini.dart';
import 'package:spacelaunchnow_flutter/models/launch/common/rocket_common.dart';
import 'package:spacelaunchnow_flutter/models/mission.dart';
import 'package:spacelaunchnow_flutter/models/pad.dart';
import 'package:spacelaunchnow_flutter/models/status.dart';
import 'package:spacelaunchnow_flutter/models/vidurls.dart';

import 'package:http/http.dart' as http;

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
    var decodedJson = json.decode(utf8.decode(response.bodyBytes)).cast<String, dynamic>();

    return decodedJson['results']
        .cast<Map<String, dynamic>>()
        .map((obj) => LaunchCommon.fromJson(obj))
        .toList()
        .cast<LaunchCommon>();
  }

  static LaunchCommon fromResponse(http.Response response) {
    var decodedJson = json.decode(utf8.decode(response.bodyBytes)).cast<String, dynamic>();
    return LaunchCommon.fromJson(decodedJson);
  }

  factory LaunchCommon.fromJson(Map<String, dynamic> json) {
    print(json);
    var mission;
    if (json['mission'] != null) {
      mission = new Mission.fromJson(json['mission']);
    }

    return new LaunchCommon(
      id: json['id'],
      name: json['name'],
      infographic: json['infographic'],
      image: json['image'],
      slug: json['slug'],
      status: new Status.fromJson(json['status']),
      windowStart: DateTime.parse(json['window_start']),
      windowEnd: DateTime.parse(json['window_end']),
      net: DateTime.parse(json['net']),
      probability: json['probability'],
      launchServiceProvider: new AgencyMini.fromJson(json['launch_service_provider']),
      rocket: new RocketCommon.fromJson(json['rocket']),
      pad: new Pad.fromJson(json['pad']),
      mission: mission,
    );
  }
}
