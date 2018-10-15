class LandingLocation {
  final String name;
  final String abbrev;
  final String description;

  LandingLocation({this.name, this.abbrev, this.description});

  factory LandingLocation.fromJson(Map<String, dynamic> json) {
    return LandingLocation(
      name: json['name'],
      abbrev: json['abbrev'],
      description: json['description'],
    );
  }
}
