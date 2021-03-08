import '../launch/list/launch_list.dart';
import '../event/event_list.dart';

class LaunchEventList {
  final List<LaunchList> launches;
  final List<EventList> events;

  LaunchEventList({this.launches, this.events});

  factory LaunchEventList.fromJson(Map<String, dynamic> json) {
    return new LaunchEventList(
        launches: new List<LaunchList>.from(json['launches'].map((launch) => new LaunchList.fromJson(launch))),
        events: new List<EventList>.from(json['events'].map((event) => new EventList.fromJson(event))),
    );
  }
}