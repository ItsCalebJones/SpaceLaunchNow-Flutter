import 'dart:convert';

import 'package:logger/logger.dart';

class News {
  final String? title;
  final String? newsSiteLong;
  final String? summary;
  final String? url;
  final String? featureImage;
  final DateTime? datePublished;

  News(
      {this.title,
      this.newsSiteLong,
      this.url,
      this.featureImage,
      this.datePublished,
      this.summary});

  static List<News>? allFromResponse(String response) {
    var decodedJson = json.decode(response).cast<String, dynamic>();
    var logger = Logger();
    logger.d(decodedJson);

    return decodedJson
        .cast<Map<String, dynamic>>()
        .map((obj) => News.fromJson(obj))
        .toList()
        .cast<News>();
  }

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'],
      newsSiteLong: json['newsSite'],
      url: json['url'],
      featureImage: json['imageUrl'],
      datePublished: DateTime.parse(json['publishedAt']),
      summary: json['summary'],
    );
  }
}
