import 'package:flutter/material.dart';



final ThemeData kIOSTheme = new ThemeData(
  primaryColorBrightness: Brightness.light,
  brightness: Brightness.light,
  primarySwatch: Colors.red,
  primaryColor: Colors.grey[200],
  accentColor: Colors.red,
  textTheme: new Typography.material2018(platform: TargetPlatform.iOS).black
);

final ThemeData kIOSThemeDark = new ThemeData(
    primaryColorBrightness: Brightness.dark,
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    primaryColor: Colors.grey[800],
    accentColor: Colors.red,
    textTheme: new Typography.material2018(platform: TargetPlatform.iOS).white
);

final ThemeData kIOSThemeBar = new ThemeData(
    primaryColorBrightness: Brightness.light,
    brightness: Brightness.light,
    canvasColor: Colors.grey[200],
    primarySwatch: Colors.blue,
    primaryColor: Colors.blue[600],
    textTheme: new Typography.material2018(platform: TargetPlatform.iOS).black
);

final ThemeData kIOSThemeDarkBar = new ThemeData(
    primaryColorBrightness: Brightness.dark,
    brightness: Brightness.dark,
    canvasColor: Colors.grey[800],
    primarySwatch: Colors.blue,
    primaryColor: Colors.grey[800],
    accentColor: Colors.red,
    textTheme: new Typography.material2018(platform: TargetPlatform.iOS).white
);

final ThemeData kIOSThemeAppBar = kIOSThemeBar.copyWith(primaryColor: Colors.grey[400]);

final ThemeData kIOSThemeDarkAppBar = kIOSThemeDark;

final ThemeData kDefaultTheme = new ThemeData(
  primaryColorBrightness: Brightness.dark,
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
    primaryColor: Colors.grey[300],
  accentColor: Colors.red[500],
  textTheme: new Typography.material2018(platform: TargetPlatform.iOS).black

);

/// App bar that uses iOS styling on iOS
class PlatformAdaptiveAppBar extends AppBar {
  PlatformAdaptiveAppBar({
    Key key,
    TargetPlatform platform,
    String text,
    Color color,
    List<Widget> actions,
    Widget title,
    Widget body,
  })
      : super(
    backgroundColor: color,
    key: key,
    elevation: platform == TargetPlatform.iOS ? 0.0 : 4.0,
    title: new Text('$text', style: kIOSThemeDark.textTheme.title.copyWith(fontWeight: FontWeight.bold)),
    brightness: Brightness.dark,
    actions: actions,
  );
}