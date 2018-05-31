import 'package:spacelaunchnow_flutter/models/agency.dart';
import 'package:spacelaunchnow_flutter/models/payload.dart';

class Mission {
  final int id;
  final String name;
  final String description;
  final String typeName;
  final String wikiURL;

//  final List<Agency> agencies;
//  final List<Payload> payloads;

  Mission({this.id, this.name, this.description, this.typeName, this.wikiURL});

  factory Mission.fromJson(Map<String, dynamic> json) {
    print(json);

    return new Mission(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      typeName: json['typeName'],
      wikiURL: json['wikiURL'],

//      agencies: new List<Agency>.from(json['agencies'].map((agency) => new Agency.fromJson(agency))),
//      payloads: new List<Payload>.from(json['payloads'].map((payload) => new Payload.fromJson(payload))),
    );
  }
}
