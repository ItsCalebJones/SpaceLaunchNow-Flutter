class RoadClosureType {
  final int id;
  final String name;

  RoadClosureType({this.id, this.name});

  factory RoadClosureType.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return new RoadClosureType(
        id: json['id'],
        name: json['name'],
      );
    } else {
      return null;
    }
  }
}
