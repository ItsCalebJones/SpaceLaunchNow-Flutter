// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:spacelaunchnow_flutter/models/dashboard/starship.dart';
import 'package:spacelaunchnow_flutter/models/event/event_detailed.dart';
import 'package:spacelaunchnow_flutter/models/event/events.dart';
import 'package:spacelaunchnow_flutter/models/launch/detailed/launch.dart';
import 'package:spacelaunchnow_flutter/models/launch/detailed/launches.dart';
import 'package:spacelaunchnow_flutter/models/launch/list/launches_list.dart';
import 'package:spacelaunchnow_flutter/models/news.dart';
import 'package:spacelaunchnow_flutter/models/news_response.dart';
import 'package:spacelaunchnow_flutter/repository/sln_repository.dart';

import 'http_client.dart';


/// Implementation of the SLNRepository interface.
/// This class is responsible for fetching data related to space launches and events.
class SLNRepositoryImpl implements SLNRepository {
  static const String BASE_URL = "https://spacelaunchnow.me/api/ll/2.2.0";
  static const String NEWS_BASE_URL = "https://api.spaceflightnewsapi.net/v4";

  final client = ClientWithUserAgent(http.Client(), useSLNAuth: true);
  final newsClient = ClientWithUserAgent(http.Client(), useSLNAuth: false);

  /// Fetches a list of launches.
  /// If [lsp] is provided, only launches from the specified launch service provider will be fetched.
  /// Returns a list of [Launch] objects.
  @override
  Future<List<Launch>> fetch([String? lsp]) {
    String kLaunchesUrl = '$BASE_URL/launch/?mode=detailed&limit=20';
    if (lsp != null) {
      kLaunchesUrl = '$kLaunchesUrl&lsp__id=$lsp';
    }
    client
        .get(Uri.parse(kLaunchesUrl))
        .then((response) => utf8.decode(response.bodyBytes));
    return client.get(Uri.parse(kLaunchesUrl)).then((http.Response response) {
      final statusCode = response.statusCode;

      if (statusCode < 200 || statusCode >= 300) {
        throw FetchDataException(
            "Error while getting contacts [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      return Launch.allFromResponse(response)!;
    });
  }

  /// Fetches the next launch.
  /// If [lsp] is provided, only launches from the specified launch service provider will be fetched.
  /// Returns a list of [Launch] objects.
  @override
  Future<List<Launch>> fetchNext([String? lsp]) {
    String kLaunchesUrl = '$BASE_URL/launch/?mode=detailed&limit=1';
    if (lsp != null) {
      kLaunchesUrl = '$kLaunchesUrl&lsp__id=$lsp';
    }
    client
        .get(Uri.parse(kLaunchesUrl))
        .then((response) => utf8.decode(response.bodyBytes));
    return client.get(Uri.parse(kLaunchesUrl)).then((http.Response response) {
      final statusCode = response.statusCode;

      if (statusCode < 200 || statusCode >= 300) {
        throw FetchDataException(
            "Error while getting contacts [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      return Launch.allFromResponse(response)!;
    });
  }

  /// Fetches a list of previous launches.
  /// If [lsp] is provided, only launches from the specified launch service provider will be fetched.
  /// [limit] specifies the maximum number of launches to fetch.
  /// [offset] specifies the number of launches to skip.
  /// [search] specifies a search query to filter launches.
  /// Returns a [LaunchesList] object.
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

    return client.get(Uri.parse(kLaunchesUrl)).then((http.Response response) {
      final jsonBody = json.decode(utf8.decode(response.bodyBytes));
      final statusCode = response.statusCode;

      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw FetchDataException(
            "Error while getting Launches [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      return LaunchesList.fromJson(jsonBody);
    });
  }

  /// Fetches a list of upcoming launches.
  /// If [lsp] is provided, only launches from the specified launch service provider will be fetched.
  /// [limit] specifies the maximum number of launches to fetch.
  /// [offset] specifies the number of launches to skip.
  /// [search] specifies a search query to filter launches.
  /// Returns a [LaunchesList] object.
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
        .then((response) => utf8.decode(response.bodyBytes));
    return client.get(Uri.parse(kLaunchesUrl)).then((http.Response response) {
      final jsonBody = json.decode(utf8.decode(response.bodyBytes));
      final statusCode = response.statusCode;

      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw FetchDataException(
            "Error while getting Launches [StatusCode:$statusCode,"
            " Error:${response.reasonPhrase}]");
      }

      debugPrint("Returning!");
      return LaunchesList.fromJson(jsonBody);
    });
  }

  /// Fetches a list of upcoming launches for the home screen.
  /// If [lsps] is provided, only launches from the specified launch service providers will be fetched.
  /// If [locations] is provided, only launches from the specified locations will be fetched.
  /// [limit] specifies the maximum number of launches to fetch.
  /// [offset] specifies the number of launches to skip.
  /// Returns a [Launches] object.
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

    debugPrint(kLaunchesUrl);

    return client.get(Uri.parse(kLaunchesUrl)).then((http.Response response) {
      final jsonBody = json.decode(utf8.decode(response.bodyBytes));
      final statusCode = response.statusCode;

      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw FetchDataException(
            "Error while getting Launches [StatusCode:$statusCode,"
            " Error:${response.reasonPhrase}]");
      }

      return Launches.fromJson(jsonBody);
    });
  }

