class Agency {
  final int id;
  final String name;
  final String abbrev;
  final String countryCode;
  final int type;
  final String infoURL;
  final String wikiURL;
//  final List<String> infoURLs;

  Agency({this.id, this.name, this.abbrev, this.countryCode, this.type, this.infoURL, this.wikiURL});

  factory Agency.fromJson(Map<String, dynamic> json) {
    return new Agency(
      id: json['id'],
      name: json['name'],
      abbrev: json['abbrev'],
      countryCode: json['countryCode'],
      type: json['type'],
      infoURL: json['infoURL'],
      wikiURL: json['wikiURL'],
//      infoURLs: json['infoURLs'],
    );
  }
}