import 'package:spacelaunchnow_flutter/models/news.dart';

class NewsResponse {
  final List<News>? news;
  final int? limit;
  final int? totalDocs;
  final bool? hasNextPage;
  final int? page;
  final int? totalPages;
  final int? pagingCounter;
  final int? nextPage;

  NewsResponse({this.news, this.limit, this.totalDocs, this.hasNextPage, this.page, this.totalPages, this.nextPage,
    this.pagingCounter});

  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    return new NewsResponse(
      news: new List<News>.from(json['docs'].map((news) => new News.fromJson(news))),
      limit: json['limit'],
      totalDocs: json['totalDocs'],
      hasNextPage: json['hasNextPage'],
      page: json['page'],
      totalPages: json['totalPages'],
      pagingCounter: json['pagingCounter'],
      nextPage: json['nextPage'],
    );
  }
}