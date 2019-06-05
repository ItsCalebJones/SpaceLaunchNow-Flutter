
import 'package:flutter/material.dart';
import 'package:spacelaunchnow_flutter/views/twitterlist/twitter_collector.dart';
import 'dart:async';

import 'package:spacelaunchnow_flutter/views/twitterlist/twitter_renderer.dart';

class TwitterFeedWidget extends StatefulWidget {
  TwitterFeedWidget({this.query: 'lists/statuses.json?slug=space-launch-news&owner_screen_name=SpaceLaunchNow&tweet_mode=extended&count=100'});
  final String query;

  @override
  _TwitterFeedWidgetState createState() => _TwitterFeedWidgetState();
}

class _TwitterFeedWidgetState extends State<TwitterFeedWidget> {
  List tweets;

  Future<Null> _gatherTweets() async {
    var collector = TwitterCollector.fromFile("config.yaml", widget.query);
    await collector.getConfigCredentials().then((success) {
      collector.gather().then((response) {
        setState(() {
          tweets = response;
        });
      }).catchError((onError) {
        print(onError);
      });
    });

    return null;
  }

  @override
  initState() {
    super.initState();
    _gatherTweets();
  }

  @override
  Widget build(BuildContext context) {
    if (tweets == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Center(
        child: RefreshIndicator(
            child: TwitterRenderer().render(tweets),
            onRefresh: () => _gatherTweets()),
      );
    }
  }
}