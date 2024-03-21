import 'package:flutter/material.dart';

final ThemeData kIOSTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.grey[200],
  typography: Typography.material2018(
      platform: TargetPlatform.iOS,
      black: Typography.blackMountainView.copyWith(
        displayLarge: Typography.blackMountainView.displayLarge!
            .copyWith(color: Colors.black87),
        displayMedium: Typography.blackMountainView.displayMedium!
            .copyWith(color: Colors.black87),
        displaySmall: Typography.blackMountainView.displaySmall!
            .copyWith(color: Colors.black87),
        headlineMedium: Typography.blackMountainView.headlineMedium!
            .copyWith(color: Colors.black87),
      ),
      white: Typography.whiteMountainView.copyWith(
        displayLarge: Typography.whiteMountainView.displayLarge!
            .copyWith(color: Colors.white),
        displayMedium: Typography.whiteMountainView.displayMedium!
            .copyWith(color: Colors.white),
        displaySmall: Typography.whiteMountainView.displaySmall!
            .copyWith(color: Colors.white),
        headlineMedium: Typography.whiteMountainView.headlineMedium!
            .copyWith(color: Colors.white),
      )),
  colorScheme:
      ColorScheme.fromSwatch(primarySwatch: Colors.blue)
          .copyWith(secondary: Colors.red, brightness: Brightness.light),
);

final ThemeData kIOSThemeDark = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.grey[800],
  typography: Typography.material2018(
      platform: TargetPlatform.iOS,
      black: Typography.blackMountainView.copyWith(
        displayLarge: Typography.blackMountainView.displayLarge!
            .copyWith(color: Colors.black87),
        displayMedium: Typography.blackMountainView.displayMedium!
            .copyWith(color: Colors.black87),
        displaySmall: Typography.blackMountainView.displaySmall!
            .copyWith(color: Colors.black87),
        headlineMedium: Typography.blackMountainView.headlineMedium!
            .copyWith(color: Colors.black87),
      ),
      white: Typography.whiteMountainView.copyWith(
        displayLarge: Typography.whiteMountainView.displayLarge!
            .copyWith(color: Colors.white),
        displayMedium: Typography.whiteMountainView.displayMedium!
            .copyWith(color: Colors.white),
        displaySmall: Typography.whiteMountainView.displaySmall!
            .copyWith(color: Colors.white),
        headlineMedium: Typography.whiteMountainView.headlineMedium!
            .copyWith(color: Colors.white),
      )),
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
    accentColor: Colors.grey[700],
  ).copyWith(secondary: Colors.grey[700], brightness: Brightness.dark),
);

final ThemeData kIOSThemeBar = ThemeData(
  brightness: Brightness.light,
  canvasColor: Colors.grey[200],
  primarySwatch: Colors.blue,
  primaryColor: Colors.blue[600],
  focusColor: Colors.black,
  typography: Typography.material2018(
      platform: TargetPlatform.iOS,
      black: Typography.blackMountainView.copyWith(
        displayLarge: Typography.blackMountainView.displayLarge!
            .copyWith(color: Colors.black87),
        displayMedium: Typography.blackMountainView.displayMedium!
            .copyWith(color: Colors.black87),
        displaySmall: Typography.blackMountainView.displaySmall!
            .copyWith(color: Colors.black87),
        headlineMedium: Typography.blackMountainView.headlineMedium!
            .copyWith(color: Colors.black87),
      ),
      white: Typography.whiteMountainView.copyWith(
        displayLarge: Typography.whiteMountainView.displayLarge!
            .copyWith(color: Colors.white),
        displayMedium: Typography.whiteMountainView.displayMedium!
            .copyWith(color: Colors.white),
        displaySmall: Typography.whiteMountainView.displaySmall!
            .copyWith(color: Colors.white),
        headlineMedium: Typography.whiteMountainView.headlineMedium!
            .copyWith(color: Colors.white),
      )),
);

final ThemeData kIOSThemeDarkBar = ThemeData(
  brightness: Brightness.dark,
  canvasColor: Colors.grey[800],
  primaryColor: Colors.grey[800],
  focusColor: Colors.white,
  typography: Typography.material2018(
      platform: TargetPlatform.iOS,
      black: Typography.blackMountainView.copyWith(
        displayLarge: Typography.blackMountainView.displayLarge!
            .copyWith(color: Colors.black87),
        displayMedium: Typography.blackMountainView.displayMedium!
            .copyWith(color: Colors.black87),
        displaySmall: Typography.blackMountainView.displaySmall!
            .copyWith(color: Colors.black87),
        headlineMedium: Typography.blackMountainView.headlineMedium!
            .copyWith(color: Colors.black87),
      ),
      white: Typography.whiteMountainView.copyWith(
        displayLarge: Typography.whiteMountainView.displayLarge!
            .copyWith(color: Colors.white),
        displayMedium: Typography.whiteMountainView.displayMedium!
            .copyWith(color: Colors.white),
        displaySmall: Typography.whiteMountainView.displaySmall!
            .copyWith(color: Colors.white),
        headlineMedium: Typography.whiteMountainView.headlineMedium!
            .copyWith(color: Colors.white),
      )),
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
      .copyWith(secondary: Colors.red, brightness: Brightness.dark),
);
