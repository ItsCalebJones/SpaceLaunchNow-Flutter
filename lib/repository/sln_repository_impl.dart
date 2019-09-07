import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:spacelaunchnow_flutter/models/events.dart';
import 'package:spacelaunchnow_flutter/models/launch.dart';
import 'package:spacelaunchnow_flutter/models/launches.dart';
import 'package:spacelaunchnow_flutter/models/launches_list.dart';
import 'package:spacelaunchnow_flutter/models/news_response.dart';
import 'package:spacelaunchnow_flutter/repository/sln_repository.dart';

class SLNRepositoryImpl implements SLNRepository {

  static const BASE_URL = "https://spacelaunchnow.me/api/3.4.0";
  static const NEWS_BASE_URL = "https://spaceflightnewsapi.net/api/v1";


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

  @override
  Future<Launches> fetchUpcomingHome({String lsps, String locations, String limit, String offset}) {
    String _kLaunchesUrl = BASE_URL + '/launch/upcoming/?mode=detailed&limit=' + limit;
    if (lsps != null) {
      _kLaunchesUrl = _kLaunchesUrl + '&lsp__ids=' + lsps;
    }

    if (locations != null) {
      _kLaunchesUrl = _kLaunchesUrl + '&location__ids=' + locations;
    }

    if (offset != null) {
      _kLaunchesUrl = _kLaunchesUrl + '&offset=' + offset;
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
      print(jsonBody);
      Launches launches = Launches.fromJson(jsonBody);
      return Launches.fromJson(jsonBody);
    });
  }

  @override
  Future<Events> fetchNextEvent({ String limit, String offset}) {
    String _kEventsUrl = BASE_URL + '/event/upcoming/?mode=detailed&limit=' + limit;

    if (offset != null){
      _kEventsUrl = _kEventsUrl + '&offset=' + offset;
    }

    return http.get(_kEventsUrl).then((http.Response response) {
      final jsonBody = json.decode(response.body);
      final statusCode = response.statusCode;

      if(statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw new FetchDataException("Error while getting contacts [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      return Events.fromJson(jsonBody);
    });
  }

  @override
  Future<NewsResponse> fetchNews({int page}) {
    String _kEventsUrl = NEWS_BASE_URL + '/articles?limit=30';

    if (page != null){
      _kEventsUrl = _kEventsUrl + '&page=' + page.toString();
    }

    print(_kEventsUrl);
    return http.get(_kEventsUrl).then((http.Response response) {
      final jsonBody = json.decode(response.body);
      final statusCode = response.statusCode;

      if(statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw new FetchDataException("Error while getting contacts [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      return NewsResponse.fromJson(jsonBody);
    });
  }

  @override
  Future<NewsResponse> fetchNewsByLaunch({String id}) {
    String _kEventsUrl = NEWS_BASE_URL + '/articles?limit=30';

    if (id != null){
      _kEventsUrl = _kEventsUrl + '&launches=' + id;
    }

    print(_kEventsUrl);
    return http.get(_kEventsUrl).then((http.Response response) {
      final jsonBody = json.decode(response.body);
      final statusCode = response.statusCode;

      if(statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw new FetchDataException("Error while getting contacts [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      return NewsResponse.fromJson(jsonBody);
    });
  }
}