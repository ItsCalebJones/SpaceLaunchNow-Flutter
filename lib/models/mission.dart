import 'package:logger/logger.dart';

import 'orbit.dart';

class Mission {
  final int? id;
  final String? name;
  final String? description;
  final String? typeName;
  final String? wikiURL;
  final Orbit? orbit;

  Mission(
      {this.id,
      this.name,
      this.description,
      this.typeName,
      this.wikiURL,
      this.orbit});

  factory Mission.fromJson(Map<String, dynamic> json) {
    var logger = Logger();

    var orbitJson = json['orbit'];
    Orbit? _orbit;
    if (orbitJson != null) {
      _orbit = Orbit.fromJson(orbitJson);
    }

    return Mission(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        typeName: json['type'],
        wikiURL: json['wiki_url'],
        orbit: _orbit);
  }
}
