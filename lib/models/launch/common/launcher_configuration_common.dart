class LauncherConfigurationCommon {
  final int? id;
  final String? name;
  final String? family;
  final String? fullName;
  final String? variant;


  LauncherConfigurationCommon(
      {
        this.id,
        this.name,
        this.family,
        this.fullName,
        this.variant,
});

  factory LauncherConfigurationCommon.fromJson(Map<String, dynamic> json) {
    var image = json['image_url'];
    if (image == null) {
      image =
          "";
    }
    return LauncherConfigurationCommon(
      id: json['id'],
      name: json['name'],
      family: json['family'],
      fullName: json['full_name'],
      variant: json['variant'],

    );
  }
}
