
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:spacelaunchnow_flutter/models/event/event_detailed.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/launch_detail_page.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:spacelaunchnow_flutter/views/starshipdashboard/custom_play_pause.dart';
import 'package:spacelaunchnow_flutter/views/widgets/ads/ad_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:spacelaunchnow_flutter/views/widgets/updates.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class EventDetailBodyWidget extends StatefulWidget {
  final Event? event;
  final AppConfiguration _configuration;

  EventDetailBodyWidget(this.event, this._configuration);

  @override
  State createState() => new EventDetailBodyState(this.event);
}

class EventDetailBodyState extends State<EventDetailBodyWidget> {
  EventDetailBodyState(
    this.mEvent,
  );

  final Event? mEvent;

  Widget _buildLocationInfo(TextTheme textTheme) {
    return new Row(
      children: <Widget>[
        new Icon(
          Icons.place,
        ),
        new Expanded(
          child: new Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: new Text(
              mEvent!.location!,
              maxLines: 2,
              style: textTheme.subtitle1,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusInfo(TextTheme textTheme) {
    var icon = Icons.event;
    return new Row(
      children: <Widget>[
        new Icon(icon),
        new Expanded(
          child: new Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: new Text(
              mEvent!.type!.name!,
              maxLines: 2,
              style: textTheme.subtitle1,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeInfo(TextTheme textTheme) {
    return new Row(
      children: <Widget>[
        new Icon(
          Icons.timer,
        ),
        new Expanded(
          child: new Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: new Text(
              new DateFormat("h:mm a 'on' EEEE, MMMM d, yyyy")
                  .format(mEvent!.net!.toLocal()),
              maxLines: 2,
              style: textTheme.subtitle1,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      ],
    );
  }



  _openUrl(String url) async {
    Uri? _url = Uri.tryParse(url);
    if (_url != null && _url.host.contains("youtube.com") && Platform.isIOS) {
      final String _finalUrl = _url.host + _url.path + "?" + _url.query;
      if (await canLaunch('youtube://$_finalUrl')) {
        await launch('youtube://$_finalUrl', forceSafariVC: false);
      }
    } else {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  Widget _buildActionButtons(ThemeData theme) {
    List<Widget> materialButtons = [];

    if (mEvent!.id != null) {
      var eventUrl = "https://spacelaunchnow.me/event/$mEvent.id";
      materialButtons.add(new Row(
        children: <Widget>[
          new Icon(Icons.share),
          new Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: new CupertinoButton(
              onPressed: () {
                Share.share(eventUrl);
              },
              child: new Text(
                'Share Event',
              ),
            ),
          ),
        ],
      ));
    }

    return new Padding(
      padding:
          const EdgeInsets.only(top: 0.0, left: 8.0, right: 8.0, bottom: 0.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: materialButtons,
      ),
    );
  }

  Widget _buildSpace() {
    return new SizedBox(height: 200);
  }

  Widget _buildContentCard(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var id = mEvent!.id;

    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
          child: new Text(
            mEvent!.name!,
            style: textTheme.headline1!                .copyWith(fontWeight: FontWeight.bold, fontSize: 30),
            textAlign: TextAlign.start,
          ),
        ),
        new Padding(
          padding: const EdgeInsets.only(
              top: 4.0, left: 8.0, right: 8.0, bottom: 2.0),
          child: _buildStatusInfo(textTheme),
        ),
        new Padding(
          padding: const EdgeInsets.only(
              top: 4.0, left: 8.0, right: 8.0, bottom: 2.0),
          child: _buildLocationInfo(textTheme),
        ),
        new Padding(
          padding: const EdgeInsets.only(
              top: 2.0, left: 8.0, right: 8.0, bottom: 2.0),
          child: _buildTimeInfo(textTheme),
        ),
        _buildDescription(),
        buildUpdates(mEvent!.updates!, context, "https://spacelaunchnow.me/event/$id"),
        _buildSpace(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContentCard(context);
  }

  Widget _buildDescription() {
    List<Widget> widgets = [];

    if (mEvent!.videoUrl != null && YoutubePlayer.convertUrlToId(mEvent!.videoUrl!) != null) {
      YoutubePlayerController _controller = YoutubePlayerController(
        initialVideoId:
        YoutubePlayer.convertUrlToId(mEvent!.videoUrl!)!,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
        ),
      );
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: new YoutubePlayer(
            key: ObjectKey(_controller),
            controller: _controller,
            showVideoProgressIndicator: false,
            bottomActions: <Widget>[CustomPlayPauseButton()],
          ),
        )
      );

      widgets.add(new Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(24),
              child: CupertinoButton(
                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: new Icon(
                        FontAwesomeIcons.youtube,
                      ),
                    ),
                    new Text(
                      'Open in YouTube',
                      style: TextStyle(),
                    ),
                  ],
                ),
                onPressed: () {
                  _openUrl(mEvent!.videoUrl!);
                }, //
              ),
            ),
          ],
        ),
      ));
    } else {
      widgets.add(Container());
    }

    widgets.add(
        new Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: new Text(
                      "Event Details",
                      style: Theme.of(context).textTheme.headline1!                          .copyWith(fontWeight: FontWeight.bold, fontSize: 30)),
                ),
                new Text(mEvent!.description!),
              ],
            ),
        )
    );

    if (mEvent!.newsUrl != null) {
      widgets.add(new Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom:24, top:16, left:8, right:8),
              child: CupertinoButton(
                color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: new Icon(
                        FontAwesomeIcons.desktop,
                      ),
                    ),
                    new Text(
                      'Related Information',
                      style: TextStyle(),
                    ),
                  ],
                ),
                onPressed: () {
                  _openUrl(mEvent!.newsUrl!);
                }, //
              ),
            ),
          ],
        ),
      ));
    }


    if (mEvent!.launches != null && mEvent!.launches!.length > 0) {
      var launch = mEvent!.launches!.first;
      var formatter = new DateFormat.yMd();

      widgets.add(new Padding(
        padding: const EdgeInsets.only(top: 4.0, bottom: 4.0,),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left:8.0, right: 8.0),
                child: new Text(
                    "Related Launch",
                    style: Theme.of(context).textTheme.headline1!                        .copyWith(fontWeight: FontWeight.bold, fontSize: 30)),
              ),
            ),
            new ListTile(
              onTap: () =>
                  _navigateToLaunchDetails(avatarTag: 0, launchId: launch.id),
              leading: new Hero(
                tag: 0,
                child: new CircleAvatar(
                  backgroundImage: new CachedNetworkImageProvider(launch.image!),
                ),
              ),
              title: new Text(launch.name!, style: Theme
                  .of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontSize: 15.0)),
              subtitle: new Text(launch.pad!.location!.name!),
              trailing: new Text(formatter.format(launch.net!), style: Theme
                  .of(context)
                  .textTheme
                  .caption),
            ),
          ],
        ),
      ));
    }


    return new Column(children: widgets);
  }

    void _navigateToLaunchDetails({Object? avatarTag, String? launchId}) {
      Navigator.of(context).push(
        new MaterialPageRoute(
          builder: (c) {
            return new LaunchDetailPage(widget._configuration, launch: null,
              avatarTag: avatarTag,
              launchId: launchId,);
          },
        ),
      );
    }

}


