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
  final newsClient = ClientWithUserAgent(http.Client(), useSLNAuth: false);

  @override
  Future<List<Launch>> fetch([String? lsp]) {
    String kLaunchesUrl = '$BASE_URL/launch/?mode=detailed&limit=20';
    if (lsp != null) {
      kLaunchesUrl = '$kLaunchesUrl&lsp__id=$lsp';
    }
    debugPrint(kLaunchesUrl);
    client
        .get(Uri.parse(kLaunchesUrl))
        .then((response) => utf8.decode(response.bodyBytes))
        .then((bodyStr) {
      debugPrint(bodyStr);
    });
    return client.get(Uri.parse(kLaunchesUrl)).then((http.Response response) {
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
    String kLaunchesUrl = '$BASE_URL/launch/?mode=detailed&limit=1';
    if (lsp != null) {
      kLaunchesUrl = '$kLaunchesUrl&lsp__id=$lsp';
    }
    print(kLaunchesUrl);
    client
        .get(Uri.parse(kLaunchesUrl))
        .then((response) => utf8.decode(response.bodyBytes))
        .then((bodyStr) {
      print(bodyStr);
    });
    return client.get(Uri.parse(kLaunchesUrl)).then((http.Response response) {
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
    String kLaunchesUrl =
        '$BASE_URL/launch/previous/?mode=list&limit=${limit!}';
    if (lsp != null) {
      kLaunchesUrl = '$kLaunchesUrl&lsp__id=$lsp';
    }
    if (offset != null) {
      kLaunchesUrl = '$kLaunchesUrl&offset=$offset';
    }
    if (search != null) {
      kLaunchesUrl = '$kLaunchesUrl&search=$search';
    }
    print(kLaunchesUrl);
    return client.get(Uri.parse(kLaunchesUrl)).then((http.Response response) {
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
    String kLaunchesUrl =
        '$BASE_URL/launch/upcoming/?mode=list&limit=${limit!}';
    if (lsp != null) {
      kLaunchesUrl = '$kLaunchesUrl&lsp__id=$lsp';
    }

    if (offset != null) {
      kLaunchesUrl = '$kLaunchesUrl&offset=$offset';
    }

    if (search != null) {
      kLaunchesUrl = '$kLaunchesUrl&search=$search';
    }

    client
        .get(Uri.parse(kLaunchesUrl))
        .then((response) => utf8.decode(response.bodyBytes))
        .then((bodyStr) {
      print(bodyStr);
    });
    return client.get(Uri.parse(kLaunchesUrl)).then((http.Response response) {
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
    String kLaunchesUrl =
        '$BASE_URL/launch/upcoming/?mode=detailed&limit=${limit!}';
    if (lsps != null) {
      kLaunchesUrl = '$kLaunchesUrl&lsp__ids=$lsps';
    }

    if (locations != null) {
      kLaunchesUrl = '$kLaunchesUrl&location__ids=$locations';
    }

    if (offset != null) {
      kLaunchesUrl = '$kLaunchesUrl&offset=$offset';
    }

    print(kLaunchesUrl);

    return client.get(Uri.parse(kLaunchesUrl)).then((http.Response response) {
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
    String kEventsUrl =
        '$BASE_URL/event/upcoming/?mode=list&limit=${limit!}';

    if (offset != null) {
      kEventsUrl = '$kEventsUrl&offset=$offset';
    }

    print(kEventsUrl);
    return client.get(Uri.parse(kEventsUrl)).then((http.Response response) {
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
    String kEventsUrl =
        '$BASE_URL/event/previous/?mode=list&limit=${limit!}';

    if (offset != null) {
      kEventsUrl = '$kEventsUrl&offset=$offset';
    }

    print(kEventsUrl);
    return client.get(Uri.parse(kEventsUrl)).then((http.Response response) {
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
    String kEventsUrl = '$BASE_URL/event/$id';

    print(kEventsUrl);
    return client.get(Uri.parse(kEventsUrl)).then((http.Response response) {
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
    String kEventsUrl = '$NEWS_BASE_URL/articles?_limit=50';

    print(kEventsUrl);
    return newsClient.get(Uri.parse(kEventsUrl)).then((http.Response response) {
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
    String kEventsUrl =
        '$NEWS_BASE_URL/articles?newsSite.name_contains=$name';

    print(kEventsUrl);
    return newsClient.get(Uri.parse(kEventsUrl)).then((http.Response response) {
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
    String kEventsUrl = '$NEWS_BASE_URL/articles/launch/$id/?_limit=30';

    print(kEventsUrl);
    return newsClient.get(Uri.parse(kEventsUrl)).then((http.Response response) {
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
    String kEventsUrl = '$NEWS_BASE_URL/articles/event/$id/?_limit=30';

    print(kEventsUrl);
    return newsClient.get(Uri.parse(kEventsUrl)).then((http.Response response) {
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
    String kUrl = '$BASE_URL/dashboard/starship/?mode=list';
    print(kUrl);
    return client.get(Uri.parse(kUrl)).then((http.Response response) {
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
