import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spacelaunchnow_flutter/models/launch/common/launch_common.dart';
import 'package:spacelaunchnow_flutter/models/program.dart';
import 'package:spacelaunchnow_flutter/models/update.dart';
import 'event_type.dart';

class Event {
  final int? id;
  final String? name;
  final String? description;
  final EventType? type;
  final String? location;
  final String? newsUrl;
  final String? videoUrl;
  final String? featureImage;
  final List<Update>? updates;
  final DateTime? date;
  final DateTime? net;
  final List<LaunchCommon>? launches;
  final List<Program>? programs;

  Event(
      {this.id,
      this.name,
      this.description,
      this.type,
      this.location,
      this.newsUrl,
      this.videoUrl,
      this.featureImage,
      this.date,
      this.launches,
      this.net,
      this.updates,
      this.programs});

  static List<Event>? allFromResponse(http.Response response) {
    var decodedJson =
        json.decode(utf8.decode(response.bodyBytes)).cast<String, dynamic>();

    return decodedJson['results']
        .cast<Map<String, dynamic>>()
        .map((obj) => Event.fromJson(obj))
        .toList()
        .cast<Event>();
  }

  static Event fromResponse(http.Response response) {
    var decodedJson =
        json.decode(utf8.decode(response.bodyBytes)).cast<String, dynamic>();
    return Event.fromJson(decodedJson);
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        id: json['id'],
        name: json['name'],
        type: EventType.fromJson(json['type']),
        description: json['description'],
        location: json['location'],
        newsUrl: json['news_url'],
        videoUrl: json['video_url'],
        featureImage: json['feature_image'],
        date: DateTime.parse(json['date']),
        net: DateTime.parse(json['date']),
        launches: List<LaunchCommon>.from(
            json['launches'].map((launch) => LaunchCommon.fromJson(launch)) ??
              <LaunchCommon>[]),
        updates: List<Update>.from(
            json['updates'].map((update) => Update.fromJson(update)) ??
              <Update>[]),
        programs: List<Program>.from(
            json['program'].map((program) => Program.fromJson(program)) ??
              <Program>[])
    );
  }
}
