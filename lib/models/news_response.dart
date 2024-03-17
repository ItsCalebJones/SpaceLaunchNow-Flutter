import 'package:spacelaunchnow_flutter/models/news.dart';

class NewsResponse {
  final List<News>? news;
  final int? count;
  final String? next;
  final String? previous;

  NewsResponse({this.news, this.next, this.count, this.previous});

  factory NewsResponse.fromResponse(Map<String, dynamic> json) {
    return NewsResponse.fromJson(json);
  }

  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    return NewsResponse(
        news: List<News>.from(json['results'].map((event) => News.fromJson(event))),
        previous: json['previous'],
        next: json['next'],
        count: json['count']);
  }
}
