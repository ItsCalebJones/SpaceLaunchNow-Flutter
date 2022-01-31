import 'package:flutter/material.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:spacelaunchnow_flutter/views/twitterlist/twitter_feed.dart';

class TwitterFeedPage extends StatefulWidget {
  const TwitterFeedPage(this._configuration);

  final AppConfiguration _configuration;

  @override
  _TwitterFeedPageState createState() => _TwitterFeedPageState();
}

class _TwitterFeedPageState extends State<TwitterFeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TwitterFeedWidget(widget._configuration),
      ),
    );
  }
}
