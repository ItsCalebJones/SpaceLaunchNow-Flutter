class Pad {
  final int id;
  final String name;
  final String infoURL;
  final String wikiURL;
  final String mapURL;
  final double latitude;
  final double longitude;

  Pad({this.id, this.name, this.infoURL, this.wikiURL, this.mapURL,
    this.latitude, this.longitude});

  factory Pad.fromJson(Map<String, dynamic> json) {
    return new Pad(
      id: json['id'],
      name: json['name'],
      infoURL: json['infoURL'],
      wikiURL: json['wikiURL'],
      mapURL: json['mapURL'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}