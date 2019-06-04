import 'dart:async';

import 'package:spacelaunchnow_flutter/models/event.dart';
import 'package:spacelaunchnow_flutter/models/events.dart';
import 'package:spacelaunchnow_flutter/models/launch.dart';
import 'package:spacelaunchnow_flutter/models/launches.dart';
import 'package:spacelaunchnow_flutter/models/launches_list.dart';

abstract class SLNRepository {
  Future<List<Launch>> fetch([String lsp]);

  Future<LaunchesList> fetchUpcoming({String lsp, String limit, String offset, String search});

  Future<LaunchesList> fetchPrevious({String lsp, String limit, String offset, String search});

  Future<List<Launch>> fetchNext([String lsp]);

  Future<Events> fetchNextEvent({String limit, String offset});

}

class FetchDataException implements Exception {
  String _message;

  FetchDataException(this._message);

  String toString() {
    return "Exception: $_message";
  }
}