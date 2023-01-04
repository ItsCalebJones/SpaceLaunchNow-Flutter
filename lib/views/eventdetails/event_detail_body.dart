import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spacelaunchnow_flutter/models/event/event_detailed.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/launch_detail_page.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:spacelaunchnow_flutter/views/starshipdashboard/custom_play_pause.dart';
import 'package:spacelaunchnow_flutter/views/widgets/updates.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class EventDetailBodyWidget extends StatefulWidget {
  const EventDetailBodyWidget(
      {Key? key, required this.event, required this.configuration})
      : super(key: key);
  final Event event;
  final AppConfiguration configuration;

  @override
  EventDetailBodyState createState() {
    return EventDetailBodyState();
  }
}

class EventDetailBodyState extends State<EventDetailBodyWidget> {
  Widget _buildLocationInfo(TextTheme textTheme) {
    return Row(
      children: <Widget>[
        const Icon(
          Icons.place,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              widget.event.location!,
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
    return Row(
      children: <Widget>[
        Icon(icon),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              widget.event.type!.name!,
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
    return Row(
      children: <Widget>[
        const Icon(
          Icons.timer,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              DateFormat("h:mm a 'on' EEEE, MMMM d, yyyy")
                  .format(widget.event.net!.toLocal()),
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

    if (widget.event.id != null) {
      var eventUrl = "https://spacelaunchnow.me/event/$widget.event.id";
      materialButtons.add(Row(
        children: <Widget>[
          const Icon(Icons.share),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CupertinoButton(
              onPressed: () {
                Share.share(eventUrl);
              },
              child: const Text(
                'Share Event',
              ),
            ),
          ),
        ],
      ));
    }

    return Padding(
      padding:
          const EdgeInsets.only(top: 0.0, left: 8.0, right: 8.0, bottom: 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: materialButtons,
      ),
    );
  }

  Widget _buildSpace() {
    return const SizedBox(height: 200);
  }

  Widget _buildContentCard(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var id = widget.event.id;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
          child: Text(
            widget.event.name!,
            style: textTheme.headline1!
                .copyWith(fontWeight: FontWeight.bold, fontSize: 30),
            textAlign: TextAlign.start,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 4.0, left: 8.0, right: 8.0, bottom: 2.0),
          child: _buildStatusInfo(textTheme),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 4.0, left: 8.0, right: 8.0, bottom: 2.0),
          child: _buildLocationInfo(textTheme),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 2.0, left: 8.0, right: 8.0, bottom: 2.0),
          child: _buildTimeInfo(textTheme),
        ),
        _buildDescription(),
        buildUpdates(widget.event.updates!, context,
            "https://spacelaunchnow.me/event/$id"),
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

    if (widget.event.videoUrl != null &&
        YoutubePlayer.convertUrlToId(widget.event.videoUrl!) != null) {
      YoutubePlayerController _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.event.videoUrl!)!,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
        ),
      );
      widgets.add(Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: YoutubePlayer(
          key: ObjectKey(_controller),
          controller: _controller,
          showVideoProgressIndicator: false,
          bottomActions: <Widget>[CustomPlayPauseButton()],
        ),
      ));

      widgets.add(Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(24),
            child: CupertinoButton(
              color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Icon(
                      FontAwesomeIcons.youtube,
                    ),
                  ),
                  Text(
                    'Open in YouTube',
                    style: TextStyle(),
                  ),
                ],
              ),
              onPressed: () {
                _openUrl(widget.event.videoUrl!);
              }, //
            ),
          ),
        ],
      ));
    } else {
      widgets.add(Container());
    }

    widgets.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Event Details",
                style: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 30)),
          ),
          Text(widget.event.description!),
        ],
      ),
    ));

    if (widget.event.newsUrl != null) {
      widgets.add(Column(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(bottom: 24, top: 16, left: 8, right: 8),
            child: CupertinoButton(
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Icon(
                      FontAwesomeIcons.desktop,
                    ),
                  ),
                  Text(
                    'Related Information',
                    style: TextStyle(),
                  ),
                ],
              ),
              onPressed: () {
                _openUrl(widget.event.newsUrl!);
              }, //
            ),
          ),
        ],
      ));
    }

    if (widget.event.launches != null && widget.event.launches!.isNotEmpty) {
      var launch = widget.event.launches!.first;
      var formatter = DateFormat.yMd();

      widgets.add(Padding(
        padding: const EdgeInsets.only(
          top: 4.0,
          bottom: 4.0,
        ),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text("Related Launch",
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 30)),
              ),
            ),
            ListTile(
              onTap: () =>
                  _navigateToLaunchDetails(avatarTag: 0, launchId: launch.id),
              leading: Hero(
                tag: 0,
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(launch.image!),
                ),
              ),
              title: Text(launch.name!,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontSize: 15.0)),
              subtitle: Text(launch.pad!.location!.name!),
              trailing: Text(formatter.format(launch.net!),
                  style: Theme.of(context).textTheme.caption),
            ),
          ],
        ),
      ));
    }

    return Column(children: widgets);
  }

  void _navigateToLaunchDetails({Object? avatarTag, String? launchId}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) {
          return LaunchDetailPage(
            widget.configuration,
            launch: null,
            avatarTag: avatarTag,
            launchId: launchId,
          );
        },
      ),
    );
  }
}
