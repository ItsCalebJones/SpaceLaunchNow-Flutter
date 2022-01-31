class NoticeType {
  final int? id;
  final String? name;

  NoticeType({this.id, this.name});

  factory NoticeType.fromJson(Map<String, dynamic> json) {
    return NoticeType(
      id: json['id'],
      name: json['name'],
    );
  }
}
