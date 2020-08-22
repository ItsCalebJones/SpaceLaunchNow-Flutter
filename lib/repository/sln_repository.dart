import 'dart:async';

import 'package:spacelaunchnow_flutter/models/events.dart';
import 'package:spacelaunchnow_flutter/models/launch.dart';
import 'package:spacelaunchnow_flutter/models/launches.dart';
import 'package:spacelaunchnow_flutter/models/launches_list.dart';
import 'package:spacelaunchnow_flutter/models/news_response.dart';
import 'package:spacelaunchnow_flutter/models/dashboard/starship.dart';

abstract class SLNRepository {
  Future<List<Launch>> fetch([String lsp]);

  Future<Launches> fetchUpcomingHome({String lsps, String locations, String limit, String offset});

  Future<LaunchesList> fetchUpcoming({String lsp, String limit, String offset, String search});

  Future<LaunchesList> fetchPrevious({String lsp, String limit, String offset, String search});

  Future<List<Launch>> fetchNext([String lsp]);

  Future<Events> fetchNextEvent({String limit, String offset});

  Future<NewsResponse> fetchNews({int page});

  Future<NewsResponse> fetchNewsByLaunch({String id});

  Future<Starship> fetchStarshipDashboard();

}

class FetchDataException implements Exception {
  String _message;

  FetchDataException(this._message);

  String toString() {
    return "Exception: $_message";
  }
}