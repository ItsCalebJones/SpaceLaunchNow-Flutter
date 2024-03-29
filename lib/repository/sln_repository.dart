import 'dart:async';

import 'package:spacelaunchnow_flutter/models/dashboard/starship.dart';
import 'package:spacelaunchnow_flutter/models/event/event_detailed.dart';
import 'package:spacelaunchnow_flutter/models/event/events.dart';
import 'package:spacelaunchnow_flutter/models/launch/detailed/launch.dart';
import 'package:spacelaunchnow_flutter/models/launch/detailed/launches.dart';
import 'package:spacelaunchnow_flutter/models/launch/list/launches_list.dart';
import 'package:spacelaunchnow_flutter/models/news.dart';

abstract class SLNRepository {
  Future<List<Launch>> fetch([String? lsp]);

  Future<Launches> fetchUpcomingHome(
      {String? lsps, String? locations, String? limit, String? offset});

  Future<LaunchesList> fetchUpcoming(
      {String? lsp, String? limit, String? offset, String? search});

  Future<LaunchesList> fetchPrevious(
      {String? lsp, String? limit, String? offset, String? search});

  Future<List<Launch>> fetchNext([String? lsp]);

  Future<Events> fetchNextEvent({String? limit, String? offset});

  Future<Events> fetchPreviousEvent({String? limit, String? offset});

  Future<Event> fetchEventById(int? id);

  Future<List<News>> fetchNews();

  Future<List<News>> fetchNewsBySite(String name);

  Future<List<News>> fetchNewsByLaunch({String? id});

  Future<List<News>> fetchNewsByEvent({int? id});

  Future<Starship> fetchStarshipDashboard();
}

class FetchDataException implements Exception {
  final String _message;

  FetchDataException(this._message);

  @override
  String toString() {
    return "Exception: $_message";
  }
}
