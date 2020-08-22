class Orbit {
  final int id;
  final String name;
  final String abbreviation;

  Orbit({this.id, this.name, this.abbreviation});

  factory Orbit.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return new Orbit(
        id: json['id'],
        name: json['name'],
        abbreviation: json['abbrev'],
      );
    } else {
      return null;
    }
  }
}
