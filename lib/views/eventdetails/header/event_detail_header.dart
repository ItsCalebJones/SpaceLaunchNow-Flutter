import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spacelaunchnow_flutter/models/event/event_detailed.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/header_background_image.dart';

class EventDetailHeader extends StatelessWidget {
  const EventDetailHeader(
    this.event, {super.key,
    required this.backEnabled,
  });

  final Event? event;
  final bool backEnabled;

  void _handleImageTap(BuildContext context, String imageUrl) {
    showImageViewer(context, Image.network(imageUrl).image,
                swipeDismissible: false);
  }

  void _handleShare() {
    var id = event!.id;
    Share.share("https://spacelaunchnow.me/event/$id");
  }

  Widget _buildAvatar(BuildContext context) {
    String avatarUrl =
        "https://spacelaunchnow-prod-east.nyc3.cdn.digitaloceanspaces.com/static/home/img/placeholder_agency.jpg";

    avatarUrl = event!.featureImage!;

    return GestureDetector(
        onTap: () {
          _handleImageTap(context, avatarUrl);
        },
      child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.width * 0.4,
          padding: const EdgeInsets.all(5.0), // border width
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary, // border color
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            foregroundColor: Colors.white,
            backgroundImage: NetworkImage(avatarUrl),
            radius: 100.0,
            backgroundColor: Colors.white,
          ),
        ),
    );
  }

  Widget _buildDiagonalImageBackground(BuildContext context) {
    String avatarUrl = event!.featureImage ?? "https://spacelaunchnow-prod-east.nyc3.cdn.digitaloceanspaces.com/static/home/img/placeholder_agency.jpg";

    return HeaderBackgroundImage(
      image: avatarUrl,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {

    if (backEnabled) {
      return Stack(
        children: <Widget>[
          _buildDiagonalImageBackground(context),
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
                tooltip: 'Share',
                onPressed: () {
                  _handleShare();
                }),
          ),
        ],
      );
    } else {
      return Stack(
        children: <Widget>[
          _buildDiagonalImageBackground(context),
          Align(
            alignment: FractionalOffset.bottomCenter,
            heightFactor: 1.35,
            child: _buildAvatar(context),
          ),
          Positioned(
            top: 24.0,
            right: 4.0,
            child: IconButton(
                icon: const Icon(Icons.share),
                tooltip: 'Share',
                onPressed: () {
                  _handleShare();
                }),
          ),
        ],
      );
    }
  }
}
