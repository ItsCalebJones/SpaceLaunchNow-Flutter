import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:spacelaunchnow_flutter/colors/app_colors.dart';
import 'package:spacelaunchnow_flutter/models/launch.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/header/diagonally_cut_colored_image.dart';

class LaunchDetailHeader extends StatelessWidget {
  static const BACKGROUND_IMAGE = 'images/profile_header_background.png';

  LaunchDetailHeader(
    this.launch, {
    this.avatarTag,
    @required this.backEnabled,
  });

  final Launch launch;
  final Object avatarTag;
  final bool backEnabled;

  Widget _buildDiagonalImageBackground(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return new DiagonallyCutColoredImage(
      new Image.network(
        launch.rocket.imageURL,
        width: screenWidth,
        height: 240.0,
        fit: BoxFit.cover,
      ),
      color: SpaceLaunchNowColors.blue_transparent,
    );
  }

  Widget _buildAvatar() {
    if (avatarTag != null) {
      return new Hero(
        tag: avatarTag,
        child: new Container(
          width: 200.0,
          height: 200.0,
          padding: const EdgeInsets.all(4.0), // borde width
          decoration: new BoxDecoration(
          color: const Color(0xFFFFFFFF), // border color
          shape: BoxShape.circle,
          ),
          child: new CircleAvatar(
            foregroundColor: Colors.white,
            backgroundImage: new NetworkImage(launch.rocket.imageURL),
            radius: 100.0,
            backgroundColor: Colors.white,
          ),
        ),
      );
    } else {
      return new Container(
        width: 200.0,
        height: 200.0,
        padding: const EdgeInsets.all(4.0), // borde width
        decoration: new BoxDecoration(
          color: const Color(0xFFFFFFFF), // border color
          shape: BoxShape.circle,
        ),
        child: new CircleAvatar(
          foregroundColor: Colors.white,
          backgroundImage: new NetworkImage(launch.rocket.imageURL),
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

    if (backEnabled) {
      return new Stack(
        children: <Widget>[
          _buildDiagonalImageBackground(context),
          new Align(
            alignment: FractionalOffset.bottomCenter,
            heightFactor: 1.35,
            child: _buildAvatar(),
          ),
          new Positioned(
            top: 24.0,
            left: 4.0,
            child: new BackButton(color: Colors.white),
          ),
          new Positioned(
            top: 24.0,
            right: 4.0,
            child: new IconButton(
                icon: const Icon(Icons.refresh),
                color: Colors.white,
                tooltip: 'Refresh',
                onPressed: () {}),
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
            child: _buildAvatar(),
          ),
          new Positioned(
            top: 24.0,
            right: 4.0,
            child: new IconButton(
                icon: const Icon(Icons.refresh),
                color: Colors.white,
                tooltip: 'Refresh',
                onPressed: () {

                }),
          ),
        ],
      );
    }
  }
}
