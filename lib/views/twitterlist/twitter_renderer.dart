import 'package:flutter/material.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:spacelaunchnow_flutter/views/twitterlist/twitter_tile.dart';

class TwitterRenderer {
  TwitterRenderer(this._configuration);

  final AppConfiguration _configuration;

  Widget render(List data) {
    return ListView(
      children: data.map((tweet) => TwitterTile(tweet, _configuration)).toList(),
    );
  }
}