class InfoURL {
  final int priority;
  final String title;
  final String description;
  final String featureImage;
  final String url;

  InfoURL(
      {
        this.priority,
        this.title,
        this.description,
        this.featureImage,
        this.url
      }
        );

  factory InfoURL.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return new InfoURL(
        priority: json['priority'],
        title: json['title'],
        description: json['description'],
        featureImage: json['feature_image'],
        url: json['url'],
      );
    } else {
      return null;
    }
  }
}
