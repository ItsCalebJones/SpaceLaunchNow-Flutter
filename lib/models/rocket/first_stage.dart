class FirstStage {
  final int id;

  FirstStage({this.id, });

  factory FirstStage.fromJson(Map<String, dynamic> json) {
    return FirstStage(
        id: json['id']
    );
  }
}