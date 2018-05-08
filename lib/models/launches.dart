import 'package:spacelaunchnow_flutter/models/launch.dart';

class Launches {
  final List<Launch> launches;
  final int total;
  final int offset;
  final int count;

  Launches({this.launches, this.total, this.offset, this.count});

  factory Launches.fromJson(Map<String, dynamic> json) {
    return new Launches(
        launches: new List<Launch>.from(json['launches'].map((launch) => new Launch.fromJson(launch))),
        total: json['total'],
        offset: json['offset'],
        count: json['count']
    );
  }
}