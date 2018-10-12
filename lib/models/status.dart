class Status {
  final int id;
  final String name;

  Status({this.id, this.name});

  factory Status.fromJson(Map<String, dynamic> json) {
    return new Status(
      id: json['id'],
      name: json['name']
    );
  }
}