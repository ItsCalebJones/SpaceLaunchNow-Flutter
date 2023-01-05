import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spacelaunchnow_flutter/models/event/event_detailed.dart';

class EventDetailHeader extends StatelessWidget {
  const EventDetailHeader(
    this.event, {Key? key,
    required this.backEnabled,
  }) : super(key: key);

  final Event? event;
  final bool backEnabled;

  void _handleTap() {}

  void _handleShare() {
    var id = event!.id;
    Share.share("https://spacelaunchnow.me/event/$id");
  }

  Widget _buildAvatar(BuildContext context) {
    String? avatarUrl =
        "https://spacelaunchnow-prod-east.nyc3.cdn.digitaloceanspaces.com/static/home/img/placeholder_agency.jpg";

    avatarUrl = event!.featureImage;

    return Container(
      width: 200.0,
      height: 200.0,
      padding: const EdgeInsets.all(2.0), // border width
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor, // border color
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        foregroundColor: Colors.white,
        backgroundImage: NetworkImage(avatarUrl!),
        radius: 100.0,
        backgroundColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if (backEnabled) {
      return Stack(
        children: <Widget>[
          Align(
            alignment: FractionalOffset.bottomCenter,
            heightFactor: 1.5,
            child: _buildAvatar(context),
          ),
          const Positioned(
            top: 24.0,
            left: 4.0,
            child: BackButton(),
          ),
          Positioned(
            top: 24.0,
            right: 4.0,
            child: IconButton(
                icon: const Icon(Icons.share),
                tooltip: 'Refresh',
                onPressed: () {
                  _handleShare();
                }),
          ),
        ],
      );
    } else {
      return Stack(
        children: <Widget>[
          Align(
            alignment: FractionalOffset.bottomCenter,
            heightFactor: 1.35,
            child: _buildAvatar(context),
          ),
          Positioned(
            top: 24.0,
            right: 4.0,
            child: IconButton(
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
