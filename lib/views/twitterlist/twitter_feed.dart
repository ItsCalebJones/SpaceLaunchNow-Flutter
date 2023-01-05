import 'package:dart_twitter_api/api/tweets/data/tweet.dart';
import 'package:flutter/material.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:spacelaunchnow_flutter/views/twitterlist/twitter_collector.dart';
import 'dart:async';

import 'package:spacelaunchnow_flutter/views/twitterlist/twitter_renderer.dart';

class TwitterFeedWidget extends StatefulWidget {
  const TwitterFeedWidget(this._configuration);

  final String query = '1.1/lists/statuses.json';
  final AppConfiguration _configuration;

  @override
  _TwitterFeedWidgetState createState() => _TwitterFeedWidgetState();
}

class _TwitterFeedWidgetState extends State<TwitterFeedWidget> {
  List? tweets;

  Future<void> _gatherTweets() async {
    var collector = TwitterCollector.fromFile(widget.query);

    await collector.getConfigCredentials().then((success) {
      collector.gather().then((response) {
        setState(() {
          tweets = response;
          PageStorage.of(context)!
              .writeState(context, tweets, identifier: 'tweets');
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
    List? _tweets =
        PageStorage.of(context)!.readState(context, identifier: 'tweets');
    if (_tweets != null) {
      setState(() {
        tweets = _tweets;
      });
    } else {
      _gatherTweets();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (tweets == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Center(
        child: RefreshIndicator(
            child: TwitterRenderer(widget._configuration).render(tweets!),
            onRefresh: () => _gatherTweets()),
      );
    }
  }
}
