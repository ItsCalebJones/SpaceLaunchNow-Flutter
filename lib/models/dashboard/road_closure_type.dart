class RoadClosureType {
  final int? id;
  final String? name;

  RoadClosureType({this.id, this.name});

  factory RoadClosureType.fromJson(Map<String, dynamic> json) {
    return RoadClosureType(
      id: json['id'],
      name: json['name'],
    );
  }
}
