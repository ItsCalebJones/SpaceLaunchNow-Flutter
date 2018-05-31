import 'package:flutter/material.dart';

class SpaceLaunchNowColors {
  SpaceLaunchNowColors._(); // this basically makes it so you can instantiate this class
  static const _greenPrimaryValue = 0xFF3a6d70;
  static const blue_transparent = const  Color(0xf02196F3);

  static const MaterialColor primary = const MaterialColor(
    _greenPrimaryValue,
    const <int, Color>{
      50: const Color(0xFF9cb6b7),
      100: const Color(0xFF88a7a9),
      200: const Color(0xFF75989a),
      300: const Color(0xFF618a8c),
      400: const Color(0xFF4d7b7e),
      500: const Color(_greenPrimaryValue),
      600: const Color(0xFF346264),
      700: const Color(0xFF2e5759),
      800: const Color(0xFF284c4e),
      900: const Color(0xFF224143),
    },
  );

  static const _greyPrimaryValue = 0xFFd8d8d8;

  static const MaterialColor secondary = const MaterialColor(
    _greyPrimaryValue,
    const <int, Color>{
      50: const Color(0xFFebebeb),
      100: const Color(0xFFe7e7e7),
      200: const Color(0xFFe3e3e3),
      300: const Color(0xFFdfdfdf),
      400: const Color(0xFFdbdbdb),
      500: const Color(_greyPrimaryValue),
      600: const Color(0xFFc2c2c2),
      700: const Color(0xFFacacac),
      800: const Color(0xFF979797),
      900: const Color(0xFF818181),
    },
  );
}
