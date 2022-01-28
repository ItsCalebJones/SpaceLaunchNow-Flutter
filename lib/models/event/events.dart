import 'dart:convert';

import 'event_list.dart';


class Events {
  final List<EventList>? events;
  final int? nextOffset;
  final int? count;

  Events({this.events, this.nextOffset, this.count});

  factory Events.fromJson(Map<String, dynamic> json) {

    int? offset;
    if (json['next'] != null) {
      Uri offsetUri = Uri.parse(json['next']);
      offset = int.parse(offsetUri.queryParameters['offset']!);
    }

    return new Events(
        events: new List<EventList>.from(json['results'].map((event) => new EventList.fromJson(event))),
        nextOffset: offset,
        count: json['count']
    );
  }
}