  /// Fetches the next event.
  /// [limit] specifies the maximum number of events to fetch.
  /// [offset] specifies the number of events to skip.
  /// Returns an [Events] object.
  @override
  Future<Events> fetchNextEvent({String? limit, String? offset}) {
    String kEventsUrl =
        '$BASE_URL/event/upcoming/?mode=list&limit=${limit!}';

    if (offset != null) {
      kEventsUrl = '$kEventsUrl&offset=$offset';
    }

    debugPrint(kEventsUrl);
    return client.get(Uri.parse(kEventsUrl)).then((http.Response response) {
      final jsonBody = json.decode(utf8.decode(response.bodyBytes));
      final statusCode = response.statusCode;

      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw FetchDataException(
            "Error while getting contacts [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      debugPrint("Returning!");
      return Events.fromJson(jsonBody);
    });
  }

  /// Fetches a list of previous events.
  /// [limit] specifies the maximum number of events to fetch.
  /// [offset] specifies the number of events to skip.
  /// Returns an [Events] object.
  @override
  Future<Events> fetchPreviousEvent({String? limit, String? offset}) {
    String kEventsUrl =
        '$BASE_URL/event/previous/?mode=list&limit=${limit!}';

    if (offset != null) {
      kEventsUrl = '$kEventsUrl&offset=$offset';
    }

    debugPrint(kEventsUrl);
    return client.get(Uri.parse(kEventsUrl)).then((http.Response response) {
      final jsonBody = json.decode(utf8.decode(response.bodyBytes));
      final statusCode = response.statusCode;

      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw FetchDataException(
            "Error while getting contacts [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      debugPrint("Returning!");

      return Events.fromJson(jsonBody);
    });
  }

  /// Fetches an event by its ID.
  /// [id] specifies the ID of the event to fetch.
  /// Returns an [Event] object.
  @override
  Future<Event> fetchEventById(int? id) {
    String kEventsUrl = '$BASE_URL/event/$id';

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

  /// Fetches a list of news articles.
  /// Returns a list of [News] objects.
  @override
  Future<List<News>> fetchNews() {
    String kEventsUrl = '$NEWS_BASE_URL/articles/?limit=50';

    return newsClient.get(Uri.parse(kEventsUrl)).then((http.Response response) {
      final jsonBody = json.decode(utf8.decode(response.bodyBytes));
      final statusCode = response.statusCode;

      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw FetchDataException(
            "Error while getting contacts [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      return NewsResponse.fromResponse(jsonBody).news ?? [];
    });
  }

  /// Fetches a list of news articles by site name.
  /// [name] specifies the name of the site to filter news articles.
  /// Returns a list of [News] objects.
  @override
  Future<List<News>> fetchNewsBySite(String name) {
    String kEventsUrl =
        '$NEWS_BASE_URL/articles/?limit=50&news_site=$name';

    return newsClient.get(Uri.parse(kEventsUrl)).then((http.Response response) {
      final jsonBody = json.decode(utf8.decode(response.bodyBytes));
      final statusCode = response.statusCode;

      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw FetchDataException(
            "Error while getting contacts [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      return NewsResponse.fromResponse(jsonBody).news ?? [];
    });
  }

  /// Fetches a list of news articles by launch ID.
  /// [id] specifies the ID of the launch to filter news articles.
  /// Returns a list of [News] objects.
  @override
  Future<List<News>> fetchNewsByLaunch({String? id}) {
    String kEventsUrl = '$NEWS_BASE_URL/articles/?launch=$id&?limit=30';

    return newsClient.get(Uri.parse(kEventsUrl)).then((http.Response response) {
      final jsonBody = json.decode(utf8.decode(response.bodyBytes));
      final statusCode = response.statusCode;

      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw FetchDataException(
            "Error while getting contacts [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      return NewsResponse.fromResponse(jsonBody).news ?? [];
    });
  }

  /// Fetches a list of news articles by event ID.
  /// [id] specifies the ID of the event to filter news articles.
  /// Returns a list of [News] objects.
  @override
  Future<List<News>> fetchNewsByEvent({int? id}) {
    String kEventsUrl = '$NEWS_BASE_URL/articles/?event=$id&limit=30';

    return newsClient.get(Uri.parse(kEventsUrl)).then((http.Response response) {
      final jsonBody = json.decode(utf8.decode(response.bodyBytes));
      final statusCode = response.statusCode;

      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw FetchDataException(
            "Error while getting contacts [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      return NewsResponse.fromResponse(jsonBody).news ?? [];
    });
  }

  /// Fetches the starship dashboard.
  /// Returns a [Starship] object.
  @override
  Future<Starship> fetchStarshipDashboard() {
    String kUrl = '$BASE_URL/dashboard/starship/?mode=list';

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
