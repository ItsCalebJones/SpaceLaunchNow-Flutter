class Update {
  final int? id;
  final String? profileImage;
  final String? comment;
  final String? infoUrl;
  final String? createdBy;
  final DateTime? createdOn;

  Update(
      {this.id,
      this.profileImage,
      this.comment,
      this.infoUrl,
      this.createdBy,
      this.createdOn});

  factory Update.fromJson(Map<String, dynamic> json) {
    return Update(
      id: json['id'],
      profileImage: json['profile_image'],
      comment: json['comment'],
      infoUrl: json['info_url'],
      createdBy: json['created_by'],
      createdOn: DateTime.parse(json['created_on']),
    );
  }
}
