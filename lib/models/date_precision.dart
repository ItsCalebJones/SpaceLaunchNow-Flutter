
class DatePrecision {
  final int? id;
  final String? name;
  final String? description;
  final String? abbrev;

  DatePrecision(
      {this.id,
        this.name,
        this.description,
        this.abbrev,});

  factory DatePrecision.fromJson(Map<String, dynamic> json) {
    return DatePrecision(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        abbrev: json['abbrev']
    );
  }
}