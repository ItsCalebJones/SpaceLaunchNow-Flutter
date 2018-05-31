class Agency {
  final int id;
  final String name;
  final String abbrev;
  final String countryCode;
  final int type;
  final String infoURL;
  final String wikiURL;
//  final List<String> infoURLs;

  const Agency({this.id, this.name, this.abbrev, this.countryCode, this.type, this.infoURL, this.wikiURL});

  factory Agency.fromJson(Map<String, dynamic> json) {
    if (json != null) {

      String infoURL;
      if (json['infoURLs'] != null && json['infoURLs'].length > 0){
        infoURL = json['infoURLs'][0];
      }
      return new Agency(
        id: json['id'],
        name: json['name'],
        abbrev: json['abbrev'],
        countryCode: json['countryCode'],
        type: json['type'],
        infoURL: infoURL,
        wikiURL: json['wikiURL'],
//      infoURLs: json['infoURLs'],
      );
    } return null;
  }
}