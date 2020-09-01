import 'package:dart_twitter_api/twitter_api.dart';

import 'abstract_collector.dart';
import 'dart:async';
import 'dart:convert';
import 'package:yaml/yaml.dart';
import 'package:flutter/services.dart' show rootBundle;

class TwitterCollector implements AbstractCollector {
  String _consumerKey;
  String _consumerSecret;
  String _accessToken;
  String _accessTokenSecret;
  String _filename;
  String _query;

  TwitterCollector.fromFile(String configFileName, String query) {
    this._filename = configFileName;
    this._query = query;
  }

  TwitterCollector(String _consumerKey, String _consumerSecret,
      String _accessToken, String _accessTokenSecret, String query) {
    this._consumerKey = _consumerKey;
    this._consumerSecret = _consumerSecret;
    this._accessToken = _accessToken;
    this._accessTokenSecret = _accessTokenSecret;
    this._query = query;
  }

  Future getConfigCredentials() async {
    String data = await rootBundle.loadString(this._filename);
    Map config = loadYaml(data)['twitterFeed'];
    this._consumerKey = config['consumerKey'];
    this._consumerSecret = config['consumerSecret'];
    this._accessToken = config['accessToken'];
    this._accessTokenSecret = config['accessTokenSecret'];

    return true;
  }

  Future gather() async {

    // Creating the twitterApi Object with the secret and public keys
    // These keys are generated from the twitter developer page
    // Dont share the keys with anyone
    final twitterApi = TwitterApi(
      client: TwitterClient(
        consumerKey: this._consumerKey,
        consumerSecret: this._consumerSecret,
        token: this._accessToken,
        secret: this._accessTokenSecret,
      ),
    );

//    var response = await twitterApi.timelineService.homeTimeline();

    var queryParameters = {
      'slug': 'space-launch-news',
      'owner_screen_name': 'SpaceLaunchNow',
      'tweet_mode': 'extended'
    };
    var response = await twitterApi.client.get(
        Uri.https('api.twitter.com', this._query, queryParameters)
    );

    print(response);
    // Convert the string response into something more useable
    return json.decode(response.body);
  }
}