import 'package:spacelaunchnow_flutter/models/rocket/spacecraft/role.dart';

import 'astronaut.dart';

class Crew {
  final int? id;
  final Role? role;
  final Astronaut? astronaut;

  Crew({this.id, this.role, this.astronaut});

  factory Crew.fromJson(Map<String, dynamic> json) {
    var astronautJson = json['astronaut'];
    Astronaut? _astronaut;
    if (astronautJson != null) {
      _astronaut = Astronaut.fromJson(astronautJson);
    }

    var roleJson = json['role'];
    Role? _role;
    if (roleJson != null) {
      _role = Role.fromJson(roleJson);
    }

    return Crew(id: json['id'], role: _role, astronaut: _astronaut);
  }
}
