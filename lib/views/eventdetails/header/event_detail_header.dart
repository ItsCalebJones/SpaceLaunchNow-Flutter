import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:share/share.dart';
import 'package:spacelaunchnow_flutter/models/event/event_detailed.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/header/diagonally_cut_colored_image.dart';

class EventDetailHeader extends StatelessWidget {

  EventDetailHeader(
    this.event,  {
    @required this.backEnabled,
  });

  final Event event;
  final bool backEnabled;

  void _handleTap() {
  }

  void _handleShare() {
    var id = event.id;
    share("https://spacelaunchnow.me/event/$id");
  }

  Widget _buildDiagonalImageBackground(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    var backgroundUrl = event.featureImage;

    return new DiagonallyCutColoredImage(
      image: backgroundUrl,
      screenWidth: screenWidth,
    );
  }

  Widget _buildAvatar(BuildContext context) {
    var avatarUrl = "https://spacelaunchnow-prod-east.nyc3.cdn.digitaloceanspaces.com/static/home/img/placeholder_agency.jpg";

    if (avatarUrl != null) {
      avatarUrl = event.featureImage;
    }

      return new Container(
        width: 200.0,
        height: 200.0,
        padding: const EdgeInsets.all(2.0), // borde width
        decoration: new BoxDecoration(
          color: Theme.of(context).highlightColor, // border color
          shape: BoxShape.circle,
        ),
        child: new CircleAvatar(
          foregroundColor: Colors.white,
          backgroundImage: new NetworkImage(avatarUrl),
          radius: 100.0,
          backgroundColor: Colors.white,
        ),
      );
    }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    if (backEnabled) {
      return new Stack(
        children: <Widget>[
          _buildDiagonalImageBackground(context),
          new Align(
            alignment: FractionalOffset.bottomCenter,
            heightFactor: 1.35,
            child: _buildAvatar(context),
          ),
          new Positioned(
            top: 24.0,
            left: 4.0,
            child: new BackButton(),
          ),
          new Positioned(
            top: 24.0,
            right: 4.0,
            child: new IconButton(
                icon: const Icon(Icons.share),
                tooltip: 'Refresh',
                onPressed: () {
                  _handleShare();
                }),
          ),
        ],
      );
    } else {
      return new Stack(
        children: <Widget>[
          _buildDiagonalImageBackground(context),
          new Align(
            alignment: FractionalOffset.bottomCenter,
            heightFactor: 1.35,
            child: _buildAvatar(context),
          ),
          new Positioned(
            top: 24.0,
            right: 4.0,
            child: new IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
                onPressed: () {
                  _handleTap();
                }),
          ),
        ],
      );
    }
  }
}
