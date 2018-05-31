import 'package:spacelaunchnow_flutter/models/agency.dart';
import 'package:spacelaunchnow_flutter/models/payload.dart';

class Mission {
  final int id;
  final String name;
  final String description;
  final String typeName;
  final String wikiURL;
  final List<Payload> payloads;
  final List<Agency> agencies;
//  final List<Payload> payloads;

  Mission({this.id, this.name, this.description, this.typeName, this.wikiURL, this.payloads, this.agencies});

  factory Mission.fromJson(Map<String, dynamic> json) {
    print(json);
    List<Payload> payloads;
    if (json['payloads'] != null && json['payloads'].length > 0){
      payloads = new List<Payload>.from(json['payloads'].map((payload) => new Payload.fromJson(payload)));
    } else {
      payloads;
    }

    List<Agency> agencies;
    if (json['agencies'] != null && json['agencies'].length > 0){
      agencies = new List<Agency>.from(json['agencies'].map((agencies) => new Agency.fromJson(agencies)));
    } else {
      agencies;
    }
    return new Mission(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      typeName: json['typeName'],
      wikiURL: json['wikiURL'],

      agencies: agencies,
      payloads: payloads,
    );
  }
}
