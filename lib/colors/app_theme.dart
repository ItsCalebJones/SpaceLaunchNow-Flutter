import 'package:flutter/material.dart';

final ThemeData kIOSTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  colorSchemeSeed: const Color.fromARGB(255, 56, 143, 214),
  typography: Typography.material2021(
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

final ThemeData kIOSThemeDark = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  colorSchemeSeed: const Color.fromARGB(255, 56, 143, 214),
  typography: Typography.material2021(
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
