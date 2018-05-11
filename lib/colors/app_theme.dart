import 'package:flutter/material.dart';
import 'package:spacelaunchnow_flutter/colors/app_colors.dart';

final ThemeData kDarkIOSTheme = new ThemeData(
  primarySwatch: SpaceLaunchNowColors.primary,
  primaryColor: SpaceLaunchNowColors.primary[500],
  accentColor: SpaceLaunchNowColors.secondary[500],
);

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.blue,
  primaryColor: Colors.blue[500],
  accentColor: Colors.red[500],
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