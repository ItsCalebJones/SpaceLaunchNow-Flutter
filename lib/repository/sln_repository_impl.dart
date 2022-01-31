import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spacelaunchnow_flutter/models/dashboard/starship.dart';
import 'package:spacelaunchnow_flutter/models/event/event_detailed.dart';
import 'package:spacelaunchnow_flutter/models/event/events.dart';
import 'package:spacelaunchnow_flutter/models/launch/detailed/launch.dart';
import 'package:spacelaunchnow_flutter/models/launch/detailed/launches.dart';
import 'package:spacelaunchnow_flutter/models/launch/list/launches_list.dart';
import 'package:spacelaunchnow_flutter/models/news.dart';
import 'package:spacelaunchnow_flutter/repository/sln_repository.dart';

import 'http_client.dart';

class SLNRepositoryImpl implements SLNRepository {
  static const String BASE_URL = "https://spacelaunchnow.me/api/ll/2.2.0";
  static const String NEWS_BASE_URL = "https://api.spaceflightnewsapi.net/v3";

  final client = ClientWithUserAgent(http.Client(), useSLNAuth: true);
  final newsClient = ClientWithUserAgent(http.Client());

  @override
  Future<List<Launch>> fetch([String? lsp]) {
    String _kLaunchesUrl = BASE_URL + '/launch/?mode=detailed&limit=20';
    if (lsp != null) {
      _kLaunchesUrl = _kLaunchesUrl + '&lsp__id=' + lsp;
    }
    print(_kLaunchesUrl);
    client
        .get(Uri.parse(_kLaunchesUrl))
        .then((response) => utf8.decode(response.bodyBytes))
        .then((bodyStr) {
      print(bodyStr);
    });
    return client.get(Uri.parse(_kLaunchesUrl)).then((http.Response response) {
      final String jsonBody = response.body;
      final statusCode = response.statusCode;

      if (statusCode < 200 || statusCode >= 300) {
        throw FetchDataException(
            "Error while getting contacts [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      return Launch.allFromResponse(response)!;
    });
  }

  @override
  Future<List<Launch>> fetchNext([String? lsp]) {
    String _kLaunchesUrl = BASE_URL + '/launch/?mode=detailed&limit=1';
    if (lsp != null) {
      _kLaunchesUrl = _kLaunchesUrl + '&lsp__id=' + lsp;
    }
    print(_kLaunchesUrl);
    client
        .get(Uri.parse(_kLaunchesUrl))
        .then((response) => utf8.decode(response.bodyBytes))
        .then((bodyStr) {
      print(bodyStr);
    });
    return client.get(Uri.parse(_kLaunchesUrl)).then((http.Response response) {
      final String jsonBody = response.body;
      final statusCode = response.statusCode;

      if (statusCode < 200 || statusCode >= 300) {
        throw FetchDataException(
            "Error while getting contacts [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      return Launch.allFromResponse(response)!;
    });
  }

  @override
  Future<LaunchesList> fetchPrevious(
      {String? lsp, String? limit, String? offset, String? search}) {
    String _kLaunchesUrl =
        BASE_URL + '/launch/previous/?mode=list&limit=' + limit!;
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
    return client.get(Uri.parse(_kLaunchesUrl)).then((http.Response response) {
      final jsonBody = json.decode(utf8.decode(response.bodyBytes));
      final statusCode = response.statusCode;

      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw FetchDataException(
            "Error while getting Launches [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      print("Returning!");
      return LaunchesList.fromJson(jsonBody);
    });
  }

  @override
  Future<LaunchesList> fetchUpcoming(
      {String? lsp, String? limit, String? offset, String? search}) {
    String _kLaunchesUrl =
        BASE_URL + '/launch/upcoming/?mode=list&limit=' + limit!;
    if (lsp != null) {
      _kLaunchesUrl = _kLaunchesUrl + '&lsp__id=' + lsp;
    }

    if (offset != null) {
      _kLaunchesUrl = _kLaunchesUrl + '&offset=' + offset;
    }

    if (search != null) {
      _kLaunchesUrl = _kLaunchesUrl + '&search=' + search;
    }

    client
        .get(Uri.parse(_kLaunchesUrl))
        .then((response) => utf8.decode(response.bodyBytes))
        .then((bodyStr) {
      print(bodyStr);
    });
    return client.get(Uri.parse(_kLaunchesUrl)).then((http.Response response) {
      final jsonBody = json.decode(utf8.decode(response.bodyBytes));
      final statusCode = response.statusCode;

      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw FetchDataException(
            "Error while getting Launches [StatusCode:$statusCode,"
            " Error:${response.reasonPhrase}]");
      }

      print("Returning!");
      return LaunchesList.fromJson(jsonBody);
    });
  }

  @override
  Future<Launches> fetchUpcomingHome(
      {String? lsps, String? locations, String? limit, String? offset}) {
    String _kLaunchesUrl =
        BASE_URL + '/launch/upcoming/?mode=detailed&limit=' + limit!;
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

    return client.get(Uri.parse(_kLaunchesUrl)).then((http.Response response) {
      final jsonBody = json.decode(utf8.decode(response.bodyBytes));
      final statusCode = response.statusCode;

      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw FetchDataException(
            "Error while getting Launches [StatusCode:$statusCode,"
            " Error:${response.reasonPhrase}]");
      }

      print("Returning!");
      print(jsonBody);
      return Launches.fromJson(jsonBody);
    });
  }

  @override
  Future<Events> fetchNextEvent({String? limit, String? offset}) {
    String _kEventsUrl =
        BASE_URL + '/event/upcoming/?mode=list&limit=' + limit!;

    if (offset != null) {
      _kEventsUrl = _kEventsUrl + '&offset=' + offset;
    }

    print(_kEventsUrl);
    return client.get(Uri.parse(_kEventsUrl)).then((http.Response response) {
      final jsonBody = json.decode(utf8.decode(response.bodyBytes));
      final statusCode = response.statusCode;

      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw FetchDataException(
            "Error while getting contacts [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      return Events.fromJson(jsonBody);
    });
  }

  @override
  Future<Events> fetchPreviousEvent({String? limit, String? offset}) {
    String _kEventsUrl =
        BASE_URL + '/event/previous/?mode=list&limit=' + limit!;

    if (offset != null) {
      _kEventsUrl = _kEventsUrl + '&offset=' + offset;
    }

    print(_kEventsUrl);
    return client.get(Uri.parse(_kEventsUrl)).then((http.Response response) {
      final jsonBody = json.decode(utf8.decode(response.bodyBytes));
      final statusCode = response.statusCode;

      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw FetchDataException(
            "Error while getting contacts [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      return Events.fromJson(jsonBody);
    });
  }

  @override
  Future<Event> fetchEventById(int? id) {
    String _kEventsUrl = BASE_URL + '/event/$id';

    print(_kEventsUrl);
    return client.get(Uri.parse(_kEventsUrl)).then((http.Response response) {
      final jsonBody = json.decode(utf8.decode(response.bodyBytes));
      final statusCode = response.statusCode;

      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw FetchDataException(
            "Error while getting contacts [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      return Event.fromResponse(response);
    });
  }

  @override
  Future<List<News>> fetchNews() {
    String _kEventsUrl = NEWS_BASE_URL + '/articles?_limit=50';

    print(_kEventsUrl);
    return client.get(Uri.parse(_kEventsUrl)).then((http.Response response) {
      final jsonBody = json.decode(utf8.decode(response.bodyBytes));
      final statusCode = response.statusCode;

      print(statusCode);

      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw FetchDataException(
            "Error while getting contacts [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      return jsonBody
          .cast<Map<String, dynamic>>()
          .map((obj) => News.fromJson(obj))
          .toList()
          .cast<News>();
    });
  }

  @override
  Future<List<News>> fetchNewsBySite(String name) {
    String _kEventsUrl =
        NEWS_BASE_URL + '/articles?newsSite.name_contains=$name';

    print(_kEventsUrl);
    return client.get(Uri.parse(_kEventsUrl)).then((http.Response response) {
      final jsonBody = json.decode(utf8.decode(response.bodyBytes));
      final statusCode = response.statusCode;

      print(statusCode);

      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw FetchDataException(
            "Error while getting contacts [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      return jsonBody
          .cast<Map<String, dynamic>>()
          .map((obj) => News.fromJson(obj))
          .toList()
          .cast<News>();
    });
  }

  @override
  Future<List<News>> fetchNewsByLaunch({String? id}) {
    String _kEventsUrl = NEWS_BASE_URL + '/articles/launch/$id/?_limit=30';

    print(_kEventsUrl);
    return client.get(Uri.parse(_kEventsUrl)).then((http.Response response) {
      final jsonBody = json.decode(utf8.decode(response.bodyBytes));
      final statusCode = response.statusCode;

      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw FetchDataException(
            "Error while getting contacts [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      return jsonBody
          .cast<Map<String, dynamic>>()
          .map((obj) => News.fromJson(obj))
          .toList()
          .cast<News>();
    });
  }

  @override
  Future<List<News>> fetchNewsByEvent({int? id}) {
    String _kEventsUrl = NEWS_BASE_URL + '/articles/event/$id/?_limit=30';

    print(_kEventsUrl);
    return client.get(Uri.parse(_kEventsUrl)).then((http.Response response) {
      final jsonBody = json.decode(utf8.decode(response.bodyBytes));
      final statusCode = response.statusCode;

      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw FetchDataException(
            "Error while getting contacts [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      return jsonBody
          .cast<Map<String, dynamic>>()
          .map((obj) => News.fromJson(obj))
          .toList()
          .cast<News>();
    });
  }

  @override
  Future<Starship> fetchStarshipDashboard() {
    String _kUrl = BASE_URL + '/dashboard/starship/?mode=list';
    print(_kUrl);
    return client.get(Uri.parse(_kUrl)).then((http.Response response) {
      final jsonBody = json.decode(utf8.decode(response.bodyBytes));
      final statusCode = response.statusCode;

      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw FetchDataException(
            "Error while getting contacts [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      return Starship.fromJson(jsonBody);
    });
  }
}
