import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TwitterTile extends StatefulWidget {
  TwitterTile(Map<String, dynamic> tweet) : this.tweet = tweet;

  final Map<String, dynamic> tweet;

  @override
  _TwitterTileState createState() => _TwitterTileState();
}

class _TwitterTileState extends State<TwitterTile> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _launchTwitterURL(widget.tweet["id_str"],
          widget.tweet["user"]["screen_name"]),
      child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: NetworkImage(widget.tweet["user"]["profile_image_url_https"]),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  widget.tweet['user']['name'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "@" + widget.tweet['user']['screen_name'],
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey,
                            )
                          ],
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Text(
                            widget.tweet['full_text'],
                          ),
                        ),
                        Container(
                          child: widget.tweet["entities"]["media"] == null
                              ? null
                              : Container(
                            width: double.infinity,
                            child: ClipRRect(
                                borderRadius:
                                BorderRadius.circular(8.0),
                                child: new CachedNetworkImage(imageUrl: widget.tweet["entities"]["media"][0]['media_url_https'])),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                width: double.infinity,
                color: Colors.grey,
                height: 0.5,
              ),
            )
          ],
        ),
    );
  }
}

_launchTwitterURL(String tweetId, String ownerName) async {
  var fullURL = 'https://twitter.com/$ownerName/statuses/$tweetId';

  if (await canLaunch(fullURL)) {
    await launch(fullURL);
  } else {
    throw 'Could not launch $fullURL';
  }
}