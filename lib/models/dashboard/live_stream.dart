class LiveStream {
  final String? title;
  final String? description;
  final String? image;
  final String? url;

  LiveStream({this.title, this.description, this.image, this.url});

  factory LiveStream.fromJson(Map<String, dynamic> json) {
    return LiveStream(
      title: json['title'],
      description: json['description'],
      image: json['image'],
      url: json['url'],
    );
  }
}
