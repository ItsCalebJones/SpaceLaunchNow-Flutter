

class Spacecraft {
  final String name;
  final String description;
  final String status;
  final String image;

  Spacecraft({this.name, this.description, this.status, this.image});

  factory Spacecraft.fromJson(Map<String, dynamic> json) {
    return Spacecraft(
      name: json['name'],
      description: json['description'],
      status: json['status']['name'],
      image: json['spacecraft_config']['image_url'],
    );
  }
}
