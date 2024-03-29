import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:spacelaunchnow_flutter/models/event/event_detailed.dart';
import 'package:spacelaunchnow_flutter/util/date_formatter.dart';
import 'package:spacelaunchnow_flutter/util/url_helper.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/launch_detail_page.dart';
import 'package:spacelaunchnow_flutter/views/starshipdashboard/custom_play_pause.dart';
import 'package:spacelaunchnow_flutter/views/widgets/updates.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class EventDetailBodyWidget extends StatefulWidget {
  const EventDetailBodyWidget(
      {super.key, required this.event});
  final Event event;

  @override
  EventDetailBodyState createState() {
    return EventDetailBodyState();
  }
}

class EventDetailBodyState extends State<EventDetailBodyWidget> {
  var logger = Logger();
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
              widget.event.location ?? "Unknown Location",
              maxLines: 2,
              style: textTheme.titleMedium,
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
              style: textTheme.titleMedium,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeInfo(TextTheme textTheme) {
    var formattedDate = PrecisionFormattedDate.getPrecisionFormattedDate(
      widget.event.datePrecision?.id ?? 0,
      widget.event.net!.toLocal()
    );
    return Row(
      children: <Widget>[
        const Icon(
          Icons.timer,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(formattedDate,
              maxLines: 2,
              style: textTheme.titleMedium,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      ],
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
            style: textTheme.displayLarge!
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
      YoutubePlayerController controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.event.videoUrl!)!,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
        ),
      );
      widgets.add(Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: YoutubePlayer(
          key: ObjectKey(controller),
          controller: controller,
          showVideoProgressIndicator: false,
          bottomActions: const <Widget>[CustomPlayPauseButton()],
        ),
      ));

      widgets.add(Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(24),
            child: CupertinoButton(
              color: Colors.red,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
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
                openUrl(widget.event.videoUrl!);
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
                    .displayLarge!
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
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
                openUrl(widget.event.newsUrl!);
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
                        .displayLarge!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 30)),
              ),
            ),
            ListTile(
              onTap: () =>
                  _navigateToLaunchDetails(avatarTag: 0, launchId: launch.id),
              leading: Hero(
                tag: 0,
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(launch.image ?? "https://spacelaunchnow-prod-east.nyc3.digitaloceanspaces.com/static/home/img/placeholder.jpg"),
                ),
              ),
              title: Text(launch.name!,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 15.0)),
              subtitle: Text(launch.pad!.location!.name!),
              trailing: Text(formatter.format(launch.net!),
                  style: Theme.of(context).textTheme.bodySmall),
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
            launch: null,
            avatarTag: avatarTag,
            launchId: launchId,
          );
        },
      ),
    );
  }
}
