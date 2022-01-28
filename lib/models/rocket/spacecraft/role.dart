class Role {
  final int? id;
  final String? role;
  final int? priority;

  Role({this.id, this.role, this.priority});


  factory Role.fromJson(Map<String, dynamic> json) {
    print(json);
    return Role(
        id: json['id'],
        role: json['role'],
        priority: json['priority']
    );
  }
}
