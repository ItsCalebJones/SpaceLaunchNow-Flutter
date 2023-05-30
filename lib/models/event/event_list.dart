import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spacelaunchnow_flutter/models/date_precision.dart';
import 'package:spacelaunchnow_flutter/models/launch/list/launch_list.dart';
import 'package:spacelaunchnow_flutter/models/update.dart';

import 'event_type.dart';

class EventList {
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
  final Iterable<LaunchList>? launches;
  final DatePrecision? datePrecision;

  EventList({
    this.id,
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
    this.datePrecision,
  });

  static List<EventList>? allFromResponse(http.Response response) {
    var decodedJson =
        json.decode(utf8.decode(response.bodyBytes)).cast<String, dynamic>();

    return decodedJson['results']
        .cast<Map<String, dynamic>>()
        .map((obj) => EventList.fromJson(obj))
        .toList()
        .cast<EventList>();
  }

  factory EventList.fromJson(Map<String, dynamic> json) {
    List<Update> updates = <Update>[];
    var updatesJson = json['updates'];
    if (updatesJson != null) {
      updates = List<Update>.from(
          updatesJson.map((update) => Update.fromJson(update)));
    }

    List<LaunchList> launches = <LaunchList>[];
    var launchesJson = json['launches'];
    if (launchesJson != null) {
      launches = List<LaunchList>.from(
          launchesJson.map((launch) => LaunchList.fromJson(launch)));
    }
    var datePrecisionJson = json['date_precision'];

    DatePrecision? datePrecision;
    if (datePrecisionJson != null) {
      datePrecision = DatePrecision.fromJson(datePrecisionJson);
    }

    return EventList(
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
      launches: launches,
      updates: updates,
      datePrecision: datePrecision
    );
  }
}
