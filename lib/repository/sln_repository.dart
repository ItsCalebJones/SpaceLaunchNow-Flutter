import 'dart:async';

import 'package:spacelaunchnow_flutter/models/events.dart';
import 'package:spacelaunchnow_flutter/models/launch.dart';
import 'package:spacelaunchnow_flutter/models/launches_list.dart';
import 'package:spacelaunchnow_flutter/models/news_response.dart';

abstract class SLNRepository {
  Future<List<Launch>> fetch([String lsp]);

  Future<LaunchesList> fetchUpcoming({String lsp, String limit, String offset, String search});

  Future<LaunchesList> fetchPrevious({String lsp, String limit, String offset, String search});

  Future<List<Launch>> fetchNext([String lsp]);

  Future<Events> fetchNextEvent({String limit, String offset});

  Future<NewsResponse> fetchNews({int page});

}

class FetchDataException implements Exception {
  String _message;

  FetchDataException(this._message);

  String toString() {
    return "Exception: $_message";
  }
}