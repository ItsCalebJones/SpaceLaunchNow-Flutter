import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:spacelaunchnow_flutter/models/launch.dart';
import 'package:spacelaunchnow_flutter/models/launches.dart';
import 'package:spacelaunchnow_flutter/repository/launches_repository.dart';

class LaunchesRepositoryImpl implements LaunchesRepository {

  static const BASE_URL = "https://launchlibrary.net/1.3";


  Future<List<Launch>> fetch([String lsp]){
    String _kLaunchesUrl = BASE_URL + '/launch/next/20';
    if (lsp != null){
      _kLaunchesUrl = _kLaunchesUrl + '/?lsp=' + lsp;
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
    String _kLaunchesUrl = BASE_URL + '/launch/next/1';
    if (lsp != null){
      _kLaunchesUrl = _kLaunchesUrl + '/?lsp=' + lsp;
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
  Future<Launches> fetchPrevious({String lsp, String offset, String search}) {
    String currentDate = new DateFormat("yyyy-MM-dd").format(new DateTime.now());
    String _kLaunchesUrl = BASE_URL + '/launch/1960-01-01/' + currentDate;
    print("Fetching!");
    _kLaunchesUrl = _kLaunchesUrl + '/?sort=desc&limit=15';
    if (lsp != null){
      _kLaunchesUrl = _kLaunchesUrl + '&lsp=' + lsp;
    }
    if (offset != null){
      _kLaunchesUrl = _kLaunchesUrl + '&offset=' + offset;
    }
    if (search != null){
      _kLaunchesUrl = _kLaunchesUrl + '&name=' + search;
    }
    print(_kLaunchesUrl);
    return http.get(_kLaunchesUrl).then((http.Response response) {
      final jsonBody = json.decode(response.body);
      final statusCode = response.statusCode;

      if(statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw new FetchDataException("Error while getting Launches [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      print("Returning!");
      return Launches.fromJson(jsonBody);
    });
  }

  @override
  Future<List<Launch>> fetchUpcoming([String lsp]) {
    String _kLaunchesUrl = BASE_URL + '/launch/next/50';
    if (lsp != null){
      _kLaunchesUrl = _kLaunchesUrl + '/?lsp=' + lsp;
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
}