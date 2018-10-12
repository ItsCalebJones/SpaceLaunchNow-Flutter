import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:spacelaunchnow_flutter/models/launch.dart';
import 'package:spacelaunchnow_flutter/models/launches.dart';
import 'package:spacelaunchnow_flutter/models/launches_list.dart';
import 'package:spacelaunchnow_flutter/repository/launches_repository.dart';

class LaunchesRepositoryImpl implements LaunchesRepository {

  static const BASE_URL = "https://spacelaunchnow.me/3.2.0";


  Future<List<Launch>> fetch([String lsp]){
    String _kLaunchesUrl = BASE_URL + '/launch/?mode=detailed&limit=20';
    if (lsp != null){
      _kLaunchesUrl = _kLaunchesUrl + '&lsp__id=' + lsp;
    }
    return http.get(_kLaunchesUrl).then((http.Response response) {
      final String jsonBody = response.body;
      final statusCode = response.statusCode;

      if(statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw new FetchDataException("Error while getting contacts [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      return Launch.allFromResponse(jsonBody);
    });
  }

  @override
  Future<List<Launch>> fetchNext([String lsp]) {
    String _kLaunchesUrl = BASE_URL + '/launch/?mode=detailed&limit=1';
    if (lsp != null){
      _kLaunchesUrl = _kLaunchesUrl + '&lsp__id=' + lsp;
    }
    return http.get(_kLaunchesUrl).then((http.Response response) {
      final String jsonBody = response.body;
      final statusCode = response.statusCode;

      if(statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw new FetchDataException("Error while getting contacts [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      return Launch.allFromResponse(jsonBody);
    });
  }

  @override
  Future<LaunchesList> fetchPrevious({String lsp, String limit, String offset, String search}) {
    String _kLaunchesUrl = BASE_URL + '/launch/previous/?mode=list&limit=' + limit;
    if (lsp != null){
      _kLaunchesUrl = _kLaunchesUrl + '&lsp__id=' + lsp;
    }
    if (offset != null){
      _kLaunchesUrl = _kLaunchesUrl + '&offset=' + offset;
    }
    if (search != null){
      _kLaunchesUrl = _kLaunchesUrl + '&search=' + search;
    }
    print(_kLaunchesUrl);
    return http.get(_kLaunchesUrl).then((http.Response response) {
      final jsonBody = json.decode(response.body);
      final statusCode = response.statusCode;

      if(statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw new FetchDataException("Error while getting Launches [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      print("Returning!");
      return LaunchesList.fromJson(jsonBody);
    });
  }

  @override
  Future<LaunchesList> fetchUpcoming({String lsp, String limit, String offset, String search}) {
    String _kLaunchesUrl = BASE_URL + '/launch/upcoming/?mode=list&limit=' + limit;
    if (lsp != null) {
      _kLaunchesUrl = _kLaunchesUrl + '&lsp__id=' + lsp;
    }

    if (offset != null) {
      _kLaunchesUrl = _kLaunchesUrl + '&offset=' + offset;
    }

    if (search != null) {
      _kLaunchesUrl = _kLaunchesUrl + '&search=' + search;
    }
    print(_kLaunchesUrl);
    return http.get(_kLaunchesUrl).then((http.Response response) {
      final jsonBody = json.decode(response.body);
      final statusCode = response.statusCode;

      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw new FetchDataException(
            "Error while getting Launches [StatusCode:$statusCode,"
                " Error:${response.reasonPhrase}]");
      }

      print("Returning!");
      return LaunchesList.fromJson(jsonBody);
    });
  }
}