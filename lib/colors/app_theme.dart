import 'package:flutter/material.dart';

final ThemeData kIOSTheme = ThemeData(
  primaryColorBrightness: Brightness.light,
  brightness: Brightness.light,
  primaryColor: Colors.grey[200],
  typography: Typography.material2018(
      platform: TargetPlatform.iOS,
      black: Typography.blackMountainView.copyWith(
        headline1: Typography.blackMountainView.headline1!
            .copyWith(color: Colors.black87),
        headline2: Typography.blackMountainView.headline2!
            .copyWith(color: Colors.black87),
        headline3: Typography.blackMountainView.headline3!
            .copyWith(color: Colors.black87),
        headline4: Typography.blackMountainView.headline4!
            .copyWith(color: Colors.black87),
      ),
      white: Typography.whiteMountainView.copyWith(
        headline1: Typography.whiteMountainView.headline1!
            .copyWith(color: Colors.white),
        headline2: Typography.whiteMountainView.headline2!
            .copyWith(color: Colors.white),
        headline3: Typography.whiteMountainView.headline3!
            .copyWith(color: Colors.white),
        headline4: Typography.whiteMountainView.headline4!
            .copyWith(color: Colors.white),
      )),
  colorScheme:
      ColorScheme.fromSwatch(primarySwatch: Colors.red, accentColor: Colors.red)
          .copyWith(secondary: Colors.red, brightness: Brightness.light),
);

final ThemeData kIOSThemeDark = ThemeData(
  primaryColorBrightness: Brightness.dark,
  brightness: Brightness.dark,
  primaryColor: Colors.grey[800],
  typography: Typography.material2018(
      platform: TargetPlatform.iOS,
      black: Typography.blackMountainView.copyWith(
        headline1: Typography.blackMountainView.headline1!
            .copyWith(color: Colors.black87),
        headline2: Typography.blackMountainView.headline2!
            .copyWith(color: Colors.black87),
        headline3: Typography.blackMountainView.headline3!
            .copyWith(color: Colors.black87),
        headline4: Typography.blackMountainView.headline4!
            .copyWith(color: Colors.black87),
      ),
      white: Typography.whiteMountainView.copyWith(
        headline1: Typography.whiteMountainView.headline1!
            .copyWith(color: Colors.white),
        headline2: Typography.whiteMountainView.headline2!
            .copyWith(color: Colors.white),
        headline3: Typography.whiteMountainView.headline3!
            .copyWith(color: Colors.white),
        headline4: Typography.whiteMountainView.headline4!
            .copyWith(color: Colors.white),
      )),
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
    accentColor: Colors.red,
  ).copyWith(secondary: Colors.red, brightness: Brightness.dark),
);

final ThemeData kIOSThemeBar = ThemeData(
  primaryColorBrightness: Brightness.light,
  brightness: Brightness.light,
  canvasColor: Colors.grey[200],
  primarySwatch: Colors.blue,
  primaryColor: Colors.blue[600],
  focusColor: Colors.black,
  typography: Typography.material2018(
      platform: TargetPlatform.iOS,
      black: Typography.blackMountainView.copyWith(
        headline1: Typography.blackMountainView.headline1!
            .copyWith(color: Colors.black87),
        headline2: Typography.blackMountainView.headline2!
            .copyWith(color: Colors.black87),
        headline3: Typography.blackMountainView.headline3!
            .copyWith(color: Colors.black87),
        headline4: Typography.blackMountainView.headline4!
            .copyWith(color: Colors.black87),
      ),
      white: Typography.whiteMountainView.copyWith(
        headline1: Typography.whiteMountainView.headline1!
            .copyWith(color: Colors.white),
        headline2: Typography.whiteMountainView.headline2!
            .copyWith(color: Colors.white),
        headline3: Typography.whiteMountainView.headline3!
            .copyWith(color: Colors.white),
        headline4: Typography.whiteMountainView.headline4!
            .copyWith(color: Colors.white),
      )),
);

final ThemeData kIOSThemeDarkBar = ThemeData(
  primaryColorBrightness: Brightness.dark,
  brightness: Brightness.dark,
  canvasColor: Colors.grey[800],
  primaryColor: Colors.grey[800],
  focusColor: Colors.white,
  typography: Typography.material2018(
      platform: TargetPlatform.iOS,
      black: Typography.blackMountainView.copyWith(
        headline1: Typography.blackMountainView.headline1!
            .copyWith(color: Colors.black87),
        headline2: Typography.blackMountainView.headline2!
            .copyWith(color: Colors.black87),
        headline3: Typography.blackMountainView.headline3!
            .copyWith(color: Colors.black87),
        headline4: Typography.blackMountainView.headline4!
            .copyWith(color: Colors.black87),
      ),
      white: Typography.whiteMountainView.copyWith(
        headline1: Typography.whiteMountainView.headline1!
            .copyWith(color: Colors.white),
        headline2: Typography.whiteMountainView.headline2!
            .copyWith(color: Colors.white),
        headline3: Typography.whiteMountainView.headline3!
            .copyWith(color: Colors.white),
        headline4: Typography.whiteMountainView.headline4!
            .copyWith(color: Colors.white),
      )),
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
      .copyWith(secondary: Colors.red, brightness: Brightness.dark),
);
