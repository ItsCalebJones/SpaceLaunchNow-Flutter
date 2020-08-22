import '../launch_list.dart';
import '../event.dart';

class LaunchEventList {
  final List<LaunchList> launches;
  final List<Event> events;

  LaunchEventList({this.launches, this.events});

  factory LaunchEventList.fromJson(Map<String, dynamic> json) {
    return new LaunchEventList(
        launches: new List<LaunchList>.from(json['launches'].map((launch) => new LaunchList.fromJson(launch))),
        events: new List<Event>.from(json['events'].map((event) => new Event.fromJson(event))),
    );
  }
}