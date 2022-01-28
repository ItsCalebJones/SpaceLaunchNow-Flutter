import 'agency_mini.dart';

class Program {
  final int? id;
  final String? name;
  final String? description;
  final String? infoUrl;
  final String? wikiUrl;
  final String? imageUrl;
  final List<AgencyMini>? agencies;

  Program({this.id, this.name, this.description, this.infoUrl, this.wikiUrl,
    this.imageUrl, this.agencies});

  factory Program.fromJson(Map<String, dynamic> json) {

    var _agencies;
    if (json['agencies'] != null) {
      _agencies = new List<AgencyMini>.from(json['agencies'].map((update) => new AgencyMini.fromJson(update)));
    }


    return new Program(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      infoUrl: json['info_url'],
      wikiUrl: json['wiki_url'],
      imageUrl: json['image_url'],
      agencies: _agencies,
    );
  }
}