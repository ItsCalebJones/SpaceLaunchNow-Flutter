import 'dart:async';

import 'package:spacelaunchnow_flutter/models/launch.dart';
import 'package:spacelaunchnow_flutter/models/launches.dart';

abstract class LaunchesRepository {
  Future<List<Launch>> fetch([String lsp]);

  Future<List<Launch>> fetchUpcoming([String lsp]);

  Future<Launches> fetchPrevious({String lsp, String offset, String search});

  Future<List<Launch>> fetchNext([String lsp]);

}

class FetchDataException implements Exception {
  String _message;

  FetchDataException(this._message);

  String toString() {
    return "Exception: $_message";
  }
}