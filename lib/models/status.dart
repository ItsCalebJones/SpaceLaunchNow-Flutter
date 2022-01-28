class Status {
  final int? id;
  final String? name;
  final String? abbrev;
  final String? description;

  Status({this.id, this.name, this.abbrev, this.description});

  factory Status.fromJson(Map<String, dynamic> json) {
    return new Status(
      id: json['id'],
      name: json['name'],
      abbrev: json['abbrev'],
      description: json['description']
    );
  }
}