class VidURL {
  final int? priority;
  final String? title;
  final String? description;
  final String? featureImage;
  final String? url;

  VidURL(
      {this.priority,
      this.title,
      this.description,
      this.featureImage,
      this.url});

  factory VidURL.fromJson(Map<String, dynamic> json) {
    return VidURL(
      priority: json['priority'],
      title: json['title'],
      description: json['description'],
      featureImage: json['feature_image'],
      url: json['url'],
    );
  }
}
