import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:spacelaunchnow_flutter/colors/app_colors.dart';
import 'package:spacelaunchnow_flutter/models/launch.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/header/diagonally_cut_colored_image.dart';
import 'package:spacelaunchnow_flutter/views/widgets/countdown.dart';

class LaunchDetailHeader extends StatelessWidget {
  static const BACKGROUND_IMAGE = 'images/profile_header_background.png';

  LaunchDetailHeader(this.launch,
      this.animationController,
      this.startValue, {
        this.avatarTag,
        @required this.backEnabled,
      });

  final Launch launch;
  final AnimationController animationController;
  final int startValue;
  final Object avatarTag;
  final bool backEnabled;

  Widget _buildDiagonalImageBackground(BuildContext context) {
    var screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return new DiagonallyCutColoredImage(
      new Image.network(launch.rocket.imageURL,
        width: screenWidth,
        height: 280.0,
        fit: BoxFit.cover,
      ),
      color: SpaceLaunchNowColors.blue_transparent,
    );
  }

  Widget _buildAvatar() {
    if (avatarTag != null) {
      return new Hero(
        tag: avatarTag,
        child: new CircleAvatar(
          backgroundImage: new NetworkImage(launch.rocket.imageURL),
          radius: 75.0,
        ),
      );
    } else {
      return new CircleAvatar(
        backgroundImage: new NetworkImage(launch.rocket.imageURL),
        radius: 75.0,
      );
    }
  }

  Widget _buildFollowerInfo(TextTheme textTheme) {
    var followerStyle =
    textTheme.subhead.copyWith(color: const Color(0xBBFFFFFF));

    return new Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: new Countdown(
        animation: new StepTween(
          begin: startValue,
          end: 0,
        ).animate(animationController),
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return new Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _createPillButton(
            'Watch Live',
            backgroundColor: theme.accentColor,
          ),
          new DecoratedBox(
            decoration: new BoxDecoration(
              border: new Border.all(color: Colors.white30),
              borderRadius: new BorderRadius.circular(30.0),
            ),
            child: _createPillButton(
              'Share',
              textColor: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _createPillButton(String text, {
    Color backgroundColor = Colors.transparent,
    Color textColor = Colors.white70,
  }) {
    return new ClipRRect(
      borderRadius: new BorderRadius.circular(30.0),
      child: new MaterialButton(
        minWidth: 140.0,
        color: backgroundColor,
        textColor: textColor,
        onPressed: () {},
        child: new Text(text),
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
            heightFactor: 1.4,
            child: new Column(
              children: <Widget>[
                _buildAvatar(),
                _buildFollowerInfo(textTheme),
                _buildActionButtons(theme),
              ],
            ),
          ),
          new Positioned(
            top: 26.0,
            left: 4.0,
            child: new BackButton(color: Colors.white),
          ),
        ],
      );
    } else {
      return new Stack(
        children: <Widget>[
          _buildDiagonalImageBackground(context),
          new Align(
            alignment: FractionalOffset.bottomCenter,
            heightFactor: 1.4,
            child: new Column(
              children: <Widget>[
                _buildAvatar(),
                _buildFollowerInfo(textTheme),
                _buildActionButtons(theme),
              ],
            ),
          ),
        ],
      );
    }
  }
}
