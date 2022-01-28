import 'package:spacelaunchnow_flutter/models/rocket/spacecraft/role.dart';

import 'astronaut.dart';

class Crew {
  final int? id;
  final Role? role;
  final Astronaut? astronaut;

  Crew({this.id, this.role, this.astronaut});


  factory Crew.fromJson(Map<String, dynamic> json) {
    var astronaut;
    if (json['astronaut'] != null){
      astronaut = new Astronaut.fromJson(json['astronaut']);
    }

    var role;
    if (json['role'] != null){
      role = new Role.fromJson(json['role']);
    }

    return Crew(
        id: json['id'],
        role: role,
        astronaut: astronaut
    );
  }
}
