import 'package:flutter/material.dart';



final ThemeData kIOSTheme = new ThemeData(
  primaryColorBrightness: Brightness.light,
  primarySwatch: Colors.blue,
  primaryColor: Colors.grey[300],
  fontFamily: "AvenirNextCondensed-Regular ",
  textTheme: new Typography(platform: TargetPlatform.iOS).black.apply(fontFamily: "AvenirNextCondensed-Regular ")
);

final ThemeData kDefaultTheme = new ThemeData(
  primaryColorBrightness: Brightness.dark,
  primarySwatch: Colors.blue,
  primaryColor: Colors.blue[500],
  accentColor: Colors.red[500],
  fontFamily: "AvenirNextCondensed-Regular ",
  textTheme: new Typography(platform: TargetPlatform.iOS).black.apply(fontFamily: "AvenirNextCondensed-Regular ")

);

/// App bar that uses iOS styling on iOS
class PlatformAdaptiveAppBar extends AppBar {
  PlatformAdaptiveAppBar({
    Key key,
    TargetPlatform platform,
    List<Widget> actions,
    Widget title,
    Widget body,
  })
      : super(
    key: key,
    elevation: platform == TargetPlatform.iOS ? 0.0 : 4.0,
    title: title,
    actions: actions,
  );
}