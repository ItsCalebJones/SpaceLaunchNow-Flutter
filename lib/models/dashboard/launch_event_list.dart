import 'package:logger/logger.dart';

import '../event/event_list.dart';
import '../launch/list/launch_list.dart';

class LaunchEventList {
  final List<LaunchList>? launches;
  final List<EventList>? events;

  LaunchEventList({this.launches, this.events});

  factory LaunchEventList.fromJson(Map<String, dynamic> json) {
    var logger = Logger();
    return LaunchEventList(
      launches: List<LaunchList>.from(
          json['launches'].map((launch) => LaunchList.fromJson(launch))),
      events: List<EventList>.from(
          json['events'].map((event) => EventList.fromJson(event))),
    );
  }
}
