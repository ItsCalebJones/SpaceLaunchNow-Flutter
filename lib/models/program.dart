import 'agency_mini.dart';

class Program {
  final int? id;
  final String? name;
  final String? description;
  final String? infoUrl;
  final String? wikiUrl;
  final String? imageUrl;
  final List<AgencyMini>? agencies;

  Program(
      {this.id,
      this.name,
      this.description,
      this.infoUrl,
      this.wikiUrl,
      this.imageUrl,
      this.agencies});

  factory Program.fromJson(Map<String, dynamic> json) {
    List<AgencyMini> _agencies = <AgencyMini>[];
    var agencyJson = json['updates'];
    if (agencyJson != null) {
      _agencies.addAll(agencyJson.map((agency) => AgencyMini.fromJson(agency)));
    }

    return Program(
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
