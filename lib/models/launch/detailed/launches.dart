import 'package:spacelaunchnow_flutter/models/launch/detailed/launch.dart';

class Launches {
  final List<Launch>? launches;
  final int? nextOffset;
  final int? count;

  Launches({this.launches, this.nextOffset, this.count});

  factory Launches.fromJson(Map<String, dynamic> json) {
    int? offset;
    if (json['next'] != null) {
      Uri offsetUri = Uri.parse(json['next']);
      offset = int.parse(offsetUri.queryParameters['offset']!);
    }

    return Launches(
        launches: List<Launch>.from(
            json['results'].map((launch) => Launch.fromJson(launch))),
        nextOffset: offset,
        count: json['count']);
  }
}
