import 'astronaut.dart';

class Crew {
  final int id;
  final String role;
  final Astronaut astronaut;

  Crew({this.id, this.role, this.astronaut});


  factory Crew.fromJson(Map<String, dynamic> json) {
    var astronaut;
    if (json['astronaut'] != null){
      astronaut = new Astronaut.fromJson(json['astronaut']);
    }

    return Crew(
        id: json['id'],
        role: json['role'],
        astronaut: astronaut
    );
  }
}
