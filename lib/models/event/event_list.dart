import 'dart:convert';

import 'package:spacelaunchnow_flutter/models/launch/list/launch_list.dart';
import 'package:http/http.dart' as http;
import 'package:spacelaunchnow_flutter/models/update.dart';

import 'event_type.dart';

class EventList {
  final int id;
  final String name;
  final String description;
  final EventType type;
  final String location;
  final String newsUrl;
  final String videoUrl;
  final String featureImage;
  final List<Update> updates;
  final DateTime date;
  final DateTime net;
  final Iterable<LaunchList> launches;

  EventList({this.id, this.name, this.description, this.type, this.location,
    this.newsUrl, this.videoUrl, this.featureImage, this.date, this.launches,
    this.net, this.updates,});

  static List<EventList> allFromResponse(http.Response response) {
    var decodedJson = json.decode(utf8.decode(response.bodyBytes)).cast<String, dynamic>();

    return decodedJson['results']
        .cast<Map<String, dynamic>>()
        .map((obj) => EventList.fromJson(obj))
        .toList()
        .cast<EventList>();
  }

  factory EventList.fromJson(Map<String, dynamic> json) {
    print (json);
    var _updates;

    if (json['updates'] != null) {
      _updates = new List<Update>.from(json['updates'].map((update) => new Update.fromJson(update)));
    }

    return new EventList(
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
        launches: new List<LaunchList>.from(json['launches'].map((launch) => new LaunchList.fromJson(launch))),
        updates: _updates,
    );
  }
}

