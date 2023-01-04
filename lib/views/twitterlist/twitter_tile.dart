import 'package:flutter/material.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:tweet_ui/embedded_tweet_view.dart';
import 'package:tweet_ui/models/api/v1/tweet.dart';

class TwitterTile extends StatefulWidget {
  const TwitterTile(this.tweet, this._configuration);

  final Map<String, dynamic> tweet;
  final AppConfiguration _configuration;

  @override
  _TwitterTileState createState() => _TwitterTileState();
}

class _TwitterTileState extends State<TwitterTile> {
  @override
  Widget build(BuildContext context) {
    print(widget._configuration.nightMode);
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: EmbeddedTweetView.fromTweetV1(TweetV1Response.fromJson(widget.tweet),
          backgroundColor: (darkModeOn) ? Colors.grey[800] : Colors.white,
          darkMode: darkModeOn),
    );
  }
}
