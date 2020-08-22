class NoticeType {
  final int id;
  final String name;

  NoticeType({this.id, this.name});

  factory NoticeType.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return new NoticeType(
        id: json['id'],
        name: json['name'],
      );
    } else {
      return null;
    }
  }
}
