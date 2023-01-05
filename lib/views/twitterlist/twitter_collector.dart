import 'dart:async';
import 'dart:convert';

import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:yaml/yaml.dart';

import '../../config/env.dart';
import 'abstract_collector.dart';

class TwitterCollector implements AbstractCollector {
  String? _consumerKey;
  String? _consumerSecret;
  String? _accessToken;
  String? _accessTokenSecret;
  late String _query;

  TwitterCollector.fromFile(String query) {
    _query = query;
  }

  TwitterCollector(String _consumerKey, String _consumerSecret,
      String _accessToken, String _accessTokenSecret, String query) {
    this._consumerKey = _consumerKey;
    this._consumerSecret = _consumerSecret;
    this._accessToken = _accessToken;
    this._accessTokenSecret = _accessTokenSecret;
    _query = query;
  }

  Future getConfigCredentials() async {
    _consumerKey = Secret.twitter_consumer_key;
    _consumerSecret = Secret.twitter_consumer_secret;
    _accessToken = Secret.twitter_access_token;
    _accessTokenSecret = Secret.twitter_access_token_secret;
    return true;
  }

  @override
  Future gather() async {
    // Creating the twitterApi Object with the secret and public keys
    // These keys are generated from the twitter developer page
    // Dont share the keys with anyone
    final twitterApi = TwitterApi(
      client: TwitterClient(
        consumerKey: _consumerKey!,
        consumerSecret: _consumerSecret!,
        token: _accessToken!,
        secret: _accessTokenSecret!,
      ),
    );

//    var response = await twitterApi.timelineService.homeTimeline();

    var queryParameters = {
      'slug': 'space-launch-news',
      'owner_screen_name': 'SpaceLaunchNow',
      'tweet_mode': 'extended'
    };
    var response = await twitterApi.client
        .get(Uri.https('api.twitter.com', _query, queryParameters));

    print(response);
    // Convert the string response into something more useable
    return json.decode(response.body);
  }
}
