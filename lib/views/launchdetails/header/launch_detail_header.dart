import 'package:flutter/material.dart';
import 'package:spacelaunchnow_flutter/models/launch/detailed/launch.dart';

class LaunchDetailHeader extends StatelessWidget {
  const LaunchDetailHeader(
    this.launch, {super.key,
    required this.loadLaunch,
    this.avatarTag,
    required this.backEnabled,
  });

  final ValueChanged<String?> loadLaunch;
  final Launch? launch;
  final Object? avatarTag;
  final bool? backEnabled;

  void _handleTap() {
    loadLaunch(launch!.id);
  }

  Widget _buildAvatar(BuildContext context) {
    String? avatarUrl =
        "https://spacelaunchnow-prod-east.nyc3.cdn.digitaloceanspaces.com/static/home/img/placeholder_agency.jpg";
    if (launch!.rocket!.configuration!.image != null &&
        launch!.rocket!.configuration!.image!.isNotEmpty) {
      avatarUrl = launch!.rocket!.configuration!.image;
    } else if (launch!.pad != null) {
      avatarUrl = launch!.pad!.mapImage;
    }

    if (avatarTag != null) {
      return Hero(
        tag: avatarTag!,
        child: Container(
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
        ),
      );
    } else {
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
  }

  @override
  Widget build(BuildContext context) {

    if (backEnabled!) {
      return Stack(
        children: <Widget>[
          Align(
            alignment: FractionalOffset.bottomCenter,
            heightFactor: 1.35,
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
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
                onPressed: () {
                  _handleTap();
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
