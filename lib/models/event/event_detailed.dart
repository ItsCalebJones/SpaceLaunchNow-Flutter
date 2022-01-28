import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spacelaunchnow_flutter/models/launch/common/launch_common.dart';

import '../program.dart';
import '../update.dart';
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
  final Iterable<LaunchCommon>? launches;
  final Iterable<Program>? programs;

  Event({this.id, this.name, this.description, this.type, this.location,
    this.newsUrl, this.videoUrl, this.featureImage, this.date, this.launches,
    this.net, this.updates, this.programs});

  static List<Event>? allFromResponse(http.Response response) {
    var decodedJson = json.decode(utf8.decode(response.bodyBytes)).cast<String, dynamic>();

    return decodedJson['results']
        .cast<Map<String, dynamic>>()
        .map((obj) => Event.fromJson(obj))
        .toList()
        .cast<Event>();
  }

  static Event fromResponse(http.Response response) {
    var decodedJson = json.decode(utf8.decode(response.bodyBytes)).cast<String, dynamic>();
    return Event.fromJson(decodedJson);
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    print (json);
    var _updates;

    if (json['updates'] != null) {
      _updates = new List<Update>.from(json['updates'].map((update) => new Update.fromJson(update)));
    }

    var _programs;

    if (json['program'] != null) {
      _programs = new List<Program>.from(json['program'].map((program) => new Program.fromJson(program)));
    }

    return new Event(
        id: json['id'],
        name: json['name'],
        type: new EventType.fromJson(json['type']),
        description: json['description'],
        location: json['location'],
        newsUrl: json['news_url'],
        videoUrl: json['video_url'],
        featureImage: json['feature_image'],
        date: DateTime.parse(json['date']),
        net: DateTime.parse(json['date']),
        launches: new List<LaunchCommon>.from(json['launches'].map((launch) => new LaunchCommon.fromJson(launch))),
        updates: _updates,
        programs: _programs
    );
  }
}

