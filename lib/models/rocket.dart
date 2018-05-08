class Rocket {
  final int id;
  final String name;
  final String configuration;
  final String infoURL;
  final String wikiURL;
//  final List<String> infoURLs;
  final String imageURL;

  Rocket({this.id, this.name,  this.configuration,  this.infoURL, this.wikiURL,
    this.imageURL});

  factory Rocket.fromJson(Map<String, dynamic> json) {
    return Rocket(
        id: json['id'],
        name: json['name'],
        configuration: json['configuration'],
        infoURL: json['infoURL'],
        wikiURL: json['wikiURL'],
//        infoURLs: new List<String>.from(json['infoURLs']),
        imageURL: json['imageURL']
    );
  }
}