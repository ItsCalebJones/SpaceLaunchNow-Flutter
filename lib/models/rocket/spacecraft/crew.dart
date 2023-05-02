import 'package:spacelaunchnow_flutter/models/rocket/spacecraft/role.dart';

import 'astronaut.dart';

class Crew {
  final int? id;
  final Role? role;
  final Astronaut? astronaut;

  Crew({this.id, this.role, this.astronaut});

  factory Crew.fromJson(Map<String, dynamic> json) {
    var astronautJson = json['astronaut'];
    Astronaut? astronaut;
    if (astronautJson != null) {
      astronaut = Astronaut.fromJson(astronautJson);
    }

    var roleJson = json['role'];
    Role? role;
    if (roleJson != null) {
      role = Role.fromJson(roleJson);
    }

    return Crew(id: json['id'], role: role, astronaut: astronaut);
  }
}
