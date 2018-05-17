import 'package:flutter/material.dart';
import 'package:spacelaunchnow_flutter/colors/app_colors.dart';

final ThemeData kDarkIOSTheme = new ThemeData(
  primarySwatch: SpaceLaunchNowColors.primary,
  primaryColor: SpaceLaunchNowColors.primary[500],
  accentColor: SpaceLaunchNowColors.secondary[500],
);

final ThemeData kIOSTheme = new ThemeData(
  primaryColorBrightness: Brightness.light,
  primarySwatch: Colors.blue,
  primaryColor: Colors.grey[300],
);

final ThemeData kDarkDefaultTheme = new ThemeData(
  primaryColorBrightness: Brightness.dark,
  brightness: Brightness.dark,
  primarySwatch: SpaceLaunchNowColors.primary,
  primaryColor: SpaceLaunchNowColors.primary[500],
  accentColor: SpaceLaunchNowColors.secondary[500],
);

final ThemeData kDefaultTheme = new ThemeData(
  primaryColorBrightness: Brightness.dark,
  primarySwatch: Colors.blue,
  primaryColor: Colors.blue[500],
  accentColor: Colors.red[500],
);

/// App bar that uses iOS styling on iOS
class PlatformAdaptiveAppBar extends AppBar {
  PlatformAdaptiveAppBar({
    Key key,
    TargetPlatform platform,
    List<Widget> actions,
    Widget title,
    Widget body,
    // TODO(jackson): other properties?
  })
      : super(
    key: key,
    elevation: platform == TargetPlatform.iOS ? 0.0 : 4.0,
    title: title,
    actions: actions,
  );
}