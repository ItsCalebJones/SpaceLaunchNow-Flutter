class Location {
  final int id;
  final String name;
  final String countryCode;
  final String infoURL;
  final String wikiURL;
  final String mapImage;

  Location({this.id, this.name,  this.countryCode,  this.infoURL, this.wikiURL,
  this.mapImage});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      countryCode: json['countryCode'],
      infoURL: json['infoURL'],
      wikiURL: json['wikiURL'],
      mapImage: json['map_image'],
    );
  }
}