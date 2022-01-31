import 'package:logger/logger.dart';

class EventType {
  final int? id;
  final String? name;

  EventType({this.id, this.name});

  factory EventType.fromJson(Map<String, dynamic> json) {
    var logger = Logger();

    return EventType(
      id: json['id'],
      name: json['name'],
    );
  }
}
