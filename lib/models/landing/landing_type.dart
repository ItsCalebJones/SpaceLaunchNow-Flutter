class LandingType {
  final String name;
  final String abbrev;
  final String description;

  LandingType({this.name, this.abbrev, this.description});

  factory LandingType.fromJson(Map<String, dynamic> json) {
    return LandingType(
      name: json['name'],
      abbrev: json['abbrev'],
      description: json['description'],
    );
  }
}
