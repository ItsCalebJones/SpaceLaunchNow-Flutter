class Agency {
  final int id;
  final String name;
  final String abbrev;
  final String countryCode;
  final String type;
  final String infoURL;
  final String wikiURL;
//  final List<String> infoURLs;

  const Agency({this.id, this.name, this.abbrev, this.countryCode, this.type, this.infoURL, this.wikiURL});

  factory Agency.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return new Agency(
        id: json['id'],
        name: json['name'],
        abbrev: json['abbrev'],
        countryCode: json['country_code'],
        type: json['type'],
        infoURL: json['info_url'],
        wikiURL: json['wiki_url'],
      );
    } return null;
  }
}