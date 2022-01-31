import 'notice_type.dart';

class Notice {
  final int? id;
  final DateTime? date;
  final String? url;
  final NoticeType? type;

  Notice({this.id, this.date, this.type, this.url});

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: json['id'],
      date: DateTime.parse(json['date']),
      url: json['url'],
      type: NoticeType.fromJson(json['type']),
    );
  }
}
