import 'package:flutter/material.dart';

final ThemeData kIOSTheme = new ThemeData(
  primaryColorBrightness: Brightness.light,
  brightness: Brightness.light,
  primarySwatch: Colors.red,
  primaryColor: Colors.grey[200],
  accentColor: Colors.red,
  typography: new Typography.material2018(
      platform: TargetPlatform.iOS,
      black: Typography.blackMountainView.copyWith(
          headline1: Typography.blackMountainView.headline1.copyWith(color: Colors.black87),
          headline2: Typography.blackMountainView.headline2.copyWith(color: Colors.black87),
          headline3: Typography.blackMountainView.headline3.copyWith(color: Colors.black87),
          headline4: Typography.blackMountainView.headline4.copyWith(color: Colors.black87),
      ),
      white: Typography.whiteMountainView.copyWith(
        headline1: Typography.whiteMountainView.headline1.copyWith(color: Colors.white),
        headline2: Typography.whiteMountainView.headline2.copyWith(color: Colors.white),
        headline3: Typography.whiteMountainView.headline3.copyWith(color: Colors.white),
        headline4: Typography.whiteMountainView.headline4.copyWith(color: Colors.white),
      )),
);

final ThemeData kIOSThemeDark = new ThemeData(
    primaryColorBrightness: Brightness.dark,
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    primaryColor: Colors.grey[800],
    accentColor: Colors.red,
  typography: new Typography.material2018(
      platform: TargetPlatform.iOS,
      black: Typography.blackMountainView.copyWith(
        headline1: Typography.blackMountainView.headline1.copyWith(color: Colors.black87),
        headline2: Typography.blackMountainView.headline2.copyWith(color: Colors.black87),
        headline3: Typography.blackMountainView.headline3.copyWith(color: Colors.black87),
        headline4: Typography.blackMountainView.headline4.copyWith(color: Colors.black87),
      ),
      white: Typography.whiteMountainView.copyWith(
        headline1: Typography.whiteMountainView.headline1.copyWith(color: Colors.white),
        headline2: Typography.whiteMountainView.headline2.copyWith(color: Colors.white),
        headline3: Typography.whiteMountainView.headline3.copyWith(color: Colors.white),
        headline4: Typography.whiteMountainView.headline4.copyWith(color: Colors.white),
      )),
);

final ThemeData kIOSThemeBar = new ThemeData(
    primaryColorBrightness: Brightness.light,
    brightness: Brightness.light,
    canvasColor: Colors.grey[200],
    primarySwatch: Colors.blue,
    primaryColor: Colors.blue[600],
    focusColor: Colors.black,
    typography: new Typography.material2018(
        platform: TargetPlatform.iOS,
        black: Typography.blackMountainView.copyWith(
          headline1: Typography.blackMountainView.headline1.copyWith(color: Colors.black87),
          headline2: Typography.blackMountainView.headline2.copyWith(color: Colors.black87),
          headline3: Typography.blackMountainView.headline3.copyWith(color: Colors.black87),
          headline4: Typography.blackMountainView.headline4.copyWith(color: Colors.black87),
        ),
        white: Typography.whiteMountainView.copyWith(
          headline1: Typography.whiteMountainView.headline1.copyWith(color: Colors.white),
          headline2: Typography.whiteMountainView.headline2.copyWith(color: Colors.white),
          headline3: Typography.whiteMountainView.headline3.copyWith(color: Colors.white),
          headline4: Typography.whiteMountainView.headline4.copyWith(color: Colors.white),
        )),
);

final ThemeData kIOSThemeDarkBar = new ThemeData(
    primaryColorBrightness: Brightness.dark,
    brightness: Brightness.dark,
    canvasColor: Colors.grey[800],
    primarySwatch: Colors.blue,
    primaryColor: Colors.grey[800],
    accentColor: Colors.red,
    focusColor: Colors.white,
    typography: new Typography.material2018(
        platform: TargetPlatform.iOS,
        black: Typography.blackMountainView.copyWith(
          headline1: Typography.blackMountainView.headline1.copyWith(color: Colors.black87),
          headline2: Typography.blackMountainView.headline2.copyWith(color: Colors.black87),
          headline3: Typography.blackMountainView.headline3.copyWith(color: Colors.black87),
          headline4: Typography.blackMountainView.headline4.copyWith(color: Colors.black87),
        ),
        white: Typography.whiteMountainView.copyWith(
          headline1: Typography.whiteMountainView.headline1.copyWith(color: Colors.white),
          headline2: Typography.whiteMountainView.headline2.copyWith(color: Colors.white),
          headline3: Typography.whiteMountainView.headline3.copyWith(color: Colors.white),
          headline4: Typography.whiteMountainView.headline4.copyWith(color: Colors.white),
        )),
);
