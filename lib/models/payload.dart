class Payload {
  final int? id;
  final String? name;

  Payload({
    this.id,
    this.name,
  });

  factory Payload.fromJson(Map<String, dynamic> json) {
    return Payload(
      id: json['id'],
      name: json['name'],
    );
  }
}
