import 'package:spacelaunchnow_flutter/models/rocket/landing.dart';
import 'package:spacelaunchnow_flutter/models/rocket/launcher.dart';

import '../../launch/detailed/launch.dart';

class Astronaut {
  final int id;
  final String name;
  final String profileImage;
  final String wikiUrl;
  final String twitterUrl;
  final String instagramUrl;
  final String bio;
  final String nationality;

  Astronaut({this.id, this.name, this.profileImage, this.wikiUrl,
    this.twitterUrl, this.instagramUrl, this.bio, this.nationality});

  factory Astronaut.fromJson(Map<String, dynamic> json) {
    return Astronaut(
      id: json['id'],
      name: json['name'],
      profileImage: json['profile_image'],
      wikiUrl: json['wiki'],
      twitterUrl: json['twitter'],
      instagramUrl: json['instagram'],
      bio: json['bio'],
      nationality: json['nationality'],
    );
  }

}
