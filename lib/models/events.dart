import 'dart:convert';

import 'package:spacelaunchnow_flutter/models/event.dart';

class Events {
  final List<Event> events;
  final int nextOffset;
  final int count;

  Events({this.events, this.nextOffset, this.count});

  factory Events.fromJson(Map<String, dynamic> json) {

    int offset;
    if (json['next'] != null) {
      Uri offsetUri = Uri.parse(json['next']);
      offset = int.parse(offsetUri.queryParameters['offset']);
    }

    return new Events(
        events: new List<Event>.from(json['results'].map((event) => new Event.fromJson(event))),
        nextOffset: offset,
        count: json['count']
    );
  }
}