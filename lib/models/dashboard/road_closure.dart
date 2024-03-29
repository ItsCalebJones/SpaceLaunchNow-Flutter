import 'road_closure_type.dart';

class RoadClosure {
  final int? id;
  final String? title;
  final RoadClosureType? status;
  final DateTime? windowStart;
  final DateTime? windowEnd;

  RoadClosure(
      {this.id, this.title, this.status, this.windowStart, this.windowEnd});

  factory RoadClosure.fromJson(Map<String, dynamic> json) {
    return RoadClosure(
      id: json['id'],
      title: json['title'],
      status: RoadClosureType.fromJson(json['status']),
      windowStart: DateTime.parse(json['window_start']),
      windowEnd: DateTime.parse(json['window_end']),
    );
  }
}
