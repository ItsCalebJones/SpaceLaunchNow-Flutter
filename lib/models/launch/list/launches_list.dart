import 'package:spacelaunchnow_flutter/models/launch/list/launch_list.dart';

class LaunchesList {
  final List<LaunchList> launches;
  final int nextOffset;
  final int count;

  LaunchesList({this.launches, this.nextOffset, this.count});

  factory LaunchesList.fromJson(Map<String, dynamic> json) {

    int offset;
    if (json['next'] != null) {
      Uri offsetUri = Uri.parse(json['next']);
      offset = int.parse(offsetUri.queryParameters['offset']);
    }

    return new LaunchesList(
        launches: new List<LaunchList>.from(json['results'].map((launch) => new LaunchList.fromJson(launch))),
        nextOffset: offset,
        count: json['count']
    );
  }
}