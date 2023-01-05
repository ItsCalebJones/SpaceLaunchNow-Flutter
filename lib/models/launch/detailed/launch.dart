import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:spacelaunchnow_flutter/models/mission.dart';
import 'package:spacelaunchnow_flutter/models/pad.dart';
import 'package:spacelaunchnow_flutter/models/rocket/rocket.dart';
import 'package:spacelaunchnow_flutter/models/status.dart';
import 'package:spacelaunchnow_flutter/models/update.dart';
import 'package:spacelaunchnow_flutter/models/vidurls.dart';
import 'package:spacelaunchnow_flutter/models/agency.dart';

class Launch {
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
  final List<Update>? updates;
  final Rocket? rocket;
  final Agency? launchServiceProvider;
  final Pad? pad;
  final Mission? mission;
  final List<VidURL>? vidURLs;

  const Launch(
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
      this.vidURLs,
      this.updates,
      this.launchServiceProvider,
      this.image,
      this.infographic,
      this.slug});

  static List<Launch>? allFromResponse(http.Response response) {
    var decodedJson =
        json.decode(utf8.decode(response.bodyBytes)).cast<String, dynamic>();

    return decodedJson['results']
        .cast<Map<String, dynamic>>()
        .map((obj) => Launch.fromJson(obj))
        .toList()
        .cast<Launch>();
  }

  static Launch fromResponse(http.Response response) {
    var decodedJson =
        json.decode(utf8.decode(response.bodyBytes)).cast<String, dynamic>();
    return Launch.fromJson(decodedJson);
  }

  factory Launch.fromJson(Map<String, dynamic> json) {
    var missionJson = json['mission'];
    var logger = Logger();
    logger.d(json);

    Mission? mission;
    if (missionJson != null) {
      mission = Mission.fromJson(missionJson);
    }



    return Launch(
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
      launchServiceProvider: Agency.fromJson(json['launch_service_provider']),
      rocket: Rocket.fromJson(json['rocket']),
      pad: Pad.fromJson(json['pad']),
      mission: mission,
      vidURLs: List<VidURL>.from(
          json['vidURLs']?.map((vidURL) => VidURL.fromJson(vidURL)) ??
              <VidURL>[]),
      updates: List<Update>.from(
          json['updates'].map((update) => Update.fromJson(update)) ??
              <Update>[]),
    );
  }
}
