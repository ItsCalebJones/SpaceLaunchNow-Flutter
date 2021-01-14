import 'dart:convert';

class News {
  final String title;
  final String newsSiteLong;
  final String url;
  final String featureImage;
  final DateTime datePublished;

  News({this.title, this.newsSiteLong, this.url,
    this.featureImage, this.datePublished});

  static List<News> allFromResponse(String response) {
    var decodedJson = json.decode(response).cast<String, dynamic>();
    print(decodedJson);

    return decodedJson
        .cast<Map<String, dynamic>>()
        .map((obj) => News.fromJson(obj))
        .toList()
        .cast<News>();
  }

  factory News.fromJson(Map<String, dynamic> json) {
    return new News(
        title: json['title'],
        newsSiteLong: json['newsSite'],
        url: json['url'],
        featureImage: json['imageUrl'],
        datePublished:  DateTime.parse(json['publishedAt'])
    );
  }
}