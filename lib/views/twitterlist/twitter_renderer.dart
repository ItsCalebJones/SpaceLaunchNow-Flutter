import 'package:flutter/material.dart';
import 'package:spacelaunchnow_flutter/views/twitterlist/twitter_tile.dart';

class TwitterRenderer {
  TwitterRenderer();

  Widget render(List data) {
    return ListView(
      children: data.map((tweet) => TwitterTile(tweet)).toList(),
    );
  }
}