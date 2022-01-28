import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:spacelaunchnow_flutter/colors/app_colors.dart';
import 'package:spacelaunchnow_flutter/models/launch/detailed/launch.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/header/diagonally_cut_colored_image.dart';

class LaunchDetailHeader extends StatelessWidget {

  LaunchDetailHeader(
    this.launch,  {
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
    String? avataruUrl = "https://spacelaunchnow-prod-east.nyc3.cdn.digitaloceanspaces.com/static/home/img/placeholder_agency.jpg";
    if (launch!.rocket!.configuration!.image != null &&
        launch!.rocket!.configuration!.image!.length > 0){
      avataruUrl = launch!.rocket!.configuration!.image;
    } else if (launch!.pad != null){
      avataruUrl = launch!.pad!.mapImage;
    }

    if (avatarTag != null) {
      return new Hero(
        tag: avatarTag!,
        child: new Container(
          width: 200.0,
          height: 200.0,
          padding: const EdgeInsets.all(2.0), // borde width
          decoration: new BoxDecoration(
          color: Theme.of(context).highlightColor, // border color
          shape: BoxShape.circle,
          ),
          child: new CircleAvatar(
            foregroundColor: Colors.white,
            backgroundImage: new NetworkImage(avataruUrl!),
            radius: 100.0,
            backgroundColor: Colors.white,
          ),
        ),
      );
    } else {
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
          backgroundImage: new NetworkImage(avataruUrl!),
          radius: 100.0,
          backgroundColor: Colors.white,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    if (backEnabled!) {
      return new Stack(
        children: <Widget>[
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
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
                onPressed: () {
                  _handleTap();
                }),
          ),
        ],
      );
    } else {
      return new Stack(
        children: <Widget>[
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
