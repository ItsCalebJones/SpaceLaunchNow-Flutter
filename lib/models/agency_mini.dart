class AgencyMini {
  final int? id;
  final String? name;
  final String? type;

  const AgencyMini({this.id, this.name, this.type});

  factory AgencyMini.fromJson(Map<String, dynamic> json) {
    return AgencyMini(
      id: json['id'],
      name: json['name'],
      type: json['type'],
    );
  }
}
